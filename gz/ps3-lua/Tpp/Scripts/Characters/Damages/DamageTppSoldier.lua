DamageTppSoldier = {

--キャラクタ情報を Knowledgeプラグインに登録（Alertフェイズ時のみ限定）
AddKnowledgeAlertPhaseOnly = function( chara, damage )

	local plgPhase = chara:FindPlugin( "AiPhasePlugin" )
	if not Entity.IsNull( plgPhase ) then
		if plgPhase:GetCurrentPhaseName()=="Alert" then

		    local plgKnow = chara:FindPluginByName( "Knowledge" )
			if not Entity.IsNull( plgKnow ) then

				--ダメージの発生元の Character を取得
				local attackerChara = TppEnemyDamageUtility.GetAttackCharacterOfDamage( damage )
				if not Entity.IsNull( attackerChara ) then

					--知識を登録
					plgKnow:AddKnowledgeEvent( AiCharacterKnowledgeEvent.Create( attackerChara ) )
				end
			end
		end
	end
end,

}
