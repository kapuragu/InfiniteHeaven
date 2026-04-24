-------------------------------------------------------------------------------
--[[
]]
--------------------------------------------------------------------------------

TppUiPrefetchTexture = {

InitTable = function()

	-- ここへは、エディタ起動時に読み込みたいもの or プリプロ用テクスチャを記述する
	---- 使用確定なテクスチャは TppUiCommonDataManager.cpp へ記述
	if Fox.GetPlatformName() == 'Windows' then
		UiDaemon.SetPrefetchTextureTable {
			-- MissionInfo画面を最初に開いたときに白い四角が出てしまう不具合対処(暫定)
			"/Assets/tpp/ui/ModelAsset/mb_photo/Pictures/ui_mb_photo_icon_a.ftex",
		}
	end

	-- フォルダごとに区切るなど、見通し良く記述
	UiDaemon.SetPrefetchTextureTable {
		"/Assets/tpp/ui/ModelAsset/cmn_loadmark/Pictures/cmn_loadmark_logo_mini.ftex",
		"/Assets/tpp/ui/ModelAsset/cmn_loadmark/Pictures/cmn_loadmark_icon_a_alp.ftex",
	}

end,

}

