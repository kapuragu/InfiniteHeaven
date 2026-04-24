-- 戦闘エリアタグを設定する
TppTrapExecSetCombatAreaTag = {

Exec = function( info )

	if info.trapFlagString == "GEO_TRAP_S_ENTER" then
		TppTrapExecSetCombatAreaTag.SendTag( info, false )
    elseif info.trapFlagString == "GEO_TRAP_S_OUT" then
		TppTrapExecSetCombatAreaTag.SendTag( info, true )
    end
    return 1
end,

AddParam = function( condition )
	-- 戦闘エリアタグ
	condition:AddConditionParam( 'String', "tagCombatArea" )
	condition.tagCombatArea = "hoge"
	-- 設定先コマンドポスト
	condition:AddConditionParam( 'EntityLink', "targetCommandPost" )
	condition.targetCommandPost = NULL
end,

------------------------------------------------------------
-- Paramチェック
------------------------------------------------------------
CheckParam = function( info )
	if info.conditionHandle.tagCombatArea == "" then
		Fox.Warning(info.trapName..":TrapConditionParam[tagCombatArea] is Empty")
		return 0
	end
	if info.conditionHandle.targetCommandPost == NULL then
		Fox.Warning(info.trapName..":TrapConditionParam[targetCommandPost] is NULL")
		return 0
	end
	return 1
end,

------------------------------------------------------------
-- タグを送信
------------------------------------------------------------
SendTag	= function( info, isRemove )
	if not TppTrapExecSetCombatAreaTag.CheckParam(info) then
		return 0
	end

	local cp = Ch.FindCharacter( info.conditionHandle.targetCommandPost )
	if not Entity.IsNull( cp ) then
		cp:SendMessage( TppCpSetCombatAreaTagMessage{tag=info.conditionHandle.tagCombatArea,isRemove=isRemove} )
	end
	return 1
end,
}
