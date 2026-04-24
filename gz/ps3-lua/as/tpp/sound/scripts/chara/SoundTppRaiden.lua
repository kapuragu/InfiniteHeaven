-------------------------------------------------------------------------------
-- サウンドプラグインスクリプト
-------------------------------------------------------------------------------
SoundTppRaiden = {
-------------------------------------------------------------------------------
-- プレーヤーサウンドコンバータ
--  キャラクタ生成時に呼ばれる関数
--  再生するサウンドに関する設定を行う
-------------------------------------------------------------------------------
Setup = function( id )

	SoundComponentPlayerEventConvert.SetPlayerRattleWeapon{
		-- "[basis]_[symbol]_[action]"
		-- symbolはweaponIdが該当する武器があればそれを使用。なければカテゴリから適切と思われるものを自動選択
		scriptId = id,
		reference = {
			"RATTLE_WEAPON",	-- 武器揺れ
		},
		basis = "sfx_p_rtl_wpn",
		action = {
			"wk",			-- 歩き
			"wkc",			-- しゃがみ歩き
			"rn",			-- 走り
			"rnc",			-- しゃがみ走り
			"dh",			-- ダッシュ
			"cr",			-- うつ伏せ
			"cp",			-- あお向け
			"dh",			-- 横転がり
		},
		type = {
			"asult_rifle",		-- アサルトライフル
			"sniper_rifle",		-- スナイパーライフル
			"shot_gun",		-- ショットガン
			"machine_gun",		-- マシンガン
			"hand_gun",		-- ハンドガン
			"sub_machine_gun",	-- サブマシンガン
			"grenade_launcher",	-- グレネードランチャー
			"missile",		-- ミサイルランチャー
			"support",		-- サポート
			"none",			-- 無音
		},
		-- アサルトライフル音で鳴らす武器ID
		asult_rifle = {
			symbol = "ar00",
			weaponId = {
			},
		},
		-- スナイパーライフル音で鳴らす武器ID
		sniper_rifle = {
			symbol = "sr00",
			weaponId = {
			},
		},
		-- ショットガン音で鳴らす武器ID
		shot_gun = {
			symbol = "ar00",
			weaponId = {
			},
		},
		-- マシンガン音で鳴らす武器ID
		machine_gun = {
			symbol = "",
			weaponId = {
			},
		},
		-- ハンドガン音で鳴らす武器ID
		hand_gun = {
			symbol = "",
			weaponId = {
			},
		},
		-- サブマシンガン音で鳴らす武器ID
		sub_machine_gun = {
			symbol = "",
			weaponId = {
			},
		},
		-- グレネードランチャー音で鳴らす武器ID
		grenade_launcher = {
			symbol = "",
			weaponId = {
			},
		},
		-- ミサイルランチャー音で鳴らす武器ID
		missile = {
			symbol = "ms00",
			weaponId = {
			},
		},
		-- サポート武器音で鳴らす武器ID
		support = {
			symbol = "",
			weaponId = {
			},
		},
		-- 揺れ音を鳴らさない武器ID
		none = {
			symbol = "",
			weaponId = {
			},
		},
	}

	SoundComponentPlayerEventConvert.SetPlayerRattleSuit{
		-- "[basis]_[symbol]_[action]"
		scriptId = id,
		reference = {
			"RATTLE_SUIT",		-- 衣擦れ
		},
		basis = "sfx_p_rtl_suit",
		action = {
			"wk",			-- 歩き
			"wkc",			-- しゃがみ歩き
			"rn",			-- 走り
			"rnc",			-- しゃがみ走り
			"wk",			-- ダッシュ
			"cr",			-- うつ伏せ
			"cp",			-- あお向け
			"dh",			-- 横転がり
		},
		type = {
			"sneaking",		-- 野戦服
			"sneaking",		-- スカーフ
			"sneaking",		-- スニーキングスーツ
		},
		-- 野戦服音で鳴らす装身具ID
		normal = {
			symbol = "nom",
			suitId = {
				"PLTypeNormal",	-- 暫定でプレイヤタイプ
			},
		},
		-- スカーフ装身具ID
		scarf = {
			symbol = "nom",
			suitId = {
				"PLTypeScarf",	-- 暫定でプレイヤタイプ
			},
		},
		-- スニーキングスーツ装身具ID
		sneaking = {
			symbol = "snk",
			suitId = {
				"PLTypeSneakingSuit",	-- 暫定でプレイヤタイプ
			},
		},
	}

	SoundComponentPlayerEventConvert.SetPlayerFootStep{
		-- "[basis]_[symbol]([wet])_[action]([impact])_l(r)"
		scriptId = id,
		reference = {
			"FOOT_GROUND_L",	-- 左足接地
			"FOOT_GROUND_R",	-- 右足接地
			"FOOT_LEAVE_L",		-- 左足離れ
			"FOOT_LEAVE_R",		-- 右足離れ
			"ARM_GROUND_L",		-- 左腕接地
			"ARM_GROUND_R",		-- 右腕接地
			"ARM_LEAVE_L",		-- 左腕離れ
			"ARM_LEAVE_R",		-- 右腕離れ
		},
		basis = "Play_sfx_P_Fs",
		action = {
			-- 立ち歩き
			"Wk_Grd", 		-- 接地
			"Wk_Lev", 		-- 離れ
			"Wk_Grd", 		-- 停止
			"Wk_Lev", 		-- 出だし
			"Wk_Tn_Grd", 		-- 接地ターン(turn flag)
			"Wk_Lev", 		-- 離れターン(turn flag)
			"Rn_Grd",		-- 着地(jump flag)
			"Rn_Lev",		-- ジャンプ(jump flag)
			"Dhr_Grd",		-- 大着地(jump flag)
			-- しゃがみ歩き
			"WkC_Grd", 		-- 接地
			"WkC_Lev", 		-- 離れ
			"WkC_Grd", 		-- 停止
			"WkC_Lev", 		-- 出だし
			"WkC_Tn_Grd", 		-- 接地ターン(turn flag)
			"WkC_Lev", 		-- 離れターン(turn flag)
			"Rn_Grd",		-- 着地(jump flag)
			"Rn_Lev",		-- ジャンプ(jump flag)
			"Dhr_Grd",		-- 大着地(jump flag)
			-- 立ち走り
			"Rn_Grd", 		-- 接地
			"Rn_Lev", 		-- 離れ
			"Wk_Grd", 		-- 停止
			"Wk_Lev", 		-- 出だし
			"Rn_Tn_Grd", 		-- 接地ターン(turn flag)
			"Rn_Lev", 		-- 離れターン(turn flag)
			"Dhr_Grd",		-- 着地(jump flag)
			"Rn_Lev",		-- ジャンプ(jump flag)
			"Dhr_Grd",		-- 大着地(jump flag)
			-- しゃがみ走り
			"RnC_Grd", 		-- 接地
			"RnC_Lev", 		-- 離れ
			"WkC_Grd", 		-- 停止
			"WkC_Lev", 		-- 出だし
			"RnC_Tn_Grd", 		-- 接地ターン(turn flag)
			"RnC_Lev", 		-- 離れターン(turn flag)
			"Dhr_Grd",		-- 着地(jump flag)
			"Rn_Lev",		-- ジャンプ(jump flag)
			"Dhr_Grd",		-- 大着地(jump flag)
			-- ダッシュ
			"Dhr_Grd", 		-- 接地
			"Dh_Lev", 		-- 離れ
			"Wk_Grd", 		-- 停止
			"Wk_Lev",		-- 出だし
			"Dh_Tn_Grd", 		-- 接地ターン(turn flag)
			"Dh_Lev", 		-- 離れターン(turn flag)
			"Dhr_Grd",		-- 着地(jump flag)
			"Dh_Lev",		-- ジャンプ(jump flag)
			"Dhr_Grd",		-- 大着地(jump flag)
			-- 壁登り(climb flag)
			"Wk_Grd", 		-- 足接地
			"Wk_Lev", 		-- 足離れ
			"El_Arm_Grd", 		-- 腕接地
			"El_Arm_Lev", 		-- 腕離れ
			-- ハシゴ(climb flag & Ladder tag)
			"Wk_Grd", 		-- 足接地
			"Wk_Lev", 		-- 足離れ
			"El_Arm_Grd", 		-- 腕接地
			"El_Arm_Lev", 		-- 腕離れ
			-- うつ伏せホフク
			"Cr_Leg_Grd", 		-- 足接地
			"Cr_Leg_Lev",		-- 足出だし
			"Cr_Arm_Grd", 		-- 腕接地
			"Cr_Arm_Lev",		-- 腕出だし
			-- あお向けホフク
			"Cp_Leg_Grd", 		-- 足接地
			"Cp_Leg_Lev",		-- 足出だし
			"Cp_Arm_Grd", 		-- 腕接地
			"Cp_Arm_Lev",		-- 腕出だし
			-- 緊急回避(jump flag & Dive tag)
			"Rn_Dv_Arm_Grd",		-- 緊急回避腕接地
			"Rn_Be_Arm_Lev",		-- 緊急回避腕離れ
			-- エルード
			"El_Arm_Grd",		-- エルード腕接地
			"El_Arm_Lev",		-- エルード腕離れ
			-- ビハインド
			"Wk_Be_Arm_Grd",		-- ビハインド腕接地
			"Wk_Be_Arm_Lev",		-- ビハインド腕離れ
			"Rn_Be_Arm_Grd",		-- ダッシュビハインド腕接地
			"Rn_Be_Arm_Lev",		-- ダッシュビハインド腕離れ
		},
		side = {
			"L",			-- 左
			"R",			-- 右
		},
		wet = "W",
		type = {
			"soil",			-- 砂地(デフォルト)
			"soilw",		-- 水場
			"soilm",		-- 水場２
			"rock",			-- 岩
			"clot",			-- 布敷きのコンクリ
			"grass",		-- 芝
			"grav",			-- 砂利
			"wood",			-- 木
			"iron",			-- 金属
			"fence",		-- フェンス
			"tin",			-- トタン
			"ironb",		-- 穴あき鉄板
		},
		-- 砂地
		soil = {
			symbol = "SOILA",
			wet = true,
			material = {
				"MTR_SOIL_A",	-- 黄色い砂地
				"MTR_SOIL_B",	-- 濃い砂地
				"MTR_SOIL_F",	-- 土（赤）
				"MTR_SOIL_G",	-- 土（白）
				"MTR_SOIL_H",	-- 土（黒）
				"MTR_SAND_A",	-- 砂、土嚢
				"MTR_SAND_B",	-- 
				"MTR_PLNT_A",	-- サボテン
			},
		},
		-- 水場
		soilm = {
			symbol = "ROCKAW",
			wet = false,
			material = {
				"MTR_SOIL_D",	-- 
				"MTR_WATE_B",	-- 
			},
		},
		-- 岩
		rock = {
			symbol = "ROCKA",
			wet = true,
			material = {
				"MTR_ROCK_A",	-- 砂利面
				"MTR_ROCK_B",	-- 
				"MTR_BRIC_A",	-- レンガ
				"MTR_CONC_A",	-- コンクリ
				"MTR_CONC_B",	-- コンクリ
				"MTR_PAPE_A",	-- 紙っぺら（貼り紙を想定）
				"MTR_RUBB_A",	-- ゴム（ゴム敷きのコンクリを想定）
				"MTR_TILE_A",	-- タイル
				"MTR_VINL_A",	-- ビニル（ビニル敷きのコンクリを想定）
				"MTR_GLAS_A",	-- 
				"MTR_RUBB_B",	-- 
			},
		},
		-- 布敷きのコンクリ
		clot = {
			symbol = "CLOTA",
			wet = true,
			material = {
				"MTR_CLOT_C",	-- 布敷きのコンクリ（布敷きのコンクリを想定）
				"MTR_CLOT_D",	-- 布製の網
			},
		},
		-- 芝
		grass = {
			symbol = "GRASA",
			wet = true,
			material = {
				"MTR_TURF_A",	-- 草が生えている面
				"MTR_LEAF",		-- 葉（透過無し）
			},
		},
		-- 砂利
		grav = {
			symbol = "GRAVA",
			wet = true,
			material = {
				"MTR_GRAV_A",	-- 
				"MTR_SOIL_C",	-- おためし
			},
		},
		-- 木
		wood = {
			symbol = "WOODA",
			wet = true,
			material = {
				"MTR_PAPE_B",	-- 段ボール（仮）
				"MTR_PLAS_A",	-- プラスチック
				"MTR_PLAS_B",	-- プラスチック（光透けてる）
				"MTR_WOOD_A",	-- 樹
				"MTR_WOOD_B",	-- 木炭
				"MTR_WOOD_C",	-- 木材
				"MTR_WOOD_D",	-- AKの柄
			},
		},
		-- 金属
		iron = {
			symbol = "IRONA",
			wet = true,
			material = {
				"MTR_IRON_A",	-- 鉄
				"MTR_IRON_B",	-- アルミ
				"MTR_IRON_C",	-- コンテナ
				"MTR_PIPE_A",	-- 
				"MTR_PIPE_B",	-- 
				"MTR_IRON_E",	-- さらに厚い鉄
			},
		},
		-- フェンス
		fence = {
			symbol = "FENCA",
			wet = true,
			material = {
				"MTR_FENC_B",	-- 網フェンス
				"MTR_CLOT_E",	-- 布つき網フェンス
			},
		},
		-- トタン
		tin = {
			symbol = "TIN_A",
			wet = true,
			material = {
				"MTR_TIN_A",	-- トタン
			},
		},
		-- 穴あき鉄板
		ironb = {
			symbol = "IRONB",
			wet = true,
			material = {
				"MTR_FENC_A",	-- 側溝の格子とか
			},
		},
	}

end,

}
