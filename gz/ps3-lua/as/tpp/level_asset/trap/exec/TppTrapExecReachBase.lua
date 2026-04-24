--[[
	トラップに入った時、指定したCPに登録されている敵兵をマーキングする
--]]

TppTrapExecReachBase = {

-- 実行関数
Exec = function ( info )
	-- トラップに入ったら
	if info.trapFlagString == "GEO_TRAP_S_ENTER" then
		-- MB諜報発動
		local MBmanager = TppMotherBaseManager:GetInstance()
		MBmanager:SetIntelligenceUnitSearchCp( info.conditionHandle.CP_CHARA_ID ) 
		
		-- トラップ処理を実行したフラグ(isOnce対応)
		info.conditionBodyHandle.isDone = true
	-- トラップから出たら
	elseif info.trapFlagString == "GEO_TRAP_S_OUT" then
		-- MB諜報停止
		local MBmanager = TppMotherBaseManager:GetInstance()
		MBmanager:ResetIntelligenceUnitSearchCp() 

		-- トラップ処理を実行したフラグ(isOnce対応)
		info.conditionBodyHandle.isDone = true
	end
	return 1
end,

-- パラメータの追加
AddParam = function ( condition )	
	--CPのCharacterID
	condition:AddConditionParam( 'String', "CP_CHARA_ID" )
	condition.voiceId = Entity.Null()
end,
}