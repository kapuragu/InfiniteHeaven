-------------------------------------------------------------------------------
-- テープ情報定義スクリプト
-------------------------------------------------------------------------------
PreinstallTape = {

SetStructure = function()

	-- このファイルで登録するテープおよび曲情報の事前登録
	TppMusicPlayer.SetStructure{
		albumNum = 19,	-- 総アルバム数
		trackNum = 62,	-- 総トラック数
	}

end,

SetMusicInfo = function()

--[[
	-- 書式 --

	-- テープ情報登録
	TppMusicPlayer.SetAlbum{
		albumId = "tp_chico_01",		-- テープ文字列ID(テープ管理エクセル参照)
		trackNum = 1,					-- テープ内のトラック数
		type = "PREINSTALL_TAPE"		-- 下記
	}
		-- typeについて
		--    PREINSTALL_MUSIC : プリインストール曲
		--    PREINSTALL_TAPE  : プリインストールテープ
		--    DOWNLOAD_MUSIC   : ダウンロード曲(GZ非対応)
		--    DOWNLOAD_TAPE    : ダウンロードテープ(GZ非対応)

	-- トラック情報登録
	TppMusicPlayer.SetTrack{
		trackIndex = 0,					-- テープ内インデックス(連番)
		fileName = "tp_chico_00_01",	-- wemファイル名
		dataTimeJp = 231000,			-- 日本語再生時間[ms]
		dataTimeEn = 231000,			-- 英語再生時間[ms]
		albumId = "tp_chico_01",		-- トラックを登録するテープのアルバムID
	}
]]

	-- チコテープ1
	TppMusicPlayer.SetAlbum{
		albumId = "tp_chico_01",
		trackNum = 1,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_chico_00_01",
		dataTimeJp = 231000,
		dataTimeEn = 231000,
		albumId = "tp_chico_01",
	}

	-- チコテープ2
	TppMusicPlayer.SetAlbum{
		albumId = "tp_chico_02",
		trackNum = 1,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_chico_00_02",
		dataTimeJp = 149000,
		dataTimeEn = 149000,
		albumId = "tp_chico_02",
	}

	-- チコテープ3
	TppMusicPlayer.SetAlbum{
		albumId = "tp_chico_03",
		trackNum = 1,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_chico_00_03",
		dataTimeJp = 98000,
		dataTimeEn = 98000,
		albumId = "tp_chico_03",
	}

	-- チコテープ4
	TppMusicPlayer.SetAlbum{
		albumId = "tp_chico_04",
		trackNum = 1,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_chico_00_04",
		dataTimeJp = 607000,
		dataTimeEn = 599000,
		albumId = "tp_chico_04",
	}

	-- チコテープ5
	TppMusicPlayer.SetAlbum{
		albumId = "tp_chico_05",
		trackNum = 1,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_chico_00_05",
		dataTimeJp = 231000,
		dataTimeEn = 220000,
		albumId = "tp_chico_05",
	}

	-- チコテープ6
	TppMusicPlayer.SetAlbum{
		albumId = "tp_chico_06",
		trackNum = 1,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_chico_00_06",
		dataTimeJp = 281000,
		dataTimeEn = 273000,
		albumId = "tp_chico_06",
	}

	-- チコテープ7
	TppMusicPlayer.SetAlbum{
		albumId = "tp_chico_07",
		trackNum = 1,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_chico_00_07",
		dataTimeJp = 396000,
		dataTimeEn = 369000,
		albumId = "tp_chico_07",
	}

	-- チコテープ8
	TppMusicPlayer.SetAlbum{
		albumId = "tp_chico_08",
		trackNum = 7,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_chico_00_01",
		dataTimeJp = 231000,
		dataTimeEn = 231000,
		albumId = "tp_chico_08",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 1,
		fileName = "tp_chico_00_02",
		dataTimeJp = 149000,
		dataTimeEn = 149000,
		albumId = "tp_chico_08",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 2,
		fileName = "tp_chico_00_03",
		dataTimeJp = 98000,
		dataTimeEn = 98000,
		albumId = "tp_chico_08",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 3,
		fileName = "tp_chico_00_04",
		dataTimeJp = 607000,
		dataTimeEn = 599000,
		albumId = "tp_chico_08",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 4,
		fileName = "tp_chico_00_05",
		dataTimeJp = 231000,
		dataTimeEn = 220000,
		albumId = "tp_chico_08",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 5,
		fileName = "tp_chico_00_06",
		dataTimeJp = 281000,
		dataTimeEn = 273000,
		albumId = "tp_chico_08",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 6,
		fileName = "tp_chico_00_07",
		dataTimeJp = 396000,
		dataTimeEn = 369000,
		albumId = "tp_chico_08",
	}

	-- ブリーフィング
	TppMusicPlayer.SetAlbum{
		albumId = "tp_bf20010_01",
		trackNum = 9,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_20010_01_01",
		dataTimeJp = 58000,
		dataTimeEn = 46000,
		albumId = "tp_bf20010_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 1,
		fileName = "tp_20010_01_02",
		dataTimeJp = 34000,
		dataTimeEn = 28000,
		albumId = "tp_bf20010_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 2,
		fileName = "tp_20010_01_03",
		dataTimeJp = 108000,
		dataTimeEn = 88000,
		albumId = "tp_bf20010_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 3,
		fileName = "tp_20010_01_04",
		dataTimeJp = 135000,
		dataTimeEn = 118000,
		albumId = "tp_bf20010_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 4,
		fileName = "tp_20010_01_05",
		dataTimeJp = 94000,
		dataTimeEn = 78000,
		albumId = "tp_bf20010_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 5,
		fileName = "tp_20010_01_06",
		dataTimeJp = 139000,
		dataTimeEn = 119000,
		albumId = "tp_bf20010_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 6,
		fileName = "tp_20010_01_07",
		dataTimeJp = 72000,
		dataTimeEn = 61000,
		albumId = "tp_bf20010_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 7,
		fileName = "tp_20010_01_08",
		dataTimeJp = 62000,
		dataTimeEn = 54000,
		albumId = "tp_bf20010_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 8,
		fileName = "tp_20010_01_09",
		dataTimeJp = 117000,
		dataTimeEn = 96000,
		albumId = "tp_bf20010_01",
	}

	-- パスの報告
	TppMusicPlayer.SetAlbum{
		albumId = "tp_pw_01",
		trackNum = 12,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_pw_01_01",
		dataTimeJp = 32000,
		dataTimeEn = 20000,
		albumId = "tp_pw_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 1,
		fileName = "tp_pw_01_02",
		dataTimeJp = 79000,
		dataTimeEn = 63000,
		albumId = "tp_pw_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 2,
		fileName = "tp_pw_01_03",
		dataTimeJp = 44000,
		dataTimeEn = 41000,
		albumId = "tp_pw_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 3,
		fileName = "tp_pw_01_04",
		dataTimeJp = 34000,
		dataTimeEn = 34000,
		albumId = "tp_pw_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 4,
		fileName = "tp_pw_01_05",
		dataTimeJp = 50000,
		dataTimeEn = 42000,
		albumId = "tp_pw_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 5,
		fileName = "tp_pw_01_06",
		dataTimeJp = 33000,
		dataTimeEn = 37000,
		albumId = "tp_pw_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 6,
		fileName = "tp_pw_01_07",
		dataTimeJp = 29000,
		dataTimeEn = 29000,
		albumId = "tp_pw_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 7,
		fileName = "tp_pw_01_08",
		dataTimeJp = 37000,
		dataTimeEn = 33000,
		albumId = "tp_pw_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 8,
		fileName = "tp_pw_01_09",
		dataTimeJp = 29000,
		dataTimeEn = 33000,
		albumId = "tp_pw_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 9,
		fileName = "tp_pw_01_10",
		dataTimeJp = 76000,
		dataTimeEn = 68000,
		albumId = "tp_pw_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 10,
		fileName = "tp_pw_01_11",
		dataTimeJp = 29000,
		dataTimeEn = 24000,
		albumId = "tp_pw_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 11,
		fileName = "tp_pw_01_12",
		dataTimeJp = 48000,
		dataTimeEn = 39000,
		albumId = "tp_pw_01",
	}

	-- 調査員の記録
	TppMusicPlayer.SetAlbum{
		albumId = "tp_it20030_01",
		trackNum = 1,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_it20030_01_01",
		dataTimeJp = 483000,
		dataTimeEn = 447000,
		albumId = "tp_it20030_01",
	}

	-- 機密情報データ
	TppMusicPlayer.SetAlbum{
		albumId = "tp_it20030_02",
		trackNum = 1,
		type = "PREINSTALL_TAPE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_it20030_02_01",
		dataTimeJp = 5000,
		dataTimeEn = 5000,
		albumId = "tp_it20030_02",
	}

	-- ANUBIS ZONE OF THE ENDERS
	TppMusicPlayer.SetAlbum{
		albumId = "tp_bgm_01",
		trackNum = 1,
		type = "PREINSTALL_MUSIC",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_bgm_01_01",
		dataTimeJp = 317000,
		dataTimeEn = 317000,
		albumId = "tp_bgm_01",
	}

	-- METAL GEAR SOLID PEACE WALKER MEDLEY
	TppMusicPlayer.SetAlbum{
		albumId = "tp_bgm_02",
		trackNum = 4,
		type = "PREINSTALL_MUSIC",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_bgm_02_01",
		dataTimeJp = 220000,
		dataTimeEn = 220000,
		albumId = "tp_bgm_02",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 1,
		fileName = "tp_bgm_02_02",
		dataTimeJp = 140000,
		dataTimeEn = 140000,
		albumId = "tp_bgm_02",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 2,
		fileName = "tp_bgm_02_03",
		dataTimeJp = 124000,
		dataTimeEn = 124000,
		albumId = "tp_bgm_02",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 3,
		fileName = "tp_bgm_02_04",
		dataTimeJp = 87000,
		dataTimeEn = 87000,
		albumId = "tp_bgm_02",
	}

	-- METAL GEAR SOLID Ground Zeroes
	TppMusicPlayer.SetAlbum{
		albumId = "tp_bgm_03",
		trackNum = 1,
		type = "PREINSTALL_MUSIC",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_bgm_03_01",
		dataTimeJp = 188000,
		dataTimeEn = 188000,
		albumId = "tp_bgm_03",
	}

	-- METAL GEAR SOLID
	TppMusicPlayer.SetAlbum{
		albumId = "tp_bgm_04",
		trackNum = 2,
		type = "PREINSTALL_MUSIC",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_bgm_04_01",
		dataTimeJp = 114000,
		dataTimeEn = 114000,
		albumId = "tp_bgm_04",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 1,
		fileName = "tp_bgm_04_02",
		dataTimeJp = 202000,
		dataTimeEn = 202000,
		albumId = "tp_bgm_04",
	}

	-- 雷電
	TppMusicPlayer.SetAlbum{
		albumId = "tp_bgm_05",
		trackNum = 2,
		type = "PREINSTALL_MUSIC",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_bgm_05_01",
		dataTimeJp = 163000,
		dataTimeEn = 163000,
		albumId = "tp_bgm_05",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 1,
		fileName = "tp_bgm_05_02",
		dataTimeJp = 119000,
		dataTimeEn = 119000,
		albumId = "tp_bgm_05",
	}

	-- 平和と和平のブルース
	TppMusicPlayer.SetAlbum{
		albumId = "tp_archCD_01",
		trackNum = 5,
		type = "PREINSTALL_ARCHIVE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_arch_cd_01_01",
		dataTimeJp = 321000,
		dataTimeEn = 0,
		albumId = "tp_archCD_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 1,
		fileName = "tp_arch_cd_01_02",
		dataTimeJp = 534000,
		dataTimeEn = 0,
		albumId = "tp_archCD_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 2,
		fileName = "tp_arch_cd_01_03",
		dataTimeJp = 428000,
		dataTimeEn = 0,
		albumId = "tp_archCD_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 3,
		fileName = "tp_arch_cd_01_04",
		dataTimeJp = 506000,
		dataTimeEn = 0,
		albumId = "tp_archCD_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 4,
		fileName = "tp_arch_cd_01_05",
		dataTimeJp = 362000,
		dataTimeEn = 0,
		albumId = "tp_archCD_01",
	}

	-- パスの日記
	TppMusicPlayer.SetAlbum{
		albumId = "tp_archDiary_01",
		trackNum = 10,
		type = "PREINSTALL_ARCHIVE",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 0,
		fileName = "tp_arch_diary_01_01",
		dataTimeJp = 132000,
		dataTimeEn = 111000,
		albumId = "tp_archDiary_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 1,
		fileName = "tp_arch_diary_01_02",
		dataTimeJp = 166000,
		dataTimeEn = 150000,
		albumId = "tp_archDiary_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 2,
		fileName = "tp_arch_diary_01_03",
		dataTimeJp = 262000,
		dataTimeEn = 218000,
		albumId = "tp_archDiary_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 3,
		fileName = "tp_arch_diary_01_04",
		dataTimeJp = 243000,
		dataTimeEn = 209000,
		albumId = "tp_archDiary_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 4,
		fileName = "tp_arch_diary_01_05",
		dataTimeJp = 245000,
		dataTimeEn = 231000,
		albumId = "tp_archDiary_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 5,
		fileName = "tp_arch_diary_01_06",
		dataTimeJp = 273000,
		dataTimeEn = 216000,
		albumId = "tp_archDiary_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 6,
		fileName = "tp_arch_diary_01_07",
		dataTimeJp = 217000,
		dataTimeEn = 172000,
		albumId = "tp_archDiary_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 7,
		fileName = "tp_arch_diary_01_08",
		dataTimeJp = 259000,
		dataTimeEn = 205000,
		albumId = "tp_archDiary_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 8,
		fileName = "tp_arch_diary_01_09",
		dataTimeJp = 177000,
		dataTimeEn = 130000,
		albumId = "tp_archDiary_01",
	}

	TppMusicPlayer.SetTrack{
		trackIndex = 9,
		fileName = "tp_arch_diary_01_10",
		dataTimeJp = 319000,
		dataTimeEn = 196000,
		albumId = "tp_archDiary_01",
	}

end,

}
