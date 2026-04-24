--[[
	@id TppTrapExecHelicopterChangeRp
	@category TppTrap

	2012.09.12
	管理者：村岡賢一

	ヘリの合流ポイントを変更する

--]]

TppTrapExecHelicopterChangeRp = {

------------------------------------------------------------
-- パラメタを追加
------------------------------------------------------------
AddParam = function( condition )
	condition:AddConditionParam( "String", "rendezvousTag" )
end,

------------------------------------------------------------
-- 実行関数
------------------------------------------------------------
Exec = function( info )
	if info.trapFlagString == "GEO_TRAP_S_ENTER" then
		local rendezvousTag = info.conditionHandle.rendezvousTag
		TppSupportHelicopterService.RequestToChangeRendezvousPoint(rendezvousTag)
	end
	return 1
end,


}