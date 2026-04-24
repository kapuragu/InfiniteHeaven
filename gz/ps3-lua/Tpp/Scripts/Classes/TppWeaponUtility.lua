--------------------------------------------------------------------------------
--! @file	TppWeaponUtility.lua
--! @brief	Collectible関連のユーティリティ Lua 関数群
--------------------------------------------------------------------------------

TppWeaponUtility = {

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

----------------------------------------
--!	@brief	スコープパラメタを取得
----------------------------------------
GetScopeParameter = function( collectibleId )

	if collectibleId == "" then
		return nil
	end

	--TODO:DB化
	local scopeParameter = {
		defaultZoom = 1.0,
		zoomChangeMode = "",
		zoomSteps = { 1.0 },
		zoomStepsLinearRange = { {-1.0,2.0} },
		uiGraphPath = "",
		hasUiGraph = false,
		seNameChangeZoom = ""
	}
	
	if collectibleId == "WP_Mosin" 
		or collectibleId == "WP_Sdiper" 
		or collectibleId == "WP_sr01_v00" 
		or collectibleId == "WP_StartingSniper" 
		or collectibleId == "WP_ms00" 
		or collectibleId == "WP_ms02" 
		or collectibleId == "WP_Rpg7" 
	then
		scopeParameter.defaultZoom = 0.0
		scopeParameter.zoomChangeMode = "Step"
		scopeParameter.zoomSteps = { 3.0, 5.0, 10.0 }
		scopeParameter.zoomStepsLinearRange = { {-1.0,2.0}, {-2.0,4.0}, {-4.0,0.0} }

		scopeParameter.uiGraphPath = "/Assets/tpp/ui/GraphAsset/StageGame/Weapon/MosinNagant/MosinNagant_Scope.uig"
		scopeParameter.hasUiGraph = true

		scopeParameter.seNameChangeZoom = "Play_sfx_p_scope_zoom_01"
		
	else
		scopeParameter.defaultZoom = 0.0
		scopeParameter.zoomChangeMode = "Disable"
	end
	
	return scopeParameter

end,


} -- TppWeaponUtility
