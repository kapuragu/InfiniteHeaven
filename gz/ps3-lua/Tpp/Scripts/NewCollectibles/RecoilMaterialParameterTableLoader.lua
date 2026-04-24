-------------------------------------------------------------------------------
-- 跳弾マテリアルパラメタリロード処理
-- dofile( "Tpp/Scripts/NewCollectibles/RecoilMaterialParameterTableLoader.lua" )
-- 
-- このファイルは下記のファイルに含まれているので、このファイルを更新する際は、下記のファイルも併せて更新する必要があります。
-- * Tpp/Scripts/NewCollectibles/ParameterTableLoaderAllIn.lua
-------------------------------------------------------------------------------

if DEBUG then
	local pref = Preference.GetPreferenceEntity("TppWeaponPreference")
	if not Entity.IsNull(pref) then
		if pref.useTempRecoilParameterTable then
			TppRecoilMaterialParameterManager.ClearRecoilMaterialParameterTable()
			-- 読み込みに失敗したら、本番用を読み込んであげるように。

			if TppRecoilMaterialParameterManager.LoadRecoilMaterialParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/RecoilMaterialParameter_temp.json" ) then
				Fox.Warning("use temporary RecoilMaterialParameterTable.")
			else
				TppRecoilMaterialParameterManager.LoadRecoilMaterialParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/RecoilMaterialParameter.json" )
			end
			return
		end
	end
end

TppRecoilMaterialParameterManager.ClearRecoilMaterialParameterTable()
TppRecoilMaterialParameterManager.LoadRecoilMaterialParameterTable( "/Assets/tpp/level_asset/weapon/ParameterTables/RecoilMaterialParameter.json" )

