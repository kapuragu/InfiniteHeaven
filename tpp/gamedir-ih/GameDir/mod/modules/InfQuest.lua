-- InfQuest.lua
-- tex implements various sideops/quest selection options
-- and IH quest addon system
local this={}

local TppDefine=TppDefine
local TppQuest=TppQuest
local TppLocation=TppLocation
local InfCore=InfCore
local IvarProc=IvarProc
local pairs=pairs
local ipairs=ipairs

this.debugModule=false
this.debugSave=false

--tex the engine breaks down the quest name in some cases to the last 6 characters (ie q30010), or just the numbers
--see TppQuest GetQuestNameId, GetQuestName
--it uses the q name as the lookup for the lang string name_<qname> and info_<qname>
--I'm not sure if anything before that has any signifincance, many have quest_ as the prefix, others have the quest area name.
--Because of this restriction any mod authors that want to build a sideop will have to notify me so to not collide with others
--questNameFmt="q3%04d"--tex currently straddling between 30010 : Little Lost Sheep and 39010 : Legendary Brown Bear
--tex current questIds claimed: https://metalgearmodding.fandom.com/wiki/Custom_Side-Ops_List

--CULL out of date, use wiki instead tex: notes on how they reserved still useful for me to track down the original messages to me
--q30100 - q30102--IH mb quests
--q30103--IH quest example
--q30104-q30154--morbidslinky sideops pack
--q30155--IH pilot rescue test
--q30156-q30199--darkhaven
--q30200-q30299--ih reserved
--q30300-q30349--caplag
--q30350-q30360--morbidslinky example sideops
--q30400-q30499--MgSolidus (via nexus message)
--q30500-q30504--hsronacse (via nexus posts page)
--q30600-q30699--amars464 (via discord) (currently made 12)
--q31069-q31099--jackwall (via nexus message)
--q31100-q31199--Adam_Online (discord) - Tales from Mother Base sidop collection on nexus.
--q35648-q34651--ventos - boss sheep
--q36660-q36760--ventos



--LIMIT GOTCHA: also currently limited by TppDefine.QUEST_MAX=250, with 167 vanilla QUEST_DEFINE entries (though some of theose are incomplete/non existing quests), 
--so without managment on 83 additional quests.
--main issue is this is governing the qst_* gvars that hold the quest states (see TppGvars, RegisterQuests >TppDefine.QUEST_MAX LIMIT comment).


--REF questAddon
--all options rather than sane example
---- ih_quest_q30103.lua --file name must have q%05u format as suffix.
--local this={
--  questId=30103,--TODO
--  questPackList={
--    "/Assets/tpp/pack/mission2/ih/ih_hostage_base.fpk",--base hostage pack
--    "/Assets/tpp/pack/mission2/ih/ddr1_main0_mdl.fpk",--model pack, edit the partsType in the TppHostage2Parameter in the quest .fox2 to match, see InfBodyInfo.lua for different body types.
--    "/Assets/tpp/pack/mission2/quest/ih/ih_example_quest.fpk",--quest fpk
--    randomFaceListIH={--for hostage isFaceRandom, see TppQuestList
--      gender="FEMALE",
--      count=1,
--    }
--  },--questPackList
--  locationId=TppDefine.LOCATION_ID.AFGH,
--  areaName="field",--tex use the 'Show position' command in the debug menu to print the quest area you are in to ih_log.txt, see TppQuestList. areaName (or TppQuest. afgAreaList,mafrAreaList,mtbsAreaList.)
--  --If areaName doesn't match the area the iconPos is in the quest fpk will fail to load (even though the Commencing Sideop message will trigger fine).
--  iconPos=Vector3(489.741,321.901,1187.506),--position of the quest area circle in idroid
--  radius=4,--radius of the quest area circle
--  category=TppQuest.QUEST_CATEGORIES_ENUM.PRISONER,--Category for the IH selection/filtering options.
--  questCompleteLangId="quest_extract_hostage",--Used for feedback of quest progress, see REF questCompleteLangId in InfQuest
--  canOpenQuest=InfQuest.AllwaysOpenQuest,--function that decides whether the quest can open/is unlocked for consideration to be active, is one way, all quests start closed and run this to see if they open, but are never closed again
--  canActiveQuest=function(questName) --Optional. All quests repop by default (are available to repeat), returning false will stop it from being considered for selection. Use this if you need to stop the quest from Active selection after the initial canOpenQuest.
--    --tex canActiveQuest example: disable quest if not dirty enough TODO: actually figure out how long dirty time is
--    if vars.passageSecondsSinceOutMB<dirtyTime then
--      return false 
--    end
--    return true
--  end, 
--  questRank=TppDefine.QUEST_RANK.G,--reward rank for clearing quest, see TppDefine.QUEST_BONUS_GMP and TppHero.QUEST_CLEAR
--  disableLzs={--disables lzs while the quest is active. Turn on the debugMessages option and look in ih_log.txt for StartedMoveToLandingZone after calling in a support heli to find the lz name.
--    "lz_lab_S0000|lz_lab_S_0000",
--  },
--  requestEquipIds={--equipIds of TppPickable weapons in the quest.
--    "EQP_WP_EX_hg_010",
--    "EQP_WP_West_ar_050",
--  },
--  -- CULL allowInStoryMissions=true,--allow quest during story mission (still follows the normal quest selection rules)--TODO needs more work to filter out quests not in mission area --DEBUGNOW TEST
--  enableInMissions={10033,10041},--Enables quest in story missions. if Ivar enableMissionQuest. handled by rlcs InfMissionQuest
--  allowInWarGames=true,--by default quests are blocked on mb wargames, this is to allow the quest during wargames
--  --required for shooting practice quests, but can be used to keep stuff resident before/after quest pack has been loaded/unloaded 
--  --TODO: not a good idea for afgh/mafr sized maps though, really need to build additional system on top of map block loading/unloading
--  missionPacks={
--    "/Assets/tpp/pack/mission2/void/quest/q30211_void_shootingpractice_start.fpk",
--  },--missionPacks
--}--this
--return this

--Example shooting quest on mother base
--local this={
--    questId=30210,
--    questPackList={
--        "/Assets/tpp/pack/mission2/quest/mtbs/Medical/quest_q30210.fpk",
--    },
--    locationId=TppDefine.LOCATION_ID.MTBS,
--    areaName="MtbsMedical",--quest area, is 'Mtbs<cluster name>'
--    clusterName="Medical",--https://metalgearmodding.fandom.com/wiki/MotherBase_Clusters
--    plntId=TppDefine.PLNT_DEFINE.Common2,--platform id. can just be the number 0-3, with 0 being the unique 'main' platform of the cluster
--    category=TppQuest.QUEST_CATEGORIES_ENUM.TARGET_PRACTICE,
--    questCompleteLangId="quest_target_eliminate",
--    canOpenQuest=function(questName)--whether quest can be active
--        local isMbLayout3=InfQuest.CanOpenIsMbLayout3()--only built layout for mbLayout 3
--        local questPlntIsDeveloped=InfQuest.CanOpenPlntIsDeveloped(questName)--uses the clusterName and plntId to check if its been built
--        return isMbLayout3 and questPlntIsDeveloped
--    end,
--    questRank=TppDefine.QUEST_RANK.I,
--    --shooting practice quests need a marker and geotrap to start the quest which needs to be resident on mission load
--    missionPacks={
--        [3]={"/Assets/tpp/pack/mission2/free/f30050/f30050_ly003_q30210.fpk",}--mb layout, if only [0] entry will use pack for all layouts 
--    },--missionPacks
--    startTrapName="ly003_cl04_npc0000|cl04pl2_q30210|trap_shootingPractice_start",--entity name, in layout fpkd fox2
--    startMarkerName="ly003_cl04_npc0000|cl04pl2_q30210|Marker_shootingPractice",--entity name, in layout fpkd fox2
--}--this
--return this

