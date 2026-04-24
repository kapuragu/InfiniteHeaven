--[[

■編集時の注意・ヒント
　・同じ名前を複数登録しない
　・「__」を名前の先頭につけると選択項目に出さないことができる
　・ここで設定する優先順位はUIに対してのみ有効。UI以外と関わる項目のpriorityはそれぞれと合わせる必要がある。
  　→　例）エフェクト用に作成した優先順位のpriorityを変更する場合、エフェクト側も変更する（TppFilter2DPrioDef.h ）

　※暫定的な注意（今後注意する必要はなくなります）
　　UIに関する優先順位は、priorityの間隔を100以上空けてください。
　　意図せずレイアウト同士が重なってしまうのを避けるためです。

　※Foxエディタ付属の「Script Source Editor」編集で、タブ揃えしている

■テーブル内容をダンプ
UiDaemon.DumpPriorityTable()
をFoxConsoleで実行

■テーブル再読み込み
dofile( "/Assets/tpp/ui/UiDrawPriorityTable.lua" )
をFoxConsoleで実行

■設定例
		{ name = "__BACK_EFFECT",	priority = 0		},
		{ name = "ACTION_ICON",	priority = 10		},
		{ name = "MAP"							},
		{ name = "TOWN_ICON"						},
		{ name = "PL_ICON",		priority = 500	},
		{ name = "EN_ICON",		priority = 600	},
		{ name = "MY_ICON",		priority = 700	},
		{ name = "POPUP"							},
		{ name = "__FRONT_EFFECT",	priority = 1200	},
		{ name = "GAME_OVER",		priority = 1210	},

--]]

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
		{ name = "RADIO_GUIDE",				priority = 42	},
		{ name = "LMENU",					priority = 45	},
		{ name = "LMENU_SELECT",			priority = 47	},
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
