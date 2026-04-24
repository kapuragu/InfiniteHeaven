-------------------------------------------------------------------------------
-- 攻撃ダメージパラメタリロード処理
-- dofile( "Tpp/Scripts/Character/Damages/AttackDamageParameterTableLoader.lua" )
-- 
-- このファイルは下記のファイルに含まれているので、このファイルを更新する際は、下記のファイルも併せて更新する必要があります。
-- * Tpp/Scripts/NewCollectibles/ParameterTableLoaderAllIn.lua
-------------------------------------------------------------------------------

if DEBUG then
	local pref = Preference.GetPreferenceEntity("TppWeaponPreference")
	if not Entity.IsNull(pref) then
		if pref.useTempDamageTable then
			TppDamageUtility.ClearAttackDamageTable()
			-- 読み込みに失敗したら、本番用を読み込んであげる。
			if not TppDamageUtility.LoadAttackDamageTable( "/Assets/tpp/level_asset/weapon/ParameterTables/AttackDamage_temp.json" ) then
				TppDamageUtility.LoadAttackDamageTable( "/Assets/tpp/level_asset/weapon/ParameterTables/AttackDamage.json" )
			end
			if not TppDamageUtility.LoadAttackDamageTable( "/Assets/tpp/level_asset/weapon/ParameterTables/WeaponDamage_temp.json" ) then
				TppDamageUtility.LoadAttackDamageTable( "/Assets/tpp/level_asset/weapon/ParameterTables/WeaponDamage.json" )
			end
			Fox.Log("use temporary DamageTable.")
			return
		end
	end
end

TppDamageUtility.ClearAttackDamageTable()
TppDamageUtility.LoadAttackDamageTable( "/Assets/tpp/level_asset/weapon/ParameterTables/AttackDamage.json" )
TppDamageUtility.LoadAttackDamageTable( "/Assets/tpp/level_asset/weapon/ParameterTables/WeaponDamage.json" )

