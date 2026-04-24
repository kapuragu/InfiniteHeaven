local ParameterPackingList = {
{ name = "tpp_2d_Map",
	params = {"HeightLimit0","HeightLimit1","ParHeight","TangentDir","UCenter","VCenter","UShift","VShift","URepeat","VRepeat","UShift_Mask","VShift_Mask","LoadColor","UShift_AnimMaskTex","VShift_AnimMaskTex","URepeat_AnimMaskTex","VRepeat_AnimMaskTex","Blend_AnimMaskTex","URepeat_Grid","VRepeat_Grid","BevelBlendRate","CameraPos"},
	packing = { 0x0,0x4,0x8,0x0,  0xc,0xd,0xe,0x0,  0x10,0x14,0x18,0x1c,  0x20,0x24,0x28,0x2c,  0x30,0x31,0x32,0x33,  0x34,0x38,0x3c,0x40,  0x44,0x0,0x48,0x4c,  0x50,0x54,0x55,0x56 },
	textures = { "Height_Texture", "ColorTable_Texture", "Mask_Texture", "AnimMask_Texture", "Grid_Texture" }
},
{ name = "tpp_2d_MapPAR",
	params = {"HeightLimit0","HeightLimit1","ParHeight","TangentDir","UCenter","VCenter","UShift","VShift","URepeat","VRepeat","UShift_Mask","VShift_Mask","LoadColor","UShift_AnimMaskTex","VShift_AnimMaskTex","URepeat_AnimMaskTex","VRepeat_AnimMaskTex","Blend_AnimMaskTex","URepeat_Grid","VRepeat_Grid","BevelBlendRate","CameraPos"},
	packing = { 0x0,0x4,0x8,0x0,  0xc,0xd,0xe,0x0,  0x10,0x14,0x18,0x1c,  0x20,0x24,0x28,0x2c,  0x30,0x31,0x32,0x33,  0x34,0x38,0x3c,0x40,  0x44,0x0,0x48,0x4c,  0x50,0x54,0x55,0x56 },
	textures = { "Height_Texture", "ColorTable_Texture", "Mask_Texture", "AnimMask_Texture", "Grid_Texture" }
},
{ name = "tpp_2d_DirDisp",
	params = {"refrectionR","refrectionG","refrectionB"},
	packing = { 0x0,0x4,0x8,0x0 },
	textures = { "Base_Texture", "NormalMap_Tex_NRM" }
},
{ name = "tpp_2d_FpvLensRflCubeMap",
	params = {"refrectionR","refrectionG","refrectionB"},
	packing = { 0x0,0x4,0x8,0x0 },
	textures = { "Base_Texture", "NormalMap_Tex_NRM", "CubeMap" }
},
{ name = "tpp3DFW_Constant_Scroll",
	params = {"SelfColor","SelfColorIntensity","URepeat_UV","VRepeat_UV","UShift_UV","VShift_UV"},
	packing = { 0x0,0x1,0x2,0x3,  0x4,0x0,0x0,0x0,  0x8,0xc,0x10,0x14 },
	textures = { "Mask_Tex_LIN", "ScrollLayer_Tex_LIN", "ScrolMask_Tex_LIN" }
},
{ name = "tpp3DFW_TargetMarker",
	params = {"SelfColor","ColorOffset","SelfColorIntensity","Incidence_Roughness","URepeat_ScreenTex","VRepeat_ScreenTex","UShift_ScreenTex","VShift_ScreenTex","SelfColor2","SelfColorBlend","SelfColorBlendScale","ViewRangeMax","ViewRangeMin","ViewRangeLong"},
	packing = { 0x0,0x1,0x2,0x3,  0x4,0x8,0xc,0x0,  0x10,0x14,0x18,0x1c,  0x20,0x21,0x22,0x24,  0x28,0x0,0x0,0x0,  0x2c,0x30,0x34,0x0 },
	textures = { "Noise_Tex_LIN", "Gradient_Tex_LIN", "Depth_Tex_LIN" }
},
{ name = "tpp3DFW_Constant_Sky",
	params = {"p0","p1","p2","p3","p4","p5","p6","p7"},
	packing = { 0x0,0x1,0x2,0x3,  0x4,0x5,0x6,0x7,  0x8,0x9,0xa,0xb,  0xc,0xd,0xe,0xf,  0x10,0x11,0x12,0x13,  0x14,0x15,0x16,0x17,  0x18,0x19,0x1a,0x1b,  0x1c,0x1d,0x1e,0x1f },
	textures = { "t_0", "t_1", "t_2", "t_3", "t_4", "t_5", "t_6", "t_7" }
},
{ name = "tpp_2d_Map_ScreenMask",
	params = {"HeightLimit0","HeightLimit1","ParHeight","TangentDir","UCenter","VCenter","UShift","VShift","URepeat","VRepeat","UShift_Mask","VShift_Mask","LoadColor","UShift_AnimMaskTex","VShift_AnimMaskTex","URepeat_AnimMaskTex","VRepeat_AnimMaskTex","Blend_AnimMaskTex","URepeat_Grid","VRepeat_Grid","BevelBlendRate","CameraPos"},
	packing = { 0x0,0x4,0x8,0x0,  0xc,0xd,0xe,0x0,  0x10,0x14,0x18,0x1c,  0x20,0x24,0x28,0x2c,  0x30,0x31,0x32,0x33,  0x34,0x38,0x3c,0x40,  0x44,0x0,0x48,0x4c,  0x50,0x54,0x55,0x56 },
	textures = { "Height_Texture", "ColorTable_Texture", "Mask_Texture", "AnimMask_Texture", "Grid_Texture" }
},
{ name = "tpp_2d_Map_ScreenMaskPAR",
	params = {"HeightLimit0","HeightLimit1","ParHeight","TangentDir","UCenter","VCenter","UShift","VShift","URepeat","VRepeat","UShift_Mask","VShift_Mask","LoadColor","UShift_AnimMaskTex","VShift_AnimMaskTex","URepeat_AnimMaskTex","VRepeat_AnimMaskTex","Blend_AnimMaskTex","URepeat_Grid","VRepeat_Grid","BevelBlendRate","CameraPos"},
	packing = { 0x0,0x4,0x8,0x0,  0xc,0xd,0xe,0x0,  0x10,0x14,0x18,0x1c,  0x20,0x24,0x28,0x2c,  0x30,0x31,0x32,0x33,  0x34,0x38,0x3c,0x40,  0x44,0x0,0x48,0x4c,  0x50,0x54,0x55,0x56 },
	textures = { "Height_Texture", "ColorTable_Texture", "Mask_Texture", "AnimMask_Texture", "Grid_Texture" }
},
{ name = "tpp_2d_DirDispCa",
	params = {"refrectionR","refrectionG","refrectionB"},
	packing = { 0x0,0x4,0x8,0x0 },
	textures = { "Base_Texture", "NormalMap_Tex_NRM" }
},
{ name = "tpp3DDC_MetalicBacteria_LNM",
	params = {"MatParamIndex_0","BlackLight","UShift_UV","VShift_UV","UShiftBL_UV","VShiftBL_UV"},
	packing = { 0x0,0x0,0x0,0x0,  0x4,0x5,0x6,0x0,  0x8,0xc,0x10,0x14 },
	textures = { "Base_Tex_SRGB", "NormalMap_Tex_NRM", "SpecularMap_Tex_LIN", "BlackLightMask_Tex_LIN", "MetalicBacteria_Tex_LIN", "Mask_Tex_LIN" }
},
{ name = "tpp3DDC_MetalicBacteria2_LNM",
	params = {"MatParamIndex_0","BlackLight","UShift_UV","VShift_UV","UShiftBL_UV","VShiftBL_UV","MaskColorAdd"},
	packing = { 0x0,0x0,0x0,0x0,  0x4,0x5,0x6,0x0,  0x8,0xc,0x10,0x14,  0x18,0x0,0x0,0x0 },
	textures = { "Base_Tex_SRGB", "NormalMap_Tex_NRM", "SpecularMap_Tex_LIN", "BlackLightMask_Tex_LIN", "MetalicBacteria_Tex_LIN", "Mask_Tex_LIN" }
},
{ name = "tpp3DDF_MetalicBacteria_LNM",
	params = {"MatParamIndex_0","Incidence_Roughness","TensionRate","TensionShift","TensionController","Incidence_Color","EdgeRoughness","EdgeTrans","MimeticCenter","MimeticRadiusMin","MimeticRadiusMax","InnerMimeticRadiusMin","InnerMimeticRadiusMax"},
	packing = { 0x0,0x0,0x0,0x0,  0x4,0x8,0xc,0x10,  0x14,0x15,0x16,0x17,  0x18,0x1c,0x0,0x0,  0x20,0x21,0x22,0x0,  0x24,0x28,0x2c,0x30 },
	textures = { "Base_Tex_SRGB", "NormalMap_Tex_NRM", "SpecularMap_Tex_LIN", "Translucent_Tex_LIN", "MetalicLayer_Tex_LIN", "MetalicBacteria_Tex_LIN", "TensionSubNormalMap_Tex_NRM", "Dirty_Tex_LIN" }
},
{ name = "tpp3DDF_WhiteBlood_Dirty_LNM",
	params = {"MatParamIndex_0"},
	packing = { 0x0,0x0,0x0,0x0,  0x0,0x0,0x0,0x0,  0x0,0x0,0x0,0x0 },
	textures = { "Base_Tex_SRGB", "NormalMap_Tex_NRM", "SpecularMap_Tex_LIN", "Dirty_Tex_LIN" }
},
{ name = "tpp3DDF_WhiteBlood_Skin_Dirty_LNM",
	params = {"MatParamIndex_0","Incidence_Roughness","Incidence_Color"},
	packing = { 0x0,0x0,0x0,0x0,  0x4,0x0,0x0,0x0,  0x8,0x9,0xa,0xb },
	textures = { "Base_Tex_SRGB", "NormalMap_Tex_NRM", "SpecularMap_Tex_LIN", "Translucent_Tex_LIN", "Dirty_Tex_LIN" }
},
{ name = "tpp3DDF_WhiteBlood_SubNorm_Dirty_LNM",
	params = {"MatParamIndex_0","SubNormal_Blend","URepeat_UV","VRepeat_UV"},
	packing = { 0x0,0x0,0x0,0x0,  0x4,0x8,0xc,0x0,  0x0,0x0,0x0,0x0 },
	textures = { "Base_Tex_SRGB", "NormalMap_Tex_NRM", "SpecularMap_Tex_LIN", "SubNormalMap_Tex_NRM", "SubNormalMask_Tex_LIN", "Dirty_Tex_LIN" }
},
{ name = "tpp3DDF_BulletMark_LNM",
	params = {"MatParamIndex_0","Radius","DirType"},
	packing = { 0x0,0x0,0x0,0x0,  0x4,0x8,0x0,0x0 },
	textures = { "Base_Tex_SRGB", "NormalMap_Tex_NRM", "SpecularMap_Tex_LIN" }
}}
local ShaderAssignList = {
	{ technique="tpp_2d_Map",type="Forward",variation="", shader="Draw2D_TppMap"},
	{ technique="tpp_2d_Map_ScreenMask",type="Forward",variation="", shader="Draw2D_TppMap_Screen"},
	{ technique="tpp_2d_MapPAR",type="Forward",variation="", shader="Draw2D_TppMapPar"},
	{ technique="tpp_2d_Map_ScreenMaskPAR",type="Forward",variation="", shader="Draw2D_TppMapPar_Screen"},
	{ technique="tpp_2d_DirDisp",type="Forward",variation="", shader="Draw2D_TppDirDisp"},
	{ technique="tpp_2d_DirDispCa",type="Forward",variation="", shader="Draw2D_TppDirDisp_CA"},
	{ technique="tpp_2d_FpvLensRflCubeMap",type="Forward",variation="", shader="Draw2D_TppFpvLensRflCubeMap"},
	{ technique="tpp3DDC_MetalicBacteria_LNM",type="Deferred_Decal",variation="", shader="tpp3ddc_MetalicBacteria"},
	{ technique="tpp3DDC_MetalicBacteria2_LNM",type="Deferred_Decal",variation="", shader="tpp3ddc_MetalicBacteria2"},
	{ technique="tpp3DDF_MetalicBacteria_LNM",type="Deferred",variation="", shader="tpp3ddf_MetalicBacteria"},
	{ technique="tpp3DDF_WhiteBlood_Dirty_LNM",type="Deferred",variation="", shader="tpp3ddf_wblood_dirty"},
	{ technique="tpp3DDF_WhiteBlood_Skin_Dirty_LNM",type="Deferred",variation="", shader="tpp3ddf_wblood_skin_dirty"},
	{ technique="tpp3DDF_WhiteBlood_SubNorm_Dirty_LNM",type="Deferred",variation="", shader="tpp3ddf_wblood_subnorm_dirty"},
	{ technique="tpp3DDF_BulletMark_LNM",type="Deferred",variation="", shader="tpp3ddf_bulletmark"},
	{ technique="tpp3DDF_BulletMark_LNM",type="CloneDeferred",variation="", shader="tpp3ddf_bulletmark_clone"},
	{ technique="tpp3DFW_Constant_Scroll",type="Forward",variation="", shader="tpp3dfw_constant_scroll"},
	{ technique="tpp3DFW_TargetMarker",type="Forward",variation="", shader="tpp3dfw_TargetMaker"},
	{ technique="tpp3DFW_Constant_Sky",type="Forward",variation="", shader="tpp3dfw_constant_sky"}}


GrTools():SetShaderParameterPackingTable( ParameterPackingList );
GrTools():SetShaderAssignTable( ShaderAssignList );
