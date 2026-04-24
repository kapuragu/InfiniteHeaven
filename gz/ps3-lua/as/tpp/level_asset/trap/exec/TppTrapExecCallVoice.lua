--[[
	トラップに入った時、指定した捕虜がしゃべる
--]]

TppTrapExecCallVoice = {

-- 実行関数
Exec = function ( info )
	
	--トラップに入ったら
	if info.trapFlagString == "GEO_TRAP_S_ENTER" then
		
		--　捕虜をしゃべらせるメッセージを送る
		local chara = info.moverHandle
		chara:SendMessage( TppCallVoiceMessage(info.conditionHandle.voiceId, info.conditionHandle.isStack ) )
		
		-- トラップ処理を実行したフラグ(isOnce対応)
		info.conditionBodyHandle.isDone = true
	end
	
	return 1

end,


-- パラメータの追加
AddParam = function ( condition )	
	--セリフパターン
	if condition:AddConditionParam( 'String', "voiceId" ) == true then
		condition.voiceId = "None"
	end
	
	--再生中の音声を上書きするかどうか
	if condition:AddConditionParam( 'bool', "isStack" ) == true then
		condition.isStack = true
	end

end,

}