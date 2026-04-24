-------------------------------------------------------------------------------
--[[
	Tpp字幕 エディタ起動時の初期化処理
]]
--------------------------------------------------------------------------------
Fox.Log("********** Start - SubtitlesBootInit ********** ") --←↓start2nd.luaに引っ越しました。Y.Ogaito 2013.11.20
--------------------
-- 字幕用システムの初期化
-- パスの設定などはtitleに入る前に行う必要があるためstart2nd.luaでは遅い
local subtitlesDaemon = SubtitlesDaemon.GetInstance()
if SubtitlesCommand then
	SubtitlesCommand:SetSubFilePath( "/Assets/tpp/ui/Subtitles/sub_old/" )
	SubtitlesCommand:SetSubpFilePath( "/Assets/tpp/ui/Subtitles/subp/" )
	SubtitlesCommand:SetDefaultGeneratorName( "Default" )
	SubtitlesCommand:SetSubFpkFilePath( "/Assets/tpp/pack/ui/subtitles" )
end
Fox.Log("----- Create - SubtitlesDaemon")


Fox.Log("********** End - SubtitlesBootInit ********** ")



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--[[
	TppUI エディタ起動時の初期化処理
]]
--------------------------------------------------------------------------------
Fox.Log("********** Start - TppUiBootInit.lua ********** ")


--------------------
---- 常駐マネージャ起動
UiCommonDataManager.Create()
local uiCommonData = UiCommonDataManager.GetInstance()
uiCommonData:CreateUiDependJob();
uiCommonData:CreateUiUseGrJob();
uiCommonData:UiPadStart();

--------------------
---- 常駐ブロック生成
if TppGameSequence.GetGameTitleName() == "TPP" then
	uiCommonData:CreateResidentBlock( 460 * 1024, "/Assets/tpp/pack/ui/ui_resident_data.fpk" );
else
	uiCommonData:CreateResidentBlock( 460 * 1024, "/Assets/tpp/pack/ui/gz/gz_ui_resident_data.fpk" );
end

--------------------------------------------------------------------------------
--------------------
---- プラットフォーム指定
uiCommonData:UiPlatFormSetting()

-- 仕向け地指定
uiCommonData:UiAreaSetting()

--------------------
---- 言語設定取得
local useLang = AssetConfiguration.GetDefaultCategory( "Language" )

--------------------------------------------------------------------------------
----フォント設定
--設定パラメータ
local slotName0 = ""
local fontName0 = ""

local slotName1 = ""
local fontName1 = ""

local slotName2 = ""
local fontName2 = ""

local setSlotNo0 = 1
local setSlotNo1 = 3


--日本語
if useLang == "jpn" then
	slotName0 = "FontSystem_KanjiFont"
	fontName0 = "/Assets/tpp/font/font_def_jp.ffnt"

	slotName1 = "FontSystem_Slot3"
	fontName1 = "/Assets/tpp/font/KanjiFont.ffnt"

	setSlotNo0 = 2 -- index:0 に FONTDATATYPE_KANJIFONT
	setSlotNo1 = 3 -- index:1 に FONTDATATYPE_SLOT_3(映画フォント)

-- 英語/欧州
elseif useLang == "eng" then
	slotName0 = "FontSystem_LatinFont"
	fontName0 = "/Assets/tpp/font/font_def_ltn.ffnt"

	slotName1 = "FontSystem_Slot3"
	fontName1 = "/Assets/tpp/font/LatinFont.ffnt"

	setSlotNo0 = 1 -- index:0 に FONTDATATYPE_LATINFONT
	setSlotNo1 = 3 -- index:1 に FONTDATATYPE_SLOT_3(映画フォント)

-- ロシア語
elseif useLang == "rus" then
	slotName0 = "FontSystem_LatinFont"
	fontName0 = "/Assets/tpp/font/font_def_rus.ffnt"

	slotName1 = "FontSystem_Slot3"
	fontName1 = "/Assets/tpp/font/russian.ffnt"

	slotName2 = "FontSystem_KanjiFont" --FontSystem_Slot2を予備のラテン語フォントとして使用
	fontName2 = "/Assets/tpp/font/font_def_ltn.ffnt"

	setSlotNo0 = 1 -- index:0 に FONTDATATYPE_LATINFONT
	setSlotNo1 = 3 -- index:1 に FONTDATATYPE_SLOT_3(映画フォント)

-- アラビア語
elseif useLang == "ara" then
	slotName0 = "FontSystem_LatinFont"
	fontName0 = "/Assets/tpp/font/arabia.ffnt"

	slotName1 = "FontSystem_Slot3"
	fontName1 = "/Assets/tpp/font/arabia.ffnt"

	setSlotNo0 = 1 -- index:0 に FONTDATATYPE_LATINFONT
	setSlotNo1 = 3 -- index:1 に FONTDATATYPE_SLOT_3(映画フォント)

