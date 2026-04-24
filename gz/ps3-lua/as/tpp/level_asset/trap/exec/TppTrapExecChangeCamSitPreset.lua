TppTrapExecChangeCamSitPreset = {

--- 実行関数
Exec = function( info )

	--トラップに入ったら
	if info.trapFlagString == "GEO_TRAP_S_ENTER"  then
		local chara = info.moverHandle

		-- プリセット変更
		TppCameraUtility.SetCameraSituationPresetName( chara, info.conditionHandle.ChangeCameraSituationPreset_name )

		-- 一回だけ実行の為に必要な設定
		info.conditionBodyHandle.isDone = true

		local funcName = info.conditionHandle.ChangeCameraSituationPreset_enterFuncName
		
		if funcName == "gntn_000" then
			TppTrapExecChangeCamSitPreset.enter_gntn_000()
		elseif funcName == "gntn_001" then
			TppTrapExecChangeCamSitPreset.enter_gntn_001()
		elseif funcName == "" then
			
		else
			Fox.Warning("invalid enterfuncName : " .. funcName )
		end
		
	-- トラップから出る時に状況プリセットをトラップ入る前の状況プリセットに戻す
	elseif info.trapFlagString == "GEO_TRAP_S_OUT" then
		--Fox.Log("Out")
		local chara = info.moverHandle
		-- プリセット復元
		TppCameraUtility.ResetCameraSituationPresetName( chara, info.conditionHandle.ChangeCameraSituationPreset_name )
		
		local funcName = info.conditionHandle.ChangeCameraSituationPreset_leaveFuncName
		
		if funcName == "gntn_000" then
			TppTrapExecChangeCamSitPreset.leave_gntn_000()
		elseif funcName == "gntn_001" then
			TppTrapExecChangeCamSitPreset.leave_gntn_001()
		elseif funcName == "" then
			
		else
			Fox.Warning("invalid leavefuncName : " .. funcName )
		end
		
	end
	
	return 1
	
end,

--- パラメータの追加
AddParam = function( condition )

	--ブリッジファンクタ
	condition:AddConditionParam( 'String', "ChangeCameraSituationPreset_name" )
	condition:AddConditionParam( 'String', "ChangeCameraSituationPreset_enterFuncName" )
	condition:AddConditionParam( 'String', "ChangeCameraSituationPreset_leaveFuncName" )

end,

--- DataBody へのパラメータの追加
AddParamBody = function( conditionBody )

	--１回目だけ有効になるフラグ
	conditionBody:AddProperty( 'bool', "isIn" )
	conditionBody.isIn = false

	--以前のカメラプリセットを保存する為の変数
	conditionBody:AddProperty( 'String', "ChangeCameraSituationPreset_prevName" )
	conditionBody.ChangeCameraSituationPreset_prevName = ""

end,

-- カメラ補間
enter_gntn_000 = function()
	TppPlayerUtility.RequestToSetCameraParamInterp{
	enableCamera = { 0 },				-- 対象のカメラ（指定必須）
		param = {
			{	-- 距離補間設定
			paramType	= 0,			-- パラメータ番号（指定必須）
			interpTime	= 0.5,			-- 補間時間（秒）（デフォルトは0）
			interpType	= 1,			-- 補間曲線タイプ（デフォルトは1（２次ベジェ曲線））
			interpMode	= 2,			-- 補間モード（デフォルトは0）
			},
			{	-- オフセット補間設定
			paramType	= 1,
			interpTime	= 0.5,
			interpType	= 1,
			interpMode	= 2,
			},
			{	-- 画角補間設定
			paramType	= 2,
			interpTime	= 0.5,
			interpType	= 1,
			interpMode	= 2,
			},
		},
	}
end,
leave_gntn_000 = function()
	TppPlayerUtility.RequestToSetCameraParamInterp{
	enableCamera = { 0 },				-- 対象のカメラ（指定必須）
		param = {
			{	-- 距離補間設定
			paramType	= 0,			-- パラメータ番号（指定必須）
			interpTime	= 1.0,			-- 補間時間（秒）（デフォルトは0）
			interpType	= 1,			-- 補間曲線タイプ（デフォルトは1（２次ベジェ曲線））
			interpMode	= 2,			-- 補間モード（デフォルトは0）
			},
			{	-- オフセット補間設定
			paramType	= 1,
			interpTime	= 1.0,
			interpType	= 1,
			interpMode	= 2,
			},
			{	-- 画角補間設定
			paramType	= 2,
			interpTime	= 1.0,
			interpType	= 1,
			interpMode	= 2,
			},
		},
	}
end,

-- カメラ補間
enter_gntn_001 = function()
	TppPlayerUtility.RequestToSetCameraParamInterp{
	enableCamera = { 0 },				-- 対象のカメラ（指定必須）
		param = {
			{	-- 距離補間設定
			paramType	= 0,			-- パラメータ番号（指定必須）
			interpTime	= 0.5,			-- 補間時間（秒）（デフォルトは0）
			interpType	= 1,			-- 補間曲線タイプ（デフォルトは1（２次ベジェ曲線））
			interpMode	= 2,			-- 補間モード（デフォルトは0）
			},
			{	-- オフセット補間設定
			paramType	= 1,
			interpTime	= 0.5,
			interpType	= 1,
			interpMode	= 2,
			},
			{	-- 画角補間設定
			paramType	= 2,
			interpTime	= 0.5,
			interpType	= 1,
			interpMode	= 2,
			},
		},
	}
end,
leave_gntn_001 = function()
	TppPlayerUtility.RequestToSetCameraParamInterp{
	enableCamera = { 0 },				-- 対象のカメラ（指定必須）
		param = {
			{	-- 距離補間設定
			paramType	= 0,			-- パラメータ番号（指定必須）
			interpTime	= 1.0,			-- 補間時間（秒）（デフォルトは0）
			interpType	= 1,			-- 補間曲線タイプ（デフォルトは1（２次ベジェ曲線））
			interpMode	= 2,			-- 補間モード（デフォルトは0）
			},
			{	-- オフセット補間設定
			paramType	= 1,
			interpTime	= 1.0,
			interpType	= 1,
			interpMode	= 2,
			},
			{	-- 画角補間設定
			paramType	= 2,
			interpTime	= 1.0,
			interpType	= 1,
			interpMode	= 2,
			},
		},
	}
end,

}
