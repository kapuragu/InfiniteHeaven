local crossSectionMaterialList = {
-- スイカテスト？
{
   materialName = "CrossSectionMaterialTest0",
   shaderTechnique = "MGS4_CH_BUMP_A",
   texture = {
	  Base_Tex_SRGB="wmln_itm_peel1_cut_c00_bsm_rep",
	  NormalMap_Tex_LIN="wmln_itm_main0_def_c00_nrm_rep",
	  SpecularMap_HeightMap_Tex_LIN="wmln_itm_peel0_def_c00_spe_rep"
   },
   parameter = {
	  Specular_Diffusion = {30}
   },
   uvScale = 0.4
},
{
   materialName = "CrossSectionMaterialTest1",
   shaderTechnique = "MGS4_CH_BUMP_A",
   texture = {
	  Base_Tex_SRGB="wmln_itm_main0_def_c00_bsm_rep",
	  NormalMap_Tex_LIN="wmln_itm_main0_def_c00_nrm_rep",
	  SpecularMap_HeightMap_Tex_LIN="wmln_itm_main0_def_c00_spe_rep"
   },
   parameter = {
	  Specular_Diffusion = {256}
   },
   uvScale = 0.4
},
-- スイカ
{
   materialName = "CrossSectionMaterialWaterMelonCut1",
   shaderTechnique = "MGS4_CH_BUMP_A",
   texture = {
	  Base_Tex_SRGB="wmln_itm_peel1_cut_c00_bsm_rep",
	  NormalMap_Tex_LIN="wmln_itm_main0_def_c00_nrm_rep",
	  SpecularMap_HeightMap_Tex_LIN="wmln_itm_main0_def_c00_spe_rep"
   },
   parameter = {
	  Specular_Diffusion = {128}
   },   
   uvScale = 0.4
},
{
   materialName = "CrossSectionMaterialWaterMelonCut2",
   shaderTechnique = "MGS4_CH_BUMP_A",
   texture = {
	  Base_Tex_SRGB="wmln_itm_main0_def_c00_bsm_rep",
	  NormalMap_Tex_LIN="wmln_itm_main0_cut_c00_nrm_rep",
	  SpecularMap_HeightMap_Tex_LIN="wmln_itm_main0_def_c00_spe_rep"
   },
   parameter = {
	  Specular_Diffusion = {64}
   },
   uvScale = 0.4
},
-- 仔月光
{
   materialName = "CrossSection_KogekkoCutBody",
   shaderTechnique = "MGS4_CH_BUMP_A",
   texture = {
	  Base_Tex_SRGB="mech_cut_main0_def_c00_bsm_rep_tgs",
	  NormalMap_Tex_LIN="mech_cut_main0_def_c00_nrm_rep_tgs",
	  SpecularMap_HeightMap_Tex_LIN="mech_cut_main0_def_c00_spe_rep_tgs"
   },
   parameter = {
	  Specular_Diffusion = {382}
   },
   uvScale = 0.3
},
{
   materialName = "CrossSection_KogekkoCutBodySkin",
   shaderTechnique = "MGS4_CH_BUMP_A",
   texture = {
	  Base_Tex_SRGB="iron_cut_main0_def_c00_bsm_rep_tgs",
	  NormalMap_Tex_LIN="damy_cut_main0_def_nrm_rep_tgs",
	  SpecularMap_HeightMap_Tex_LIN="iron_cut_main0_def_c00_spe_rep_tgs"
   },
   parameter = {
	  Specular_Diffusion = {382}
   },
   uvScale = 0.3
},
{
   materialName = "CrossSection_KogekkoCutArm",
   shaderTechnique = "MGS4_CH_BUMP_A",
   texture = {
	  Base_Tex_SRGB="mscl_cut_main0_def_c00_bsm_rep_tgs",
	  NormalMap_Tex_LIN="mscl_cut_main0_def_c00_nrm_rep_tgs",
	  SpecularMap_HeightMap_Tex_LIN="mscl_cut_main0_def_c00_spe_rep_tgs"
   },
   parameter = {
	  Specular_Diffusion = {128}
   },
   uvScale = 0.3
},
{
   materialName = "CrossSection_KogekkoCutArmSkin",
   shaderTechnique = "MGS4_CH_BUMP_A",
   texture = {
	  Base_Tex_SRGB="rub_cut_main0_def_c00_bsm_rep_tgs",
	  NormalMap_Tex_LIN="damy_cut_main0_def_nrm_rep_tgs",
	  SpecularMap_HeightMap_Tex_LIN="rub_cut_main0_def_c00_spe_rep_tgs"
   },
   parameter = {
	  Specular_Diffusion = {254}
   },
   uvScale = 0.3
},
-- ボーリングピン
{
   materialName = "CrossSection_BowlPinCutBody",
   shaderTechnique = "MGS4_CH_BUMP_A",
   texture = {
	  Base_Tex_SRGB="bpin_cut_main0_def_c00_bsm_rep_tgs",
	  NormalMap_Tex_LIN="bpin_cut_main0_def_c00_nrm_rep_tgs",
	  SpecularMap_HeightMap_Tex_LIN="bpin_cut_main0_def_c00_spe_rep_tgs"
   },
   parameter = {
	  Specular_Diffusion = {254}
   },
   uvScale = 0.4
},
{
   materialName = "CrossSection_BowlPinCutInside",
   shaderTechnique = "MGS4_CH_BUMP_A",
   texture = {
	  Base_Tex_SRGB="wood_cut_main0_def_c00_bsm_rep_tgs",
	  NormalMap_Tex_LIN="wood_cut_main0_def_c00_nrm_rep_tgs",
	  SpecularMap_HeightMap_Tex_LIN="wood_cut_main0_def_c00_spe_rep_tgs"
   },
   parameter = {
	  Specular_Diffusion = {128}
   },
   uvScale = 0.4
}
}

