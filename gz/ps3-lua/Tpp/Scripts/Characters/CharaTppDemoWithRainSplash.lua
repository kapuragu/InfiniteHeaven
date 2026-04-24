--------------------------------------------------------------------------------
-- デモ用キャラクター (キャラ雨飛沫エフェクト付き)
--------------------------------------------------------------------------------
CharaTppDemoWithRainSplash = {

----------------------------------------
--各システムとの依存関係の定義
--
-- GeoやGrなどの各システムのJob実行タイミングを
-- 「キャラクタのJob実行後」に合わせ、
-- システムを正常に動作させるために必要。
-- 使用するシステム名を記述してください。
--
-- "Gr"				: 描画を使うなら必要
-- "Geo"			: 当たりを使うなら必要
-- "Nt"				: 通信同期を使うなら必要
-- "Fx"				: エフェクトを使うなら必要
-- "Sd"				: サウンドを使うなら必要
-- "Noise"			: ノイズを使うなら必要
-- "Nav"			: 経路探索を使うなら必要
-- "GroupBehavior"	: 連携を使うなら必要
-- "Ui"				: UIを使うなら必要
----------------------------------------
dependSyncPoints = {
	"Gr",
	"Geo",
	"Nt",
	"Fx",
},

----------------------------------------
--生成処理 OnCreate()
--　キャラクタ生成時に呼ばれる関数
--　プラグインの生成などを行う
----------------------------------------
OnCreate = function( chara )

	local params = chara:GetParams()
	local partsPath = params.partsPath
	Fox.Log( "params.partsPath:" .. tostring(params.partsPath))

	--プラグインの優先順位設定
	chara:InitPluginPriorities{
		"DemoAction",
	}

	chara:AddPlugins{
		--Bodyプラグイン
		ChBodyPlugin{
			name = "Body",
			noControlHeightWithNoMotion = true,
			parts = partsPath,
--			animGraphLayer = "/Assets/fox/demo/DemoCharacter/DemoCharacter_layers.fagx",
			isSleepStart = true,
			useCharacterController = false,
			tags = { "Editor", },
			formVariation	= params.formVariationKeyName,	-- 服装変化データ参照キー
		},

		--ActionRootPlugin
		ChActionRootPlugin{
			name			= "ActionRoot",
			tags			= { "Editor", },
		},

		--デモ実演プラグイン
		ChDemoActionPlugin{
			script			= "Fox/Scripts/Characters/DemoCharacterAction.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
--			layerName		= "Demo",
			priority		= "DemoAction",
			isSleepStart	= true,
			tags			= { "Editor", },
		},

		-- Effectプラグイン
		ChEffectPlugin {
			name			= "Effect",
			bodyPluginName	= "Body",
		},
	}

	-- キャラ雨飛沫
	--引数: objectName		  オブジェクト名（任意）
	--引数: effectName		  ダミー
	--引数: effectBuilderName パーツエフェクト名（アーティストに聞いて下さい）
	--引数: effectKindName    エフェクト種類（将来的な予約）
	local fxCharaRainSplash = TppCharaRainSplash {
		objectName	      = "TppCharaRainSplash" .. chara:GetLocatorHandle().name, -- chara:GetName()
		effectName        = "dummy",
		effectBuilderName = "RainSplash",
		effectKindName    = "RainSplashDemoChara",
		isNotUnregisteredWhenUnrealize = true,
	}

	local plgEffect = chara:FindPlugin( "ChEffectPlugin" )
	if plgEffect then
		plgEffect:CallEffect( "TppCharaRainSplash" .. chara:GetLocatorHandle().name, fxCharaRainSplash )
	end

end,

----------------------------------------
--解放処理 OnRelease()
--　キャラクタの解放時によばれる
----------------------------------------
OnRelease = function( chara )

	--エフェクト終了、削除
	local plgEffect = chara:FindPlugin( "ChEffectPlugin" )
	if plgEffect then
		plgEffect:StopEffect( "TppCharaRainSplash" .. chara:GetLocatorHandle().name )
		--Fox.Log("StopEffect TppModelEffect")
	end
end,


}
