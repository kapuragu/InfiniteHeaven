--[[
	車から降りて、ルートチェンジをする
--]]

TppTrapExecVehicleGetOff = {

-- 実行関数
Exec = function ( info )
	
	--トラップに入ったら
	if info.trapFlagString == "GEO_TRAP_S_ENTER" then
		
		--敵のデータを取得して、ルートを変更
		local charaLocatorData = info.conditionHandle.enemyLocator
		local charaLocator = charaLocatorData:GetDataBodyWithReferrer( info.trapBodyHandle )
                local charaObject = charaLocator:GetCharacterObject()
                local chara = charaObject:GetCharacter()
          
		if not Entity.IsNull( charaLocator ) then
                  local request = TppNpcGetOffAndRouteChangeRequest( info.conditionHandle.nextRouteId, info.conditionHandle.nextRoutePoint )
                  chara:SendMessage( request )
		end
		
		-- トラップ処理を実行したフラグ(isOnce対応)
		info.conditionBodyHandle.isDone = true
	end
	
	return 1

end,


-- パラメータの追加
AddParam = function ( condition )

	--ルートチェンジする敵兵
        if condition:AddConditionParam( 'EntityLink', "enemyLocator" ) == true then
		condition.enemyLocator = nil
	end
	
	--チェンジ先のルート
	if condition:AddConditionParam( 'EntityLink', "nextRoute" ) == true then
		condition.nextRoute = nil
	end

	--チェンジ先のルートID
	if condition:AddConditionParam( 'String', "nextRouteId" ) == true then
		condition.nextRouteId = ""
	end

	--チェンジ先ルートの開始番号
	if condition:AddConditionParam( 'uint32', "nextRoutePoint" ) == true then
		condition.nextRoutePoint = 0
	end
end,

}

