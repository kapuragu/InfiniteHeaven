--[[
	Gr初期化スクリプト
]]

-- TexturePack のロード待ち機能を有効化
GrTools:SetTexturePackLoadConditioningEnable(true)

-- テクスチャのデフォルトパス
GrTools.SetDefaultTextureLoadPath( "/tmp/")
-- 新シェーダー用テクスチャ
GrTools.SetReflectionTexture("/Assets/fox/effect/gr_pic/default_reflection.ftex")
GrTools.SetMaterialTexture("/Assets/fox/effect/gr_pic/materials_alp_rgba32_nomip_nrt.ftex")
GrTools.SetMaterialParamBinary("/Assets/fox/effect/gr_pic/material_params.fmtt")

-- テレインマテリアルのデフォルトテクスチャ
GrTools.SetTerrainMaterialTexture(0
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(1
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain01_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(2
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain02_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(3
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain03_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(4
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain04_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(5
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain05_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(6
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain06_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(7
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain07_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(8
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain08_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(9
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain09_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(10
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain10_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(11
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain11_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(12
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain12_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(13
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain13_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(14
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain14_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )
GrTools.SetTerrainMaterialTexture(15
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain15_bsm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_nrm.ftex"
								, "/Assets/fox/environ/terrain_def_tex/sourceimages/initterrain00_srm.ftex" )


-- デバッグ表示設定
-----------------------------------------------------------------------------------------------
local isEnableDebugPrint      = true 
local isEnableDebug2D         = true 
local isEnableDebugPrimitive  = true 
if Preference then
	local edGrDebugDrawSetting = Preference.GetPreferenceEntity("DebugDrawSetting")
	if not Entity.IsNull(edGrDebugDrawSetting) then
	    isEnableDebugPrint      = edGrDebugDrawSetting.isEnableDebugPrint    
	    isEnableDebug2D         = edGrDebugDrawSetting.isEnableDebug2D       
	    isEnableDebugPrimitive  = edGrDebugDrawSetting.isEnableDebugPrimitive
	end
end
-- レンダリングモード切り替え
-----------------------------------------------------------------------------------------------
GrTools.SwitchRenderMode( {renderName="MainRender", execMode="deferred" } )
--GrTools.SwitchRenderMode( {renderName="MainRender", execMode="forward" } )
--GrTools.SwitchRenderMode( {renderName="MainRender", execMode="wireframe" } )
--GrTools.SwitchRenderMode( {renderName="MainRender", execMode="pseudoshade" } )

-- DEFERRED描画用のプラグイン（デフォルト）
-----------------------------------------------------------------------------------------------
-- ビューコールバックプラグイン
GrRenderPlugin.AddPlugin( GrPluginViewCallback{ pluginName="VIEW_CALLBACK", priority = 0 } )
-- モデルのセットアッププラグイン. Gr前処理なので，MODEL_DRAWより高いプライオリティ
GrRenderPlugin.AddPlugin( GrPluginModelSetup{ pluginName = "MODEL_SETUP", priority = 1 } )
-- 可視判定拡張プラグイン
GrRenderPlugin.AddPlugin( GrPluginOccluder{ pluginName="OCCLUDER", priority = 6 } )
-- フィルタリングなしのPrimitiveの描画　⇒　必ずPOSTFILTERより高い番号で登録してください！
GrRenderPlugin.AddPlugin( GrPluginPrimitiveUnfiltered{ pluginName = "PRIMITIVES_UNFILTERED", priority = 950, isEnableResolveRenderBuffer = false } )
-- フィルタリングなしのモデル描画
GrRenderPlugin.AddPlugin( GrPluginOverlayModel{ pluginName= "OVERLAY_MODEL", priority=930 } )
-- 2D描画システム
GrRenderPlugin.AddPlugin( GrPlugin2D{ pluginName = "DRAW2D", priority = 1573 } )
-- 前面2D描画 - Zバッファがクリアされちゃうので、最後の最後に登録します！
GrRenderPlugin.AddPlugin( GrPlugin2DFrontmost{ pluginName = "DRAW2D_FRONTMOST", priority = 10000 } )
-- TemporalAA - 自動で priority = 5 の TEMPORAL_AA_PREPROCESS を挿す
--GrRenderPlugin.AddPlugin( GrPluginTemporalAA{ pluginName= "TEMPORAL_AA", priority=880 } )
-- ポストフィルタ
GrRenderPlugin.AddPlugin( GrPluginPostFilter{ pluginName= "POSTFILTER", priority=900 } )
	-- トーンマップ
	GrRenderPlugin.AddPlugin( GrPluginTonemap{ pluginName="TONEMAP", priority=150, parentPluginName="POSTFILTER"} )

	-- 縮小2D描画
	GrRenderPlugin.AddPlugin( GrPlugin2DShrink{ pluginName = "DRAW2D_SHRINK", priority=400, parentPluginName="POSTFILTER" } )

	-- モーションブラー
	GrRenderPlugin.AddPlugin( GrPluginMotionBlur{ pluginName= "MOTION_BLUR", priority=500, parentPluginName="POSTFILTER" } )
	-- 色調整（必須）
	GrRenderPlugin.AddPlugin( GrPluginColorCorrection{ pluginName="COLOR_CORRECTION", priority=600, parentPluginName="POSTFILTER"} )
	-- FXAA (ポストフィルタの直後へ)
	GrRenderPlugin.AddPlugin( GrPluginFxaa{ pluginName= "FXAA", priority=901} )

-- 天球の前計算(どのGrPluginSkyよりも先にしておく)
GrRenderPlugin.AddPlugin( GrPluginPrecomputeSky{ pluginName="PRECOMPUTE_SKY", priority=7, isActive=true } )



-- DEFERRED RENDERING用
-- Deferred
GrRenderPlugin.AddPlugin( GrPluginDeferredRendering{ pluginName = "DEFERRED", priority = 10 } ) 

	-- Geometry-Pass
	GrRenderPlugin.AddPlugin( GrPluginDeferredGeometry{ pluginName="GEOMETRY_PASS", priority=10, parentPluginName ="DEFERRED" } ) 
		-- Terrain(深度書き込みのみ)
		GrRenderPlugin.AddPlugin( GrPluginTerrainDepth{ pluginName="TERRAIN_DRAW_DEPTH", priority=1, parentPluginName="GEOMETRY_PASS" } )
		-- モデル用のパス
		GrRenderPlugin.AddPlugin( GrPluginDeferredGeometryOpaque{ pluginName="OPAQUE_PASS", priority=5, parentPluginName="GEOMETRY_PASS"} )
		-- Maskが必要なモデル用のパス
		GrRenderPlugin.AddPlugin( GrPluginDeferredGeometryMasked{ pluginName="MASK_PASS", priority=10, parentPluginName="GEOMETRY_PASS"} )
	    -- Deferred-Clone
		GrRenderPlugin.AddPlugin( GrPluginCloneDeferred{ pluginName="DEFERRED_CLONE", priority=15, parentPluginName="GEOMETRY_PASS" } ) 
		-- Terrain
		GrRenderPlugin.AddPlugin( GrPluginTerrain{ pluginName="TERRAIN_DRAW", priority=20, parentPluginName="GEOMETRY_PASS" } )
		-- Decalが必要なモデル用のパス
		GrRenderPlugin.AddPlugin( GrPluginDeferredGeometryDecal{ pluginName="DECAL_PASS", priority=30, parentPluginName="GEOMETRY_PASS"} )
		-- デカール描画
		GrRenderPlugin.AddPlugin( GrPluginDecal{ pluginName= "DECALS_DEFERRED", priority=100, parentPluginName="GEOMETRY_PASS" } )
		-- Deferred-Clone-Decal
		GrRenderPlugin.AddPlugin( GrPluginCloneDeferred{ pluginName="DEFERRED_CLONEDECAL", priority=105, parentPluginName="GEOMETRY_PASS", DecalType=1 } ) 
		-- マテリアルレイヤー描画（現在は雨の為のアルベド調整のみ）
		GrRenderPlugin.AddPlugin( GrPluginMaterialLayer{ pluginName= "MATERIAL_LAYER", priority=110, parentPluginName="GEOMETRY_PASS" , isActive=true } )

	-- テレインのセルフシャドウ焼付け
	-- @GRTODO: 未実装
	-- GrRenderPlugin.AddPlugin( GrPluginSeflShadowOfTerrain{ pluginName="SELF_SHADOW_OF_TERRAIN", priority=14, parentPluginName="DEFERRED", isActive=false } )

	-- SunLight Shadow
	GrRenderPlugin.AddPlugin( GrPluginShadow{ pluginName= "SUN_SHADOW_DEFERRED", priority=15, parentPluginName="DEFERRED" } )

	-- Shading-Pass
	GrRenderPlugin.AddPlugin( GrPluginDeferredShading{ pluginName="SHADING_PASS", priority=20, parentPluginName="DEFERRED" } )
		-- 間接ライト(SH)
		GrRenderPlugin.AddPlugin( GrPluginSphericalHarmonics{ pluginName="PLUGIN_SPHERICALHARMONICS", priority=10, parentPluginName="SHADING_PASS" })
		-- Local Lights
		GrRenderPlugin.AddPlugin( GrPluginLocalLight{ pluginName="LOCAL_LIGHTS", priority=20, parentPluginName="SHADING_PASS" } ) 
		-- SunLight
		GrRenderPlugin.AddPlugin( GrPluginSunlight{ pluginName="SUNLIGHT", priority=30, parentPluginName="SHADING_PASS" } ) 
		-- ライトアキュムレーションレイヤー描画(現在は雨のみ)
		GrRenderPlugin.AddPlugin( GrPluginLightAccumulateLayer{ pluginName="LIGHT_ACCUMULATE_LAYER", priority=90, parentPluginName="SHADING_PASS" , isActive=true })

	-- SSAO (priorityの設定でSHADING_PASSの前にする。
	-- SHADING_PASSにテクスチャを登録できるために、登録順は逆。
	GrRenderPlugin.AddPlugin( GrPluginLineIntegralSSAO{ pluginName="LINEINTEGRAL_SSAO", priority=15, parentPluginName="DEFERRED" } )
	GrRenderPlugin.AddPlugin( GrPluginScreenSpaceAmbientOcclusion{ pluginName="SSAO", priority=75, isActive=false, parentPluginName="SHADING_PASS" } )


-- 指定されたバッファに書きこんでいく人たち
-- GrRenderPlugin.AddPlugin( GrPluginGivenBufferRendering{ pluginName = "GIVEN_BUFFER", priority = 20 } ) 
	-- スカイシミュレータ
	GrRenderPlugin.AddPlugin( GrPluginSky{ pluginName="SKY", priority=20, isActive=true } )
	-- Global Volumetric Fog
	GrRenderPlugin.AddPlugin( GrPluginGlobalVolumetricFog{ pluginName="GLOBAL_VOLUMETRIC_FOG", priority=8, isActive=true } )
	-- 半透明モデル
	GrRenderPlugin.AddPlugin( GrPluginAlphaModel{ pluginName= "ALPHA_MODEL", priority=28 } )
	-- Primitiveプラグインは必須（ないとエディタが落ちる？！）
	GrRenderPlugin.AddPlugin( GrPluginPrimitive{ pluginName = "PRIMITIVES", priority = 30, shrinkLevel = 1, shrinkFilter="BILATERAL" } )
	-- 光学迷彩
	--  transparency="SIMPLE" にすると複数の光学迷彩があった時に順番で描画する（重くなる！）
	GrRenderPlugin.AddPlugin( GrPluginOpticalCamouflage{ pluginName="OPTICAL_CAMOUFLAGE", priority=40 } )
	-- サーモグラフィーモデル描画
	GrRenderPlugin.AddPlugin( GrPluginThermography{ pluginName="THERMOGRAPHY", priority=45 } )
	
	-- ScreenCapture
	GrRenderPlugin.AddPlugin( GrPluginScreenCapture{ pluginName="SCREEN_CAPTURE", priority=20000 } )
	
-- デバッグ系のプラグイン
-----------------------------------------------------------------------------------------------
-- デバッグ用のプリミティブ描画
if (GrPluginPrimitiveDebug ~= nil) then
	GrRenderPlugin.AddPlugin( GrPluginPrimitiveDebug{ pluginName = "PRIMITIVE_DEBUG", priority = 3100, isActive = isEnableDebugPrimitive, isEnableResolveRenderBuffer = false } )
end
-- デバッグ描画用プラグイン
if (GrPluginDebugPrimitive ~= nil) then
	GrRenderPlugin.AddPlugin( GrPluginDebugPrimitive{ pluginName="DEBUG_DRAW", priority=1000, isActive=isEnableDebugPrimitive } )
end
-- モデルデバッグ
if (GrPluginModelDebug ~= nil) then
	GrRenderPlugin.AddPlugin( GrPluginModelDebug{ pluginName = "MODEL_DEBUG", priority=3300 } )
end
-- デバッグ用の2D描画プラグイン
if (GrPluginDebug2D ~= nil) then
	GrRenderPlugin.AddPlugin( GrPluginDebug2D{ pluginName = "DEBUG_DRAW2D", priority=3400, isActive=isEnableDebug2D } )
end
if (GrPluginDebugView ~= nil) then
	GrRenderPlugin.AddPlugin( GrPluginDebugView{ pluginName="DEBUGVIEW", priority=999 } )
end


-- FORWARD描画の切り替え用
-----------------------------------------------------------------------------------------------
GrRenderPlugin.AddPlugin( GrPluginViewCallback{ pluginName="VIEW_CALLBACK_FWD", priority = 0, execMode="forward" } )
GrRenderPlugin.AddPlugin( GrPluginModelSetup{ pluginName = "MODEL_SETUP_FWD", priority = 1, execMode="forward" } )
GrRenderPlugin.AddPlugin( GrPluginOccluder{ pluginName="OCCLUDER_FWD", priority = 2, execMode="forward" } )
GrRenderPlugin.AddPlugin( GrPluginPrimitive{ pluginName = "PRIMITIVES_FWD", priority = 800, shrinkLevel = 1, shrinkFilter="BILATERAL", execMode="forward" } )
GrRenderPlugin.AddPlugin( GrPluginPrimitiveUnfiltered{ pluginName = "PRIMITIVES_UNFILTERED_FWD", priority = 950, execMode="forward" } )
GrRenderPlugin.AddPlugin( GrPlugin2D{ pluginName = "DRAW2D_FWD", priority = 1573, execMode="forward" } )
GrRenderPlugin.AddPlugin( GrPlugin2DFrontmost{ pluginName = "DRAW2D_FRONTMOST_FWD", priority = 10000, execMode="forward" } )
GrRenderPlugin.AddPlugin( GrPluginForwardRendering{ pluginName= "FORWARD", priority=100, execMode="forward" } )
  -- SunLight Shadow
  GrRenderPlugin.AddPlugin( GrPluginShadow{ pluginName= "SHADOW_DRAW", priority=1, parentPluginName="FORWARD", execMode="forward" } )
  -- Forward Model
  GrRenderPlugin.AddPlugin( GrPluginModel{ pluginName= "MODEL", priority=10, parentPluginName="FORWARD", execMode="forward" } )
  -- デカール描画
  -- GrRenderPlugin.AddPlugin( GrPluginDecal{ pluginName="DECALS_FORWARD", priority=100, parentPluginName="FORWARD", execMode="forward" } )
  -- Terrain
  GrRenderPlugin.AddPlugin( GrPluginTerrain{ pluginName="TERRAIN_DRAW", 788, parentPluginName="FORWARD", execMode="forward" } )

if (GrPluginDebugPrimitive ~= nil) then
	GrRenderPlugin.AddPlugin( GrPluginDebugPrimitive{ pluginName="DEBUG_DRAW_FWD", priority=3200, execMode="forward", isActive=isEnableDebugPrimitive } )
end
if (GrPluginModelDebug ~= nil) then
	GrRenderPlugin.AddPlugin( GrPluginModelDebug{ pluginName = "MODEL_DEBUG_FWD", priority=3300, execMode="forward" } ) 
end
if (GrPluginDebug2D ~= nil) then
	GrRenderPlugin.AddPlugin( GrPluginDebug2D{ pluginName = "DEBUG_DRAW2D_FWD", priority=3400, execMode="forward", isActive=isEnableDebug2D } )
end