--REF questCompleteLangId =
--"quest_extract_elite",--Highly-Skilled Soldier Extracted [%d/%d]"
--"quest_defeat_armor",--"Heavy Infantry Eliminated [%d/%d]"
--"quest_defeat_zombie",--"Wandering Puppet Eliminated [%d/%d]"
--"quest_extract_hostage","Prisoner Extracted [%d/%d]"
--"quest_defeat_armor_vehicle","Armored Vehicle Unit Eliminated [%d/%d]"
--"quest_defeat_tunk","Tank Unit Eliminated [%d/%d]"
--"quest_target_eliminate","Target Destroyed [%d/%d]"
--"mine_quest_log",--"Mine Cleared [%d/%d]"
--"quest_extract_animal",--"Animal Extracted [%d/%d]"--tex added by IH
--tex NOTE: questCompleteLangId is a misnomer, it's actually an announceLogId for the TppUI.ANNOUNCE_LOG_TYPE announceLogId>langId table.
--if the announceLogId isn't found IH essentially use your questCompleteLangId as a direct langId


--tex see LoadQuestDefs,
this.ihQuestNames={}
--tex see LoadQuestDefs, RegisterQuests
--k=questName,v=questDef module
this.ihQuestsInfo={}

function this.PostModuleReload(prevModule)
  this.ihQuestNames=prevModule.ihQuestNames
  this.ihQuestsInfo=prevModule.ihQuestsInfo
  this.messageExecTable=prevModule.messageExecTable
  --DEBUGNOW this.LoadLibraries()--TODO: see that stuff in RegisterQuests isnt additive/go pear shaped with multiple calls
end

function this.LoadLibraries()
  this.LoadStates()
  this.LoadQuestDefs()
  this.RegisterQuests()
end

function this.OnStartTitle()
  --tex since registerquests is run before the first game save/gvar load
  this.SetupInstalledQuestsState()
end

function this.OnAllocate(missionTable)
  if missionTable.enemy then
  --CULL this.LoadEquipTable()
  end
  
  this.OnAllocateQuestPatchup(missionTable)
  this.FixFlags()  
  
  local setIsOnceOff=Ivars.quest_setIsOnceToRepop:Get()==1
  this.SetIsOnceOff(setIsOnceOff)
end--OnAllocate

