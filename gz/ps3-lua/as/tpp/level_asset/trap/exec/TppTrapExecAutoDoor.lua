--[[
	2012.06.27
	管理者：Kim Youngho
	
	自動ドアーの開きと閉めの設定
--]]

TppTrapExecAutoDoor = {

--- 実行関数
Exec = function( info )
	
	--トラップに入った
	if info.trapFlagString == "GEO_TRAP_S_ENTER" then
		
		-- ドアーに開くリクエストを送る
		if not Entity.IsNull(info.conditionHandle.doorLocator) then

			-- CharacterTagチェックがあったら該当タグのキャラクターのみで処理
			if not Entity.IsNull( info.conditionHandle.characterTag ) and info.conditionHandle.characterTag ~= "" then		
				local chara = info.moverHandle
				if chara:IsKindOf( ChCharacter ) then
					if chara:FindTag( info.conditionHandle.characterTag ) then
						local door = Ch.FindCharacter( info.conditionHandle.doorLocator )
						door:SendMessage( TppGadgetStartActionRequest() )
					end
				end
			else
				local door = Ch.FindCharacter( info.conditionHandle.doorLocator )
				door:SendMessage( TppGadgetStartActionRequest() )
			end
		end

		-- トラップ処理を実行したフラグ(isOnce対応)
		info.conditionBodyHandle.isDone = true
	elseif info.trapFlagString == "GEO_TRAP_S_OUT" then

		-- ドアーに予約終わったとリクエストを送る（ドアー側で予約人数0になったら閉まる）
		if not Entity.IsNull(info.conditionHandle.doorLocator) then

			-- CharacterTagチェックがあったら該当タグのキャラクターのみで処理
			if not Entity.IsNull( info.conditionHandle.characterTag ) and info.conditionHandle.characterTag ~= "" then
				local chara = info.moverHandle
				if chara:IsKindOf( ChCharacter ) then
					if chara:FindTag( info.conditionHandle.characterTag ) then
						local door = Ch.FindCharacter( info.conditionHandle.doorLocator )
						door:SendMessage( TppGadgetUnsetOwnerRequest() )
					end
				end
			else
				local door = Ch.FindCharacter( info.conditionHandle.doorLocator )
				door:SendMessage( TppGadgetUnsetOwnerRequest() )
			end
		end
	end
	return 1

end,

--- パラメータの追加
AddParam = function( condition )
	
	--ドアーロケーター
	condition:AddConditionParam( 'EntityLink', "doorLocator" )
	condition.charaLocator = Entity.Null()

	--判定されるキャラクタータグ
	condition:AddConditionParam( 'String', "characterTag" )
	condition.characterTag = Entity.Null()

end,

}

