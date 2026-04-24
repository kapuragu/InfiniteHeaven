--[[
	2012.11.28 MatsushitaArata
	e20040 ミッション開始デモ終了
--]]

p12_030000_EndAction = {

	--------------------------------------------------------------------------------
	-- 初期設定
	--------------------------------------------------------------------------------
	--------------------------------------------------------------------------------
	-- イベントリスナーの登録
	events = {
		Target_Demo = { Finish="MissionStartDemoEnd" },	-- デモ終了メッセージ
	},

	--================================================================================
	-- イベントリスナー
	--================================================================================
	-- デモが終了した時に呼ばれる関数
	MissionStartDemoEnd = function( mission )

		Fox.Log( " MissionStartDemo Demo End " )
		-- missionEventFlag_startMissionを0→1
		missionCommon_functionSet.FlagChange("missionEventFlag_startMission",1)
		Fox.Log( " missionEventFlag_startMission Flag 1 !! " )

	end,

}
