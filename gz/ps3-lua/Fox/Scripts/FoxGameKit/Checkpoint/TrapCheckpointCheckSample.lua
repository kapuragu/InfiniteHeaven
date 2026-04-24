TrapCheckpointCheckSample = {

--- トラップ条件関数
Check = function( info )

	-- プレイヤが入ったら起動
	for key, value in pairs( info.moverTags ) do
		if key == "PlayerLocator" or key == "AiPlayerLocatorData0000" then

			-- 入ったときに処理する
		    if info.trapFlagString == "GEO_TRAP_S_ENTER" then
		    	return 0
		    end

			-- チェックポイントが処理中ならスキップ
			if( Checkpoint.IsBusy() == true ) then
				--Fox.Log( "Busy" )
				return 0
			end

			-- チェックポイントタグ(infoからもらう)
			local checkpointTag = ""
			if( info.conditionHandle.checkpointName == nil ) then
				Fox.Log( "checkpointName is nil" )
				checkpointTag = "LATEST_CHECKPOINT"
			else
				--Fox.Log( "Checkpoint " .. info.checkpointName )
				checkpointTag = info.conditionHandle.checkpointName
				-- すでに通過済みチェックポイントか判定
				if( Checkpoint.IsPassedCheckpoint( checkpointTag ) == true ) then
					--Fox.Log( "Already Passed " .. checkpointTag )
					return 0
				end
			end

			Fox.Log("Check OK")

			return 1
		end
	end

	return 0

end,
}
