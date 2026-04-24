TppTrapCheckPoint = {

-- チェックポイントパラメータ追加
AddParam = function( condition )

	-- ここでconditionに追加したプロパティはDataList上で参照/編集可能
	--   Check()やExec()に渡されるinfoにもメンバ変数として追加される
	--   Exec()で作成するチェックポイントパラメータにはこれらをダイナミックプロパティとして追加している

	Fox.Log( "Set checkpoint information" )

	-- チェックポイント名デフォルト(必須)
	condition:AddConditionParam( 'String', "checkpointName" )
	condition.checkpointName = "LATEST_CHECKPOINT"
--[[	
	-- リスタート位置デフォルト
	condition:AddConditionParam( 'Vector3', "restartPosition" )
	condition.restartPosition = Vector3{ 0, 1, 0 }
	
	-- リスタート向きデフォルト
	condition:AddConditionParam( 'Quat', "restartRotation" )
	condition.restartRotation = Quat( 0, 0, 0, 1 )
--]]
	condition:AddConditionParam( 'EntityPtr', "restartLocater" )
	condition.restartLocater = NULL
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
			Fox.Log("x,y,z=" .. param.restartPosition:GetX() .. "," .. param.restartPosition:GetY() .. "," .. param.restartPosition:GetZ() )
			players.array[1]:SetPosition( param.restartPosition )
		else
			Fox.Log( "restartPosition is nil" )
		end
		-- 向き (Exec()でParamに追加していた)
		if( param.restartRotation ~= nil ) then
			--players.array[1]:SetRotation( param.restartRotation )
			local bodyPlugin = players.array[1]:FindPlugin("ChBodyPlugin")
			bodyPlugin:SetControlTurn(param.restartRotation)
			bodyPlugin:SetControlRotation(param.restartRotation)
		else
			Fox.Log( "restartRotation is nil" )
		end
	end

	--TODO_Restart暫定
	--敵兵のPhaseを強制的にDefault状態へ変更
	local phaseManager = TppSystemUtility.GetPhaseController()
	if phaseManager ~= NULL then
		-- CPに紐付いているPhaseController
		local cpControllers = phaseManager:GetSubPhaseControllers()
		if cpControllers ~= nil then
			for i, cpController in ipairs( cpControllers ) do
				-- Phaseをdefaultに戻す
				local cpDefPhase = cpController:GetDefaultPhaseName()
				cpController:SetCurrentPhaseByName( cpDefPhase )

				-- Charaに紐付いているPhaseController
				local charaControllers = cpController:GetSubPhaseControllers()
				if charaControllers ~= nil then
					for j, charaController in ipairs( charaControllers ) do
						-- Phaseをdefaultに戻す
						local charaDefPhase = charaController:GetDefaultPhaseName()
						charaController:SetCurrentPhaseByName( charaDefPhase )
					end
				end
			end
		end
	end

	--TODO_Restart暫定
	local commandPosts = Ch.FindCharacters( "CommandPost" )
	for i, cp in ipairs( commandPosts.array ) do
		local members = cp:GetMembers()
		if #members.array > 0 then
			for j, member in ipairs( members.array ) do
				local desc = member:GetCharacterDesc()
				if desc:IsKindOf( TppSquadDesc ) then
					local squadMembers = member:GetMembers()
					if #squadMembers.array > 0 then
						for k, squadMember in ipairs( squadMembers.array ) do
							local charaDesc = squadMember:GetCharacterDesc()
							if charaDesc:IsKindOf( TppHumanEnemyDesc ) or charaDesc:IsKindOf( TppProtoEnemyStrykerDesc ) then
								local message = NULL
								if MgsRemoveSpreadMessage ~= nil then
									message = MgsRemoveSpreadMessage( charaDesc )
								else
									message = TppRemoveSpreadMessage( charaDesc )
								end
								if not Entity.IsNull( message ) then
									--伝播削除
									cp:SendMessage( message )
								end
							end
							-- Knowledge削除
							local plgKnow = squadMember:FindPlugin( "AiKnowledgePlugin" )
							if plgKnow ~= NULL then
								plgKnow:RemoveAllKnowledge()
								plgKnow:RemoveAllKnowledgePoints()
							end
						end
					end
				elseif desc:IsKindOf( TppHumanEnemyDesc ) then
					local message = NULL
					if MgsRemoveSpreadMessage ~= nil then
						message = MgsRemoveSpreadMessage( desc )
					else
						message = TppRemoveSpreadMessage( desc )
					end
					
					if not Entity.IsNull( message ) then
						--伝播削除
						cp:SendMessage( message )
					end
				end
				-- Knowledge削除
				local plgKnow = member:FindPlugin( "AiKnowledgePlugin" )
				if plgKnow ~= NULL then
					plgKnow:RemoveAllKnowledge()
					plgKnow:RemoveAllKnowledgePoints()
				end
			end
		end
		-- Knowledge削除
		local plgKnow = cp:FindPlugin( "AiKnowledgePlugin" )
		if plgKnow ~= NULL then
			plgKnow:RemoveAllKnowledge()
			plgKnow:RemoveAllKnowledgePoints()
		end
	end

end,

}