-- その他
else
	slotName0 = "FontSystem_LatinFont"
	fontName0 = "/Assets/tpp/font/font_def_ltn.ffnt"

	slotName1 = "FontSystem_Slot3"
	fontName1 = "/Assets/tpp/font/LatinFont.ffnt"

	setSlotNo0 = 1 -- index:0 に FONTDATATYPE_LATINFONT
	setSlotNo1 = 3 -- index:1 に FONTDATATYPE_SLOT_3(映画フォント)

end

--登録コール
GrTools.FontSystemLoad( slotName0, fontName0 )
GrTools.FontSystemLoad( slotName1, fontName1 )
UiDaemon.SetFontTypeTransTable( 0, setSlotNo0 )
UiDaemon.SetFontTypeTransTable( 1, setSlotNo1 )
if useLang == "rus" then
	-- ロシア語のみslot2を使う. アーティストが指定できる必要はないのでUIには登録しない
	GrTools.FontSystemLoad( slotName2, fontName2 )
end
--------------------------------------------------------------------------------


--------------------
-- TppUI 基本初期化処理

----- Fade初期化
FadeFunction.InitFadeSetting()

--------------------
---- // UiTexture Prefetch
Fox.Log("Call - TppUiPrefetchTexture")
UiDaemon.SetExecLuaFile("Tpp/Scripts/Ui/TppUiPrefetchTexture.lua")


--------------------
---- Uiパッドボタン登録
local uidaemon = UiDaemon.GetInstance();
uidaemon.ResetDefaultButtonMap()  -- 一旦クリア

-- // 基本型
uidaemon.SetButtonMap( "BUTTON_A",		fox.PAD_A )
uidaemon.SetButtonMap( "BUTTON_B",		fox.PAD_B )
uidaemon.SetButtonMap( "BUTTON_X",		fox.PAD_X )
uidaemon.SetButtonMap( "BUTTON_Y",		fox.PAD_Y )
uidaemon.SetButtonMap( "BUTTON_UP",		fox.PAD_U )
uidaemon.SetButtonMap( "BUTTON_DOWN",	fox.PAD_D )
uidaemon.SetButtonMap( "BUTTON_LEFT",	fox.PAD_L )
uidaemon.SetButtonMap( "BUTTON_RIGHT",	fox.PAD_R )
uidaemon.SetButtonMap( "STATUS_UP",		fox.PAD_U+4 )
uidaemon.SetButtonMap( "STATUS_DOWN",	fox.PAD_D+4 )
uidaemon.SetButtonMap( "STATUS_LEFT",	fox.PAD_L+4 )
uidaemon.SetButtonMap( "STATUS_RIGHT",	fox.PAD_R+4 )
uidaemon.SetButtonMap( "BUTTON_LT",		fox.PAD_L2 )
uidaemon.SetButtonMap( "BUTTON_RT",		fox.PAD_R2 )
uidaemon.SetButtonMap( "BUTTON_LB",		fox.PAD_L1 )
uidaemon.SetButtonMap( "BUTTON_RB",		fox.PAD_R1 )

-- // 抽象パッド
uidaemon.SetButtonDecideMap( "UI_DECIDE" )
uidaemon.SetButtonCancelMap( "UI_CANCEL" )
uidaemon.SetButtonMap( "UI_DETAIL",				fox.PAD_Y )
uidaemon.SetButtonMap( "UI_CHECK",				fox.PAD_X )
uidaemon.SetButtonMap( "UI_SELECT",				fox.PAD_SELECT )
uidaemon.SetButtonMap( "UI_START",				fox.PAD_START )
uidaemon.SetButtonMap( "UI_UP",					fox.PAD_U )
uidaemon.SetButtonMap( "UI_DOWN",				fox.PAD_D )
uidaemon.SetButtonMap( "UI_LEFT",				fox.PAD_L )
uidaemon.SetButtonMap( "UI_RIGHT",				fox.PAD_R )
uidaemon.SetButtonMap( "UI_LT",					fox.PAD_L2 )
uidaemon.SetButtonMap( "UI_RT",					fox.PAD_R2 )
uidaemon.SetButtonMap( "UI_LB",					fox.PAD_L1 )
uidaemon.SetButtonMap( "UI_RB",					fox.PAD_R1 )
uidaemon.SetButtonMap( "UI_LEFTSTICK_PUSH",		fox.PAD_L3 )
uidaemon.SetButtonMap( "UI_RIGHTSTICK_PUSH",	fox.PAD_R3 )

uidaemon.CreateButtonMap() -- ボタンマップ再生成


--------------------
-- UI表示優先順位設定
--dofile( "/Assets/tpp/ui/UiDrawPriorityTable.lua" ) --プライオリティ指定はこのluaファイル内でやる↓ Y.Ogaito 2013.11.20

