TppTrapExecChangeMissionState = {

Exec = function( info )
	if ( info.conditionHandle.enable == false ) then
		return 1
	end

	if ( info.trapFlagString == "GEO_TRAP_S_ENTER" and info.conditionBodyHandle.isIn == false ) then
		local missionManager = TppMissionManager:GetInstance()
		-- defaultミッション状態でないと受けられない
		if ( Entity.IsNull( missionManager ) ) then
			Fox.Log("missionManager does not exist")
			return 1
		end
		if ( missionManager:IsMainMissionDefault() == false ) then
			Fox.Log("default mission is not started.")
			return 1
		end

		info.conditionBodyHandle.isIn = true

		if ( info.conditionHandle.enableFlag == true ) then
			Fox.Log("send mission change request :" .. info.conditionHandle.missionName )
			missionManager:SendMainMissionChangeRequest( info.conditionHandle.missionName )
		else
			-- @todo 名前チェックくらいいれよう
			Fox.Log("send mission release request")
			missionManager:ReleaseMainMission()
		end
	end
	
end,

AddParam = function( condition )
	-- トラップ処理の有効/無効
	condition:AddConditionParam( 'bool', "enable" )
	condition.enable = true
	
	--毎回判定するかどうか
	condition:AddConditionParam( 'bool', "onlyFirstTime" )
	condition.onlyFirstTime = true		--初回のみ判定する
	
	condition:AddConditionParam( 'String', "missionName" )
	condition:AddConditionParam( 'bool', "enableFlag" )
	condition.enableFlag = true

end,

AddParamBody = function( conditionBody )
	conditionBody:AddProperty( 'bool', "isIn" )
	conditionBody.isIn = false
end,

}