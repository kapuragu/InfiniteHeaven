--[[FDOC
	@id AiRtEvChkIshmaelLeadPlayer
	@category Ai RouteNodeEvent
	@brief ルートイベント条件スクリプト
	 * イシュメール専用。プレイヤーとの距離をチェックしてRouteNodeEventの実行を制御します。
	 * 離れているなら実行。近いなら実行しません。
]]--

AiRtEvChkIshmaelLeadPlayer = {

----------------------------------------
--開始条件判定 EnableCheck()
--　RouteNodeEventのアクション実行前に呼ばれます。
--　boolを返してください。
--		true:	アクションを開始します。
--		false:	アクションを開始せずに、次のアクションを実行します。
----------------------------------------
EnableCheck = function( chara )

	-- キャラクタがイシュメールかチェック
	local charaObj = chara:GetCharacterObject()
	if not charaObj:IsMemberOf( TppIshmaelObject ) then
		Ch.Warning( chara, "AiRtEvChkIshmaelLeadPlayer.EnableCheck() : This character is not an ishmael. [" .. charaObj:GetClassName() .. "]" )
		return false
	end

	-- プレイヤーとイシュメールの距離を取得
	local toPlayerLengthSqr = AiRtEvChkIshmaelLeadPlayer.GetToPlayerLengthSqr( chara )

	-- 停止距離まで離れたかチェック
	local playerLeadMoveStopRange = TppIshmaelObject.GetPlayerLeadMoveStopRange()
	if toPlayerLengthSqr >= playerLeadMoveStopRange * playerLeadMoveStopRange then
		return true		-- 離れたなら実行
	end
	return false
end,

----------------------------------------
--中断条件判定 InterruptCheck()
--　RouteNodeEventのアクション実行中に呼ばれます。
--　boolを返してください。
--		true:	アクションを終了します。
--		false:	アクションを終了しません。
----------------------------------------
InterruptCheck = function( chara )
	
	-- プレイヤーとイシュメールの距離を取得
	local toPlayerLengthSqr = AiRtEvChkIshmaelLeadPlayer.GetToPlayerLengthSqr( chara )

	-- 移動開始距離まで近づいたかチェック
	local playerLeadMoveStartRange = TppIshmaelObject.GetPlayerLeadMoveStartRange()
	if toPlayerLengthSqr <= playerLeadMoveStartRange * playerLeadMoveStartRange then
		return true		-- 近づいたら終了
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
end,

----------------------------------------
-- private
----------------------------------------

-- プレイヤーとイシュメールの距離を取得
GetToPlayerLengthSqr = function( ishmaelChara )

	-- キャラクタがイシュメールかチェック
	local ishmaelCharaObj = ishmaelChara:GetCharacterObject()
	if not ishmaelCharaObj:IsKindOf( "TppIshmaelObject" ) then
		Fox.Warning( "AiRtEvChkIshmaelLeadPlayer.EnableCheck() : This character is not an ishmael. [" .. charaObj:GetClassName() .. "]" )
		return 0.0
	end

	-- プレイヤーを取得
	local playerChara = TppPlayerUtility.GetLocalPlayerCharacter()
	if playerChara == NULL then
		Fox.Warning( "AiRtEvChkIshmaelLeadPlayer.EnableCheck() : player not found." )
		return 0.0
	end

	-- 距離
	local ishmaelPos = ishmaelChara:GetPosition()
	local playerPos  = playerChara:GetPosition()
	return ( ishmaelPos - playerPos ):GetLengthSqr()
end,

}
