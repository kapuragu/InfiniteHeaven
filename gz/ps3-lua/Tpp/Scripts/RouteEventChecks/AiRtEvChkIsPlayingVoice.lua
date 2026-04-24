--[[FDOC
	@id AiRtEvChkIsPlayingVoice
	@category Ai RouteNodeEvent
	@brief ルートイベント条件スクリプト
	 * 汎用。ChVoicePluginの再生完了待ちを行うスクリプト
]]--

AiRtEvChkIsPlayingVoice = {

----------------------------------------
--開始条件判定 EnableCheck()
--　RouteNodeEventのアクション実行前に呼ばれます。
--　boolを返してください。
--		true:	アクションを開始します。
--		false:	アクションを開始せずに、次のアクションを実行します。
----------------------------------------
EnableCheck = function( chara )

	--VoicePluginが見つからない場合終了
	local plgVoice = chara:FindPlugin( "ChVoicePlugin" )
	if Entity.IsNull( plgVoice ) then
		plgVoice = chara:FindPlugin( "ChVoicePlugin2" )
		if Entity.IsNull( plgVoice ) then
			return false
		end
	end
	
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
	--VoicePluginが見つからない場合終了
	local plgVoice = chara:FindPlugin( "ChVoicePlugin" )
	if Entity.IsNull( plgVoice ) then
		plgVoice = chara:FindPlugin( "ChVoicePlugin2" )
		if Entity.IsNull( plgVoice ) then
			return true
		end
	end

	-- 音声再生終了で終了
	if not plgVoice:IsPlaying() then
		return true
	end

	return false
end,
}
