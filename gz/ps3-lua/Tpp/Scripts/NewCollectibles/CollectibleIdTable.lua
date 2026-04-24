CollectibleIdTable = {

InitTable = function()

	TppCollectibleDataManager:ClearTable();

	-- PrimaryWeaponなら最後に0
	-- SecondaryWeaponなら最後に1
	-- SupportWeaponなら最後に2
	-- を指定する。
	-- それ以外は今のところ指定無しでよい
	
	TppCollectibleDataManager:AddTable( "CP_AkType_Magazine", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am10_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_GoverType_Magazine", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hag/hg00_ammo0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_LMagazine_Test", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am07_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_M556_Magazine", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am00_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_M762_Magazine", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am02_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Magazine9mm", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am04_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_MagazineAk_Test", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am01_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_MagazineM4_Test", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am00_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_MagazineMg02_Test", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am08_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_MagazineMosin_Test", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am09_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_MagazineRuger_Test", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hag/hg01_ammo0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_MagazineScar_Test", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am06_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Magazine_hg04", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hag/hg04_ammo0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Magazine_sr01", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am09_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_QtPrproSniperMagazine", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am02_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Rpg7Shell", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/mis/ms01_ammo0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_SoundSuppressor_Test", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/smg/sm00_supp0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_StartingSniperMagazine", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am09_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_su00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/sup/su00_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_su02", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/sup/su02_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_PU_PrimaryMagazine", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am01_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_QuietPrimaryMagazine", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am02_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_hg00Ammo", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hag/hg00_ammo0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_gl01Shell", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/bul/bu01_whed0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "IT_Binocle", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/item/bin/bin0_main0_def.parts", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_CBox", TppCollectibleBlock.BLOCK_PLAYER_ITEM, "/Assets/tpp/parts/item/cbx/cbx0_main0_def.parts", "/Assets/tpp/pack/collectible/item/cbx0_main0_def.fpk" )
	TppCollectibleDataManager:AddTable( "IT_HandyLight", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/item/lig/lig0_main0_def.parts", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_IDroid", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/item/idr/idr0_main0_def_v00.parts", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_Suppressor", TppCollectibleBlock.BLOCK_PLAYER_ITEM, "/Assets/tpp/parts/item/m4a1_sup/m4a1_sup.parts", "/Assets/tpp/pack/collectible/item/m4a1_sup.fpk" )
	TppCollectibleDataManager:AddTable( "IT_Fulton", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/put/pt02_main0_def.parts", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_Knife", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/bld/bl00_main0_def.parts", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_TimeCigarette", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/item/psi/psi0_main0_def.parts", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_Cassette", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/item/cct/cct0_main1_def_v00.parts", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_XOFEmblem", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/chara/wss/wss2_eqit1_def_v00.parts", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_Skull", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/sku/Scenes/sku0_main0_def.fmdl", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_LAEmblem", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/chara/wss/la_patch_def_v00.parts", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_CureSpray", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/item/mds/mds0_main0_def_v00.parts", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_PickingToolR", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/pic/Scenes/pic0_main0_def.fmdl", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_PickingToolL", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/pic/Scenes/pic0_lhan0_def.fmdl", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_Nvg", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/item/thm/Scenes/thm0_main0_def.fmdl", "/Assets/tpp/pack/collectible/common/col_common.fpk" )
	TppCollectibleDataManager:AddTable( "IT_Cigarette", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/item/tab/tab0_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "IT_CigaretteCase", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/item/tab/tab0_cese0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "IT_Radio", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/item/rdi/rdi0_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "IT_BayonetWest", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/bld/bl05_main0_def_v00.parts", "" )

	TppCollectibleDataManager:AddTable( "WP_AK102", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar01_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/ar01_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_AkType", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar01_v01_cm.parts", "/Assets/tpp/pack/collectible/primary/ar01_v01_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_CannonShell", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/mecha/shl/shl0_main0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "WP_GoverType", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/hag/hg00_main0_aw0_v00.parts", "/Assets/tpp/pack/collectible/secondary/hg00_main0_def.fpk", 1 )
	TppCollectibleDataManager:AddTable( "WP_M4", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/ar00_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_M870", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/shg/sg01_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/sg01_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_Machete", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/bld/bl03_main0_def.parts", "/Assets/tpp/pack/collectible/primary/bl03_main0_def.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_MortarShell", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hew/hw00_ammo0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "WP_SmokeAssist", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/hew/hw00_ammo0_def_v02.parts", "" )
	TppCollectibleDataManager:AddTable( "WP_FlareBomb", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hew/hw00_ammo1_def.parts", "" )
	TppCollectibleDataManager:AddTable( "WP_Mosin", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/snr/sr02_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/sr02_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_QtPrproSniper", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/snr/sr00_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/sr00_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_Ruger", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/hag/hg01_main0_aw0_v00.parts", "/Assets/tpp/pack/collectible/secondary/hg01_main0_def.fpk", 1 )
	TppCollectibleDataManager:AddTable( "WP_Scar", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/mag/mg01_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/mg01_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_Sdar", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_v03_cm.parts", "/Assets/tpp/pack/collectible/primary/ar00_v03_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_Sdiper", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/snr/sr00_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/sr00_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_StartingSniper", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/snr/sr01_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/sr01_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_VMG50", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/hew/hw01_main0_def.parts", "/Assets/tpp/pack/collectible/primary/hw01_main0_def.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_gl01_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/grl/gl01_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/gl01_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "BL_20mmGrenade", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/bul/bu01_whed0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "WP_hw01", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/hew/hw01_main0_def.parts", "/Assets/tpp/pack/collectible/primary/hw01_main0_def.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_PU_Primary", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar01_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/ar01_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_hw01_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/hew/hw01_main0_def_v00.parts", "/Assets/tpp/pack/collectible/primary/hw01_main0_def_v00.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_hw01_v01", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/hew/hw01_main0_def_v01.parts", "/Assets/tpp/pack/collectible/primary/hw01_main0_def_v01.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_hw01_v02", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/hew/hw01_main0_def_v02.parts", "/Assets/tpp/pack/collectible/primary/hw01_main0_def_v02.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_hw03_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/hew/hw03_main0_def_v00.parts", "/Assets/tpp/pack/collectible/primary/hw03_main0_def_v00.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_hw03_v02", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hew/hw03_main0_def_v02.parts", "" )
	TppCollectibleDataManager:AddTable( "WP_HeliMachinegun", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/mecha/uth/uth0_mgun0_def.parts", "/Assets/tpp/pack/collectible/primary/uth0_mgun0_def.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_QuietPrimary", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/snr/sr00_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/sr00_v00_cm.fpk", 0 )

	-- 正式名なものはここ以下に移す。

	TppCollectibleDataManager:AddTable( "WP_ar01_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar01_main1_aw0_v00.parts", "/Assets/tpp/pack/collectible/primary/ar01_v00_asm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "CP_Ar01", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am10_main0_def_v00.parts", "" )

	TppCollectibleDataManager:AddTable( "WP_ar02", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar02_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/ar02_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "CP_Ar02", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am00_main0_def.parts", "" )

	TppCollectibleDataManager:AddTable( "WP_sr00_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/snr/sr00_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/sr00_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "CP_Sr00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am02_main0_def.parts", "" )

	TppCollectibleDataManager:AddTable( "WP_sr02_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/snr/sr02_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/sr02_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "CP_Sr02", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am09_main0_def.parts", "" )

	TppCollectibleDataManager:AddTable( "WP_mg02_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/mag/mg02_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/mg02_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "CP_Mg02", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am08_main0_def.parts", "" )

	TppCollectibleDataManager:AddTable( "WP_hg00_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/hag/hg00_v00_cm.parts", "/Assets/tpp/pack/collectible/secondary/hg00_v00_cm.fpk", 1 )

	TppCollectibleDataManager:AddTable( "WP_hg04", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/hag/hg04_main0_def.parts", "/Assets/tpp/pack/collectible/secondary/hg04_main0_def.fpk", 1 )
	TppCollectibleDataManager:AddTable( "CP_Hg04", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hag/hg04_ammo0_def.parts", "" )

	TppCollectibleDataManager:AddTable( "WP_hg08", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/hag/hg08_main0_def.parts", "/Assets/tpp/pack/collectible/secondary/hg08_main0_def.fpk", 1 )
	TppCollectibleDataManager:AddTable( "CP_Hg08", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hag/hg08_ammo0_def.parts", "" )

	TppCollectibleDataManager:AddTable( "WP_sm00_v01", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/smg/sm00_v01_sa.parts", "/Assets/tpp/pack/collectible/secondary/sm00_v01_sa.fpk", 1 )

	TppCollectibleDataManager:AddTable( "WP_ms00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/mis/ms00_main0_def.parts", "/Assets/tpp/pack/collectible/primary/ms00_main0_def.fpk", 0 )
	TppCollectibleDataManager:AddTable( "BL_Ms00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/mis/ms00_ammo0_def.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Ms00Shell", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/mis/ms00_ammo0_def.parts", "" )

	TppCollectibleDataManager:AddTable( "WP_ew00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/enw/ew00_main0_def_v00.parts", "/Assets/tpp/pack/collectible/primary/ew00_v00.fpk", 0 )
	TppCollectibleDataManager:AddTable( "CP_Ew00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/amo/am02_main0_def.parts", "" )

	TppCollectibleDataManager:AddTable( "WP_Magazine", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/weapon/amo/Scenes/am00_main0_def.fmdl", "", 2 )
	TppCollectibleDataManager:AddTable( "WP_Bottle", TppCollectibleBlock.BLOCK_SUPPORT_WEAPON, "/Assets/tpp/parts/environ/object/middle_africa/bottle/mafr_bttl001/mafr_bttl001.parts", "", 2 )
	TppCollectibleDataManager:AddTable( "WP_AntitankMine", TppCollectibleBlock.BLOCK_SUPPORT_WEAPON, "/Assets/tpp/parts/weapon/put/pt03_main0_def.parts", "/Assets/tpp/pack/collectible/support/pt03_main0_def.fpk", 2 )

	-- GZとTPPで変える部分
	if TppGameSequence.GetGameTitleName() == "TPP" then
		-- TPP
		TppCollectibleDataManager:AddTable( "WP_hg00_v01", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/hag/hg00_main0_aw0_v00.parts", "/Assets/tpp/pack/collectible/secondary/hg00_main0_def.fpk", 1 )
		TppCollectibleDataManager:AddTable( "CP_Hg00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hag/hg00_ammo0_def.parts", "" )

		TppCollectibleDataManager:AddTable( "WP_hg01_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/hag/hg01_main0_aw0_v00.parts", "/Assets/tpp/pack/collectible/secondary/hg01_main0_def.fpk", 1 )
		TppCollectibleDataManager:AddTable( "CP_Hg01", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hag/hg01_ammo0_def.parts", "" )

		TppCollectibleDataManager:AddTable( "WP_hg02_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/hag/hg02_main0_def_v00.parts", "/Assets/tpp/pack/collectible/secondary/hg02_main0_def.fpk", 1 )
		TppCollectibleDataManager:AddTable( "CP_Hg02", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am12_main0_def.fmdl", "" )

		TppCollectibleDataManager:AddTable( "WP_sm00_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/smg/sm00_main0_aw0_v00.parts", "/Assets/tpp/pack/collectible/secondary/sm00_v00_sa.fpk", 1 )
		TppCollectibleDataManager:AddTable( "CP_Sm00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am04_main0_def.fmdl", "" )

		TppCollectibleDataManager:AddTable( "WP_ar00_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_aw0_v00.parts", "/Assets/tpp/pack/collectible/primary/ar00_v00_cm.fpk", 0 )
		TppCollectibleDataManager:AddTable( "WP_ar00_v01", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_aw1_v00.parts", "/Assets/tpp/pack/collectible/primary/ar00_v01_cm.fpk", 0 )
		TppCollectibleDataManager:AddTable( "WP_ar00_v03", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_aw3_v00.parts", "/Assets/tpp/pack/collectible/primary/ar00_v03_cm.fpk", 0 )
		TppCollectibleDataManager:AddTable( "WP_ar00_v03b", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_aw3_v01.parts", "/Assets/tpp/pack/collectible/primary/ar00_v03b_cm.fpk", 0 )
		TppCollectibleDataManager:AddTable( "WP_ar00_v04", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_asw_v04.parts", "/Assets/tpp/pack/collectible/primary/ar00_v04_asm.fpk", 0 )
		TppCollectibleDataManager:AddTable( "WP_ar00_v05", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_aw5_v00.parts", "/Assets/tpp/pack/collectible/primary/ar00_v05_asm.fpk", 0 )
		TppCollectibleDataManager:AddTable( "CP_Ar00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am00_main0_def.fmdl", "" )
		TppCollectibleDataManager:AddTable( "CP_Gl00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am05_main0_def.fmdl", "" )

		TppCollectibleDataManager:AddTable( "WP_sr01_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/snr/sr01_main0_aw1_v00.parts", "/Assets/tpp/pack/collectible/primary/sr01_v00_cm.fpk", 0 )
		TppCollectibleDataManager:AddTable( "CP_Sr01", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am09_main0_def.fmdl", "" )

		TppCollectibleDataManager:AddTable( "WP_sg01_v00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/shg/sg01_main0_aw0_v00.parts", "/Assets/tpp/pack/collectible/primary/sg01_v00_cm.fpk", 0 )
		TppCollectibleDataManager:AddTable( "CP_Sg01", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am12_main0_def.fmdl", "" )

		TppCollectibleDataManager:AddTable( "WP_ms02", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/mis/ms02_main0_def_v00.parts", "/Assets/tpp/pack/collectible/primary/ms02_main0_def.fpk", 0 )
		TppCollectibleDataManager:AddTable( "BL_Ms02", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/mis/ms02_ammo0_def_v00.parts", "" )
		TppCollectibleDataManager:AddTable( "CP_Ms02Shell", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/mis/ms02_ammo0_def_v00.parts", "" )

		TppCollectibleDataManager:AddTable( "WP_Grenade", TppCollectibleBlock.BLOCK_SUPPORT_WEAPON, "/Assets/tpp/parts/weapon/thr/tr01_main0_def_v00.parts", "/Assets/tpp/pack/collectible/support/tr01_main0_def.fpk", 2 )
		TppCollectibleDataManager:AddTable( "WP_SmokeGrenade", TppCollectibleBlock.BLOCK_SUPPORT_WEAPON, "/Assets/tpp/parts/weapon/thr/tr00_main0_def_v01.parts", "/Assets/tpp/pack/collectible/support/tr00_main0_def.fpk", 2 )
		TppCollectibleDataManager:AddTable( "WP_WarningFlare", TppCollectibleBlock.BLOCK_SUPPORT_WEAPON, "/Assets/tpp/parts/weapon/thr/tr00_main0_def_v00.parts", "/Assets/tpp/pack/collectible/support/tr00_main0_def.fpk", 2 )
		TppCollectibleDataManager:AddTable( "WP_C4", TppCollectibleBlock.BLOCK_SUPPORT_WEAPON, "/Assets/tpp/parts/weapon/put/pt02_main0_def_v00.parts", "/Assets/tpp/pack/collectible/support/pt02_main0_def.fpk", 2 )
		TppCollectibleDataManager:AddTable( "WP_Claymore", TppCollectibleBlock.BLOCK_SUPPORT_WEAPON, "/Assets/tpp/parts/weapon/put/pt01_main0_def_v00.parts", "/Assets/tpp/pack/collectible/support/pt01_main0_def.fpk", 2 )
	else
		-- GZ
		TppCollectibleDataManager:AddTable( "WP_hg00_v01", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/assemble/hag/hg00_main0_aw0_v00.parts", "", 1 )
		TppCollectibleDataManager:AddTable( "CP_Hg00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hag/hg00_ammo0_def.parts", "" )

		TppCollectibleDataManager:AddTable( "WP_hg01_v00", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/assemble/hag/hg01_main0_aw0_v00.parts", "", 1 )
		TppCollectibleDataManager:AddTable( "CP_Hg01", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/hag/hg01_ammo0_def.parts", "" )

		TppCollectibleDataManager:AddTable( "WP_hg02_v00", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/hag/hg02_main0_def_v00.parts", "", 1 )
		TppCollectibleDataManager:AddTable( "CP_Hg02", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am12_main0_def.fmdl", "" )

		TppCollectibleDataManager:AddTable( "WP_sm00_v00", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/assemble/smg/sm00_main0_aw0_v00.parts", "", 1 )
		TppCollectibleDataManager:AddTable( "CP_Sm00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am04_main0_def.fmdl", "" )

		TppCollectibleDataManager:AddTable( "WP_ar00_v00", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_aw0_v00.parts", "", 0 )
		TppCollectibleDataManager:AddTable( "WP_ar00_v01", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_aw1_v00.parts", "", 0 )
		TppCollectibleDataManager:AddTable( "WP_ar00_v03", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_aw3_v00.parts", "", 0 )
		TppCollectibleDataManager:AddTable( "WP_ar00_v03b", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_aw3_v01.parts", "", 0 )
		TppCollectibleDataManager:AddTable( "WP_ar00_v04", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_asw_v04.parts", "", 0 )
		TppCollectibleDataManager:AddTable( "WP_ar00_v05", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_main0_aw5_v00.parts", "", 0 )
		TppCollectibleDataManager:AddTable( "CP_Ar00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am00_main0_def.fmdl", "" )
		TppCollectibleDataManager:AddTable( "CP_Gl00", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am05_main0_def.fmdl", "" )

		TppCollectibleDataManager:AddTable( "WP_sr01_v00", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/assemble/snr/sr01_main0_aw1_v00.parts", "", 0 )
		TppCollectibleDataManager:AddTable( "CP_Sr01", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am09_main0_def.fmdl", "" )

		TppCollectibleDataManager:AddTable( "WP_sg01_v00", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/assemble/shg/sg01_main0_aw0_v00.parts", "", 0 )
		TppCollectibleDataManager:AddTable( "CP_Sg01", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/weapon/amo/Scenes/am12_main0_def.fmdl", "" )

		TppCollectibleDataManager:AddTable( "WP_ms02", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/mis/ms02_main0_def_v00.parts", "", 0 )
		TppCollectibleDataManager:AddTable( "BL_Ms02", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/mis/ms02_ammo0_def_v00.parts", "" )
		TppCollectibleDataManager:AddTable( "CP_Ms02Shell", TppCollectibleBlock.BLOCK_NONE, "/Assets/tpp/parts/weapon/mis/ms02_ammo0_def_v00.parts", "" )

		TppCollectibleDataManager:AddTable( "WP_Grenade", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/thr/tr01_main0_def_v00.parts", "", 2 )
		TppCollectibleDataManager:AddTable( "WP_SmokeGrenade", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/thr/tr00_main0_def_v01.parts", "", 2 )
		TppCollectibleDataManager:AddTable( "WP_WarningFlare", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/thr/tr00_main0_def_v00.parts", "", 2 )
		TppCollectibleDataManager:AddTable( "WP_C4", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/put/pt02_main0_def_v00.parts", "", 2 )
		TppCollectibleDataManager:AddTable( "WP_Claymore", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/parts/weapon/put/pt01_main0_def_v00.parts", "", 2 )

	end
	
	TppCollectibleDataManager:AddTable( "AB_PrimaryCommon", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/ibo/Scenes/ibo0_main0_def.fmdl", "" )
	TppCollectibleDataManager:AddTable( "AB_PrimaryTranq", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/ibo/Scenes/ibo0_main0_def.fmdl", "" )
	TppCollectibleDataManager:AddTable( "AB_PrimaryMissile", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/ibo/Scenes/ibo2_main0_def.fmdl", "" )
	TppCollectibleDataManager:AddTable( "AB_SecondaryCommon", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/ibo/Scenes/ibo1_main0_def.fmdl", "" )
	TppCollectibleDataManager:AddTable( "AB_SecondaryTranq", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/ibo/Scenes/ibo1_main1_def.fmdl", "" )
	TppCollectibleDataManager:AddTable( "AB_Support", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/ibo/Scenes/ibo1_main0_def.fmdl", "" )

	TppCollectibleDataManager:AddTable( "BX_Primary", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/ibo/Scenes/ibo3_main1_def.fmdl", "" )
	TppCollectibleDataManager:AddTable( "BX_Secondary", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/ibo/Scenes/ibo3_main0_def.fmdl", "" )
	TppCollectibleDataManager:AddTable( "BX_Support", TppCollectibleBlock.BLOCK_COMMON, "/Assets/tpp/item/ibo/Scenes/ibo4_main0_def.fmdl", "" )

	-- ここ以下、キメラパーツ

	TppCollectibleDataManager:AddTable( "REC_Ar00", TppCollectibleBlock.BLOCK_PARTS_RECEIVER, "/Assets/tpp/parts/weapon/asr/ar00_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "REC_Ar01", TppCollectibleBlock.BLOCK_PARTS_RECEIVER, "/Assets/tpp/parts/weapon/asr/ar01_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "REC_Ar02", TppCollectibleBlock.BLOCK_PARTS_RECEIVER, "/Assets/tpp/parts/weapon/asr/ar02_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "REC_Ar03", TppCollectibleBlock.BLOCK_PARTS_RECEIVER, "/Assets/tpp/parts/weapon/asr/ar03_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "REC_Sr00", TppCollectibleBlock.BLOCK_PARTS_RECEIVER, "/Assets/tpp/parts/weapon/snr/sr00_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "REC_Sr03", TppCollectibleBlock.BLOCK_PARTS_RECEIVER, "/Assets/tpp/parts/weapon/snr/sr03_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "REC_Mg01", TppCollectibleBlock.BLOCK_PARTS_RECEIVER, "/Assets/tpp/parts/weapon/mag/mg01_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "REC_Mg02", TppCollectibleBlock.BLOCK_PARTS_RECEIVER, "/Assets/tpp/parts/weapon/mag/mg02_main0_def_v00.parts", "" )

	TppCollectibleDataManager:AddTable( "CP_Am00", TppCollectibleBlock.BLOCK_PARTS_MAGAZINE, "/Assets/tpp/parts/weapon/amo/am00_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Am01", TppCollectibleBlock.BLOCK_PARTS_MAGAZINE, "/Assets/tpp/parts/weapon/amo/am01_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Am02", TppCollectibleBlock.BLOCK_PARTS_MAGAZINE, "/Assets/tpp/parts/weapon/amo/am02_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Am04", TppCollectibleBlock.BLOCK_PARTS_MAGAZINE, "/Assets/tpp/parts/weapon/amo/am04_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Am05", TppCollectibleBlock.BLOCK_PARTS_MAGAZINE, "/Assets/tpp/parts/weapon/amo/am05_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Am06", TppCollectibleBlock.BLOCK_PARTS_MAGAZINE, "/Assets/tpp/parts/weapon/amo/am06_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Am08", TppCollectibleBlock.BLOCK_PARTS_MAGAZINE, "/Assets/tpp/parts/weapon/amo/am08_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Am09", TppCollectibleBlock.BLOCK_PARTS_MAGAZINE, "/Assets/tpp/parts/weapon/amo/am09_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Am10", TppCollectibleBlock.BLOCK_PARTS_MAGAZINE, "/Assets/tpp/parts/weapon/amo/am10_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "CP_Am12", TppCollectibleBlock.BLOCK_PARTS_MAGAZINE, "/Assets/tpp/parts/weapon/amo/am12_main0_def_v00.parts", "" )

	TppCollectibleDataManager:AddTable( "BA_Ba00", TppCollectibleBlock.BLOCK_PARTS_BARREL, "/Assets/tpp/parts/weapon/bar/ba00_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "BA_Ba01", TppCollectibleBlock.BLOCK_PARTS_BARREL, "/Assets/tpp/parts/weapon/bar/ba01_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "BA_Ba02", TppCollectibleBlock.BLOCK_PARTS_BARREL, "/Assets/tpp/parts/weapon/bar/ba02_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "BA_Ba03", TppCollectibleBlock.BLOCK_PARTS_BARREL, "/Assets/tpp/parts/weapon/bar/ba03_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "BA_Ba04", TppCollectibleBlock.BLOCK_PARTS_BARREL, "/Assets/tpp/parts/weapon/bar/ba04_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "BA_Ba05", TppCollectibleBlock.BLOCK_PARTS_BARREL, "/Assets/tpp/parts/weapon/bar/ba05_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "BA_Ba06", TppCollectibleBlock.BLOCK_PARTS_BARREL, "/Assets/tpp/parts/weapon/bar/ba06_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "BA_Ba07", TppCollectibleBlock.BLOCK_PARTS_BARREL, "/Assets/tpp/parts/weapon/bar/ba07_main0_def_v00.parts", "" )

	TppCollectibleDataManager:AddTable( "SK_Sk00", TppCollectibleBlock.BLOCK_PARTS_STOCK, "/Assets/tpp/parts/weapon/stk/sk00_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "SK_Sk01", TppCollectibleBlock.BLOCK_PARTS_STOCK, "/Assets/tpp/parts/weapon/stk/sk01_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "SK_Sk02", TppCollectibleBlock.BLOCK_PARTS_STOCK, "/Assets/tpp/parts/weapon/stk/sk02_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "SK_Sk04", TppCollectibleBlock.BLOCK_PARTS_STOCK, "/Assets/tpp/parts/weapon/stk/sk04_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "SK_Sk06", TppCollectibleBlock.BLOCK_PARTS_STOCK, "/Assets/tpp/parts/weapon/stk/sk06_main0_def_v00.parts", "" )

	TppCollectibleDataManager:AddTable( "MZ_Mz00", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz00_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz01", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz01_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz02", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz02_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz03", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz03_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz04", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz04_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz05", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz05_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz06", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz06_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz07", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz07_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz08", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz08_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz09", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz09_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz10", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz10_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz11", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz11_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz12", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz12_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "MZ_Mz13", TppCollectibleBlock.BLOCK_PARTS_MUZZLE, "/Assets/tpp/parts/weapon/mzl/mz13_main0_def_v00.parts", "" )

	TppCollectibleDataManager:AddTable( "ST_St00", TppCollectibleBlock.BLOCK_PARTS_REARSIGHT, "/Assets/tpp/parts/weapon/sit/st00_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "ST_St01", TppCollectibleBlock.BLOCK_PARTS_REARSIGHT, "/Assets/tpp/parts/weapon/sit/st01_main0_def_v00.parts", "" )

	TppCollectibleDataManager:AddTable( "FL_Fl00", TppCollectibleBlock.BLOCK_PARTS_OPTIONSYS1, "/Assets/tpp/parts/weapon/flt/fl00_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "FL_Fl01", TppCollectibleBlock.BLOCK_PARTS_OPTIONSYS1, "/Assets/tpp/parts/weapon/flt/fl01_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "FL_Fl02", TppCollectibleBlock.BLOCK_PARTS_OPTIONSYS1, "/Assets/tpp/parts/weapon/flt/fl02_main0_def_v00.parts", "" )
	TppCollectibleDataManager:AddTable( "LS_Ls00", TppCollectibleBlock.BLOCK_PARTS_OPTIONSYS2, "/Assets/tpp/parts/weapon/lsr/ls00_main0_def_v00.parts", "" )

	TppCollectibleDataManager:AddTable( "UD_Gl00", TppCollectibleBlock.BLOCK_PARTS_UNDERBARREL, "/Assets/tpp/parts/weapon/grl/gl00_main0_def_v00.parts", "" )
	-- TppCollectibleDataManager:AddTable( "UD_Hg07", TppCollectibleBlock.BLOCK_PARTS_UNDERBARREL, "", "" )

	-- ぶれ調整用
	TppCollectibleDataManager:AddTable( "WP_ar_wobtest556", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar00_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/ar00_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_ar_wobtest762", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/asr/ar01_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/ar01_v00_cm.fpk", 0 )
	TppCollectibleDataManager:AddTable( "WP_sm_wobtest9mm", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/smg/sm00_v00_sa.parts", "/Assets/tpp/pack/collectible/secondary/sm00_v00_sa.fpk", 1 )
	TppCollectibleDataManager:AddTable( "WP_sr_wobtest762", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/snr/sr00_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/sr00_v00_cm.fpk", 0 )

	-- ローカルテスト用
	-- TppCollectibleDataManager:AddTable( "WP_ar00_gl00", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpptest/level/Weapon/TestParts/test_ar00_gl00.parts", "/Assets/tpp/pack/collectible/primary/ar00_gl00.fpk", 0 )
	-- TppCollectibleDataManager:AddTable( "WP_ar00_hg07", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpptest/level/Weapon/TestParts/test_ar00_hg07.parts", "/Assets/tpp/pack/collectible/primary/ar00_hg07.fpk", 0 )
	-- TppCollectibleDataManager:AddTable( "WP_sg01_asm", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/shg/sg01_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/sg01_v00_cm.fpk", 0 )
	-- TppCollectibleDataManager:AddTable( "WP_ew00_asm", TppCollectibleBlock.BLOCK_MISSION_WEAPON, "/Assets/tpp/parts/weapon/assemble/shg/sg01_v00_cm.parts", "/Assets/tpp/pack/collectible/primary/sg01_v00_cm.fpk", 0 )

end,

}
