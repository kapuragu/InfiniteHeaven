-------------------------------------------------------------------------------
--[[
	TppMBCore エディタ起動時の初期化処理
]]
--------------------------------------------------------------------------------

Fox.Log("********** Start - TppMBCoreBootInit.lua ********** ")


-----マネージャ起動
TppMotherBaseManager.Create()
Fox.Log("----- Create - TppMotherBaseManager")

-- GMPミッション設定
if TppGameSequence.GetGameTitleName() == "TPP" then
	dofile( "/Assets/tpp/motherbase/gmpEarnMissions.lua" )
	Fox.Log("----- Call - gmpEarnMissions.lua")
end

Fox.Log("********** End - TppMBCoreBootInit.lua ********** ")
