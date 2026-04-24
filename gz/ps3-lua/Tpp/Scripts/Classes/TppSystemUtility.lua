--------------------------------------------------------------------------------
--! @file	TppSystemUtility.lua
--! @brief	システム関連のユーティリティ Lua 関数群
--! 
--------------------------------------------------------------------------------




--	パックデータに含めるためにパッドデータ関連は
--	/Assets/tpp/level_asset/chara/player/TppPlayerPadConfig.lua に移動しました。



TppSystemUtility = {

-- SquadLocater以下のEnemyのenable/disableを切り替える
-- EnemyUtilityにあるべき？
SetSquadEnableState = function( locator, enableFlag )
	if ( locator:IsKindOf( "ChCharacterLocator" ) == false ) then
		Fox.Log("arg1 is not a ChCharacterLocator")
		return false
	end
	local charaObj = locator.charaObj
	if ( Entity.IsNull(charaObj) ) then
		Fox.Log("charaObj is null")
		-- Unreallize状態？
		return true
	end
	if ( charaObj:IsKindOf( "AiSquadObject" ) == false ) then
		Fox.Log("not a AiSquadObject")
		return false
	end
	charaObj:SetMembersEnable( enableFlag )
	return true
end


} -- TppSystemUtility