local crossSectionMaterialConfig = {
   {
	  models={
		 "MESH_all",
		 "ghsd_def",
	  },
	  defaultMaterial="CrossSectionMaterialTest0",
	  replaceMaterialList = {
		 foxColladafxShader1="CrossSectionMaterialTest0",
		 foxColladafxShader2="CrossSectionMaterialTest1",
		 CrossSectionMaterialTest0="CrossSectionMaterialTest0",
		 CrossSectionMaterialTest1="CrossSectionMaterialTest1"
	  }
   },
   {
	  models={
		 "mep_def",
	  },
	  defaultMaterial="CrossSectionMaterialWaterMelonCut2",
	  replaceMaterialList = {
		 foxColladafxShader1="CrossSectionMaterialWaterMelonCut2",
		 foxColladafxShader2="CrossSectionMaterialWaterMelonCut2",
		 CrossSectionMaterialWaterMelonCut2="CrossSectionMaterialWaterMelonCut2",
	  }
   },
   {
	  models={
		"water_melon",
	  },
	  defaultMaterial="CrossSectionMaterialWaterMelonCut1",
	  replaceMaterialList = {
		 foxColladafxShader1="CrossSectionMaterialWaterMelonCut1",
		 foxColladafxShader2="CrossSectionMaterialWaterMelonCut2",
		 CrossSectionMaterialWaterMelonCut1="CrossSectionMaterialWaterMelonCut1",
		 CrossSectionMaterialWaterMelonCut2="CrossSectionMaterialWaterMelonCut2",
	  }
   },
   {
	  models={
		"water_melon_inside_FRAC_9",
		"water_melon_inside_FRAC_11",
		"water_melon_inside_FRAC_13",
		"water_melon_inside_FRAC_14",
		"water_melon_inside_FRAC_15",
		"water_melon_inside_FRAC_16",
		"water_melon_inside_FRAC_17",
		"water_melon_inside_FRAC_18",
		"water_melon_inside_FRAC_19",
		"water_melon_inside_FRAC_20",
		"water_melon_inside_FRAC_21",
		"water_melon_inside_FRAC_22",
		"water_melon_outside_FRAC_7",
		"water_melon_outside_FRAC_8",
		"water_melon_outside_FRAC_9",
		"water_melon_outside_FRAC_10",
		"water_melon_outside_FRAC_11",
		"water_melon_outside_FRAC_12",
		"water_melon_outside_FRAC_13",
		"water_melon_outside_FRAC_14"
	  },
	  defaultMaterial="CrossSectionMaterialWaterMelonCut2",
	  replaceMaterialList = {
		 foxColladafxShader1="CrossSectionMaterialWaterMelonCut2",
		 foxColladafxShader2="CrossSectionMaterialWaterMelonCut2",
		 foxColladafxShader3="CrossSectionMaterialWaterMelonCut2",
		 CrossSectionMaterialWaterMelonCut2="CrossSectionMaterialWaterMelonCut2",
	  }
   },
   {
	  models={
		"kgek_mgr_main0_def_tgs"
	  },
	  defaultMaterial="CrossSection_KogekkoCutBody",
	  replaceMaterialList = {
		 fox_basic_phong_bump_arm="CrossSection_KogekkoCutArm",
		 fox_basic_phong_bump_body_skin="CrossSection_KogekkoCutBodySkin",
		 fox_basic_phong_bump_arm_skin="CrossSection_KogekkoCutArmSkin",
		 CrossSection_KogekkoCutArm="CrossSection_KogekkoCutArm",
		 CrossSection_KogekkoCutBodySkin="CrossSection_KogekkoCutBodySkin",
		 CrossSection_KogekkoCutArmSkin="CrossSection_KogekkoCutArmSkin"
	  }
   },
   {
	  models={
		"bpin_itm_main0_def_tgs"
	  },
	  defaultMaterial="CrossSection_BowlPinCutBody",
	  replaceMaterialList = {
		 fox_basic_phong_bump_inside="CrossSection_BowlPinCutInside",
		 CrossSection_BowlPinCutInside="CrossSection_BowlPinCutInside"
	  }
   },
   {
	  models={
		"conc_cut_1"
	  },
	  defaultMaterial="CrossSection_BowlPinCutBody",
	  replaceMaterialList = {
		 fox_basic_phong_bump_inside="CrossSection_BowlPinCutInside",
		 CrossSection_BowlPinCutInside="CrossSection_BowlPinCutInside"
	  }
   },
   {
	  models={
		"test_group"
	  },
	  defaultMaterial="CrossSection_KogekkoCutBodySkin",
	  replaceMaterialList = {
		 MTR_IRON_D="CrossSection_BowlPinCutInside",
		 MTR_CLOT_B="CrossSectionMaterialTest0",
		 MTR_BLOOD_A="CrossSectionMaterialTest1"
	  }
   },
   {
	  models={
		"pill_1"
	  },
	  defaultMaterial="CrossSection_BowlPinCutBody",
	  replaceMaterialList = {
		 fox_basic_phong_bump_inside="CrossSection_BowlPinCutInside",
		 CrossSection_BowlPinCutInside="CrossSection_BowlPinCutInside"
	  }
   }
}


GrxModelCutter():AddMaterialList( crossSectionMaterialList );
GrxModelCutter():AddModelCrossSectionConfig( crossSectionMaterialConfig );
print( "@@ GrxModelCutter MATERIAL SETTING OK." )
