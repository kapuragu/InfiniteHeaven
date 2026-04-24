-------------------------------------------------------------------------------
-- サウンドプラグインスクリプト
-------------------------------------------------------------------------------
SoundTppSoldier = {
-------------------------------------------------------------------------------
-- 敵兵サウンドコンバータ
--  キャラクタ生成時に呼ばれる関数
--  再生するサウンドに関する設定を行う
-------------------------------------------------------------------------------
Setup = function( id )

	-- basis, action, symbolは編集可 type, suitIdは編集/要素追加可 その他はプログラマ対応が必要
	SoundComponentEnemyEventConvert.SetEnemyRattleSuit{
		-- "[basis]_[symbol]_[action]"
		scriptId = id,
		reference = {
			"RATTLE_SUIT",		-- 衣擦れ
		},
		basis = "sfx_e_rtl_suit",			-- 今だけはbasisが空だとPostEventされないようになっています
		action = {
			"wk",			-- 歩き
			"wkc",			-- しゃがみ歩き
			"rn",			-- 走り
			"rnc",			-- しゃがみ走り
			"dh",			-- ダッシュ
			"cr",			-- うつ伏せ(敵兵にはうつ伏せ移動は現状存在しない)
			"cp",			-- あお向け(敵兵にはうつ伏せ移動は現状存在しない)
		},
		type = {
			"normal",		-- 一般
			"heavy",		-- 重装備
		},
		-- 現状は敵タイプが取れないので、normal(仮)のsymbolのみ記述してください(必ずそれが使用されます)
		-- 一般兵
		normal = {
			symbol = "nom",
			suitId = {
				"",
			},
		},
		-- 重装備
		heavy = {
			symbol = "hvy",
			suitId = {
				"",
			},
		},
	}

	-- basis, wet, symbolは編集可 type, materialは編集/要素追加可 その他はプログラマ対応が必要
	SoundComponentEnemyEventConvert.SetEnemyBodyCollision{
		-- "[basis]_[symbol]([wet])_[action]"
		scriptId = id,
		reference = {
			"CHEST_GROUND",	-- 胸接触
		},
		basis = "sfx_e",
		action = {
			"hitfenc",			-- 通常（手すりあたり）
			"hitwall",			-- 投げられ(Throwタグ)
		},
		wet = "W",
		type = {
			"soil",			-- 砂地(デフォルト)
			"soilm",		-- 水場２
			"rock",			-- 岩
			"clot",			-- 布敷きのコンクリ
			"grass",		-- 芝
			"grav",			-- 砂利
			"wood",			-- 木
			"iron",			-- 金属
			"fence",		-- フェンス
		},
		-- 砂地
		soil = {
			symbol = "SOILA",
			wet = false,
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
			wet = false,
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
			wet = false,
			material = {
				"MTR_CLOT_C",	-- 布（布敷きのコンクリを想定）
				"MTR_CLOT_D",	-- 布製の網
			},
		},
		-- 芝
		grass = {
			symbol = "GRASA",
			wet = false,
			material = {
				"MTR_TURF_A",	-- 草が生えている面
				"MTR_LEAF",		-- 葉（透過無し）
			},
		},
		-- 砂利
		grav = {
			symbol = "GRAVA",
			wet = false,
			material = {
				"MTR_GRAV_A",	-- 
				"MTR_SOIL_C",	-- おためし
			},
		},
		-- 木
		wood = {
			symbol = "WOODA",
			wet = false,
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
			wet = false,
			material = {
				"MTR_IRON_A",	-- 鉄
				"MTR_IRON_B",	-- アルミ
				"MTR_FENC_A",	-- 
				"MTR_PIPE_A",	-- 
				"MTR_PIPE_B",	-- 
				"MTR_TIN_A",	-- 
				"MTR_IRON_E",	-- さらに厚い鉄
			},
		},
		-- フェンス
		fence = {
			symbol = "FENCA",
			wet = false,
			material = {
				"MTR_FENC_B",	-- 網フェンス
				"MTR_CLOT_E",	-- 布つき網フェンス
			},
		},
	}

	-- basis, action, side, wet, symbolは編集可 type, materialは編集/要素追加可 その他はプログラマ対応が必要
	SoundComponentEnemyEventConvert.SetEnemyFootStep{
		-- "[basis]_[symbol]([wet])_[action]_[side]"
		scriptId = id,
		reference = {
			"FOOT_GROUND_L",	-- 左足接地
			"FOOT_GROUND_R",	-- 右足接地
			"FOOT_LEAVE_L",		-- 左足離れ
			"FOOT_LEAVE_R",		-- 右足離れ
		},
		basis = "Play_sfx_E_Fs",
		action = {
			-- 立ち歩き
			"Wk_Grd", 		-- 接地
			"Wk_Lev", 		-- 離れ
			"Wk_Grd", 		-- 停止
			"Wk_Lev", 		-- 出だし
			"Wk_Grd", 		-- 接地ターン
			"Wk_Lev", 		-- 離れターン
			"Wk_Grd",		-- 着地
			"Wk_Lev",		-- ジャンプ
			-- しゃがみ歩き
			"WkC_Grd", 		-- 接地
			"WkC_Lev", 		-- 離れ
			"WkC_Grd", 		-- 停止
			"WkC_Lev", 		-- 出だし
			"WkC_Grd", 		-- 接地ターン
			"WkC_Lev", 		-- 離れターン
			"WkC_Grd",		-- 着地
			"WkC_Lev",		-- ジャンプ
			-- 立ち走り
			"Rn_Grd", 		-- 接地
			"Rn_Lev", 		-- 離れ
			"Wk_Grd", 		-- 停止
			"Wk_Lev", 		-- 出だし
			"Rn_Grd", 		-- 接地ターン
			"Rn_Lev", 		-- 離れターン
			"Rn_Grd",		-- 着地
			"Rn_Lev",		-- ジャンプ
			-- しゃがみ走り
			"RnC_Grd", 		-- 接地
			"RnC_Lev", 		-- 離れ
			"WkC_Grd", 		-- 停止
			"WkC_Lev", 		-- 出だし
			"RnC_Grd", 		-- 接地ターン
			"RnC_Lev", 		-- 離れターン
			"RnC_Grd",		-- 着地
			"RnC_Lev",		-- ジャンプ
			-- ダッシュ
			"Dh_Grd", 		-- 接地
			"Dh_Lev", 		-- 離れ
			"Wk_Grd", 		-- 停止
			"Wk_Lev",		-- 出だし
			"Dh_Grd", 		-- 接地ターン
			"Dh_Lev", 		-- 離れターン
			"Dh_Grd",		-- 着地
			"Dh_Lev",		-- ジャンプ
			-- 壁登り
			"Wk_Grd", 		-- 足接地
			"Wk_Lev", 		-- 足離れ
			"Wk_Grd", 		-- 腕接地
			"Wk_Lev", 		-- 腕離れ
			-- うつ伏せホフク
			"Wk_Grd", 		-- 足接地
			"Wk_Lev",		-- 足出だし
			"Wk_Grd", 		-- 腕接地
			"Wk_Lev",		-- 腕出だし
			-- あお向けホフク
			"Wk_Grd", 		-- 足接地
			"Wk_Lev",		-- 足出だし
			"Wk_Grd", 		-- 腕接地
			"Wk_Lev",		-- 腕出だし
		},
		side = {
			"L",			-- 左
			"R",			-- 右
		},
		wet = "W",
		type = {
			"soil",			-- 砂地(デフォルト)
			"soilm",		-- 水場２
			"rock",			-- 岩
			"clot",			-- 布敷きのコンクリ
			"grass",		-- 芝
			"grav",			-- 砂利
			"wood",			-- 木
			"iron",			-- 金属
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
				"MTR_CLOT_C",	-- 布（布敷きのコンクリを想定）
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
				"MTR_FENC_A",	-- 
				"MTR_FENC_B",	-- 
				"MTR_PIPE_A",	-- 
				"MTR_PIPE_B",	-- 
				"MTR_TIN_A",	-- 
				"MTR_CLOT_E",	-- 布つき網フェンス
				"MTR_IRON_E",	-- さらに厚い鉄
			},
		},
	}

end,

}
