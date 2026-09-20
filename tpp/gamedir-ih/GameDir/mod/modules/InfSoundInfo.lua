--InfSoundInfo.lua
--the enemy vox soundbanks used are usually defined in the mission fpks,
--but with IH custom soldier body/InfBodyInfo system need to load others
--GOTCHA what vox language a soldier uses (and other things) is still defined by the EnemyType somewhere in the exe.
--REF EnemyType is set via SendCommand SetSoldier2Type

--TODO: make sure cp lang soundpack loaded. is via SetUpSoldiers > SetCpType command, mtbs_enemy SetEnemyLocationType and a couple of other specfic mission enemy scripts (search SetCpType)

local this={}

--tex SoundPackage>sdf>vox_ene_common_* sbp loaders
--the vox_ene_common* soundbanks include both soldier and CP vox for the respective language
this.soundPacks={
  ene_en="/Assets/tpp/pack/mission2/ih/snd_ene_en.fpk",--vox_ene_common.sbp
  ene_en_fml="/Assets/tpp/pack/mission2/ih/snd_ene_en_fml.fpk",--vox_ene_common_fml.sbp
  ene_ru="/Assets/tpp/pack/mission2/ih/snd_ene_ru.fpk",--vox_ene_common_ru.sbp
  ene_af="/Assets/tpp/pack/mission2/ih/snd_ene_af.fpk",--vox_ene_common_af.sbp
}--soundPacks

--WIP subtitles_boot / SubtitlesBlockControllerData which currently just point to the free roam subtitle packs,
--which means there's doubling up for subp references which seems to be causing issues, either that or two subs packs cant be loaded
--but there already are via results_subtitles in location pack?

--a 'more proper' way would require to build seperate packs for every <lang>Voice/<lang>Text which is a bunch of work
--but cant guarantee wont still have issues since vanilla files will still double up on the SubtitlesPackage references

--if I hadn't hit the issues I would have just rolled them into the above soundpacks.
this.subsPacks={
  ene_en="/Assets/tpp/pack/mission2/ih/subs_boot_ene_en.fpk",-- f30050_subtitles -> <lang>Voice/<lang>Text/ene_common.subp,_str.subp
  ene_ru="/Assets/tpp/pack/mission2/ih/subs_boot_ene_ru.fpk",-- f30010_subtitles -> <lang>Voice/<lang>Text/ene_common_ru.subp,_str.subp
  ene_af="/Assets/tpp/pack/mission2/ih/subs_boot_ene_af.fpk",-- f30020_subtitles -> <lang>Voice/<lang>Text/ene_common_af.subp,_str.subp
}--soundPacks


this.langForEnemyType={
  [EnemyType.TYPE_SOVIET]="ene_ru",
  [EnemyType.TYPE_PF]="ene_af",
  [EnemyType.TYPE_SKULL]="ene_en",
  --[EnemyType.TYPE_CHILD]=,--TODO build pack
  [EnemyType.TYPE_DD]="ene_en",
}--langForEnemyType

this.langForCpType={
  [CpType.TYPE_SOVIET]="ene_ru",
  [CpType.TYPE_AMERICA]="ene_en",
  [CpType.TYPE_AFRIKAANS]="ene_af",
}--langForCpType

function this.AddMissionPacks(missionCode,packPaths)
  local maleBodyInfo=InfEneFova.GetMaleBodyInfo(missionCode)
  local femaleBodyInfo=InfEneFova.GetFemaleBodyInfo(missionCode)

  if maleBodyInfo then
    local soldierSubType=maleBodyInfo.soldierSubType and maleBodyInfo.soldierSubType or "DD_FOB" --TODO see TppEnemy.GetSoldierSubType defaulting to soldierSubType DD_FOB why?
    local soldierType=InfMainTpp.soldierTypeForSubtypes[soldierSubType]
    local lang=this.langForEnemyType[soldierType]
    table.insert(packPaths,this.soundPacks[lang])
  end
  --GOTCHA: only eng female enemy voices
  if femaleBodyInfo then
    local lang="ene_en_fml"
    table.insert(packPaths,this.soundPacks[lang])
  end

  local changeCpType=IvarProc.GetForMission("changeCpType",missionCode)
  if changeCpType>0 then
    --tex CpType enum from 0, ivar settings 0 == "DEFAULT"
    InfCore.Log("InfSoundInfo.AddMissionPacks: changeCpType: "..InfMainTppIvars.cpTypeNames[changeCpType])
    local lang=this.langForCpType[changeCpType-1]
    InfUtil.InsertUniqueInList(packPaths,this.soundPacks[lang])
  end  
end--AddMissionPacks

return this
