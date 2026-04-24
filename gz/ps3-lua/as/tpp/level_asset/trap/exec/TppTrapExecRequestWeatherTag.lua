TppTrapExecRequestWeatherTag = {

--実行関数
Exec = function( info )
	
	--トラップに入った
	if info.trapFlagString == "GEO_TRAP_S_ENTER" then
		if info.conditionHandle.inTag ~= "" then
			local wm=TppWeatherManager:GetInstance()
			wm:RequestTag(info.conditionHandle.inTag, info.conditionHandle.inTime)
		end
		
		-- トラップ処理を実行したフラグ(isOnce対応)
		info.conditionBodyHandle.isDone = true
		
	--トラップから出た
	elseif info.trapFlagString == "GEO_TRAP_S_OUT" then
		if info.conditionHandle.outTag ~= "" then
			local wm=TppWeatherManager:GetInstance()
			wm:RequestTag(info.conditionHandle.outTag, info.conditionHandle.outTime)
		end
	end
	
	return 1

end,

--パラメータの追加
AddParam = function( condition )

	condition:AddConditionParam("String", "inTag" )
	condition.inTag = ""
	condition:AddConditionParam("float", "inTime" )
	condition.inTime = 0
	condition:AddConditionParam("String", "outTag")
	condition.outTag = ""
	condition:AddConditionParam("float", "outTime")
	condition.outTime = 0

end,

}
