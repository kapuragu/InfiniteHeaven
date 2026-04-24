----------------------------------------------------------------
-- Tpp 犬(実験用)
----------------------------------------------------------------
CharaTppDog = {

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
	"Fx",
	"Nt",
	"Sd",
	"Noise",
},

pluginIndexEnumInfoName = "TppDogPluginDefine",

OnCreate = function( chara )

	chara:InitPluginPriorities {
		"DemoAction",
		"TailAction",
		"BasicAction",
	}

	chara:AddPlugins {
	
		-- Bodyプラグイン
		"PLG_BODY",
		ChBodyPlugin{
			name = "Body",
			parts = "parts",
			animGraphLayer	= "motionGraph",
			script			= "Tpp/Scripts/Characters/Bodies/BodyTppDog.lua",
			maxMotionPoints = { 2, 2, 2 },
			extraScaleJoints = 1,
		},

		-- Effectプラグイン
		"PLG_EFFECT",
		ChEffectPlugin {
			name			= "Effect",
			bodyPluginName	= "Body",
		},

		--モーション速度だけ変化させるプラグイン --
		"PLG_MOTION_SPEED",
		TppCharacterMotionSpeedPlugin {
			name = "TppCharacterMotionSpeed",
			bodyPluginName = "Body"
		},		

		---------------------------------------------------------------------------------------------------
		-- 以下、ActionPlugin関連
		---------------------------------------------------------------------------------------------------		

		"PLG_ACTION_ROOT",
		ChActionRootPlugin {
			name = "ActionRoot",
		},

		--デモアクションプラグイン
		"PLG_DEMO_ACTION",
		ChDemoActionPlugin{
			name			= "DemoAction",
			script			= "Tpp/Scripts/Characters/Actions/ActionTppDemo.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			layerName		= "Lower",
			priority		= "DemoAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Lower, TppPluginExclusiveGroup.Upper },
			isSleepStart	= true,
		},		
		
		"PLG_BASIC_ACTION",
--		TppBasicActionPlugin {
		TppDogBasicActionPlugin {
			name			=	"BasicAction",
			script			=	"Tpp/Scripts/Characters/Actions/ActionTppDogBasic.lua",
			parent			=	"ActionRoot",
			bodyPlugin		=	"Body",
			layerName		=	"Lower",
			priority		=	"BasicAction",
			exclusiveGroups	=	{ TppPluginExclusiveGroup.Lower },
		},

		"PLG_TAIL_ACTION",
--		TppBasicActionPlugin {
		TppDogTailActionPlugin {
			name			=	"TailAction",
			script			=	"Tpp/Scripts/Characters/Actions/ActionTppDogTail.lua",
			parent			=	"ActionRoot",
			bodyPlugin		=	"Body",
			layerName		=	"Tail",
			priority		=	"TailAction",
			exclusiveGroups	=	{ TppPluginExclusiveGroup.Upper },
		}
	}

	--犬足煙エフェクトマネージャ起動
	--引数: objectName	オブジェクト名（任意）
	--引数: effectName  今回は必要ないのでDummy（下記の通り）		
	--引数: animalKind  動物種類（下記の通り）	
	--引数: effectKind  エフェクト種類（下記の通り）
	local fxObj = TppAnimalEffectObject {
		objectName = "TppDogEffect",
		effectName = "Dummy",
		animalKind = "Dog",
		effectKind = "FootSmokeStrict",
	}
	local plgEffect = chara:FindPlugin( "ChEffectPlugin" )
	if plgEffect then
	    plgEffect:CallEffect( fxObj )
	    --Fox.Log("CallEffect TppHorseEffect")
	end

end,


OnRelease = function( chara )

	--エフェクト終了、削除
	local plgEffect = chara:FindPlugin( "ChEffectPlugin" )
	if plgEffect then
	    plgEffect:StopEffect( "TppDogEffect" )
	    --Fox.Log("StopEffect TppDogEffect")
	end
	
end,

}
