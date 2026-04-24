--[[FDOC
	@id freePlayFinishByHelicopter
	@category Script GameScript
	@brief フリープレイにおいて、ヘリのCloseDoorメッセージを受けたら、フリープレイを終了に向かわせるゲームスクリプト
]]--

freePlayFinishByHelicopter = {

--------------------------------------------------------------------------------
-- 初期設定
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- イベントリスナーの登録
events = {
	Heli = { CloseDoor="OnCloseDoor" },
},

-- 動的プロパティの追加
AddDynamicPropertiesToData = function( data, body )

	-- イベントキーの準備
	if data.variables.Heli == NULL then
		data.variables.Heli = nil
	end

end,

-- 初期化
Init = function( data, body )

end,

-- メッセージボックスリストの設定
SetMessageBoxes = function( data, body )

end,

-- チェックポイントデータの復元
Restore = function( data, body )

end,

--================================================================================
-- イベントリスナー
--================================================================================
-- 発煙筒が使用された時に呼ばれる処理
OnCloseDoor = function( data, body, sender, id, arg1, arg2, arg3, arg4 )

	-- もしも今のミッションがフリープレイ（地上）ならフリープレイを終了に向かわせる。（つまりフリープレイ（地上）以外では発動しない）
	local missionManager = TppMissionManager:GetInstance()
	
	--ヘリ処理は当面、全部統一でいいので。
	--if missionManager:IsFreePlay() == true and missionManager:IsFreePlayHeli() == false then 
		missionManager:RequestMissionFinishOnHeli()
	--end

end,
}