-- 一旦全てクリア
UiDaemon.ClearDrawPriorityTable()
-- テーブル設定
UiDaemon.SetDrawPriorityTable {
	-- priority値を指定しない場合に使用されるpriority間隔（ひとつ上の項目のpriority＋intervalが設定される）
	interval = 100,
	-- テーブル（最大100項目まで）
	-- 先頭の項目にpriority値を設定しない場合、0が設定される）
	table = {
	-- UIより優先順位が低いエフェクト
		{ name = "__BACK_EFFECT",			priority = 0	},
		{ name = "VERY_BACK",				priority = 11	},

	-- HUD
		{ name = "__HUD",					priority = 20	},
		{ name = "WORLD_MARKER_CHARA",		priority = 23	},
		{ name = "WORLD_MARKER",			priority = 25	},
		{ name = "TIME_CIGARETTE_BG",		priority = 30	},
		{ name = "TIME_CIGARETTE",			priority = 32	},
		{ name = "NOTICE_DIR",				priority = 35	},
		{ name = "DAMAGE_DIR",				priority = 37	},
		{ name = "PRESET_RADIO",			priority = 40	},
		{ name = "PICK_UP",					priority = 49	},
		{ name = "ACTION_ICON",				priority = 50	},
		{ name = "RETICLE_LOW",				priority = 53	},
		{ name = "RETICLE",					priority = 55	},
		{ name = "RETICLE_HIGH",			priority = 57	},
	--MB端末
		{ name = "__MB_DEVICE",				priority = 64	},
		{ name = "MB_BG",					priority = 65	},
		{ name = "MB_MAP",					priority = 68	},
		{ name = "MB_MAP_ICON",				priority = 70	},
		{ name = "MB_MAP_HIGH",				priority = 78	},
		{ name = "MB_MENU_LOW",				priority = 80	},
		{ name = "MB_MENU_MIDDLE",			priority = 82	},
		{ name = "MB_MENU_HIGH",			priority = 84	},
		{ name = "MB_CHILD_PAGE",			priority = 90	},
		{ name = "MB_CHILD_LOW",			priority = 92	},
		{ name = "MB_CHILD_MIDDLE",			priority = 94	},
		{ name = "MB_CHILD_HIGH",			priority = 96	},
	--武器アイコン
		{ name = "WEP_ICON",				priority = 95	},
	--主観サイト
		{ name = "__SIGHT",					priority = 128 },
		{ name = "SIGHT_BG",				priority = 130 },
		{ name = "SIGHT_RETICLE",			priority = 132 },
		{ name = "SIGHT_STRONG",			priority = 135 },
	--主観サイトより強いHUD
		{ name = "SIGHT_STRONG_HUD",		priority = 137 },
		{ name = "LMENU",					priority = 137	},
		{ name = "LMENU_SELECT",			priority = 138	},
		{ name = "RADIO_GUIDE",				priority = 140 },
	--字幕より弱い汎用指定
		{ name = "UNDER_SUBTITLE_BG",		priority = 145 },
	--字幕
		{ name = "__SUBTITLE",				priority = 150 },
		{ name = "SUBTITLE",				priority = 151 },
	--テキスト表示
		{ name = "__TEXT",					priority = 160 },
		{ name = "ANNOUNCE_LOG",			priority = 161 },
	--テロップ、ポーズメニュ系
		{ name = "__TELOP_PAUSE",			priority = 170 },
		{ name = "TELOP_BG",				priority = 171 },
		{ name = "TELOP_TEXT",				priority = 173 },
		{ name = "PAUSE_BG",				priority = 171 },
		{ name = "PAUSE_MENU",				priority = 173 },
		{ name = "PAUSE_MENU_ADD",			priority = 175 },
	--ポップアップ
		{ name = "__POPUP",					priority = 180 },
		{ name = "POPUP_BG",				priority = 181 },
		{ name = "POPUP_MENU",				priority = 183 },
	--ゲームフェード
		{ name = "__GAME_FADE",				priority = 190 },
		{ name = "GAME_FADE",				priority = 191 },
		{ name = "GAME_FADE_UP",			priority = 192 },
	--強テロップ、ポーズメニュ系
		{ name = "__STRONG_TELOP_PAUSE",	priority = 200 },
		{ name = "STRONG_TELOP_BG",			priority = 201 },
		{ name = "STRONG_TELOP_TEXT",		priority = 203 },
		{ name = "STRONG_PAUSE_BG",			priority = 205 },
		{ name = "STRONG_PAUSE_MENU",		priority = 207 },
		{ name = "STRONG_PAUSE_ICON",		priority = 209 },
	--強字幕
		{ name = "__STRONG_SUBTITLE",		priority = 210 },
	-- UIより手前に表示したいエフェクト
		{ name = "__FRONT_EFFECT",			priority = 245 },
	--エラーメッセージ
		{ name = "__ERROR_MESSAGE",			priority = 251 },
		{ name = "ERROR_MESSAGE",			priority = 251 },
		{ name = "SYSTEM_MESSAGE",			priority = 251 },
	}
}
Fox.Log("Setup UiDrawPriorityTable end.")

Fox.Log("********** End - TppUiBootInit.lua ********** ")
