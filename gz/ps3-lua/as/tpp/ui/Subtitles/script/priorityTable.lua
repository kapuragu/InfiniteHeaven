if SubtitlesCommand then
	-- 優先度設定( 優先度区分ID, 開始時優先度, 再生中優先度 )
	SubtitlesCommand:SetDefaultSubPriority( 0, 255, 255 )	-- Unknown
	SubtitlesCommand:SetDefaultSubPriority( 1, 0, 0 )		-- Unknown(優先度を気にしない)
	SubtitlesCommand:SetDefaultSubPriority( 2, 0, 0 )		-- カットシーン
	SubtitlesCommand:SetDefaultSubPriority( 6, 15, 50 )		-- プリセット無線
	SubtitlesCommand:SetDefaultSubPriority( 9, 15, 50 )		-- 諜報無線
	SubtitlesCommand:SetDefaultSubPriority( 10, 0, 0 )		-- インゲーム演出
	SubtitlesCommand:SetDefaultSubPriority( 11, 75, 90 )	-- 敵兵音声
	SubtitlesCommand:SetDefaultSubPriority( 12, 65, 70 )	-- CP
	SubtitlesCommand:SetDefaultSubPriority( 13, 15, 11 )	-- テープ
	SubtitlesCommand:SetDefaultSubPriority( 14, 12, 20 )	-- 担ぎ台詞
	SubtitlesCommand:SetDefaultSubPriority( 16, 0, 0 )		-- スーパー
	SubtitlesCommand:SetDefaultSubPriority( 18, 5, 10 )		-- 尋問台詞
	SubtitlesCommand:SetDefaultSubPriority( 19, 12, 20 )	-- NPC音声
	SubtitlesCommand:SetDefaultSubPriority( 20, 65, 70 )	-- HQ
	SubtitlesCommand:SetDefaultSubPriority( 21, 15, 50 )	-- プリセット無線
	SubtitlesCommand:SetDefaultSubPriority( 22, 0, 0 )		-- プリセット無線
	SubtitlesCommand:SetDefaultSubPriority( 23, 1, 0 )		-- ゲームオーバー
	SubtitlesCommand:SetDefaultSubPriority( 24, 85, 90 )	-- プレイヤー音声
	SubtitlesCommand:SetDefaultSubPriority( 25, 15, 50 )	-- 任意無線
	SubtitlesCommand:SetDefaultSubPriority( 26, 75, 80 )		-- 敵兵立ち話
	SubtitlesCommand:SetDefaultSubPriority( 27, 55, 60 )		-- ヘリパイロット音声
	SubtitlesCommand:SetDefaultSubPriority( 28, 75, 90 )		-- NPC音声

	SubtitlesCommand:SetDefaultSubPriority( 61, 255, 255 )	-- 字幕カテゴリ指定無し(優先度気にしない)
	SubtitlesCommand:SetDefaultSubPriority( 62, 0, 0 )		-- 字幕カテゴリ指定無し(優先度最大)
	SubtitlesCommand:SetDefaultSubPriority( 63, 0, 0 )		-- デバッグテキスト
end