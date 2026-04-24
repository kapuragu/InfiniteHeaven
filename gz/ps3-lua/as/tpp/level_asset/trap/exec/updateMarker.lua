--[[
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	Author		：	Tanimoto_Hayato
	Outline		：	Markerをオンオフするトラップ
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--]]

updateMarker = {


-- パラメータの追加
AddParam = function( condition )

	condition:AddConditionParam( 'bool', "isAboutDraw" )
	condition:AddConditionParam( 'EntityLink', "onMarker" ) 
	condition:AddConditionParam( 'EntityLink', "offMarker" ) 	
	condition.isAboutDraw = false
	condition.onMarker = nil
	condition.offMarker = nil

end,


-- 実行関数
Exec = function( info )

	-- トラップに入ったトリガー
	if info.trapFlagString == "GEO_TRAP_S_ENTER" then

		local player = Ch.FindCharacters( "Player" )

		if (#player.array ~= 0) then
			--OnMarker 処理
			if (not Entity.IsNull(info.conditionHandle.onMarker)) then

				local charaLocatorOn = info.conditionHandle.onMarker:GetDataBodyWithReferrer( info.trapBodyHandle )
				local charaObjOn = charaLocatorOn:GetCharacterObject()

				local characterId = charaObjOn:GetCharacterId()
				local isAboutDrawOn = info.conditionHandle.isAboutDraw

				TppMarkerSystem.EnableMarker{ markerId=characterId, isAbout=isAboutDrawOn }

			else
				Fox.Log( "Invalid onMarker parameter." )
			end

			--offMarker 処理
			if (not Entity.IsNull(info.conditionHandle.offMarker)) then

				local charaLocatorOff = info.conditionHandle.offMarker:GetDataBodyWithReferrer( info.trapBodyHandle )
				local charaObjOff = charaLocatorOff:GetCharacterObject()

				local characterId = charaObjOff:GetCharacterId()

				--Off関数がきたらここを差し替える
				Fox.Log( "MarkerOff" )
				TppMarkerSystem.DisableMarker{ markerId=characterId}

			else
				Fox.Log( "[WARNING] Invalid offMarker parameter." )
			end

		else
			Fox.Log( "player not found." )
		end
		
		-- トラップ処理を実行したフラグ(isOnce対応)
		info.conditionBodyHandle.isDone = true
		
	end

	return 1

end,

}