function this.AddMissionPacks(missionCode,packPaths)
  if TppMission.IsHelicopterSpace(vars.missionCode) then
    return
  end

  local locationName=TppPackList.GetLocationNameFormMissionCode(missionCode)
  local locationId=TppDefine.LOCATION_ID[locationName]

  for questName,questAddon in pairs(this.ihQuestsInfo)do
    questAddon.missionPacks=questAddon.missionPacks or questAddon.missionPackList--tex PATCHUP: RENAMED missionPackList
  
    if questAddon.missionPacks then
      if questAddon.locationId==locationId then
        if TppQuest.CanActiveQuestInMission(missionCode,questName)then
          if TppQuest.IsActive(questName) then
            if this.debugModule then
              InfCore.PrintInspect(questAddon,"InfQuest AddMissionPacks questAddon "..questName.." missionCode:"..missionCode.." locationName:"..locationName.." locationId:"..locationId)
            end
            local packs=questAddon.missionPacks[missionCode] or questAddon.missionPacks--tex LEGACY: don't actually need to push packs into [missionCode] subtable now that I'm filtering by location and CanActiveQuestInMission
            if locationName=="MTBS" then
              packs=packs[vars.mbLayoutCode] or packs[0] or packs
            end
            for i,packPath in ipairs(packs)do
              packPaths[#packPaths+1]=packPath
            end
          end--if IsActive
        end--if CanActiveQuestInMission
      end
    end--if questAddon.missionPacks
  end--for ihQuestsInfo
end--AddMissionPacks

function this.MissionPrepare()
--CULL handled more completely by rlcs InfMissionQuest
--  local allowedQuests={}
--  for questName,questAddon in pairs(this.ihQuestsInfo)do
--    if questAddon.allowInStoryMissions then
--      allowedQuests[questName]=true
--    end
--  end--for ihQuestsInfo
--  TppQuest.RegisterCanActiveQuestListInMission(allowedQuests)
end--MissionPrepare

--tex see InfEquip.LoadEquipTable for notes
--CULL, now in InfEquip.LoadEquipTable
--function this.LoadEquipTable()
--  if not TppMission.IsFreeMission(vars.missionCode) and not TppMission.IsStoryMission(vars.missionCode) then
--    return
--  end
--
--  local equipLoadTable={}
--
--  for questName,questAddon in pairs(this.ihQuestsInfo)do
--    if TppQuest.IsActive(questName) then
--      if questAddon.requestEquipIds then
--        InfCore.Log("InfQuest.LoadEquipTable IsActive:"..questName)
--        for n,equipName in ipairs(questAddon.requestEquipIds)do
--          local equipId=TppEquip[equipName]
--          if equipId==nil then
--            InfCore.Log("ERROR InfQuest.LoadEquipTable: requestEquipIds "..questName.."  could not find equipId "..tostring(equipId))
--          else
--            equipLoadTable[#equipLoadTable+1]=equipId
--          end
--        end
--      end
--    end
--  end
--
--  if #equipLoadTable>0 and TppEquip.RequestLoadToEquipMissionBlock then
--    TppEquip.RequestLoadToEquipMissionBlock(equipLoadTable)
--  end
--end
--tex some basic 'CanOpen' functions
function this.CanOpenClusterGrade0(questName)
  local questAddon=this.ihQuestsInfo[questName]
  return TppLocation.GetLocalMbStageClusterGrade(TppDefine.CLUSTER_DEFINE[questAddon.clusterName]+1)>0
end
--tex mother base mbLayout changes from 0-3 depending on the plnts built off command
--so if you don't want to mess around with having to work out positions for all the layouts you can just limit it to this
--(through the player will have to have developed mb to that point before
function this.CanOpenIsMbLayout3(questName)
  return TppLocation.GetLocalMbStageClusterGrade(TppDefine.CLUSTER_DEFINE.Command+1)>=4
end
function this.CanOpenPlntIsDeveloped(questName)
  local questAddon=this.ihQuestsInfo[questName]
  return TppLocation.GetLocalMbStageClusterGrade(TppDefine.CLUSTER_DEFINE[questAddon.clusterName]+1)>=(questAddon.plntId+1)
end
--tex default for canOpenQuest
function this.AllwaysOpenQuest(questName)
  return true
end

--CALLER: Ivars.quest_setIsOnceToRepop, this.OnAllocate (with ivar setting)
--IN: Ivars.quest_setIsOnceToRepop
--IN/OUT: TppQuest.questList questListInfo
--tex Only sets isOnce on those quests that had it set in vanilla (identified by my additional defaultIsOnce)
--tex used to either change qst_questRepopFlag, or gate other functions with quest_forceRepop (still there for debugging)
--but that's a headache to get head around
--this approach modifies the runtime data of TppQuest, flipping isOnce, which lets vanilla code just do its thing
function this.SetIsOnceOff(setIsOnceOff)
  InfCore.LogFlow("InfQuest.SetIsOnceOff "..tostring(setIsOnceOff))
  for i,locationInfo in ipairs(TppQuestList.questList)do
    for j,questListInfo in ipairs(locationInfo.infoList)do
      if not questListInfo.strictIsOnce then--tex some quests really shouldnt repeat
        if setIsOnceOff then
          if questListInfo.isOnce then
            if this.debugModule then
              InfCore.Log("InfQuest.SetIsOnceOff: forcing isOnce off "..questListInfo.name)
            end
            questListInfo.isOnce=false
          end
        else
          if questListInfo.defaultIsOnce and questListInfo.isOnce==false then
            if this.debugModule then
              InfCore.Log("InfQuest.SetIsOnceOff: setting isOnce back on "..questListInfo.name)
            end
            questListInfo.isOnce=true
            --tex UpdateRepopFlagImpl understandably doesn't take into account turning off repop of isOnce because it never set on in the first place
            --yes, despite 'touching flags bad', it's actually nessesary and considered this time
            if TppQuest.IsCleard(questListInfo.name) and questListInfo.isOnce then
              gvars.qst_questRepopFlag[TppDefine.QUEST_INDEX[questListInfo.name]]=false
            end
          end  
        end--if setIsOnceOff
      end--not strictIsOnce
    end--for area infoList
  end--for questList
  if this.debugModule then
    InfCore.PrintInspect(TppQuestList.questList,"TppQuestList.questList post SetIsOnceOff")
  end
end--SetIsOnce

local blockQuests={
  --sovietBase_q99020=true,-- 82, make contact with emmeric. is just a trigger for a mission --CULL either move to strictIsOnce or some other more consistant method
}

--block quests> aka (not CanActiveQuestIH())
--return true if this quest should not be selected for Active
function this.BlockQuest(questName)
  --tex TODO: doesn't work for the quest area you start in (need to clear before in actual mission)
  if InfMainTpp.IsMbEvent() then
    --InfCore.Log("BlockQuest on event "..tostring(questName).." "..tostring(vars.missionCode))--DEBUG
    local questAddon=this.ihQuestsInfo[questName]
    if not questAddon or not questAddon.allowInWargames then
      if this.debugModule then
        InfCore.Log("BlockQuest "..questName.." IsMbEvent")
      end
      return true
    end
  end

  if blockQuests[questName] then
    if TppQuest.IsCleard(questName) then
      return true
    end
  end

  --tex instead of faffing about in tppquest to filter categories just filter here as it already calls BlockQuest
  local questInfo=TppQuest.GetSideOpsInfo(questName)
  if questInfo==nil then--tex hidden quest, dont block
    return false
  end

  --tex category selection menu / InfQuestIvars quest_category_
  local categoryName=TppQuest.QUEST_CATEGORIES[questInfo.category+1]  
  local ivarName=InfQuestIvars.categoryIvarPrefix..categoryName
  local ivar=Ivars[ivarName]
  
  local categorySetting=ivar:GetSettingName()
  local isAddon=InfQuest.ihQuestsInfo[questName]
  --REF {"ALL","NONE","ADDON_ONLY"},
  if categorySetting=="NONE" then
    return true
  elseif categorySetting=="ADDON_ONLY" and not isAddon then
    return true
  end
  --<
 
  --tex block heli quests to allow super reinforce
  if Ivars.enableHeliReinforce:Is(1) then
    --if TppMission.GetMissionID()==30010 or TppMission.GetMissionID()==30020 then
    for n,name in ipairs(TppDefine.QUEST_HELI_DEFINE)do
      if name==questName then
        return true
      end
    end
    --end
  end

  return false
end
--tex for UpdateActiveQuest
-- returns {[forcedQuestArea]=<forcedQuestName>}--only one entry
--because there can only be one sidop unlocked per area, but currently only forcing one sideop
local printUnlockedFmt="quest_forceQuestNumber:%u %s %s"
function this.GetForced()
  InfCore.LogFlow("InfQuest.GetForced")
  --tex TODO: need to get intended mission code
  if InfMainTpp.IsMbEvent() then
    --InfCore.Log("GetForced on event "..tostring(vars.missionCode))--DEBUG
    return nil
  end

  local forcedQuests={}--tex <areaName>=<questName>
  local forcedCount=0

  local questTable=TppQuest.GetQuestInfoTable()

  --tex find name and area for unlocksideop
  local forceQuestNumber=Ivars.quest_forceQuestNumber:Get()
  if forceQuestNumber>0 and forceQuestNumber<=#questTable then
    local unlockedName=questTable[forceQuestNumber].questName
    local unlockedArea=nil
    if unlockedName~=nil then
      unlockedArea=TppQuestList.questAreaNameTable[unlockedName]
      if unlockedArea==nil then
        InfCore.Log("ERROR: InfQuest.GetForced questAreaNameTable[] nil for "..unlockedName)
        InfCore.Log("No location or area for the quest installed?")
      else
        forcedQuests[unlockedArea]=unlockedName
        forcedCount=forcedCount+1
        InfCore.Log(string.format(printUnlockedFmt,forceQuestNumber,unlockedName,unlockedArea))
      end
    end--if unlockedName
  end--if forceQuestNumber <=#questTable

  if forcedCount==0 then
    return nil
  else
    if this.debugModule then
      InfCore.PrintInspect(forcedQuests,forcedQuests)
    end

    return forcedQuests
  end
end--GetForced
--tex for UpdateActiveQuest / InfQuestIvars sideOpsCategoryMenu quest category selection
--returns {[QUEST_CATEGORIES_ENUM]="ALL"|"NONE"|"ADDON_ONLY",...}
--DEPRECIATED: only used for debugging. 
--the original approach was to run this to gather all the category settings, then compare that in the quest list loops, 
--but it's not really that much slower to look up the single ivar for each quest from within the loop
function this.GetEnabledCategories()
  local enabledCategories={}
  local ivarPrefix=InfQuestIvars.categoryIvarPrefix
  for i,categoryName in ipairs(TppQuest.QUEST_CATEGORIES)do
    local ivarName=ivarPrefix..categoryName
    local categoryEnum=TppQuest.QUEST_CATEGORIES_ENUM[categoryName]
    local ivar=Ivars[ivarName]
    if not ivar then
      InfCore.Log("ERROR: GetEnabledCategories could not find selection ivar for category "..categoryName)
    else
      enabledCategories[categoryEnum]=ivar:GetSettingName()
    end
  end--for QUEST_CATEGORIES
  return enabledCategories
end--GetEnabledCategories

local gvarFlagNames={
  "qst_questOpenFlag",
  "qst_questRepopFlag",
  "qst_questClearedFlag",
  "qst_questActiveFlag",
}
--tex REF for SEO: if searching for any of the below you should also search gvarFlagNames in this module to see them also being used
--gvars.qst_questOpenFlag--see note above
--gvars.qst_questRepopFlag--see note above
--gvars.qst_questClearedFlag--see note above
--gvars.qst_questActiveFlag--see note above

--tex clear range above vanilla quests
function this.ClearGvarFlagsAddonRange()
  for questGvarIndex=TppDefine.NUM_VANILLA_QUEST_DEFINES,TppDefine.QUEST_MAX-1 do
    for i,gvarName in ipairs(gvarFlagNames)do
      gvars[gvarName][questGvarIndex]=false
    end
  end
end--ClearGvarFlagsAddonRange

--tex loads the quest definitions/scripts from MGS_TPP\mod\quests
--the name of the script file will be used for questName throughout the tables
--name of file can be anything, provided it has a qname suffix (see notes at start of this file).
--SIDE: this.ihQuestNames,this.ihQuestsInfo
function this.LoadQuestDefs()
  InfCore.LogFlow("InfQuest.LoadQuestDefs")
  local ihQuestNames={}
  local ihQuestsInfo={}
  local questIdToQuestName={}
  local questIds={}

  local questFiles=InfCore.GetFileList(InfCore.files.quests,".lua")
  for i,fileName in ipairs(questFiles)do
    InfCore.Log("InfQuest.LoadQuestDefs: "..fileName)

    local questName=InfUtil.StripExt(fileName)
    local module=InfCore.LoadSimpleModule(InfCore.paths.quests,fileName)
    if module.questPackList then--tex TYPE
      ihQuestsInfo[questName]=module
      ihQuestNames[#ihQuestNames+1]=questName
    end
  end

  --TODO validate questDef
  --TODO collision quest nubmer with existing quests

  --tex bit of futzing to put ihQuestNames in questId order
  for i,questName in ipairs(ihQuestNames) do
    local questNumber=this.GetQuestNumber(questName)
    if not questNumber then
      InfCore.Log("InfQuest.LoadQuestDefs: Could not find questNumber on "..questName)
    else
      if questIdToQuestName[questNumber] then
        InfCore.Log("InfQuest.LoadQuestDefs: WARNING: questNumber "..questNumber.." collision with "..questIdToQuestName[questNumber].." and "..questName)
      end
      questIdToQuestName[questNumber]=questName
    end
  end

  for questId,questName in pairs(questIdToQuestName)do
    questIds[#questIds+1]=questId
  end
  table.sort(questIds)

  ihQuestNames={}--tex clear, finally putting in order
  for i,questId in ipairs(questIds)do
    ihQuestNames[#ihQuestNames+1]=questIdToQuestName[questId]
  end
  --

  if this.debugModule then
    InfCore.PrintInspect(questFiles,"questFiles")
    InfCore.PrintInspect(questIds,"questIds")

    InfCore.PrintInspect(ihQuestNames,"LoadQuestDefs ihQuestNames")
    InfCore.PrintInspect(ihQuestsInfo,"LoadQuestDefs ihQuestsInfo")
  end

  this.ihQuestNames=ihQuestNames
  this.ihQuestsInfo=ihQuestsInfo
end

--REF
--TppQuestList.questList={
--  {locationId=TppDefine.LOCATION_ID.MTBS,areaName="MtbsCombat",clusterName="Combat",
--    infoList={
--    {name="mtbs_q42070",invokeStepName="QStep_Start"},
--    {name="quest_q30100",invokeStepName="QStep_Start"},
--TppQuestList.questAreaNameTable
--tex just grinding through arrays since too many lookup tables are a pain to manage and this is a once-on-load, or on user command function.
function this.AddToQuestList(questList,questAreaNameTable,questName,AddToQuestList)
  for i,areaQuests in ipairs(questList)do
    if areaQuests.locationId==AddToQuestList.locationId
      and areaQuests.areaName==AddToQuestList.areaName then

      local infoList=areaQuests.infoList

      --tex find existing index
      local infoListIndex
      for i,areaQuest in ipairs(infoList)do
        if areaQuest.name==questName then
          infoListIndex=i
          break
        end
      end
      --tex get new index
      if not infoListIndex then
        infoListIndex=#infoList+1
      end

      questAreaNameTable[questName]=AddToQuestList.areaName
      infoList[infoListIndex]={name=questName,invokeStepName="QStep_Start"}--tex DEBUGNOW add isStory, isOnce support?

      break
    end
  end
end--AddToQuestList

--REF TppQuest.questInfoTable={
--  --[[XXX]]{questName="quest_q30100",questId="quest_q30100",locationId=TppDefine.LOCATION_ID.MTBS,clusterId=TppDefine.CLUSTER_DEFINE.Combat,plntId=TppDefine.PLNT_DEFINE.Special,category=this.QUEST_CATEGORIES_ENUM.CAPTURE_ANIMAL},--tex
--  --[[XXX]]{questName="fort_q71080",questId="quest_q71080",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(2080.718,456.726,-1927.582),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
--IN/OUT: questInfoTable,questTableIndexes
function this.AddToQuestInfoTable(questInfoTable,questInfoIndexes,questName,questAddon)
  local addQuestInfo={
    questName=questName,
    questId=questName,
    locationId=questAddon.locationId,
    clusterId=TppDefine.CLUSTER_DEFINE[questAddon.clusterName],
    plntId=questAddon.plntId,
    iconPos=questAddon.iconPos,
    radius=questAddon.radius,
    category=questAddon.category or TppQuest.QUEST_CATEGORIES_ENUM.NO_CATEGORY
  }

  --tex get existing index (if user manually reloading scripts in-game), or add new (on first call/startup).
  local questInfoIndex=questInfoIndexes[questName] or #questInfoTable+1
  questInfoIndexes[questName]=questInfoIndex
  questInfoIndexes[questInfoIndex]=questName
  questInfoTable[questInfoIndex]=addQuestInfo
end

--tex basically just pulls together a lot of scattered data for easier setup of new quests
function this.RegisterQuests()
  InfCore.LogFlow("InfQuest.RegisterQuests")

  local questInfoTable=TppQuest.GetQuestInfoTable()

  if this.debugModule then
    InfCore.Log("numVanillaUiQuests:"..TppQuest.NUM_VANILLA_UI_QUESTS.." #questInfoTable:"..#questInfoTable)
  end

  local TppQuest=TppQuest
  local TppQuestList=TppQuestList
  local QUEST_DEFINE=TppDefine.QUEST_DEFINE

  local questInfoTable=TppQuest.GetQuestInfoTable()
  local openQuestCheckTable=TppQuest.GetCanOpenQuestTable()
  local canActiveQuestChecks=TppQuest.GetCanActiveQuestTable()

  InfMain.RandomSetToLevelSeed()

  local removeQuests={}--tex quests that arent valid to add

  for i,questName in ipairs(this.ihQuestNames)do
    local questAddon=this.ihQuestsInfo[questName]
    
    --tex find existing or new
    local questIndex
    for i,_questName in ipairs(QUEST_DEFINE)do
      if _questName==questName then
        questIndex=i
        break
      end
    end
    if not questIndex then
      questIndex=#QUEST_DEFINE+1
    end
    
    InfCore.Log("RegisterQuests "..questName.." "..tostring(questIndex))--DEBUG
    
    local doRegister=true
    
    if questIndex>TppDefine.QUEST_MAX-1 then
      --tex LIMIT the only main issue I can see currently with being > QUEST_MAX is gvars qst_quest*Flags. scriptvar arrays dont seem to complain (at least not visibly) when going above their arraySize, and return nil over.
      InfCore.Log("ERROR: InfQuest.RegisterQuests: questIndex>TppDefine.QUEST_MAX. Currently save states only work for 83 additional addon quests.",true,true)--DEBUGNOW is announcelog up when this is called?
    end
    
    --tex since quest info is defined by TppDefine.LOCATION_ID this will be nil if its for a location addon that hasn't been installed
    --TODO: would be better as string so can compare against actually nil questAddon.locationId, and print for debugging?
    if questAddon.locationId==nil then
      InfCore.Log("ERROR: InfQuest.RegisterQuests: questAddon.locationId==nil, Location for quest not installed?",true,true)--DEBUGNOW is announcelog up when this is called?
      doRegister=false
    end
    
    if this.debugModule then
      InfCore.PrintInspect(questAddon,"questAddon")
    end

    if not doRegister then
      table.insert(removeQuests,questName)
    else
    questAddon.missionPacks=questAddon.missionPacks or questAddon.missionPackList--PATCHUP: LEGACY: missionPackList renamed (only initial release of mtbs_medical_plnt2_shootingpractice should have this, unless someone in the community started using it since) 
        
    TppDefine.QUEST_DEFINE[questIndex]=questName
    TppDefine.QUEST_INDEX=TppDefine.Enum(TppDefine.QUEST_DEFINE)
    --InfCore.PrintInspect(TppDefine.QUEST_RANK_TABLE)--DEBUG
    TppDefine.QUEST_RANK_TABLE[TppDefine.QUEST_INDEX[questName]]=questAddon.questRank
    --InfCore.PrintInspect(TppDefine.QUEST_RANK_TABLE)--DEBUG

    if questAddon.questPackList.randomFaceList then
      table.insert(TppDefine.QUEST_RANDOM_FACE_DEFINE,questName)
      TppDefine.QUEST_RANDOM_FACE_INDEX=TppDefine.Enum(TppDefine.QUEST_RANDOM_FACE_DEFINE)
      --InfCore.PrintInspect(TppDefine.QUEST_RANDOM_FACE_INDEX)
    end
    --tex WORKAROUND, cant do in TppQuest.RegisterQuestPackList since it's already using random inside its loop
    local randomFaceListIH=questAddon.questPackList.randomFaceListIH
    if randomFaceListIH then
      questAddon.questPackList.faceIdList=InfCore.PCallDebug(InfEneFova.GetRandomFaces,randomFaceListIH.gender,randomFaceListIH.count)
    end
    this.AddToQuestInfoTable(questInfoTable,TppQuest.QUESTTABLE_INDEX,questName,questAddon)
    openQuestCheckTable[questName]=questAddon.canOpenQuest or this.AllwaysOpenQuest--tex always checked so cant be nil
    canActiveQuestChecks[questName]=questAddon.canActiveQuest--tex can be nil (is assumed true)

    TppQuest.questCompleteLangIds[questName]=questAddon.questCompleteLangId
    --tex -^- this goes through TppQuest.ShowAnnounceLog > TppUI.ShowAnnounceLog so hits the imho silly TppUI.ANNOUNCE_LOG_TYPE indirect
    --so I'll just patch it in if it doesnt exist
    if not TppUI.ANNOUNCE_LOG_TYPE[questAddon.questCompleteLangId] then
      TppUI.ANNOUNCE_LOG_TYPE[questAddon.questCompleteLangId]=questAddon.questCompleteLangId
    end

    this.AddToQuestList(TppQuestList.questList,TppQuestList.questAreaNameTable,questName,questAddon)
    TppQuestList.questPackList[questName]=questAddon.questPackList

    if questAddon.hasEnemyHeli then
      if not InfUtil.FindInList(TppDefine.QUEST_HELI_DEFINE,questName) then
        table.insert(TppDefine.QUEST_HELI_DEFINE,questName)
      end
    end
    end--if doRegister
  end--for ihQuestNames

  InfMain.RandomResetToOsTime()

  if this.debugModule then
    InfCore.PrintInspect(removeQuests,"removeQuests")
  end
  for i,questName in ipairs(removeQuests)do
    for j,_questName in ipairs(this.ihQuestNames)do
      if questName==_questName then
        table.remove(this.ihQuestNames,j)
        break
      end
    end--for this.ihQuestNames
    
    this.ihQuestsInfo[questName]=nil
  end--for removeQuests

  InfCore.Log("numUiQuests:"..#questInfoTable)

  if this.debugModule then
    InfCore.PrintInspect(TppDefine.QUEST_INDEX,"QUEST_INDEX")
    InfCore.PrintInspect(TppDefine.QUEST_RANK_TABLE,"QUEST_RANK_TABLE")
    InfCore.PrintInspect(TppQuestList.questAreaNameTable,"questAreaNameTable")
    InfCore.PrintInspect(TppQuestList.questList,"questList")
    InfCore.PrintInspect(openQuestCheckTable,"openQuestCheckTable")
    InfCore.PrintInspect(TppQuestList.questPackList,"questPackList")
  end
end--RegisterQuests

--REF
--  <locationInfo>.questAreas={
--    {
--      areaName="tent",
--      --xMin,yMin,xMax,yMax, in smallblock coords. see Tpp.CheckBlockArea. debug menu ShowPosition will log GetCurrentStageSmallBlockIndex, or you can use whatever block visualisation in unity you have
--      loadArea={116,134,131,152},--load is the larger area, so -1 minx, -1miny, +1maxx,+1maxy vs active
--      activeArea={117,135,130,151},
--      invokeArea={117,135,130,151},--same size as active, but keeping here to stay same implementation as vanilla
--    },
--    ...
--  },

--locationInfo questAreas to TppQuestList.questList
--CALLER: InfMission.AddInLocations
--GOTCHA: must be run before InfQuest.RegisterQuests,
--and it is because InfMission.LoadLibraries > AddInLocations > InfQuest.AddLocationQuestAreas . And InfQuest.PostAllModulesLoad > RegisterQuests
--but watch out if you split InfMission to InfLocation
--DEBUGNOW also see what happens RE: reloadmodules
--OUT/SIDE: TppQuestList.questList
function this.AddLocationQuestAreas(locationId,locationQuestAreas)
  if locationQuestAreas==nil then
    return
  end

  InfCore.Log("InfQuest.AddLocationQuestAreas locationId:"..locationId)

  --TODO: VALIDATE locationQuestAreas (or should that be done on load?)

  --TODO: if this is useful move somewhere (I might have some lookup tables to make this easier, but since we're adding they wont be accurate)
  --IN: TppQuestList.questList
  local function GetLocationQuestArea(locationId,areaName)
    local locationHasArea=false
    for i,questArea in ipairs(TppQuestList.questList)do
      if locationId==questArea.locationId then
        if areaName==questArea.areaName then
          return questArea
        end
      end
    end--for questList

    return nil
  end--GetLocationQuestArea

  for i,questArea in ipairs(locationQuestAreas)do
    local currentQuestArea=GetLocationQuestArea(locationId,questArea.areaName)

    if currentQuestArea then
      InfCore.Log("WARNING: InfQuest.AddLocationQuestAreas locationId already has questArea "..questArea.areaName)
    else
      local newQuestArea={
        locationId=locationId,--tex could probably add this on load then just copy table in
        areaName=questArea.areaName,
        loadArea=questArea.loadArea,
        activeArea=questArea.activeArea,
        invokeArea=questArea.invokeArea,
        clusterName=questArea.clusterName,
        infoList={
        },
      }
      table.insert(TppQuestList.questList,newQuestArea)
      if this.debugModule then
        InfCore.PrintInspect(newQuestArea,"newQuestArea")
      end
    end
  end--for locationQuestAreas
end--AddLocationQuestAreas

--DEBUG
function this.DEBUG_PrintQuestClearedFlags()
  for i=0,TppDefine.QUEST_MAX-1 do
    InfCore.Log("qst_questClearedFlag["..i.."]="..tostring(gvars.qst_questClearedFlag[i]))
  end
end

--CALLER: TppVarInit.StartTitle (>InfMain CallOnModules this.OnStartTitle) - since registerquests is run before the first game save/gvar load
function this.SetupInstalledQuestsState()
  InfCore.LogFlow"InfQuest.SetupInstalledQuestsState"
  if not this.questStatesLoaded then
    --tex clear quest gvars range as matter of course and rely on ih_save.questStates to restore them
    this.ClearGvarFlagsAddonRange()--DEBUGNOW TESTS
    --complete addon quest, quit and see if its still completed next session
    --then uninstall it, run game, reinstall it, run game, see if its cleared
    --
    this.questStatesLoaded=true
  end

  --tex restore any saved quest gvars from ih_save state
  this.ReadSaveStates()

  --this.DEBUG_PrintQuestClearedFlags()
end

function this.GetQuestNumber(questName)
  return tonumber(string.sub(questName,-5))
end

--tex called from equivalent TppQuest funcs
--QuestBlockOnAllocate only called in added ih quests, not vanilla quests, the rest of the functions called by vannila quest scripts
function this.QuestBlockOnAllocate(questScript)--tex

end
--tex called during questScript .OnAllocate
function this.RegisterQuestSystemCallbacks(callbackFunctions)

end
function this.QuestBlockOnInitialize(questScript)

end
function this.QuestBlockOnInitializeBottom(questScript)
  InfCore.LogFlow("InfQuest.QuestBlockOnInitializeBottom")
  InfShootingPractice.QuestBlockOnInitializeBottom(questScript)
end--QuestBlockOnInitializeBottom
function this.QuestBlockOnUpdate(questScript)

end
function this.QuestBlockOnTerminate(questScript)

end
--

--tex GetSideOpsListTable is called by engine for sideops ui
function this.PrintSideOpsListTable()
  local sideOpsTable=TppQuest.GetSideOpsListTable()
  InfCore.PrintInspect(sideOpsTable,{varName="sideOpsTable"})
end

function this.PrintQuestArea()
  if TppLocation.GetLocationName()=="mtbs" or TppLocation.GetLocationName()=="mbqf" then
    local clusterId=MotherBaseStage.GetCurrentCluster()
    if clusterId==nil then
      InfCore.Log("InfQuest.PrintQuestArea: WARNING: GetCurrentCluster==nil")
    else
      local clusterName=TppDefine.CLUSTER_NAME[clusterId+1]
      --tex not using InfMain.CLUSTER_NAME because there's currently no quest area for separation,zoo
      --GOTCHA doesn't take into account MtbsPaz area, but im not sure how it decides that area
      if clusterName==nil then
        InfCore.Log("InfQuest.PrintQuestArea: WARNING: clusterName==nil")
      else
        InfCore.Log("Quest Area: Mtbs"..clusterName)
      end
    end
    return
  end

  local blockIndexX,blockIndexY=Tpp.GetCurrentStageSmallBlockIndex()
  local blockIndexMessage="blockIndexX:"..blockIndexX..",blockIndexY:"..blockIndexY
  InfCore.Log(blockIndexMessage,false,true)

  local areaTypes={
    loadArea=false,
    invokeArea=false,
    activeArea=false,
  }

  local numAreas=#mvars.qst_questList
  for i=1,numAreas do
    local areasQuestInfo=mvars.qst_questList[i]--TppQuestList .questList

    for areaType,inArea in pairs(areaTypes)do
      areaTypes[areaType]=TppQuest.IsInsideArea(areaType,areasQuestInfo,blockIndexX,blockIndexY)
    end

    local inAnyArea=false
    for areaType,inArea in pairs(areaTypes)do
      if areaTypes[areaType]==true then
        inAnyArea=true
        break
      end
    end

    if inAnyArea then
      local areaInfoMessage="Quest area: "..areasQuestInfo.areaName..", in:"
      for areaType,inArea in pairs(areaTypes)do
        areaInfoMessage=areaInfoMessage.." "..areaType.."="..tostring(inArea)
      end

      InfCore.Log(areaInfoMessage,false,true)
    end
  end
end

function this.GetQuestPositions()
  local positions={}
  local questTable=TppQuest.GetQuestInfoTable()
  for sideopNum,sideOpInfo in ipairs(questTable)do
    if sideOpInfo.locationId==vars.locationCode then
      local iconPos=sideOpInfo.iconPos
      if iconPos then
        local pos={iconPos:GetX(),iconPos:GetY(),iconPos:GetZ()}
        table.insert(positions,pos)
      end
    end
  end
  return positions
end

--saving/loading
--tex currently only loads ih_quest_states once on session
--but saves to is on every game save
--the qst_ gvars keep doing their thing normally after the initial set by ih
--
this.isSaveDirty=false--tex GOTCHA: actually used for external module to flag (currently only InfShootingPractice)

this.saveName="ih_quest_states.lua"

--tex don't lose existing on modulereload
ih_quest_states=ih_quest_states or {}

--CALLER: MakeNewGameSaveData
--TODO: delete file outright
function this.ClearSave()
  --tex only bother saving if there was something in previous
  if next(ih_quest_states)~=nil then
    this.isSaveDirty=true
  end
  --tex clear
  ih_quest_states={}
end--ClearSave
function this.Save(newSave)
  local isSaveDirty=this.isSaveDirty or this.GetCurrentStates()--tex see gotcha on this.isSaveDirty
  if isSaveDirty then
    if this.debugSave then
      InfCore.Log("questStates isDirty")
    end

    local saveTextList={
      "-- "..this.saveName,
      "-- save states for quests (sideops).",
      "local this={}",
    }
    for questName,questStates in pairs(ih_quest_states)do
      IvarProc.BuildTableText(questName,questStates,saveTextList)
    end

    saveTextList[#saveTextList+1]="return this"
    IvarProc.WriteSave(saveTextList,this.saveName)
    this.isSaveDirty=false
  end

  if this.debugSave then
    InfCore.PrintInspect(ih_quest_states,"ih_quest_states")
  end
end--Save
--GOTCHA: not module 'LoadSave' because we only really want to load once on , as gvars handles reverting state
function this.LoadStates()
  InfCore.LogFlow"InfQuest.LoadStates"
  local saveName=this.saveName
  local filePath=InfCore.paths.saves..saveName
  if not InfCore.FileExists(filePath) then
    InfCore.Log(filePath.." does not exist. (File is only created if addon quests installed)",false,true);
    return nil
  end

  local box=true
  local ih_save=InfCore.LoadSimpleModule(InfCore.paths.saves,saveName,box)

  if ih_save==nil then
    local errorText="LoadStates Error: ih_save==nil"
    InfCore.Log(errorText,true,true)

    return nil
  end

  if type(ih_save)~="table"then
    local errorText="LoadStates Error: ih_save==table"
    InfCore.Log(errorText,true,true)

    return nil
  end

  ih_quest_states=ih_save
  if this.debugSave then
    InfCore.PrintInspect(ih_quest_states,"ih_quest_states")
  end
end--LoadStates

--tex set questCleared gvars from ih_save state
--IN/SIDE: ih_save
--REF ih_save
--ih_quest_states={
--  ih_quest_q30100={
--    qst_questOpenFlag=true,
--  },
--}

function this.ReadSaveStates()
  InfCore.LogFlow"InfQuest.ReadSaveStates"

  if ih_quest_states==nil then
    local errorText="ERROR: ReadSaveStates: ih_quest_states==nil"
    InfCore.Log(errorText,true,true)
    return {}
  end

  if this.debugSave then
    InfCore.PrintInspect(ih_quest_states,"ih_quest_states")
  end

  local clearStates={}
  for questName,questStates in pairs(ih_quest_states) do
    local questIndex=TppDefine.QUEST_INDEX[questName]
    if not questIndex then
      InfCore.Log("InfQuest.ReadSaveStates: Could not find questIndex for "..questName)
      table.insert(clearStates,questName)--tex dont propogate it (also cant delete from table you're iterating, so actual clear ias after the loop)
    else
      for i,gvarFlagName in ipairs(gvarFlagNames)do
        gvars[gvarFlagName][questIndex]=questStates[gvarFlagName] or false
      end
    end
  end--for ih_quest_states

  for i,questName in ipairs(clearStates)do
    ih_quest_states[questName]=nil
  end

  --tex open up new quests
--CULL, DEBUGNOW UpdateOpenQuest should handle it, but that needs a UpdateActiveQuest call?
--  for i,questName in ipairs(this.ihQuestNames)do
--    if not ih_quest_states[questName] then
--      local questIndex=TppDefine.QUEST_INDEX[questName]
--      if not questIndex then
--        InfCore.Log("ERROR: InfQuest.ReadSaveStates: Could not find questIndex for "..questName)
--      else
--        gvars.qst_questOpenFlag[questIndex]=true
--      end
--    end
--  end--for ihQuestNames

  if this.debugSave then
    for questName,questStates in pairs(ih_quest_states) do
      InfCore.Log(questName)
      local questIndex=TppDefine.QUEST_INDEX[questName]
      if not questIndex then
      else
        for i,gvarFlagName in ipairs(gvarFlagNames)do
          local value=tostring(gvars[gvarFlagName][questIndex])
          InfCore.Log(gvarFlagName.."="..value)
        end
      end
    end--for ih_quest_states
  end
end--ReadSaveStates
--IN: gvars.qst_quest*Flags
--IN: ih_quest_states
--OUT: ih_quest_states
function this.GetCurrentStates()
  local QUEST_INDEX=TppDefine.QUEST_INDEX
  local gvars=gvars

  local isSaveDirty=false

  for i,questName in ipairs(this.ihQuestNames)do
    local questIndex=QUEST_INDEX[questName]
    if not questIndex then
      InfCore.Log("ERROR: InfQuest.GetCurrentStates: Could not find questIndex for "..questName,false,true)
    else
      local questStates=ih_quest_states[questName] or {}

      for i,gvarFlagName in ipairs(gvarFlagNames) do
        local gvarValue=gvars[gvarFlagName][questIndex]
        if questStates[gvarFlagName]~=gvarValue then
          isSaveDirty=true
          questStates[gvarFlagName]=gvarValue
        end
      end

      ih_quest_states[questName]=questStates
    end
  end--for ihQuestNames

  return isSaveDirty
end--GetCurrentStates

function this.DebugCurrentFlags()
  local allStates={}
  for i,questName in ipairs(TppDefine.QUEST_DEFINE)do
    local questIndex=TppDefine.QUEST_INDEX[questName]
    if not questIndex then
      InfCore.Log("ERROR: InfQuest.DebugCurrentFlags: Could not find questIndex for "..questName,false,true)
    else      
      local questStates={}
      allStates[questName]=questStates
      questStates.index=questIndex
      for i,gvarFlagName in ipairs(gvarFlagNames) do
        local gvarValue=gvars[gvarFlagName][questIndex]
        questStates[gvarFlagName]=gvarValue
      end
    end--if questIndex
  end--for ihQuestNames
  
  return allStates
end--DebugCurrentFlags

--CALLER: TppLandingZone.OnMissionCanStart
function this.DisableLandingZones()
  InfCore.LogFlow("InfQuest.DisableLandingZones:")
  local function FindMatchLZ(lz)
    for location,lzs in pairs(TppLandingZone.assaultLzs)do
      for drpRoute,aprRoute in pairs(lzs) do
        if aprRoute==lz then
          return drpRoute
        end
      end
    end
    for location,lzs in pairs(TppLandingZone.missionLzs)do
      for aprRoute,drpRoute in pairs(lzs) do
        if drpRoute==lz then
          return aprRoute
        end
      end
    end
    return lz
  end

  for questName,questAddon in pairs(this.ihQuestsInfo)do
    if TppQuest.IsActive(questName) then
      if questAddon.disableLzs then
        InfCore.Log("DisableLandingZones IsActive:"..questName)
        for i,lz in ipairs(questAddon.disableLzs) do
          local otherRoute=FindMatchLZ(lz)
          InfCore.Log("otherRoute "..tostring(otherRoute))
          TppUiCommand.AddDisabledLandPoint(otherRoute)
          TppLandingZone.GroundDisableLandingZone(lz)
        end
      end
    end
  end
end

--tex called from quest script to have the external quest defintion script as the quest script
function this.GetScript(scriptName)
  InfCore.Log("InfQuest.GetScript: "..tostring(scriptName))
  local questScript=this.ihQuestsInfo[scriptName]
  if not questScript then
    InfCore.Log("ERROR: InfQuest.GetScript: could not find quest script "..tostring(scriptName),false,true)
    return {}
  else
    return questScript
  end
end
--tex FIXUP try and fix any flags I may have messed up in older (pre r260) IH versions where I was doing dumb things with flags
function this.FixFlags()
  --tex UpdateRepopFlagImpl with ih force repop ivar (bypassed IsRepop and isOnce) used to set qst_questRepopFlag true which could posibly have activated some of the hidden or specially managed quests
  for i,locationAreaInfo in ipairs(TppQuestList.questList)do
    for j,questListInfo in ipairs(locationAreaInfo.infoList)do
      local questName=questListInfo.name
      if TppQuest.IsRepop(questListInfo.name) then
        --local isHiddenQuest=TppQuest.GetSideOpsInfo(questName)==nil
        if questListInfo.strictIsOnce and TppQuest.IsCleard(questName) then--tex only really an issue with the hidden/managed quests, which are now flagged with strictIsOnce DEBUGNOW think this through, review strictIsOnce once you've expanded them for set isonce false ivar
          local questIndex=TppQuest.GetQuestIndex(questName)
          gvars.qst_questRepopFlag[questIndex]=false
          gvars.qst_questActiveFlag[questIndex]=false
        end
      end
    end--for infoList
  end--for questList
  
  --tex from old ReadSaveStates 
  --DEBUGNOW FIX while ClearGvarFlagsAddonRange will close it, and the normal updateopen will sort out new quests, 
  --but existing ih_quest_states from before this -v- was removed may still have open saved/restore it
  --only really an issue for addon quests that had a specific open condition that should be false at the time the user is playing, ala mb plat development
  --a manual fix is to just delete ih_save_states
  --cant think of a good way to detect at the moment
  --REF CULL
  --  for i,questName in ipairs(this.ihQuestNames)do
--    if not ih_quest_states[questName] then
--      local questIndex=TppDefine.QUEST_INDEX[questName]
--      if not questIndex then
--        InfCore.Log("ERROR: InfQuest.ReadSaveStates: Could not find questIndex for "..questName)
--      else
--        gvars.qst_questOpenFlag[questIndex]=true
--      end
--    end
--  end--for ihQuestNames

--tex InfPuppy ivar mbEnablePuppy OnChange used to flip the open flag for Mtbs_child_dog
--REF CULL
--  OnChange=function(self,setting)
--    local puppyQuestIndex=TppDefine.QUEST_INDEX.Mtbs_child_dog 
--    if setting==0 then
--      gvars.qst_questRepopFlag[puppyQuestIndex]=false
--      gvars.qst_questOpenFlag[puppyQuestIndex]=false
--    else
--      local puppyQuestIndex=TppDefine.QUEST_INDEX.Mtbs_child_dog
--      gvars.qst_questRepopFlag[puppyQuestIndex]=true
--      gvars.qst_questOpenFlag[puppyQuestIndex]=true
--    end
--    TppQuest.UpdateRepopFlagImpl(TppQuestList.questList[17])--MtbsCommand
--    TppQuest.UpdateActiveQuest()
--  end, 

  --tex the fix. open should be automatically fixed? VERIFY
  --Mtbs_child_dog isnt isOnce, but has canActiveQuestChecks to prevent it replaying after DDogGoWithMe demo, 
  --which also sets its repop to false (DEBUGNOW but does UpdateRepopFlagImpl repop it?) 
  local puppyQuestIndex=TppDefine.QUEST_INDEX.Mtbs_child_dog 
  if TppQuest.IsCleard("Mtbs_child_dog") and gvars.qst_questRepopFlag[puppyQuestIndex] then
    InfCore.Log("InfQuest.FixFlags fixing Mtbs_child_dog",true,true) 
    gvars.qst_questRepopFlag[puppyQuestIndex]=false
    gvars.qst_questActiveFlag[puppyQuestIndex]=false
  end
  
  --InfQuest.UpdateActiveQuest used to set qst_questRepopFlag false for all quests, which may have been cause of all quests disabled bug.
  --REF
--function this.UpdateActiveQuest()
--  InfCore.LogFlow("InfQuest.UpdateActiveQuest")
--  for i=0,TppDefine.QUEST_MAX-1 do
--    gvars.qst_questRepopFlag[i]=false
--  end
--
--  for i,areaQuests in ipairs(TppQuestList.questList)do
--    TppQuest.UpdateRepopFlagImpl(areaQuests)
--  end
--  TppQuest.UpdateActiveQuest()
--
--  TppLandingZone.OnMissionCanStart()--tex redo disable lzs
--end

  --tex the fix
  --a manual fix is to just do reroll sideops command (in mtbs to catch UpdateRepopFlagImpl weird exclusion condition) 
--CULL simple approach 
--if TppQuest.CanOpenSideOpsList()then  
--  local allRepopFalse=true
--  for i=0,TppDefine.QUEST_MAX-1 do
--    if gvars.qst_questRepopFlag[i]==true then
--      allRepopFalse=false
--      break
--    end
--  end--for QUEST_MAX
--  
--  if allRepopFalse then
--    InfCore.Log("WARNING: InfQuest.FixFlags: All repop flags false",true,true)
--    for i,locationInfo in ipairs(TppQuestList.questList)do
--      local forceUpdate=true
--      TppQuest.UpdateRepopFlagImpl(locationInfo,forceUpdate)
--    end
--  end
--end--CanOpenSideOpsList
  --tex DEBUGNOW but may trigger more than
  --tex only vanilla? and leaving out the MtbsPaz for good measure 
  --might possibly want this as a general fix of no repops, but would need to be sure it doesnt run outside of normal conditions
  --otherwise a manual fix is ivar quest_updateRepopMode 'allways' with InfQuest.UpdateActiveQuest should unstick it
  local checkAreas={
  --afgh
    tent=true,
    field=true,
    ruins=true,
    waterway=true,
    cliffTown=true,
    commFacility=true,
    sovietBase=true,
    fort=true,
    citadel=true,
    --mafr
    outland=true,
    pfCamp=true,
    savannah=true,
    hill=true,
    banana=true,
    diamond=true,
    lab=true,
    --mtbs
    MtbsCommand=true,
    MtbsCombat=true,
    MtbsDevelop=true,
    MtbsMedical=true,
    MtbsSupport=true,
    MtbsSpy=true,
    MtbsBaseDev=true,
    --MtbsPaz=true,
  }--checkAreas
  --
  --DEBUGNOW alt, more generic of below
  --tex some of the stuff I'm using for detection kind of assumes its mid game
--  if TppQuest.CanOpenSideOpsList()then          
--    --DEBUGNOW tex just seeing if its hitting in unexpected situations for now
--    if this.debugModule then
--     --TODO: build a list of

--      for i,areaQuests in ipairs(TppQuestList.questList)do
--        if checkAreas[areaQuests.areaName] then
--          local noQuestsActivableForArea=true
--          local numRepopable=0
--          local otherPlayable=0
--          for j,questListInfo in ipairs(areaQuests.infoList)do
--            local dontBlock=true
--            local storyQuests,nonStoryQuests,repopQuests,repopAddonQuests=TppQuest.SelectActivableQuests(areaQuests.infoList,dontBlock)    
--            local activableQuests=#storyQuests+#nonStoryQuests+#repopQuests
--            if activableQuests==0 then
--              if TppQuest.NeedUpdateRepop(areaQuests) then
--    
--                InfCore.Log("WARNING: InfQuest.FixFlags: noQuestsActivableForArea for "..areaQuests.areaName,false,true)
--                local forceUpdate=true
--                --DEBUGNOW TppQuest.UpdateRepopFlagImpl(areaQuests,forceUpdate)    
--              end
--            end
--          end--if noQuestsActivableForArea
--        end--if checkAreas
--      end--for questList
--    end--if debugModule  
--  end --CanOpenSideOpsList
  
  --
--  for i,areaQuests in ipairs(TppQuestList.questList)do
--    if checkAreas[areaQuests.areaName] then
--      local noQuestsActivableForArea=true
--      local numRepopable=0
--      for j,questListInfo in ipairs(areaQuests.infoList)do
--        local questName=questListInfo.name
--        if TppQuest.IsOpen(questName) then
--          if TppQuest.IsCleard(questName) and not questListInfo.isOnceDefault then
--            local CanActiveQuest=TppQuest.GetCanActiveQuestTable()[questName]
--            if not CanActiveQuest or CanActiveQuest(questListInfo.name)then
--              numRepopable=numRepopable+1
--            end
--          end--if cleared and not isOnceDefault
--        end--if IsOpen
--        
--        --tex isrepop means we aint got the bug
--        if TppQuest.IsRepop(questName)then
--          noQuestsActivableForArea=false
--          break
--        end
--      end--for infoList
--      if numRepopable>0 and noQuestsActivableForArea then
--        if TppQuest.NeedUpdateRepop(areaQuests) then--tex DEBUGNOW it might not update not going to update anyhoo, so squelch warning by prerunning the WantUpdateRepop
--          InfCore.Log("WARNING: InfQuest.FixFlags: noQuestsActivableForArea for "..areaQuests.areaName,true,true)
--          local forceUpdate=true
--          TppQuest.UpdateRepopFlagImpl(areaQuests,forceUpdate)
--        end
--      end--if noQuestsActivableForArea
--    end--if checkAreas
--  end--for questList
  --<
end--FixFlags

--Commands
--DEBUG, UNUSED
this.ForceAllQuestOpenFlagFalse=function()
  for n,questIndex in ipairs(TppDefine.QUEST_INDEX)do
    gvars.qst_questOpenFlag[questIndex]=false
    gvars.qst_questActiveFlag[questIndex]=false
  end
  TppQuest.UpdateActiveQuest()
  InfMenu.PrintLangId"done"
end
--tex called by various IH ivars OnChange, and a Command in itself
this.RerollQuestSelection=function()
  InfCore.LogFlow("InfQuest.RerollQuestSelection")
  
  InfMain.RegenSeed(vars.missionCode,vars.missionCode)--tex DEBUGNOW whats my reasoning here?
  
  --tex UpdateRepopFlag (which calls UpdateRepopFlagImpl) is only usually called on quest clear with that quests questarea
  --the only worysome area is MtbsPaz, but the quest there isOnced and now also guarded with strictIsOnce
  for i,areaQuests in ipairs(TppQuestList.questList)do
    local forceUpdate=true
    TppQuest.UpdateRepopFlagImpl(areaQuests,forceUpdate)
  end
  TppQuest.UpdateActiveQuest()

  TppLandingZone.OnMissionCanStart()--tex redo disable lzs
end--RerollQuestSelection

function this.PrintCurrentFlags()
  local currentFlags=this.DebugCurrentFlags()
  InfCore.PrintInspect(currentFlags,"InfQuest.DebugCurrentFlags")
  InfCore.DebugPrint("PrintCurrentFlags to Log")
end--PrintCurrentFlags
--CALLER: TppQuest.GetSideOpsListTable if TppQuest.debugModule
function this.DEBUGTweakSideopsList(sideOpsListTable)
  InfCore.LogFlow"InfQuest.DEBUGTweakSideopsList"
  
  if #sideOpsListTable==0 then
    return sideOpsListTable
  end
  
  --tex GOTCHA: GetSideOpsListTable adds {allSideOpsNum=#questInfoTable} as last entry  
  --make sure you add it back before return
  local allSideOpsNum=table.remove(sideOpsListTable,#sideOpsListTable)
  
  --tex testing sideopslisttable
  for k,v in pairs(sideOpsListTable)do
    if v==nil then
      InfCore.Log("ERROR: v nil for "..tostring(k))
    end
  end
  
  for i,questInfo in pairs(sideOpsListTable)do
    if questInfo==nil then
      InfCore.Log("ERROR: questInfo nil for "..tostring(i))
    end
  end
  
  local questInfoKeyNames={
    "questName",
    "questId",
    "locationId",
    --"iconPos",--TODO: mtbs quests dont have this
    --"radius",--TODO: mtbs quests dont have this
    "category",--IH
    --GetSideOpsListTable>
    "index",
    "isActive",
    "isCleard",
    "gmp",
  }
  for i,questInfo in ipairs(sideOpsListTable)do
    for j,keyName in ipairs(questInfoKeyNames)do
      if questInfo[keyName]==nil then
        InfCore.Log("ERROR: "..tostring(questInfo.questName).." questInfo."..keyName.."==nil")
        InfCore.PrintInspect(questInfo,"questInfo")
      end
    end
  end--for sideOpsListTable
  
--tex verify isActive, isCleard do what they do
--result: yes they do (hilight and checkmark)
 -- for i,questInfo in ipairs(sideopsList)do
--    questInfo.isActive=true--tex NMC controls hilighted on ui
--    questInfo.isCleard=false--tex NMC controls checkmark
    --questInfo.gmp=this.GetBounusGMP(questName)
 -- end

  --tex verify max ui entries, 
  --resulte: yes its 192
--  local start=#sideopsList
--  for i=1,200 do
--    local questInfoCopy={}
--    for k,v in pairs(sideopsList[1])do
--      questInfoCopy[k]=v
--    end
--    questInfoCopy.index=start+i
--    table.insert(sideopsList,questInfoCopy)
--  end

  --tex test .index vs sideOpsListTable order
  --result: index is the number in the ui, order of entries is sideOpsListTable order
--  local index=#sideOpsListTable
--  for i,questInfo in ipairs(sideOpsListTable)do
--    questInfo.index=index
--    index=index-1
--  end
  
--testing sideopsListTable< 
 
	--tex adding back
  table.insert(sideOpsListTable,allSideOpsNum)
  
  --tex function already guarded by TppQuest debugModule
  InfCore.PrintInspect(sideOpsListTable,"TppQuest.GetSideOpsListTable post tweaked")--tex DEBUG  

  return sideOpsListTable
end--DEBUGTweakSideopsList

function this.OnAllocateQuestPatchup(missionTable)
  InfCore.LogFlow"OnAllocateQuestPatchup"
  if vars.missionCode==30010 then
    this.qst_volginQuestDone=false
    InfCore.Log("tent_q99040 repop f30250 demo play fix")
    missionTable.demo.PlayRecoverVolgin=this.PlayRecoverVolgin
  end
end--OnAllocateQuestPatchup
--tex tent_q99040 repop f30250 demo play fix
this.qst_volginQuestDone=false
--f30010_demo function replacement
--CALLER: 30010_sequence.sequences.Seq_Demo_RecoverVolgin
function this.PlayRecoverVolgin( startFunc, endFunc )
  InfCore.Log("InfQuest.PlayRecoverVolgin ***** f30010_demo:PlayRecoverVolgin *****")
  TppDemo.Play("Demo_RecoverVolgin",
    {
      onStart = function() 
        startFunc()
        InfCore.Log("InfQuest.PlayRecoverVolgin demo OnStart")
        this.qst_volginQuestDone=true
      end,
      onEnd = function() endFunc() end,
    },
    {
      useDemoBlock = false,
      finishFadeOut = true
    }
  )
end--PlayRecoverVolgin

return this
