-------------------------------------------------------------------------------
-- 攻撃ダメージパラメタリロード処理
-- dofile( "Tpp/Scripts/Character/Damages/EquipmentParameterTableLoader.lua" )
-- 
-- このファイルは下記のファイルに含まれているので、このファイルを更新する際は、下記のファイルも併せて更新する必要があります。
-- * Tpp/Scripts/NewCollectibles/ParameterTableLoaderAllIn.lua
-------------------------------------------------------------------------------

if DEBUG then
	local pref = Preference.GetPreferenceEntity("TppWeaponPreference")
	if not Entity.IsNull(pref) then
		if pref.useTempParameterTable then
			TppEquipmentParameterManager.ClearAllParameterTable()
			-- 読み込みに失敗したら、本番用を読み込んであげるように。

			if TppEquipmentParameterManager.LoadGunBasicParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/GunBasicParameter_temp.json" ) then
				Fox.Warning("use temporary GunBasicParameterTable.")
			else
				TppEquipmentParameterManager.LoadGunBasicParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/GunBasicParameter.json" )
			end

			if TppEquipmentParameterManager.LoadBulletParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/BulletParameter_temp.json" ) then
				Fox.Warning("use temporary BulletParameterTable.")
			else
				TppEquipmentParameterManager.LoadBulletParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/BulletParameter.json" )
			end

			if TppEquipmentParameterManager.LoadReceiverParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/ReceiverParameter_temp.json" ) then
				Fox.Warning("use temporary ReceiverParameterTable.")
			else
				TppEquipmentParameterManager.LoadReceiverParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/ReceiverParameter.json" )
			end

			if TppEquipmentParameterManager.LoadMagazineParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/MagazineParameter_temp.json" ) then
				Fox.Warning("use temporary MagazineParameterTable.")
			else
				TppEquipmentParameterManager.LoadMagazineParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/MagazineParameter.json" )
			end

			if TppEquipmentParameterManager.LoadBarrelParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/BarrelParameter_temp.json" ) then
				Fox.Warning("use temporary BarrelParameterTable.")
			else
				TppEquipmentParameterManager.LoadBarrelParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/BarrelParameter.json" )
			end

			if TppEquipmentParameterManager.LoadScopeParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/ScopeParameter_temp.json" ) then
				Fox.Warning("use temporary ScopeParameterTable.")
			else
				TppEquipmentParameterManager.LoadScopeParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/ScopeParameter.json" )
			end

			if TppEquipmentParameterManager.LoadShellParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/ShellParameter_temp.json" ) then
				Fox.Warning("use temporary ShellParameterTable.")
			else
				TppEquipmentParameterManager.LoadShellParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/ShellParameter.json" )
			end

			if TppEquipmentParameterManager.LoadBlastParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/BlastParameter_temp.json" ) then
				Fox.Warning("use temporary BlastParameterTable.")
			else
				TppEquipmentParameterManager.LoadBlastParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/BlastParameter.json" )
			end

			if TppEquipmentParameterManager.LoadSupportWeaponParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/SupportWeaponParameter_temp.json" ) then
				Fox.Warning("use temporary SupportWeaponParameterTable.")
			else
				TppEquipmentParameterManager.LoadSupportWeaponParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/SupportWeaponParameter.json" )
			end

			if TppEquipmentParameterManager.LoadWobblingParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/WobblingParameter_temp.json" ) then
				Fox.Warning("use temporary WobblingParameterTable.")
			else
				TppEquipmentParameterManager.LoadWobblingParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/WobblingParameter.json" )
			end
			return
		end
	end
end

TppEquipmentParameterManager.ClearAllParameterTable()
TppEquipmentParameterManager.LoadGunBasicParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/GunBasicParameter.json" )
TppEquipmentParameterManager.LoadBulletParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/BulletParameter.json" )
TppEquipmentParameterManager.LoadReceiverParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/ReceiverParameter.json" )
TppEquipmentParameterManager.LoadMagazineParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/MagazineParameter.json" )
TppEquipmentParameterManager.LoadBarrelParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/BarrelParameter.json" )
TppEquipmentParameterManager.LoadScopeParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/ScopeParameter.json" )
TppEquipmentParameterManager.LoadShellParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/ShellParameter.json" )
TppEquipmentParameterManager.LoadBlastParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/BlastParameter.json" )
TppEquipmentParameterManager.LoadSupportWeaponParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/SupportWeaponParameter.json" )
TppEquipmentParameterManager.LoadWobblingParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/WobblingParameter.json" )

