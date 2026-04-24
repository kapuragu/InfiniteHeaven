TppNoiseDefinitions = {


	--ノイズ定義 { "Name"  { Tags, } Idx }
Definitions = {
--## Zero / Start --
	-- 現在、下記２つはNoise無しと定義
	--"FootWalk",				{},										-- 立ち歩き
	--"FootSquatWalk",			{}, 									-- しゃがみ歩き
	
	"Zero",						{},										0,		--	---- 最小音 ------------
--## Zero / End --
	
--## SS / Start --
	"LockerClose",			{ "Sign", },									--	ロッカー閉まる音
	"MicQuest",				{ "Voice", "Human", },							--	マイクで質問
	"Holdup",				{ "Voice", "Human", "Threat", },				--	ホールドアップ
	"Dec",					{ "Threat", },									--	拳銃デコック
	"SilentShoot",			{ "Threat", },									--	サイレンサー付き射撃音
	"Flashlight",			{ "Sight", },									--	フラッシュライト まぶしい
	"SolidEye",				{ "Machine", },									--	ソリッドアイの駆動音
	"Darkness",				{ "Sight" },									--	暗闇になった
	"ResistanceFound",		{ "Voice", "Human", },							--	レジスタンスを見つけたので誰かきてくれ！
	"FootSquat",			{ "Sign", "Human", },							--	しゃがみ走り
	"SS",						{},										20,	--	---- ↑ かすかな物音 ------	--	ん？
--## SS / End --
	
--## S / Start --
	"Crawl",				{ "Sign", "Human", },							--	匍匐
	"CrawlSideroll",		{ "Sign", "Human", },							--	匍匐ゴロゴロ
	"HorseWalk",			{ "Sign", "Human", },							--	馬（１速）
	"Foot",					{ "Sign", "Human", },							--	足音
	"S",						{},										25,	--	---- ↑ 小さな物音 --------	--	ん？何の音だ？
--## S / End --
	
--## M / Start --
	"KnockWall",			{ "Sign", "Human", },							--	壁コンコン
	"Sonar",				{ "Machine", },									--	アクティブソナー波発動
	"Rebound",				{ "SmallObject", },								--	小物跳ね返り
	"ChaffRebound",			{ "SmallObject", "Threat", },					--	チャフ
	"SmokeRebound",			{ "SmallObject", "Threat", },					--	スモークグレネード
	"StunRebound",			{ "SmallObject", "Threat", },					--	スタングレネード
	"GrenadeRebound",		{ "SmallObject", "Threat", },					--	グレネード跳ね返り
	"Scream",				{ "Voice", "Human", "Threat", },				--	うわっ！
	"ScreamLarge",			{ "Voice", "Human", "Threat", },				--	きゃー！
	"Vomit",				{ "Voice", "Human", },							--	ゲロー
	"Sneeze",				{ "Voice", "Human", },							--	くしゃみ
	"Hungry",				{ "Voice", "Human", },							--	腹減り
	"Bird",					{ "Sign", },									--	鳥飛び立ち
	"Kerotan",				{ "Voice", "Kerotan", },						--	ケロタン鳴き声
	"KnockDoor",			{ "Sign", "Human", },							--	ドアコンコン @後で↑壁コンコンの次くらいに移す可能性大
	"Barbedwire",			{ "Sign", "Human", },							--	鉄乗網
	"PlayerDamage",			{ "Voice", "Human", "Damage", },				--	プレイヤーあうち
	"DogCaution",			{ "Voice", "Dog", "Threat", },					--	犬の鳴き声 警戒
	"WaterSplash",			{ "Sign", },									--	水にとびこんだ
	"WindowBreak",			{ "Crash", "Threat", },							--	窓が割れた
	"Drum",					{ "Sign", },									--	ドラムカン
	"FootDash",				{ "Sign", "Human", },							--	スプリント
	"HorseTrot",			{ "Sign", "Human", },							--	馬（２速）
	"M",						{},										50,	--	---- ↑ 大きな音 ----------	--	警戒！
--## M / End --

--## L / Start --
	"Ricochet",				{ "Gunfire", "Threat", },						--	跳弾音
	"WolfRailgunRicochet",	{ "Gunfire", "Threat", },						--	ウルフレールガンの跳弾音
	"KnockClapper",			{ "Sign", "Trap", },							--	鳴子
	"KerotanScream",		{ "Voice", "Kerotan", },						--	ケロタン撃たれた
	"LightBreak",			{ "Crash", "Threat", "Sight", },				--	サーチライト破壊
	"BombPetrobomb",		{ "Bomb", "Threat", },							--	火炎瓶爆発
	"HorseCanter",			{ "Sign", "Human", },							--	馬（3速）
	"HorseGallop",			{ "Sign", "Human", },							--	馬（４速）
	"L",						{},										75,	--	---- ↑ かなり大きな物音 --------
--## L / End --
	
--## HLL / Start --
	"StrykerStop",			{ "Sign", "Human", },							--	ストライカー停止
	"StrykerSlow",			{ "Sign", "Human", },							--	ストライカー遅い速度
	"StrykerFast",			{ "Sign", "Human", },							--	ストライカー早い速度
	"HLL",					{},											80,	--	---- 大きいが爆音ではない物音(ハーフエルでHL…付け足していった結果がこれだよ) ----
--## HLL / End --
	
--## LL / Start --
	"Shoot",				{ "Gunfire", "Threat", },						--	射撃音
	"DogAlert",				{ "Voice", "Dog", "Threat", },					--	犬の鳴き声 危険
	"GekkouAlert",			{ "Voice", "Gekkou", "Threat", },				--	月光 発見叫び
	"BombSGMine",			{ "Bomb", "Threat", },							--	睡眠地雷(さほどでもない爆発)
	"LL",						{},										90,	--	---- ↑ 爆音 --	--	超危険！
--## LL / End --

--## Alert / Start --
	"StrykerCannon",		{ "Bomb", "Threat", },							--	ストライカー主砲
	"Bomb",					{ "Bomb", "Threat", },							--	爆発系
	"BombMapObject",		{ "Bomb", "Threat", },							--	設置系オブジェクト（車やドラム缶）爆発
	"BombFacilities",		{ "Bomb", "Threat", },							--	施設が爆破された！全域に聞こえる
	"FPExplosion",			{ "Bomb", "Threat", },							--	FPが爆発した
	"BombGrenade",			{ "Bomb", "Threat", },							--	投げもの系 爆発
	"BombClaymore",			{ "Bomb", "Threat", },							--	クレイモア 爆発
	"BombMortar",			{ "Bomb", "Threat", },							--	迫撃砲 爆発
	"BombMissile",			{ "Bomb", "Threat", },							--	ミサイル系（ＲＰＧ、ジャベリン・・） 爆発
	"BombVehicle",			{ "Bomb", "Vehicle", "Threat", },				--	乗り物が爆破された ... やられたのか！？
	"Alert",					{},										120,--	---- ↑ 即危険！ -------------
--## Alert / End --

--## MAX / Start --
	"DSHK",					{ "Gunfire", "WarWeapon", "Threat", },			--	機銃
	"ZU23",					{ "Gunfire", "WarWeapon", "Threat", },			--	対空砲
	"MAX",						{},										128,	--	---- 最大音 ------------
--## MAX / End --
},


}
