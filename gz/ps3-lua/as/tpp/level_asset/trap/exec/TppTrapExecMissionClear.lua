--[[
	Writen : Tanimoto_Hayato
	ミッションクリア処理:ヘリに乗り込んでのクリア以外でミッションクリアが呼ぶ時の共通処理
--]]

TppTrapExecMissionClear = {

	Exec = function( info )

		-- ミッションクリア条件を満たしていた場合にクリア処理を行う
		if info.trapFlagString == "GEO_TRAP_S_ENTER" then

			local lm = TppLocationManager:GetInstance()
			local value = lm:GetEventFlagValue("missionEventFlag_readyToClear")

			if value == 1 then
				Fox.Log("RequestMissionClear")
				local missionManager = TppMissionManager:GetInstance()
				missionManager:RequestMissionClear()

			end
		end
		return 1

	end,

}

