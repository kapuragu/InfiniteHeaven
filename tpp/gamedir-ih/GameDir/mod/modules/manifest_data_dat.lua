--manifest-data_dat-lua.lua",
--mgsv 1.0.15.3
--tex list of vanilla file paths just for internal stock take
--in load order
local this={}
this.fileList={
    --exe, when the respective modules are set up (TODO when exactly)
    "/Fox/Scripts/Classes/Entity.lua",
    "/Fox/Scripts/Classes/Pad.lua",
    "/Fox/Scripts/Classes/Scene.lua",
    --exe
    "/Assets/tpp/ui/Script/emblem_list.lua",

    --exe
    "/init.lua",
    --init.lua
    --dofile
    "/Fox/Scripts/Gr/gr_init.lua",
    "/Fox/Scripts/Gr/gr_init_dx11.lua",
    "/shaders/dx11/GrSystemShadersNoLnm_dx11.lua",
    "/shaders/dx11/GrModelShadersNoLnm_dx11.lua",
    "/shaders/dx11/FxShadersNoLnm_dx11.lua",
    "/shaders/dx11/GrSystemShaders_dx11.lua",   
    "/shaders/dx11/GrModelShaders_dx11.lua",
    "/shaders/dx11/FxShaders_dx11.lua",
    --
    --exe
    "/Tpp/start.lua",
    --start.lua
    "/Tpp/Scripts/RouteEvents/AiRtEvSoldier.lua",--not actually loaded
    --dofile
    "/shaders/dx11/TppShadersNoLnm_dx11.lua",
    "/shaders/dx11/TppShaders_dx11.lua",--not loaded, as above exists
    --exe (TODO: how, when?)
    "/Assets/tpp/sound/scripts/chara/SoundTppPlayer.lua",
    "/Assets/tpp/sound/scripts/chara/SoundTppAnimal.lua",
    "/Assets/tpp/sound/scripts/chara/SoundTppSoldier.lua",
    --dofile
    "/Tpp/Scripts/Ui/TppUiBootInit.lua",
    --TppUiBootInit.lua UiDaemon.SetExecLuaFile, not sure how or when exe loads it
    "/Tpp/Scripts/Ui/TppUiPrefetchTexture.lua",
    --exe (TODO: how,when?)
    "/Assets/tpp/sound/scripts/tape/PreinstallTape.lua",
    --
    "/Tpp/Scripts/Equip/EquipIdTable.lua",--Script.LoadLibraryAsync
    
    --LoadLibrary
    "/Assets/tpp/level_asset/weapon/ParameterTables/parts/EquipParameters.lua",
    "/Tpp/Scripts/Equip/EquipParameters.lua",--appears to be legacy, not loaded since the above exists
    "/Assets/tpp/level_asset/weapon/ParameterTables/parts/EquipMotionDataForChimera.lua",
    "/Assets/tpp/level_asset/chara/enemy/TppEnemyFaceId.lua",
    "/Assets/tpp/level_asset/chara/enemy/TppEnemyBodyId.lua",
    "/Tpp/Scripts/Equip/ChimeraPartsPackageTable.lua",
    "/Assets/tpp/level_asset/weapon/ParameterTables/EquipParameterTables.lua",
    "/Assets/tpp/level_asset/damage/ParameterTables/DamageParameterTables.lua",
    "/Assets/tpp/level_asset/chara/enemy/Soldier2ParameterTables.lua",
    "/Tpp/Scripts/Equip/EquipMotionData.lua",
    "/Assets/tpp/level_asset/chara/enemy/TppEnemyFaceGroupId.lua",
    "/Assets/tpp/level_asset/chara/enemy/TppEnemyFaceGroup.lua",
    "/Assets/tpp/level_asset/chara/enemy/Soldier2FaceAndBodyData.lua",
    "/Assets/tpp/level_asset/weapon/ParameterTables/RecoilMaterial/RecoilMaterialTable.lua",
    
    --Script.LoadLibraryAsync
    "/Assets/tpp/script/lib/Tpp.lua",
    --Tpp.lua requires list
    "/Assets/tpp/script/lib/TppDefine.lua",
    "/Assets/tpp/script/lib/TppMath.lua",
    "/Assets/tpp/script/lib/TppSave.lua",
    "/Assets/tpp/script/lib/TppLocation.lua",
    "/Assets/tpp/script/lib/TppSequence.lua",
    "/Assets/tpp/script/lib/TppWeather.lua",
    "/Assets/tpp/script/lib/TppDbgStr32.lua",
    "/Assets/tpp/script/lib/TppDebug.lua",
    "/Assets/tpp/script/lib/TppClock.lua",
    "/Assets/tpp/script/lib/TppUI.lua",
    "/Assets/tpp/script/lib/TppResult.lua",
    "/Assets/tpp/script/lib/TppSound.lua",
    "/Assets/tpp/script/lib/TppTerminal.lua",
    "/Assets/tpp/script/lib/TppMarker.lua",
    "/Assets/tpp/script/lib/TppRadio.lua",
    "/Assets/tpp/script/lib/TppPlayer.lua",
    "/Assets/tpp/script/lib/TppHelicopter.lua",
    "/Assets/tpp/script/lib/TppScriptBlock.lua",
    "/Assets/tpp/script/lib/TppMission.lua",
    "/Assets/tpp/script/lib/TppStory.lua",
    "/Assets/tpp/script/lib/TppDemo.lua",
    "/Assets/tpp/script/lib/TppEnemy.lua",
    "/Assets/tpp/script/lib/TppGeneInter.lua",
    "/Assets/tpp/script/lib/TppInterrogation.lua",
    "/Assets/tpp/script/lib/TppGimmick.lua",
    "/Assets/tpp/script/lib/TppMain.lua",
    "/Assets/tpp/script/lib/TppDemoBlock.lua",
    "/Assets/tpp/script/lib/TppAnimalBlock.lua",
    "/Assets/tpp/script/lib/TppCheckPoint.lua",
    "/Assets/tpp/script/lib/TppPackList.lua",
    "/Assets/tpp/script/lib/TppQuest.lua",
    "/Assets/tpp/script/lib/TppTrap.lua",
    "/Assets/tpp/script/lib/TppReward.lua",
    "/Assets/tpp/script/lib/TppRevenge.lua",
    "/Assets/tpp/script/lib/TppReinforceBlock.lua",
    "/Assets/tpp/script/lib/TppEneFova.lua",
    "/Assets/tpp/script/lib/TppFreeHeliRadio.lua",
    "/Assets/tpp/script/lib/TppHero.lua",
    "/Assets/tpp/script/lib/TppTelop.lua",
    "/Assets/tpp/script/lib/TppRatBird.lua",
    "/Assets/tpp/script/lib/TppMovie.lua",
    "/Assets/tpp/script/lib/TppAnimal.lua",
    "/Assets/tpp/script/lib/TppException.lua",
    "/Assets/tpp/script/lib/TppTutorial.lua",
    "/Assets/tpp/script/lib/TppLandingZone.lua",
    "/Assets/tpp/script/lib/TppCassette.lua",
    "/Assets/tpp/script/lib/TppEmblem.lua",
    "/Assets/tpp/script/lib/TppDevelopFile.lua",
    "/Assets/tpp/script/lib/TppPaz.lua",
    "/Assets/tpp/script/lib/TppRanking.lua",
    "/Assets/tpp/script/lib/TppTrophy.lua",
    "/Assets/tpp/script/lib/TppMbFreeDemo.lua",
    --Tpp requires list<
    --Script.LoadLibrary
    "/Assets/tpp/script/lib/TppDefine.lua",--tex should have already been loaded above, dont know why the repeat
    "/Assets/tpp/script/lib/TppVarInit.lua",
    "/Assets/tpp/script/lib/TppGVars.lua",
    "/Assets/tpp/script/list/TppMissionList.lua",
    "/Assets/tpp/script/list/TppQuestList.lua",
    "/Assets/tpp/ui/Script/UiRegisterInfo.lua",
    "/Assets/tpp/level_asset/chara/player/game_object/player2_camouf_param.lua",
    --loadfile in coroutine
    "/Tpp/Scripts/System/start2nd.lua",
    --start2nd.lia>
    --dofile
    "/Assets/tpp/sound/scripts/motion/setup.lua",
    "/Assets/tpp/ui/Subtitles/script/priorityTable.lua",
    "/Assets/tpp/level_asset/chara/player/game_object/TppPlayer2InitializeScript.lua",
    --TppPlayer2InitializeScript.lua .Player.RegisterScriptFunc, TODO: not sure how/when it's loaded
    "/Assets/tpp/level_asset/chara/player/game_object/TppPlayer2CallbackScript.lua",

    --Script.LoadLibrary
    "/Assets/tpp/motherbase/script/MbmCommonSetting.lua",
    "/Assets/tpp/motherbase/script/MbmCommonSetting20BaseResSec.lua",
    "/Assets/tpp/motherbase/script/MbmCommonSetting30Deploy.lua",
    "/Assets/tpp/motherbase/script/MbmCommonSetting40RewardDeploy.lua",
    "/Assets/tpp/motherbase/script/MbmCommonSetting50RewardFob.lua",
    "/Assets/tpp/motherbase/script/MbmCommonSetting60DbPfLang.lua",
    "/Assets/tpp/motherbase/script/EquipDevelopConstSetting.lua",
    "/Assets/tpp/motherbase/script/EquipDevelopFlowSetting.lua",
    "/Assets/tpp/motherbase/script/MotherBaseWeaponSpecSetting.lua",
    "/Assets/tpp/motherbase/script/WeaponPartsUiSetting.lua",
    "/Assets/tpp/motherbase/script/WeaponPartsCombinationSettings.lua",
    "/Assets/tpp/radio/script/RadioParameterTable.lua",
    --start2nd.lua<
    --start.lua<
    
    --? tex none of these logged by lua_loadHook, nor exe strings or hashes I can see
    --havent searched fox2/other files for their strings or hashes
    "/Assets/tpp/script/lib/TppCollection.lua",--tex theres an internal TppCollection, so maybe its loaded alongside in a similar mechanism to /Fox/Scripts/Classes/%s, but then it's set up as a normal lib/ script, but its not listed nor logged as loading via lua_load
    "/Assets/tpp/script/lib/TppDebugMbDevelop.lua",
    "/Assets/tpp/motherbase/gmpEarnMissions.lua",
    "/Assets/tpp/ui/Script/avatar_presets.lua",--tex possibly loaded dureing avatar edit mode
    "/Fox/Scripts/Language/LanguageInit.lua",
    "/Tpp/Scripts/Classes/TppPadOperatorUtility.lua",
}--fileList
--tex for faster lookup
for i,fileName in ipairs(this.fileList)do
    this.fileList[fileName]=true
end
this.moduleNames={}
for i,fileName in ipairs(this.fileList)do
    local moduleName=InfCore.GetModuleName(fileName)
    this.moduleNames[moduleName]=fileName
end
return this