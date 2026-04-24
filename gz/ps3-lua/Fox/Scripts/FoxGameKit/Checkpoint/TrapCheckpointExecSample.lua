TrapCheckpointExecSample = {

--- トラップ実行関数
Exec = function( info )
	
	Fox.Log( "Checkpoint Trap Exec" )
	
	-- チェックポイントが処理中の場合無視
	if( Checkpoint.IsBusy() == true ) then
		Fox.Log( "Busy" )
		return 0
	end
	
	-- チェックポイントパラメータ
	--    すべてのオブザーバーの保存・復帰処理に渡される
	--    エンティティであれば何でも良いので
	--    必要に応じてコンテンツ・場面ごとに型を定義する
	local param = CheckpointData()
	if param == nil then
		Fox.Log( "Checkpoint parameter is nil" )
		return 0
	end
	
	-- チェックポイント名取得
	local checkpointTag = "LATEST_CHECKPOINT"
	if( info.conditionHandle.checkpointName == nil ) then
		Fox.Log( "checkpointName is nil" )
	else
		Fox.Log( "Checkpoint " .. info.conditionHandle.checkpointName )
		checkpointTag = info.conditionHandle.checkpointName
		-- すでに通過済みチェックポイントか判定
		if( Checkpoint.IsPassedCheckpoint( checkpointTag ) == true ) then
			Fox.Log( "Already Passed " .. checkpointTag )
			return 0
		end
		-- paramにも追加
		param:AddProperty( 'String', "checkpointTag" )
		param.checkpointTag = checkpointTag
	end
	
	-- リスタート位置を取得してparamに追加
	local restartPosition = Vector3{ 0, 0, 0 }
	if( info.conditionHandle.restartPosition == nil ) then
		Fox.Log( "restartPosition is nil" )
	else
		restartPosition = info.conditionHandle.restartPosition
		-- paramにも追加
		param:AddProperty( 'Vector3', "restartPosition" )
		param.restartPosition = restartPosition
	end
	
	-- リスタート向きを取得してparamに追加
	local restartRotation = Quat( 0, 0, 0, 1 )
	if( info.conditionHandle.restartRotation == nil ) then
		Fox.Log( "restartRotation is nil" )
	else
		restartRotation = info.conditionHandle.restartRotation
		-- paramにも追加
		param:AddProperty( 'Quat', "restartRotation" )
		param.restartRotation = restartRotation
	end
	
	-- チェックポイント登録
	--    tag : ユニークなチェックポイント名
	--    parameter : チェックポイントパラメータ
	--    replace : 最新チェックポイントで更新される
	local ret = Checkpoint.PostCheckpointCreation {
		tag = checkpointTag,
		parameter = param,
		replace = true,
	}
	
	-- デバッグ表示
	GrxDebug.Print2D {
		life = 100,
		size = 30,
		x=50, y=600,
		color=Color(1,1,1, 1),
		args={ "チェックポイント" }
	}
	
    return 1

end,

}
