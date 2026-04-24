-------------------------------------------------------------------------------
-- 地面のマテリアルと車両のサウンド及びエフェクトの対応表ロード処理
-- 
-- このファイルは下記のファイルに含まれているので、このファイルを更新する際は、下記のファイルも併せて更新する必要があります。
-- * Tpp/Scripts/NewCollectibles/ParameterTableLoaderAllIn.lua
-------------------------------------------------------------------------------

if DEBUG then
	local pref = Preference.GetPreferenceEntity("TppWeaponPreference")
	if not Entity.IsNull(pref) then
		if pref.useTempParameterTable then
			TppVehicleMaterialInfoManager.ClearVehicleMaterialInfoTable()
			-- 読み込みに失敗したら、本番用を読み込んであげるように。

			if TppVehicleMaterialInfoManager.LoadVehicleMaterialInfoTable( "/Assets/tpp/level_asset/vehicle/ParameterTables/VehicleMaterialInfo_temp.json" ) then
				Fox.Warning("use temporary VehicleMaterialInfoTable.")
			else
				TppVehicleMaterialInfoManager.LoadVehicleMaterialInfoTable( "/Assets/tpp/level_asset/vehicle/ParameterTables/VehicleMaterialInfo.json" )
			end
			return
		end
	end
end

TppVehicleMaterialInfoManager.ClearVehicleMaterialInfoTable()
TppVehicleMaterialInfoManager.LoadVehicleMaterialInfoTable( "/Assets/tpp/level_asset/vehicle/ParameterTables/VehicleMaterialInfo.json" )

