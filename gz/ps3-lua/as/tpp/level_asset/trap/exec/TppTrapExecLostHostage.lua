-------------------------------------------------------------------------------
--[[FDOC
	@id TppTrapExecLostHostage
	@category TppTrap
	捕虜回収ノーティス用Trap実行時のScript
--]]
--------------------------------------------------------------------------------


TppTrapExecLostHostage = {

--- 実行関数
Exec = function( info )
	
	if info.trapFlagString == "GEO_TRAP_S_ENTER" then

		if info.moverHandle:IsKindOf( ChCharacter ) then
			local charaObj = info.moverHandle:GetCharacterObject()

			local hostageLocater = info.conditionHandle.hostageLocator:GetDataBodyWithReferrer( info.trapBodyHandle )
			local hostageObj = hostageLocater:GetCharacterObject()

			--Fox.Log("Hostage_IN="..tostring(hostageLocater:GetCharacterId()))
			--Fox.Log("Mover_IN="..tostring(charaObj:GetCharacterId()))
			
			if not Entity.IsNull(hostageObj) then
				if charaObj:GetCharacterId() == hostageLocater:GetCharacterId() then
					--対象の捕虜か名前で確認
					local hostage = hostageObj:GetCharacter()
					local chLocater = info.conditionHandle.commandPostLocator:GetDataBodyWithReferrer( info.trapBodyHandle )
					local cpObj = chLocater:GetCharacterObject()
					local cpChara = cpObj:GetCharacter()
					local hostageStatus = cpObj:GetHostageStatus(hostage, info.conditionBodyHandle.noticeObject)

					if cpObj:CompHostageStatus(hostage, info.conditionBodyHandle.noticeObject, "HOSTAGE_STATUS_LOST") == true then
						--指名手配前なら消せる
						TppTrapExecLostHostage.HostageInfoSet(info.conditionHandle, info.trapBodyHandle, hostage, info.conditionBodyHandle.noticeObject, false )
						info.conditionBodyHandle.noticeObject = Entity.Null()
					end
				end
			end
		end

	elseif info.trapFlagString == "GEO_TRAP_S_OUT" then

		if info.moverHandle:IsKindOf( ChCharacter ) then
			local charaObj = info.moverHandle:GetCharacterObject()

			local hostageLocater = info.conditionHandle.hostageLocator:GetDataBodyWithReferrer( info.trapBodyHandle )
			local hostageObj = hostageLocater:GetCharacterObject()
			--Fox.Log("Hostage_Out="..tostring(hostageLocater:GetCharacterId()))
			--Fox.Log("Mover_Out="..tostring(charaObj:GetCharacterId()))

			if not Entity.IsNull(hostageObj) then
				if charaObj:GetCharacterId() == hostageLocater:GetCharacterId() then
					--対象の捕虜か名前で確認
					local hostage = hostageObj:GetCharacter()
					if Entity.IsNull(info.conditionBodyHandle.noticeObject) then
						if MgsEnemyNoticeObject ~= nil then
							info.conditionBodyHandle.noticeObject = MgsEnemyNoticeObject(info.trapPosition+Vector3(0,0.5,0), "LostPrisoner")
						else
							info.conditionBodyHandle.noticeObject = TppEnemyNoticeObject(info.trapPosition+Vector3(0,0.5,0), "LostPrisoner")
						end
						TppTrapExecLostHostage.HostageInfoSet(info.conditionHandle, info.trapBodyHandle, hostage, info.conditionBodyHandle.noticeObject, true )
					end
				end
			end
		end
	end
	
	return 1
end,

--- パラメータの追加
AddParam = function( condition )
	--捕虜
	--コマンドポスト
	condition:AddConditionParam( 'EntityLink', "commandPostLocator" )
	condition.commandPostLocator = nil

	--捕虜
	condition:AddConditionParam( 'EntityLink', "hostageLocator" )
	condition.hostageLocator = nil

end,


--- DataBody へのパラメータの追加
AddParamBody = function( conditionBody )
	
	conditionBody:AddProperty("EntityPtr", "noticeObject")
	conditionBody.noticeObject = Entity.Null()
end,


------------------------------------------------------------
-- メッセージ
------------------------------------------------------------
HostageInfoSet = function(data, body, hostage, notice, request )
	local commandPostLocatorDataBody = data.commandPostLocator:GetDataBodyWithReferrer(body)
	TppCommandPostObject.GsHostageInfoSet( commandPostLocatorDataBody , hostage, notice, request )
end,


}
