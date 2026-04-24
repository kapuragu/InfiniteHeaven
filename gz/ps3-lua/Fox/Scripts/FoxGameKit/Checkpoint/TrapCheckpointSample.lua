TrapCheckpointSample = {

-- チェックポイントパラメータ追加
AddParam = function( condition )

	-- ここでconditionに追加したプロパティはDataList上で参照/編集可能
	--   Check()やExec()に渡されるinfoにもメンバ変数として追加される
	--   Exec()で作成するチェックポイントパラメータにはこれらをダイナミックプロパティとして追加している

	Fox.Log( "Set checkpoint information" )

	-- チェックポイント名デフォルト(必須)
	condition:AddConditionParam( 'String', "checkpointName" )
	condition.checkpointName = "LATEST_CHECKPOINT"
	
	-- リスタート位置デフォルト
	condition:AddConditionParam( 'Vector3', "restartPosition" )
	condition.restartPosition = Vector3{ 0, 1, 0 }
	
	-- リスタート向きデフォルト
	condition:AddConditionParam( 'Quat', "restartRotation" )
	condition.restartRotation = Quat( 0, 0, 0, 1 )
end,


--- 保存処理
OnStorage = function( param, data )

	-- dataに対してチェックポイントで保存したい変数を追加
	--    ここで更新したdataはOnRestoration()に渡される
	--    paramはExec()で作成したチェックポイントパラメータ

	Fox.Log( "OnStorage" )

	-- 保存テスト：通過時のプレイヤー体力を保存
	--    本来はプレイヤープログラム側でやるべきであろう
	local players = Ch.FindCharacters( "Player" )
	if #players.array > 0 then
		local plgLife = players.array[1]:FindPlugin( "ChLifePlugin" )
		local lifeValue = plgLife:GetValue( "Life" )
		if( lifeValue ~= nil ) then
			data:AddProperty( 'int32', "playerLife" )
			data.playerLife = lifeValue:Get()
		end
	end
	
end,


-- 復元処理
OnRestoration = function( param, data )

	-- リスタート時に呼ばれる。dataおよびparamから復帰情報を得て復元
	--    paramはExec()で作成したチェックポイントパラメータ
	--    セーブデータのバージョン違いによって存在しない値が発生するので、dataおよびparamの変数のnilチェックは必ずおこなうこと

	Fox.Log( "OnRestoration" )

	-- 状態復元
	local players = Ch.FindCharacters( "Player" )
	if players.array[1] then
	
		-- テスト：プレイヤー体力戻し
		--    本来はプレイヤープログラム側でやるべきであろう
		local plgLife = players.array[1]:FindPlugin( "ChLifePlugin" )
		local lifeValue = plgLife:GetValue( "Life" )
		if( lifeValue ~= nil ) then
			if( data.playerLife ~= nil ) then
				lifeValue:Set( data.playerLife )
			else
				-- 保存されていなければ最大値
				lifeValue:Set( lifeValue:GetMax() )
			end
		end
		
		-- 位置 (Exec()でParamに追加していた)
		if( param.restartPosition ~= nil ) then
			players.array[1]:SetPosition( param.restartPosition )
		else
			Fox.Log( "restartPosition is nil" )
		end
		-- 向き (Exec()でParamに追加していた)
		if( param.restartRotation ~= nil ) then
			players.array[1]:SetRotation( param.restartRotation )
		else
			Fox.Log( "restartRotation is nil" )
		end
	end

end,

}
