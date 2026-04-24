-------------------------------------------------------------------------------
--[[FDOC
	@id TppTrapCheckIntrude
	@category TppTrap
	Intrude用Trap実行可能かどうかの確認のScript
]]
--------------------------------------------------------------------------------


TppTrapCheckIntrude = {

--- 条件関数
-- 入った人にPlayerタグがついていたら実行
Check = function( info )
	for key, value in pairs( info.moverTags ) do
		--Fox.Log("Check : " .. tostring(key))
		-- 渡辺さんに聞いた所、moverTags規約が決まってないのでLocatorの名前らしい
		if key == "PlayerLocator" then
			--Fox.Log("return 1")
			return 1
		end
	end
	return 0
end,
}
