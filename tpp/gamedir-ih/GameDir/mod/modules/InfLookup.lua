-- InfLookup.lua
-- tex various script analysis, lookup-tables, printing functions
-- still some other stuff scattered around:
-- InfLangProc.CpNameString

local this={}

--LOCAOPT 
local InfCore=InfCore
local TppGameObject=TppGameObject
local GetGameObjectId=GameObject.GetGameObjectId
local GetTypeIndex=GameObject.GetTypeIndex
local NULL_ID=GameObject.NULL_ID
local StrCode32=Fox.StrCode32
local type=type
local tostring=tostring

this.debugModule=false

this.str32ToString={}--tex what the <module>.DEBUG_StrCode32ToString tables are loaded into as well as mod\strings\*.txt, migrates into InfCore.str32ToString if this.StrCode32ToString gets any hits.
this.path32ToString={}

this.subtitleId32ToString={}--tex NOTE: interrogation name is also subtitleId (TODO also note in wiki for subp?)
this.path32ToDataSetName={}

this.strings={}
this.gameObjectNames={}
--tex build using this.BuildSoldierSvarIndexes()
--entries: [soldierNameStr32]=<svars.sol* index>
this.soldierSvarIndexes={}

this.objectNameLists={}
this.objectNameListsEnum={}

this.dictionaries={
  subtitleId={
    fileName="subp_dictionary.txt",
    HashFunction=Fox.StrCode32,--seems SubtitlesCommand:ConvertToSubtitlesId(subtitleId) is just StrCode32
  },
}

function this.PostModuleReload(prevModule)
  this.str32ToString=prevModule.str32ToString
  this.path32ToString=prevModule.path32ToString

  this.subtitleId32ToString=prevModule.subtitleId32ToString
  this.path32ToDataSetName=prevModule.path32ToDataSetName
    
  this.soldierSvarIndexes=prevModule.soldierSvarIndexes
  
  --GOTCHA: generated lookups need to be restored too else they'll point to the empty ones from the newly loaded module
  this.lookups.subtitleId=prevModule.subtitleId32ToString
  this.lookups.dataSetPath32=prevModule.path32ToDataSetName

  --tex these would be handled by PostAllModulesLoad, but I'm skipping them if doneStartup
  this.strings=prevModule.strings
  this.gameObjectNames=prevModule.gameObjectNames
  
  this.objectNameLists=prevModule.objectNameLists
  this.objectNameListsEnum=prevModule.objectNameListsEnum
end

function this.PostAllModulesLoad()
  if not InfCore.debugMode then
    return
  end

  --tex not really going to do too much runtime edit/reload, so bail out so I dont have to wait
  if InfCore.doneStartup then
    return
  end

  this.LoadStrings()

  this.BuildStr32ToString()
  this.BuildPath32ToDataSetName()

  this.AddObjectNamesToStr32List()
  this.BuildDictionaryLookup("subtitleId",this.subtitleId32ToString)

  this.LoadGameObjectNames()

  this.InitObjectLists()

  if this.debugModule then
    InfCore.PrintInspect(this.lookups,"InfLookup.lookups")
  end
end

function this.OnInitializeTop(missionTable)
  if Ivars.debugMode:Is(0) then
    return
  end
  --tex want this as early as possible (gameobjects are init sometime between allocate and oninit)
  --GOTCHA: InfLookup isn't guaranteed to be before any other modules (but currently there aren't really any other modules that do InfLookups in OnInitTop)
  this.BuildGameIdToNames()
  this.BuildSoldierSvarIndexes()--DEBUGNOW don't know at what point soldier svars are valid, TODO: find down those svar save commands (TppEnemy.StoreSVars/RestoreOn?) and log the call

  for name,module in pairs(missionTable)do
    if module.DEBUG_strCode32List then
      InfCore.Log("Adding "..tostring(name)..".DEBUG_strCode32List to strCode32List")
      this.AddToStr32StringLookup(module.DEBUG_strCode32List)
    end
  end
end

function this.Init(missionTable)
  if Ivars.debugMode:Is(0) then
    return
  end

  this.DumpUnknowns()
end

function this.DumpUnknowns()
  InfCore.Log"Dumping unknownStr32"
  --DEBUGNOW TODO also load ih_unknownStr32 into InfCore.unknownStr32 so I don't have to babysit the file over sessions and just let it accumulate
  local unknownStr={}
  for strCode,isUnknown in pairs(InfCore.unknownStr32)do
    unknownStr[#unknownStr+1]=strCode
  end
  table.sort(unknownStr)

  InfCore.WriteStringTable(InfCore.paths.mod.."ih_unknownStr32.txt",unknownStr)

  InfCore.Log"Dumping unknownMessages"
  local unknownMessages={InfInspect.Inspect(InfCore.unknownMessages)}
  InfCore.WriteStringTable(InfCore.paths.mod.."ih_unknownMessages.txt",unknownMessages)
end--DumpUnknowns

function this.Save()
  if Ivars.debugMode:Is(0) then
    return
  end

  --DEBUGNOW WIP - See this.Init
  --  if IHGenUnknownHashes then
  --    InfCore.Log("Saving IHGenUnknownHashes")
  --    local saveTextList={}
  --    saveTextList[#saveTextList+1]="--IHGenUnknownHashes.lua"
  --    saveTextList[#saveTextList+1]="--GENERATED at runtime from hashes that have no match"
  --    saveTextList[#saveTextList+1]="this={}"
  --    IvarProc.BuildTableText("unknownStr32",IHGenUnknownHashes.unknownStr32,saveTextList)
  --    IvarProc.BuildTableText("unknownMessages",IHGenUnknownHashes.unknownMessages,saveTextList)
  --    saveTextList[#saveTextList+1]="return this"
  --    InfCore.WriteStringTable(InfCore.paths.modules.."IHGenUnknownHashes.lua",saveTextList)
  --  end
end

function this.LoadStrings()
  if InfCore.filesFull.strings then
    InfCore.LogFlow("LoadStrings")
    for i,filePath in ipairs(InfCore.filesFull.strings)do
      InfCore.Log("LoadStrings "..filePath)
      local name=InfUtil.GetFileName(filePath,true)
      local extension=InfUtil.GetFileExtension(filePath)
      if extension==".txt" then
        local lines=InfCore.GetLines(filePath)
        if lines==nil then
          InfCore.Log("InfLookup LoadStrings: could not load "..name)
        else
          --InfCore.Log("Adding "..name.." to strings")
          this.strings[name]=lines
        end
      end
    end
  end
end

--lookup-tables>
function this.GenerateNameList(fmt,num,list)
  local list=list or {}
  for i=0,num-1 do
    local name=string.format(fmt,i)
    table.insert(list,name)
  end
  return list
end

--tex TODO: scrape fox2s typeName
this.gameObjectClass={
  "TppBear",
  "TppBuddyDog2",
  "TppBuddyPuppy",
  "TppBuddyQuiet2",
  "TppBossQuiet2",--tex is also sniper parasites
  "TppCodeTalker2",
  "TppCommandPost2",
  "TppCommonWalkerGear2",
  "TppCorpse",
  "TppCritterBird",
  "TppDecoySystem",
  "TppEagle",
  "TppEnemyHeli",
  "TppEspionageRadioSystem",
  "TppGoat",
  "TppJackal",
  "TppMarker2LocatorSystem",
  "TppNubian",
  "TppHeli2",
  "TppHorse2",
  "TppHostage2",
  "TppHostageKaz",
  "TppHostageUnique",
  "TppHostageUnique2",
  "TppHuey2",
  "TppLiquid2",
  "TppMantis2",
  "TppOcelot2",
  "TppOtherHeli2",
  "TppParasite2",
  "TppPlacedSystem",
  "TppPlayer2",
  "TppPlayerHorseforVr",--tex prologue volgin escape
  "TppRat",
  "TppSahalen2",
  "TppSecurityCamera2",
  "TppSkullFace2",
  "TppSoldier2",
  "TppStork",
  "TppSupplyCboxSystem",
  "TppSupportAttackSystem",
  "TppVolgin2",
  "TppVolgin2forVr",--tex prologue volgin escape
  "TppUav",
  "TppVehicle2",
  "TppWalkerGear2",
  "TppWolf",
  "TppZebra",
}

this.mbCps={
  "ly003_cl00_npc0000|cl00pl0_uq_0000_npc2|mtbs_command_cp",
  "ly003_cl01_npc0000|cl01pl0_uq_0010_npc2|mtbs_combat_cp",
  "ly003_cl02_npc0000|cl02pl0_uq_0020_npc2|mtbs_develop_cp",
  "ly003_cl03_npc0000|cl03pl0_uq_0030_npc2|mtbs_support_cp",
  "ly003_cl04_npc0000|cl04pl0_uq_0040_npc2|mtbs_medic_cp",
  "ly003_cl05_npc0000|cl05pl0_uq_0050_npc2|mtbs_intel_cp",
  "ly003_cl06_npc0000|cl06pl0_uq_0060_npc2|mtbs_basedev_cp",
}

--TABLESETUP
--tex TODO: scrape fox2s
this.objectNameLists={
  player_locator=this.GenerateNameList("player_locator_%04d",2),
  helis={"SupportHeli","EnemyHeli","WestHeli"},
  accPilot={"hos_pilot_0000"},
  charactersInPrologue={"ishmael","volgin","ocelot","ocelot_horse"},
  charactersInMb={
    "ly003_cl00_npc0000|cl00pl0_uq_0000_npc2|TppOcelot2GameObjectLocator",
    "mtbs_uq0040_plnt0000|uq_00400000|uq_0040_asset|TppPazLocator"
  },
  buddies={"BuddyDogGameObjectLocator","BuddyDogGameObjectLocator","BuddyQuietGameObjectLocator","BuddyWalkerGearGameObjectLocator",},
  characters={"TppHuey2GameObjectLocator"},
  veh_lv=this.GenerateNameList("veh_lv_%04d",20),--jeeps
  veh_trc=this.GenerateNameList("veh_trc_%04d",10),--trucks
  wkr_WalkerGear=this.GenerateNameList("wkr_WalkerGear_%04d",20),
  anml_quest=this.GenerateNameList("anml_quest_%02d",10),
  sol_quest=this.GenerateNameList("sol_quest_%04d",10),
  hos_quest=this.GenerateNameList("hos_quest_%04d",10),
  vehicle_quest=this.GenerateNameList("vehicle_quest_%04d",10),
  ih_hostage=this.GenerateNameList("ih_hostage_%04d",30),
  itm_Mine_quest=this.GenerateNameList("itm_Mine_quest_%04d",10),
  itm_revDecoy=this.GenerateNameList("itm_revDecoy_%04d",10),
  itm_revMine=this.GenerateNameList("itm_revMine_%04d",10),
  otherHeli=this.GenerateNameList("OtherHeli%04d",10),
  tppCorpseGameObjectLocator=this.GenerateNameList("TppCorpseGameObjectLocator%04d",12),--TODO VERIFY max
  pickable_ih=this.GenerateNameList("pickable_ih_%04d",20),
  pickable_quest=this.GenerateNameList("pickable_quest_%04d",20),
  mbCps=this.mbCps,
}

--tex from TppAnimalBlock animalsTable
--REF
--  Goat={type="TppGoat",locatorFormat="anml_goat_%02d",routeFormat="rt_anml_goat_%02d",nightRouteFormat="rt_anml_goat_n%02d",isHerd=true,isDead=false},
--  Wolf={type="TppWolf",locatorFormat="anml_wolf_%02d",routeFormat="rt_anml_wolf_%02d",nightRouteFormat="rt_anml_wolf_n%02d",isHerd=true,isDead=false},
--  Nubian={type="TppNubian",locatorFormat="anml_nubian_%02d",routeFormat="rt_anml_nubian_%02d",nightRouteFormat="rt_anml_nubian_n%02d",isHerd=true,isDead=false},
--  Jackal={type="TppJackal",locatorFormat="anml_jackal_%02d",routeFormat="rt_anml_jackal_%02d",nightRouteFormat="rt_anml_jackal_n%02d",isHerd=true,isDead=false},
--  Zebra={type="TppZebra",locatorFormat="anml_Zebra_%02d",routeFormat="rt_anml_Zebra_%02d",nightRouteFormat="rt_anml_Zebra_n%02d",isHerd=true,isDead=false},
--  Bear={type="TppBear",locatorFormat="anml_bear_%02d",routeFormat="rt_anml_bear_%02d",nightRouteFormat="rt_anml_bear_n%02d",isHerd=false,isDead=false},
--  BuddyPuppy={type="TppBuddyPuppy",locatorFormat="anml_BuddyPuppy_%02d",routeFormat="rt_anml_BuddyPuppy_%02d",nightRouteFormat="rt_anml_BuddyPuppy_%02d",isHerd=false,isDead=false},
--  MotherDog={type="TppJackal",locatorFormat="anml_MotherDog_%02d",routeFormat="rt_anml_BuddyPuppy_%02d",nightRouteFormat="rt_anml_BuddyPuppy_%02d",isHerd=false,isDead=true},
--  Rat={type="TppRat",locatorFormat="anml_rat_%02d",routeFormat="rt_anml_rat_%02d",nightRouteFormat="rt_anml_rat_%02d",isHerd=false,isDead=false},
--  NoAnimal={type="NoAnimal",locatorFormat="anml_NoAnimal_%02d",routeFormat="rt_anml_BuddyPuppy_%02d",nightRouteFormat="rt_anml_BuddyPuppy_%02d",isHerd=false,isDead=false}
local animalLocatorPrefixes={
  anml_goat="anml_goat_%02d",
  anml_wolf="anml_wolf_%02d",
  anml_nubian="anml_nubian_%02d",
  anml_jackal="anml_jackal_%02d",
  anml_Zebra="anml_Zebra_%02d",
  anml_bear="anml_bear_%02d",
  anml_BuddyPuppy="anml_BuddyPuppy_%02d",
  anml_MotherDog="anml_MotherDog_%02d",
  anml_rat="anml_rat_%02d",
  anml_NoAnimal="anml_NoAnimal_%02d",
}
for name,fmt in pairs(animalLocatorPrefixes)do
  this.objectNameLists[name]=this.GenerateNameList(fmt,10)
end

this.objectNameLists.mbVehicleNames={
  "veh_cl01_cl00_0000",
  "veh_cl02_cl00_0000",
  "veh_cl03_cl00_0000",
  "veh_cl04_cl00_0000",
  "veh_cl05_cl00_0000",
  "veh_cl06_cl00_0000",
  "veh_cl00_cl04_0000",
  "veh_cl00_cl02_0000",
  "veh_cl00_cl03_0000",
  "veh_cl00_cl01_0000",
  "veh_cl00_cl05_0000",
  "veh_cl00_cl06_0000",
}

this.animalIds = {
  [0]  = "Gerbil",
  [1]  = "Gerbil",
  -- ...
  [4]  = "Long-eared Hedgehog",
  [5]  = "Four-toed Hedgehog",
  [6]  = "Afghan Pika",
  [7]  = "Common Raven",
  [8]  = "Trumpeter Hornbill",
  [9]  = "Oriental Stork",
  [10] = "Black Stork",
  [11] = "Jehuty",
  [12] = "Griffon Vulture",
  [13] = "Lappet-faced Vulture",
  [14] = "Martial Eagle",
  [15] = "Cashmere Goat",
  [16] = "Cashmere Goat",
  [17] = "Cashmere Goat",
  [18] = "Cashmere Goat",
  [19] = "Cashmere Goat",
  [20] = "Cashmere Goat",
  [21] = "Cashmere Goat",
  [22] = "Cashmere Goat",
  [23] = "Karakul Sheep",
  [24] = "Karakul Sheep",
  [25] = "Karakul Sheep",
  [26] = "Karakul Sheep",
  [27] = "Karakul Sheep",
  [28] = "Karakul Sheep",
  [29] = "Karakul Sheep",
  [30] = "Karakul Sheep",
  [31] = "Nubian",
  [32] = "Nubian",
  [33] = "Nubian",
  [34] = "Nubian",
  [35] = "Nubian",
  [36] = "Nubian",
  [37] = "Nubian",
  [38] = "Nubian",
  [39] = "Nubian",
  [40] = "Nubian",
  [41] = "Nubian",
  [42] = "Nubian",
  [43] = "Nubian",
  [44] = "Nubian",
  [45] = "Nubian",
  [46] = "Nubian",
  [47] = "Boer Goat",
  [48] = "Boer Goat",
  [49] = "Boer Goat",
  [50] = "Boer Goat",
  [51] = "Boer Goat",
  [52] = "Boer Goat",
  [53] = "Boer Goat",
  [54] = "Boer Goat",
  [55] = "Boer Goat",
  [56] = "Boer Goat",
  [57] = "Boer Goat",
  [58] = "Boer Goat",
  [59] = "Boer Goat",
  [60] = "Boer Goat",
  [61] = "Boer Goat",
  [62] = "Boer Goat",
  [63] = "Wild Ass",
  [64] = "Grant's Zebra",
  [65] = "Okapi",
  [66] = "Gray Wolf",
  [67] = "African Wild Dog",
  [68] = "Side-striped Jackal",
  [69] = "Anubis",
  [70] = "Brown Bear",
  [71] = "Himalayan Brown Bear",
}

for location,cpNames in pairs(InfMain.baseNames) do
  this.objectNameLists["cpNames"..location]=cpNames
end

--CALLER: Init
function this.InitObjectLists()
  this.objectNameLists.reinforceSoldiers=TppReinforceBlock.REINFORCE_SOLDIER_NAMES
  this.objectNameLists.reinforceDriver={TppReinforceBlock.REINFORCE_DRIVER_SOLDIER_NAME}
  if InfNPCHeli then
    this.objectNameLists.ihHeliUTH=InfNPCHeli.heliNames.UTH
    this.objectNameLists.ihHeliEnemyHeli=InfNPCHeli.heliNames.EnemyHeli
  end
  if InfAnimal then
    this.objectNameLists.ihBirdNames=InfAnimal.birdNames
  end
  if InfMainTpp then
    this.objectNameLists.reserveSoldierNames=InfMainTpp.reserveSoldierNames
  end
  --tex DEBUGNOW add a AddObjectNames function
  if InfParasite then
    this.objectNameLists.parasiteARMOR=InfParasite.parasiteNames.ARMOR
    this.objectNameLists.parasiteMIST=InfParasite.parasiteNames.MIST
    this.objectNameLists.parasiteCAMO=InfParasite.parasiteNames.CAMO
  end

  if InfWalkerGear then
    this.objectNameLists.ihWalkerList=InfWalkerGear.walkerNames
  end

  if InfNPC then
    this.objectNameLists.ihHostageNames=InfNPC.hostageNames
  end

  this.BuildObjectNameListsEnum()

  if this.debugModule then
    InfCore.PrintInspect(this.objectNameListsEnum,"InfLookup.objectNameListsEnum")
    InfCore.PrintInspect(this.objectNameLists,"InfLookup.objectNameLists")
  end
end--InitObjectLists
function this.BuildObjectNameListsEnum()
  InfUtil.ClearArray(this.objectNameListsEnum)
  for k,v in pairs(this.objectNameLists)do
    table.insert(this.objectNameListsEnum,k)
  end
  table.sort(this.objectNameListsEnum)
end

--tex --CULL DEBUGNOW run onselect
--GOTCHA: would have to update enum as well
function this.RefreshObjectLists()

  --        local travelPlan="travelArea2_01"
  --         return InfVehicle.inf_patrolVehicleConvoyInfo[travelPlan]


  --tex not really dynamic/runtime but are setup after Init so cant be in InitObjectLists
  --return InfSoldier.ene_wildCardNames
  --return TppEnemy.armorSoldiers

  
end
--

function this.Time(time)
  return TppClock.FormalizeTime(time,"string")
end

--tex not exhaustive, theres still a bunch of loose ids scattered around, and a bunch only defined in EXE
function this.PopupErrorId(findErrorId)
  for errorName,errorId in pairs(TppDefine.ERROR_ID) do
    if findErrorId==errorId then
      return errorName
    end
  end
  return nil
end

--tex TODO, wont really cover all anyway, better to just use str32 table, or scrape one targeted at lz objects
this.str32LzToLz={}
function this.BuildStr32ToLzLookup()

end

function this.LandingZoneName(lzStr32)
  return InfLZ.str32LzToLz[lzStr32]
end

function this.BuildStr32ToString()
  this.str32ToString[StrCode32("")]=[[""]]
  --this.str32ToString[3205930904]=[[""]]


  for name,strings in pairs(this.strings) do
    InfCore.Log("Adding "..name.." strings to strCode32List")
    this.AddToStr32StringLookup(strings)
  end
  for i,libName in ipairs(Tpp._requireList)do
    local module=_G[libName]
    if module and module.DEBUG_strCode32List then
      InfCore.Log("Adding "..tostring(libName)..".DEBUG_strCode32List to strCode32List")
      this.AddToStr32StringLookup(module.DEBUG_strCode32List)
    end
  end
  for i,module in ipairs(InfModules)do
    if module.DEBUG_strCode32List then
      InfCore.Log("Adding "..tostring(module.name)..".DEBUG_strCode32List to strCode32List")
      this.AddToStr32StringLookup(module.DEBUG_strCode32List)
    end
  end
end

--tex TODO: more targeted?
--SIDE: this.path32ToDataSetName
function this.BuildPath32ToDataSetName()
  InfCore.Log("InfLookup.BuildPath32ToDataSetName:")
  for name,strings in pairs(this.strings) do
    for i,line in ipairs(strings)do
      local ext=InfUtil.GetFileExtension(line)
      --InfCore.Log(ext)--DEBUG
      if ext==".fox2" then
        local path32=Fox.PathFileNameCode32(line)
        this.path32ToDataSetName[path32]=line
      end
    end
  end
  --InfCore.PrintInspect(this.path32ToDataSetName,"path32ToDataSetName")--DEBUG
end

--tex gives {[gameClass.Enum]=enum name}
function this.BuildGameClassEnumNameLookup(gameClassName,enumNames)
  InfCore.LogFlow("InfLookup.BuildGameClassEnumNameLookup: "..gameClassName)

  local gameClass=_G[gameClassName]

  if gameClass==nil then
    InfCore.Log("WARNING: InfLookup.BuildGameClassEnumNameLookup: gameclass "..gameClassName.." == nil")
    return
  end

  local enumNameLookup={}
  for i,name in ipairs(enumNames) do
    local enum=gameClass[name]
    if enum then
      if enumNameLookup[enum] then
        if this.debugModule then
          InfCore.Log("WARNING: InfLookup.BuildGameClassEnumNameLookup "..name.." with enum "..enum.." is same as ".. enumNameLookup[enum])--DEBUG
        end
        enumNameLookup[enum]=enumNameLookup[enum].."||"..name
      else
        enumNameLookup[enum]=name
      end
    else
      InfCore.Log("WARNING: InfLookup.BuildGameClassEnumNameLookup: could not find enum "..tostring(name))
    end
  end
  if #enumNameLookup==0 then
    InfCore.Log("WARNING: InfLookup.BuildGameClassEnumNameLookup: "..gameClassName.." #enumNameLookup==0")
  end
  return enumNameLookup
end

--tex assumes gameclass has lua readable enum names like TppDamage, and not whatever index fancyness gameclasses like ScritBlock do
--GOTCHA: filter is exact match prefix, ie must match from start of string
function this.BuildDirectGameClassEnumLookup(gameClassName,filter,exclude)
  InfCore.LogFlow("InfLookup.BuildGameClassEnumNameLookup: "..gameClassName.." "..tostring(filter))

  local gameClass=_G[gameClassName]

  --tex WORKAROUND autodoc/mock
  if gameClass==nil then
    InfCore.Log("WARNING: InfLookup.BuildGameClassEnumNameLookup: gameClass "..gameClassName.."==nil")
    return {}
  end

  local enumToName={}
  for k,v in pairs(gameClass)do
    if type(v)=="number" then
      local doExclude=false
      if type(exclude)=="table"then
        for i,excludeStr in ipairs(exclude)do
          if string.find(k,excludeStr)~=nil then
            doExclude=true
          end
        end
      elseif type(exclude)=="string"then
        if string.find(k,exclude)~=nil then
          doExclude=true
        end
      end
    
      if string.find(k,filter)==1 and not doExclude then
        if enumToName[v] then
          InfCore.Log("WARNING: InfLookup.BuildDirectGameClassEnumLookup: "..k.." with enum "..v.." is same as ".. enumToName[v])--DEBUG
          enumToName[v]=enumToName[v].."|"..k
        else
          enumToName[v]=k
        end
      end
    end
  end
  if #enumToName==0 then
    InfCore.Log("WARNING: InfLookup.BuildGameClassEnumNameLookup: gameClass "..gameClassName.." "..filter.." #enumToName==0")
  end
  return enumToName
end

--tex there's no real lookup for this I've found
--there's probably faster tables (look in DefineSoldiers()) that have the cpId>soldierId, but this is nice for the soldiername,cpname
function this.ObjectNameForGameIdList(findId,list,objectType)
  for n,name in ipairs(list)do
    local gameId=NULL_ID
    if objectType then
      gameId=InfCore.GetGameObjectId(objectType,name)
    else
      gameId=InfCore.GetGameObjectId(name)
    end
    if gameId~=NULL_ID then
      if gameId==findId then
        return name
      end
    end
  end
end
--returns name or nil

function this.ObjectNameForGameId(findId,objectType)
  if findId==0 then
    return "Player"--ASSUMPTION -- player instance 0, single player/local player
  end
  if findId==1 then
    return "Player instance 1"--ASSUMPTION, fob defender (if local is server)
  end

  --tex == 65535
  if findId==NULL_ID then
    return "NULL_ID"
  end

  local lookupName=InfCore.gameIdToName[findId]
  if lookupName then
    return lookupName
  end

  if not objectType or objectType=="TppSoldier2" then
    --tex TODO: build lookup
    if mvars.ene_soldierDefine then
      for cpName,cpDefine in pairs(mvars.ene_soldierDefine)do
        local objectName=this.ObjectNameForGameIdList(findId,cpDefine,"TppSoldier2")
        if objectName then
          return objectName
        end
      end
    end
  end

  --tex alread added in BuildGameIdToNames, but quest objects wont have been loaded at that point
  for listName,list in pairs(this.objectNameLists) do
    local objectName
    --tex {{nameList},"objectType"}
    if type(list[1])=="table" then
      if not objectType or objectType==list[2] then
        objectName=this.ObjectNameForGameIdList(findId,list[1],list[2])
      end
    else
      objectName=this.ObjectNameForGameIdList(findId,list)
    end
    if objectName then
      return objectName
    end
  end

  --too killer on performance to do frequencly, TODO enable on a switch
  --  if IHStringsGameObjectNames then
  --    local module=IHStringsGameObjectNames
  --    if module.lookupStrings then
  --      local objectName=this.ObjectNameForGameIdList(findId,module.lookupStrings)
  --      if objectName then
  --        return objectName
  --      end
  --    end
  --  end
  --nuclear option, try str32 lists
  --  for i,module in ipairs(InfModules) do
  --    if module.lookupStrings then
  --      local objectName=this.ObjectNameForGameIdList(findId,module.lookupStrings)
  --      if objectName then
  --        return objectName
  --      end
  --    end
  --  end

  return nil
end

function this.GameObjectNameForGimmickId(gimmickId)
  if mvars.gim_identifierParamTable==nil then
    return "WARNING: mvars.gim_identifierParamTable==nil"
  end
  local ret,gameId=TppGimmick.GetGameObjectId(gimmickId)
  return this.ObjectNameForGameId(gameId)
end

function this.CpNameForCpId(cpId)
  if cpId==nil then
    return 'nil'
  end

  if cpId==NULL_ID then
    return 'NULL_ID'
  end

  local cpName
  if mvars.ene_cpList then
    cpName=mvars.ene_cpList[cpId]
  end
  if cpName==nil then
    if TppLocation.GetLocationName()=="mtbs" then
      local clusterId=MotherBaseStage.GetCurrentCluster()
      local cpName=this.mbCps[clusterId]
      local gameId=GetGameObjectId("TppCommandPost2",cpName)
      if cpId==gameId then
        return cpName
      end
      cpName=this.ObjectNameForGameIdList(cpId,this.mbCps,"TppCommandPost2")
    end
  end
  if cpName==nil then
    InfCore.Log("WARNING: InfLookup.CpNameForCpId "..cpId..":could not find cpName in lists")
    return this.ObjectNameForGameId(cpId)
  end
  return cpName
end--CpNameForCpId
function this.SoldierSvarIndexForName(soldierName)
  local s32Name=StrCode32(soldierName)
  local svarIndex=this.soldierSvarIndexes[s32Name]
  --DEBUGNOW TODO check out of bounds?
  if svars.solName[svarIndex]~=s32Name then
    InfCore.Log("WARNING: InfLookup.SoldierSvarIndexForName: soldierSvarIndexes index for "..soldierName.."/"..s32Name.." does not match svars index")--DEBUGNOW
    --DEBUGNOW TODO: not picking up quest soldiers for some reason, either: I'm doing something wrong, or they're flagged no to save?
    for i=0,mvars.ene_maxSoldierStateCount-1 do
      if svars.solName[i]==s32Name then
        return i
      end
    end

    return nil
  end
  return svarIndex
end

--TABLESETUP
function this.AddToStr32StringLookup(strCode32List)
  for i,someString in ipairs(strCode32List)do
    this.str32ToString[StrCode32(someString)]=someString
  end
end

--tex returns matching string or the input strCode if no string found
--lookup filled by mod\strings, and uses of InfCore.StrCode32
--isStrCode on guaranteed strcodes to add that code to unknowns (this function is also used in a blanket fashion in PrintOnMessage with potential non-strcodes)
function this.StrCode32ToString(strCode,isStrCode)
  if strCode==nil then
    return 'nil'
  end

  if type(strCode)=="number" then
    --tex using InfCore since this is built up using Fox.StrCode32 replacement InfCore.StrCode32, since InfCore is loaded before lib modules
    local returnString=InfCore.str32ToString[strCode]
    if returnString==nil then
      returnString=this.str32ToString[strCode]
      if returnString then
        InfCore.str32ToString[strCode]=returnString--tex push back into InfCore str32ToString so I can dump that as a verified in-use dictionary
      end
    end
    if isStrCode and returnString==nil then
      InfCore.unknownStr32[strCode]=true
    end
    if returnString==nil then
      return strCode
    end

    if type(returnString)=="number" then
      InfCore.Log("WARNING: InfLookup.StrCode32ToString: returnString for strCode:"..strCode.." is a number: "..returnString)
    end

    return returnString
  else
    InfCore.Log("WARNING: InfLookup.StrCode32ToString: strCode:"..tostring(strCode).." is not a number.")
  end
  return tostring(strCode)
end--StrCode32ToString
--tex returns string or pathCode32
--isPathCode on guaranteed strcodes to add that code to unknowns (this function is also used in a blanket fashion in PrintOnMessage with potential non-strcodes)
function this.PathCode32ToString(pathCode,isPathCode)
  if pathCode==nil then
    return 'nil'
  end

  if type(pathCode)=="number" then
    --tex using InfCore since this is built up using Fox.StrCode32 replacement InfCore.StrCode32, since InfCore is loaded before lib modules
    local returnString=InfCore.path32ToString[pathCode]
    if returnString==nil then
      returnString=this.path32ToString[pathCode]
      if returnString then
        InfCore.path32ToString[pathCode]=returnString--tex push back into InfCore str32ToString so I can dump that as a verified in-use dictionary
      end
    end
    if isPathCode and returnString==nil then
      InfCore.unknownPath32[pathCode]=true
    end
    if returnString==nil then
      return pathCode
    end

    if type(returnString)=="number" then
      InfCore.Log("WARNING: InfLookup.PathCode32ToString: returnString for strCode:"..pathCode.." is a number: "..returnString)
    end

    return returnString
  else
    InfCore.Log("WARNING: InfLookup.PathCode32ToString: strCode:"..tostring(pathCode).." is not a number.")
  end
  return tostring(pathCode)
end--StrCode32ToString
function this.DumpStrCodeTables()
  InfCore.Log("InfCore.str32ToString")
  --InfCore.PrintInspect(InfCore.str32ToString)

  local strings={}
  local strToCode={}
  for strCode,str in pairs(InfCore.str32ToString)do
    table.insert(strings,str)
    strToCode[str]=strCode
  end
  table.sort(strings)
  for i,str in ipairs(strings) do
    InfCore.Log(str.."="..strToCode[str])
  end

  InfCore.PrintInspect(InfCore.unknownStr32,{varName="InfCore.unknownStr32"})
end

function this.GenericFlagWrangler(flag,flags)
  local flagsStatus={}
  for bitFlag,flagName in pairs(flags)do
    flagsStatus[bitFlag]=false
    if flag ~= nil and bit.band(flag,bitFlag)==bitFlag then
      flagsStatus[bitFlag]=true
    end
  end
  local flagsStr="|"
  for bitFlag,flagSet in pairs(flagsStatus)do
    flagsStr=flagsStr..flags[bitFlag].."="..tostring(flagSet).."|"
  end
  return flagsStr
end

--game class lookups
this.HeadshotMessageFlag={
  headshotMessageFlag=this.BuildGameClassEnumNameLookup("HeadshotMessageFlag",
    {--are bitflags,
      "NONE", --0
      "IS_TRANQ_HANDGUN",--1
      "IS_JUST_UNCONSCIOUS",--2
      "NEUTRALIZE_DONE",--4
    }
  ),
}

this.HeadshotMessageFlag.headshotMessageFlags=function(flag)
  return this.GenericFlagWrangler(flag, this.HeadshotMessageFlag.headshotMessageFlag)
end

this.DamageMessageFlag={
  damageMessageFlag=this.BuildGameClassEnumNameLookup("DamageMessageFlag",
    {--are bitflags, sorta
      "NONE", --0
      "IS_BULLET_HIT_ARMOR", --1
      "BROKEN_HELMET", --2
      "IS_LIFE_DAMAGE", --4
    }
  ),
}

this.DamageMessageFlag.damageMessageFlags=function(flag)
  return this.GenericFlagWrangler(flag, this.DamageMessageFlag.damageMessageFlag)
end

this.DeadMessageFlag={
  deadMessageFlag=this.BuildGameClassEnumNameLookup("DeadMessageFlag",
    {--are bitflags, sorta
      "NONE",--0
      "FIRE",--1
      -- "DYING",--2
      "FIRE_OR_DYING", --3
      "NOT_DAMAGE_DEAD", --4
      "INDIRECTLY_TARGET", --8
      "FROM_PLAYER_ORDER", --16
    }
  ),
}

--tex outputs all flag states for the bitflag value
this.DeadMessageFlag.deadMessageFlags=function(flag)
  return this.GenericFlagWrangler(flag, this.DeadMessageFlag.deadMessageFlag)
end

this.BulletGuardArmorMessageFlag={
  bulletGuardArmorMessageFlag=this.BuildGameClassEnumNameLookup("BulletGuardArmorMessageFlag",
    {--are bitflags, sorta
      "NONE", --0
      "IS_HIT_ARMOR", --1
      "BROKEN_HELMET", --2
    }
  ),
}

--tex outputs all flag states for the bitflag value
this.BulletGuardArmorMessageFlag.bulletGuardArmorMessageFlags=function(flag)
  return this.GenericFlagWrangler(flag, this.BulletGuardArmorMessageFlag.bulletGuardArmorMessageFlag)
end

local function DumpFlagBinSeq(flag)
  local flags = {}

  local i, testval = 0, 0
  local outstr = ""
  if flag ~= nil then
    repeat
      testval = 2^i
      local prependval = "0"
      if bit.band(flag, testval) == testval then
        prependval = "1"
      end
      i = i + 1
      outstr = prependval .. outstr
    until(testval > flag)
  end

  return "b"..outstr
end

local function DumpFlags(flag)
  local flags = {}

  local i, testval = 0, 0
  if flag ~= nil then
    repeat
      testval = 2^i
      if bit.band(flag, testval) == testval then
        flags[i] = testval
      end
      i = i + 1
    until(testval > flag)
  end

  return flags
end

local function DumpFlagsString(flags)
  local flagsStr="|"
  for index, value in pairs(flags)do
    flagsStr=flagsStr..tostring(index).."="..tostring(value).."|"
  end
  return flagsStr
end

this.NeutralizeCause={
  --TODO: at lease one missing (gap in consecurive enum)
  --22 missing, trigger by doing holdup, or fultoning walker?
  neutralizeCause=this.BuildGameClassEnumNameLookup("NeutralizeCause",
    {
      "CQC",
      "NO_KILL",
      "NO_KILL_BULLET",
      "CQC_KNIFE",
      "HANDGUN",
      "SUBMACHINE_GUN",
      "SHOTGUN",
      "ASSAULT_RIFLE",
      "MACHINE_GUN",
      "SNIPER_RIFLE",
      "GRENADE",
      "MINE",
      "QUIET",
      "D_DOG",
      "D_HORSE",
      "D_WALKER_GEAR",
      "VEHICLE",
      "SUPPORT_HELI",
      "ASSIST",
      "ROCKET_ARM",
      "GIMMICK",
    }
  ),
}

this.NeutralizeFobCause={
  --TODO: at lease two missing (gaps in consecurive enum)
  neutralizeFobCause=this.BuildGameClassEnumNameLookup("NeutralizeFobCause",
    {
      "CQC",
      "CQC_KNIFE",
      "HANDGUN",
      "SUBMACHINE_GUN",
      "SHOTGUN",
      "ASSAULT_RIFLE",
      "MACHINE_GUN",
      "SNIPER_RIFLE",
      "QUIET",
      "D_DOG",
      "D_HORSE",
      "D_WALKER_GEAR",
      "VEHICLE",
      "ASSIST",
      "ROCKET_ARM",
      "GRENADER",
      "ANTIMATERIAL_RIFLE",
      "THROWING",
      "PLACED",
      "BOSS",
      "TURRET",
      "ANTI_AIR",
      "MORTAR",
      "HELI_MINI_GUN",
    }
  ),
}

this.NeutralizeType={
  neutralizeType=this.BuildGameClassEnumNameLookup("NeutralizeType",
    {"INVALID","FAINT","SLEEP","DYING","HOLDUP","FULTON"}
  ),
}

this.ScriptBlock={
  scriptBlockState=this.BuildGameClassEnumNameLookup("ScriptBlock",
    {
      "SCRIPT_BLOCK_STATE_EMPTY",
      "SCRIPT_BLOCK_STATE_PROCESSING",
      "SCRIPT_BLOCK_STATE_INACTIVE",
      "SCRIPT_BLOCK_STATE_ACTIVE",
    }
  ),
  scriptBlockStateTransition=this.BuildGameClassEnumNameLookup("ScriptBlock",
    {
      "TRANSITION_LOADED",
      "TRANSITION_ACTIVATED",
      "TRANSITION_DEACTIVATED",
      "TRANSITION_EMPTIED",
    }
  ),
}

this.StageBlock={
  stageBlockState=this.BuildGameClassEnumNameLookup("StageBlock",
    {
      "INACTIVE",
      "ACTIVE",
    }
  ),
}

this.TppCollection={
  resourceType=this.BuildDirectGameClassEnumLookup("TppCollection","TYPE_"),
}

this.TppDamage={
  attackId=this.BuildDirectGameClassEnumLookup("TppDamage","ATK_"),
  damageSource=this.BuildDirectGameClassEnumLookup("TppDamage","DAM_SOURCE_"),
  injuryType=this.BuildDirectGameClassEnumLookup("TppDamage","INJ_TYPE_"),
}

this.tppEquipPrefix={  
  equipId="EQP",--tex couple of exceptions for just using this prefix, EQP_TYPE_, EQP_BLOCK_ trample on some equipIds, and EQP_ also includes some of the following prefixes
  supportWeapon="SWP",
  weaponId="WP",
  --tex in chimera parts order
  reciever="RC",
  barrel="BA",
  ammo="AM",--'Magazine'
  stock="SK",
  muzzle="MZ",
  muzzleOption="MO",--'muzzle accessory'
  rearSight="ST",--'Optics 1'
  frontSight="ST",--'Optics 2'
  option1="LT",--'Flashlight'
  option2="LS",--'Laser Sight
  underBarrel="UB",
  underBarrelAmmo="AM",
  --alts
  weapon="WP",
  magazine="AM",
  sight="ST",
  flashLight="LT",
  laserSight="LS",
  
  blast="BLA",
  bullet="BL",
}--tppEquipPrefix

this.TppEquip={
  equipId=this.BuildDirectGameClassEnumLookup("TppEquip","EQP_",{"EQP_TYPE","EQP_BLOCK"}),--tex TYPE and BLOCK trample on equipIds so exclude them 
  equipType=this.BuildDirectGameClassEnumLookup("TppEquip","EQP_TYPE_"),
}
--DEBUGNOW TODO: only build most lookups if debug mode
for id,prefix in pairs(this.tppEquipPrefix)do
  if not this.TppEquip[id]then
     this.TppEquip[id]=this.BuildDirectGameClassEnumLookup("TppEquip",prefix.."_","EQP_")--tex EQP includes some of the specific types so exclude it
  end
end
if this.debugModule then
  InfCore.PrintInspect(this.TppEquip,"this.TppEquip")--DEBUG
end

--DEBUG >
--InfCore.Log("Iterate TppGameObject")
--for k,v in pairs(TppGameObject) do
--  InfCore.Log(tostring(k)..","..tostring(v))
--end
--InfCore.Log("Inspect TppGameObject")
--InfCore.PrintInspect(TppGameObject)
--<

--tex in exe order
local gameObjectTypes={
  "GAME_OBJECT_TYPE_PLAYER2",--0
  "GAME_OBJECT_TYPE_COMMAND_POST2",
  "GAME_OBJECT_TYPE_SOLDIER2",
  "GAME_OBJECT_TYPE_HOSTAGE2",
  "GAME_OBJECT_TYPE_HOSTAGE_UNIQUE",
  "GAME_OBJECT_TYPE_HOSTAGE_UNIQUE2",
  "GAME_OBJECT_TYPE_HOSTAGE_KAZ",
  "GAME_OBJECT_TYPE_OCELOT2",
  "GAME_OBJECT_TYPE_HUEY2",
  "GAME_OBJECT_TYPE_CODE_TALKER2",
  "GAME_OBJECT_TYPE_SKULL_FACE2",
  "GAME_OBJECT_TYPE_MANTIS2",
  "GAME_OBJECT_TYPE_BIRD2",
  "GAME_OBJECT_TYPE_HORSE2",
  "GAME_OBJECT_TYPE_HELI2",
  "GAME_OBJECT_TYPE_ENEMY_HELI",
  "GAME_OBJECT_TYPE_OTHER_HELI",
  "GAME_OBJECT_TYPE_OTHER_HELI2",
  "GAME_OBJECT_TYPE_BUDDYQUIET2",
  "GAME_OBJECT_TYPE_BUDDYDOG2",
  "GAME_OBJECT_TYPE_BUDDYPUPPY",
  "GAME_OBJECT_TYPE_SAHELAN2",
  "GAME_OBJECT_TYPE_PARASITE2",
  "GAME_OBJECT_TYPE_LIQUID2",
  "GAME_OBJECT_TYPE_VOLGIN2",
  "GAME_OBJECT_TYPE_BOSSQUIET2",
  "GAME_OBJECT_TYPE_UAV",
  "GAME_OBJECT_TYPE_SECURITYCAMERA2",
  "GAME_OBJECT_TYPE_GOAT",
  "GAME_OBJECT_TYPE_NUBIAN",
  "GAME_OBJECT_TYPE_CRITTER_BIRD",
  "GAME_OBJECT_TYPE_STORK",
  "GAME_OBJECT_TYPE_EAGLE",
  "GAME_OBJECT_TYPE_RAT",
  "GAME_OBJECT_TYPE_ZEBRA",
  "GAME_OBJECT_TYPE_WOLF",
  "GAME_OBJECT_TYPE_JACKAL",
  "GAME_OBJECT_TYPE_BEAR",
  "GAME_OBJECT_TYPE_CORPSE",
  "GAME_OBJECT_TYPE_MBQUIET",
  "GAME_OBJECT_TYPE_COMMON_HORSE2",
  "GAME_OBJECT_TYPE_HORSE2_FOR_VR",
  "GAME_OBJECT_TYPE_PLAYER_HORSE2_FOR_VR",
  "GAME_OBJECT_TYPE_VOLGIN2_FOR_VR",
  "GAME_OBJECT_TYPE_WALKERGEAR2",
  "GAME_OBJECT_TYPE_COMMON_WALKERGEAR2",
  "GAME_OBJECT_TYPE_BATTLEGEAR",
  "GAME_OBJECT_TYPE_EXAMPLE",
  "GAME_OBJECT_TYPE_SAMPLE_GAME_OBJECT",
  "GAME_OBJECT_TYPE_NOTICE_OBJECT",
  "GAME_OBJECT_TYPE_VEHICLE",
  "GAME_OBJECT_TYPE_MOTHER_BASE_CONTAINER",
  "GAME_OBJECT_TYPE_EQUIP_SYSTEM",
  "GAME_OBJECT_TYPE_PICKABLE_SYSTEM",
  "GAME_OBJECT_TYPE_COLLECTION_SYSTEM",
  "GAME_OBJECT_TYPE_THROWING_SYSTEM",
  "GAME_OBJECT_TYPE_PLACED_SYSTEM",
  "GAME_OBJECT_TYPE_SHELL_SYSTEM",
  "GAME_OBJECT_TYPE_BULLET_SYSTEM3",
  "GAME_OBJECT_TYPE_CASING_SYSTEM",
  "GAME_OBJECT_TYPE_FULTON",
  "GAME_OBJECT_TYPE_BALLOON_SYSTEM",
  "GAME_OBJECT_TYPE_PARACHUTE_SYSTEM",
  "GAME_OBJECT_TYPE_SUPPLY_CBOX",
  "GAME_OBJECT_TYPE_SUPPORT_ATTACK",
  "GAME_OBJECT_TYPE_RANGE_ATTACK",
  "GAME_OBJECT_TYPE_CBOX",
  "GAME_OBJECT_TYPE_OBSTRUCTION_SYSTEM",
  "GAME_OBJECT_TYPE_DECOY_SYSTEM",
  "GAME_OBJECT_TYPE_CAPTURECAGE_SYSTEM",
  "GAME_OBJECT_TYPE_DUNG_SYSTEM",
  "GAME_OBJECT_TYPE_MARKER2_LOCATOR",
  "GAME_OBJECT_TYPE_ESPIONAGE_RADIO",
  "GAME_OBJECT_TYPE_MGO_ACTOR",
  "GAME_OBJECT_TYPE_FOB_GAME_DAEMON",
  "GAME_OBJECT_TYPE_SYSTEM_RECEIVER",
  "GAME_OBJECT_TYPE_SEARCHLIGHT",
  "GAME_OBJECT_TYPE_FULTONABLE_CONTAINER",
  "GAME_OBJECT_TYPE_GARBAGEBOX",
  "GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE",
  "GAME_OBJECT_TYPE_GATLINGGUN",
  "GAME_OBJECT_TYPE_MORTAR",
  "GAME_OBJECT_TYPE_MACHINEGUN",
  "GAME_OBJECT_TYPE_DOOR",
  "GAME_OBJECT_TYPE_WATCH_TOWER",
  "GAME_OBJECT_TYPE_TOILET",
  "GAME_OBJECT_TYPE_ESPIONAGEBOX",
  "GAME_OBJECT_TYPE_IR_SENSOR",
  "GAME_OBJECT_TYPE_EVENT_ANIMATION",
  "GAME_OBJECT_TYPE_BRIDGE",
  "GAME_OBJECT_TYPE_WATER_TOWER",
  "GAME_OBJECT_TYPE_RADIO_CASSETTE",
  "GAME_OBJECT_TYPE_POI_SYSTEM",
  "GAME_OBJECT_TYPE_SAMPLE_MANAGER",--93
}--gameObjectTypes

this.TppGameObject={
  --tex: no go, TppGameObject seems to have more dynamic indexing funkyness
  --  typeIndex=this.BuildDirectGameClassEnumLookup("TppGameObject","GAME_OBJECT_TYPE_"),
  --  routeEventFailedType=this.BuildDirectGameClassEnumLookup("TppGameObject","ROUTE_EVENT_FAILED_TYPE_"),

  phase=this.BuildGameClassEnumNameLookup("TppGameObject",
    {
      "PHASE_SNEAK",
      "PHASE_CAUTION",
      "PHASE_EVASION",
      "PHASE_ALERT",
    }
  ),
  routeEventFailedType=this.BuildGameClassEnumNameLookup("TppGameObject",
    {
      "ROUTE_EVENT_FAILED_TYPE_NONE",
      "ROUTE_EVENT_FAILED_TYPE_VEHICLE_GET_IN",
      "ROUTE_EVENT_FAILED_TYPE_WALKER_GEAR_GET_IN",
      "ROUTE_EVENT_FAILED_TYPE_PICK_UP_HONEY_BEE",
      "ROUTE_EVENT_FAILED_TYPE_LOST_HOSTAGE_PUT_IN_VEHICLE",
      "ROUTE_EVENT_FAILED_TYPE_LOST_HOSTAGE_TAKE_OUT_OF_VEHICLE",
      "ROUTE_EVENT_FAILED_TYPE_LOST_VEHICLE_HOSTAGE_PUT_IN",
      "ROUTE_EVENT_FAILED_TYPE_LOST_VEHICLE_HOSTAGE_TAKE_OUT_OF",
    }
  ),
  vehicleActionType=this.BuildGameClassEnumNameLookup("TppGameObject",
    {
      "VEHICLE_ACTION_TYPE_GOT_IN_VEHICLE",
      "VEHICLE_ACTION_TYPE_GOT_OUT_VEHICLE",
      "VEHICLE_ACTION_TYPE_FELL_OFF_VEHICLE",
    }
  ),

  typeIndex=this.BuildGameClassEnumNameLookup("TppGameObject",gameObjectTypes),
}

this.TppSystem={
  bgmPhase=this.BuildGameClassEnumNameLookup("TppSystem",
    {
      --tex actual enum order, from 0
      "BGM_PHASE_NONE",
      "BGM_PHASE_SNEAK_1",
      "BGM_PHASE_SNEAK_2",
      "BGM_PHASE_SNEAK_3",
      "BGM_PHASE_CAUTION",
      "BGM_PHASE_EVASION",
      "BGM_PHASE_ALERT",
      "BGM_PHASE_ALERT_BATTLE",
      "BGM_PHASE_ALERT_CP",
      "BGM_PHASE_ALERT_REINFORCE",
      "BGM_PHASE_ALERT_LOST",
    }
  ),
}

--< game classes

--TppDefine.WEATHER
this.weatherTypeNames={
  [0]="SUNNY",
  [1]="CLOUDY",
  [2]="RAINY",
  [3]="SANDSTORM",
  [4]="FOGGY",
  [5]="POURING",
}

local gameClasses={
  "BulletGuardArmorMessageFlag",
  "DamageMessageFlag",
  "DeadMessageFlag",
  "HeadshotMessageFlag",
  "NeutralizeCause",
  "NeutralizeFobCause",
  "NeutralizeType",
  "ScriptBlock",
  "StageBlock",
  "TppCollection",
  "TppDamage",
  "TppEquip",
  "TppGameObject",
  "TppSystem",
}

--tex player carry soldier/hostage
this.carryState={
  [0]="START",--going through pick up animation
  [1]="END",--dropped/thrown
  [2]="CARRYING",
}

-- ej stuff I found
this.radioTargets={
  -- [Decoy] ?
  -- ...
  [3]  = "Heavy Machine Gun [Gun Emplacement]",
  [4]  = "Mortar Launcher [Mortar]",
  [5]  = "Anti-Aircraft Gun [Anti-Air Cannon]",
  [6]  = "Communications Equipment [Transmitter]",
  [7]  = "Power Generator (Outdoors)",
  [8]  = "Power Generator (GZ)",
  [9]  = "Communications Radar [Antenna]",
  -- ...
  [11] = "Searchlight",
  [12] = "Surveillance Camera [Surveillance Camera]",
  [13] = "Target Container (Code Talker's Materials) [Container]",
  -- ...
  [15] = "IR-Sensors",
  [16] = "PF Soldier / Child Soldier", -- from Mission 22: RETAKE THE PLATFORM
  [17] = "Anti-Air Radar",
  [18] = "Dumpster [Dumpster]",
  [19] = "Metal Drum (Explosive)",
  [20] = "Portable Toilet [Toilet]",
  [21] = "Skull Soldier", -- Quiet / Skull Sniper / Armor Skull ",
  -- ...
  [23] = "Anti-Theft Device / Alarm Trigger",
  [24] = "Temporary Shower Unit [Shower]", -- from Over the Fence
  [25] = "Gun Camera [Gun Camera]",
  [26] = "UAV [UAV]", -- from YELLOW ASSET
  [27] = "Military Four-Wheel Drive [Four-Wheel Drive]",
  [28] = "Military Truck [Truck]",
  [29] = "Armored Vehicle (APC) [Armored Vehicle]",
  [30] = "Tank",
  [31] = "Walker Gear (Empty) [Walker Gear]",
  [32] = "Walker Gear (Manned) [Walker Gear]",
  [33] = "CFA Soldier [CFA Soldier]",
  [34] = "Rogue Coyote Soldier [Rogue Coyote Soldier]",
  [35] = "Zero Risk Security Soldier [ZRS Soldier]",
  [36] = "XOF Soldier [XOF Soldier]",
  [37] = "Puppet Soldier [Puppet Soldier]",
  -- ...
  [40] = "Gerbil", -- animal
  [41] = "Long-eared Hedgehog [Rodent]", --animal
  [42] = "Four-toed Hedgehog [Rodent]", -- [TBD, NEVER HAS FUNCTIONAL RADIO?]
  [43] = "Afghan Pika [Rabbit]", -- animal
  [44] = "Raven [Bird]", -- animal
  [45] = "Trumpeter Hornbill [Bird]", -- animal
  [46] = "Oriental Stork [Bird]", -- animal [TBD, NEVER HAS FUNCTIONAL RADIO]
  [47] = "Black Stork [Bird]", -- animal
  [48] = "Jehuty [Jehuty]", -- animal
  [49] = "Griffon Vulture [Bird]", -- animal
  [50] = "Lappet-faced Vulture [Bird]", -- animal
  [51] = "Martial Eagle [Bird]", --animal
  [52] = "Cashmere Goat [Goat]", -- animal
  [53] = "Karakul Sheep [Sheep]", -- animal
  [54] = "Nubian Goat [Goat]", -- animal
  [55] = "Boer Goat [Goat]", -- animal
  [56] = "Wild Ass [Donkey]", -- animal
  [57] = "Zebra [Horse]", -- animal
  [58] = "Okapi [Okapi]", -- animal
  [59] = "Gray Wolf [Wolf]", --animal
  [60] = "African Wild Dog [Wolf]", --animal
  [61] = "Side-striped Jackal [Jackal]", --animal
  [62] = "Anubis [Anubis]", --animal
  [63] = "Brown Bear [Bear]", --animal
  [64] = "Himalayian Brown Bear [Himalayian Brown Bear]", --animal
  [65] = "Soviet Soldier [Soviet Soldier]",
  -- ...
  [4294967295] = "Invalid", -- should be "-1", usually set by some sort of override
}

this.supportStrikes = {
  [1] = "BOMBARDMENT",
  [2] = "SMOKE",
  [3] = "SLEEP",
  [4] = "CHAFF",
  [5] = "WEATHER_MODIFICATION",
}

this.gradeIds = {
  [0] = "GRADE_G",
  [1] = "GRADE_F",
  [2] = "GRADE_E",
  [3] = "GRADE_D",
  [4] = "GRADE_C",
  [5] = "GRADE_B",
  [6] = "GRADE_A",
  [7] = "GRADE_S",
}

this.staffTabIds = {
   [0] = "Waiting Room",
   [1] = "Combat Unit",
   [2] = "R&D Team",
   [3] = "Base Development Unit",
   [4] = "Support Unit",
   [5] = "Intel Unit",
   [6] = "Medical Team",
   [7] = "Security Team",
   [8] = "Sickbay",
   [9] = "Brig",
-- ...
  [12] = "All Staff",
  [13] = "KIA/Former",
-- ...
  [15] = "Brig (FOB)"
-- ... ?
}

this.creditLocations = {
  "LeftCenter",
  "Center",
  "CenterLarge",
  "RightCenter",
}

--tex simplified lookup name to lookup table or function
this.lookups={
  str32=this.StrCode32ToString,
  gameId=this.ObjectNameForGameId,
  cpId=this.CpNameForCpId,
  time=this.Time,
  weatherType=this.weatherTypeNames,
  popupId=this.PopupErrorId,
  --landingZone=this.LandingZoneName,--tex not complete, use str32 instead
  carryState=this.carryState,
  gimmickId=this.GameObjectNameForGimmickId,
  subtitleId=this.subtitleId32ToString,
  dataSetPath32=this.path32ToDataSetName,
  radioTargetId=this.radioTargets,
  supportStrikeId=this.supportStrikes,
  gradeId=this.gradeIds,
  staffTabId=this.staffTabIds,
  boolAsNumber={[0]="false",[1]="true"},
  genericFlags=function(n) return DumpFlagsString(DumpFlags(n)) end,
  binaryFlags=DumpFlagBinSeq,
  gimmickInstanceOrAnimalId=function(val)
    if val == nil then
      return nil
    end
    if val == NULL_ID then
      -- we abducted a human
      return "NULL_ID"
    elseif val < NULL_ID then
      if this.animalIds[val] ~= nil then
        -- TODO: if this.animalIds == 0 it is a chance it is a vehicle for some reason as well
        -- unfortunately most gerbils are fucking 
        return this.animalIds[val]
      end
    elseif val > NULL_ID then
      -- presume this is 
      return this.StrCode32ToString(val)
    end
  end,
  staffIdOrResourceId=function(val)
    if val ~= nil and val > 0 then
      return this.StrCode32ToString(val)
    end
  end,
}
--tex crushes down this[gameclass][lookup] to lookups[lookup] - ex this.lookups.phase=TppGameObject.phase
for i,gameClass in ipairs(gameClasses)do
  for lookupType,lookup in pairs(this[gameClass])do
    this.lookups[lookupType]=lookup
  end
end

function this.Lookup(lookupType,value)
  --tex Handled elsewhere
  if lookupType=="guess"then
    return nil
  end

  local lookedupValue=nil
  local lookup=this.lookups[lookupType]
  if type(lookup)=="function" then
    lookedupValue=lookup(value)
  elseif type(lookup)=="table" then
    lookedupValue=lookup[value]
  else
    if lookupType~="number" then
      InfCore.Log("WARNING: InfLookup.Lookup: no lookup of type "..lookupType)
    elseif lookupType == nil then
      InfCore.Log("WARNING: InfLookup.Lookup: lookupType was nil for "..value)
    end
  end
  return lookedupValue
end

this.alertFuncs={
  any=function()
    return true
  end,
  radioGapSeeker=function(x)
    return this.radioTargets[x] == nil
  end,
  notNil=function(x)
    return x ~= nil
  end,
  notZero=function(x)
    return x ~= 0
  end,
  truthy=function(x)
    -- forgot 0 is truthy in lua (why?)
    if x == 0 then
      return false
    else
      return x
    end
  end,
  neitherZeroNorNullId=function(x)
    return x ~= 0 and x ~= NULL_ID
  end,
  notNullId=function(x)
    return x ~= NULL_ID
  end,
}

this.signatureTypes={
  none={},
  demoSimple={
    {argName="prevName",argType="str32"},
    {argName="nextName",argType="str32"},
  },
  ui={
    {argName="uiBool",argType="number",argAlert=this.alertFuncs.notZero} -- every UI message seems to have this
  }
}

--tex message signatures for PrintOnMessage/Ivars.debugMessages
-- {
--  MESSAGE CLASS={
--    MSG={
--      [arg(n+1)]={argName=<arg name>,argType=<lookupType>},
-- lookupType for this.lookups table.
this.messageSignatures={
  Block={
    OnScriptBlockStateTransition={
      {argName="blockName",argType="str32"},
      {argName="blockState",argType="scriptBlockStateTransition"},
    },
    OnChangeLargeBlockState={
      {argName="blockName",argType="str32"},
      {argName="blockStatus",argType="stageBlockState"},
    },
    OnChangeSmallBlockState={
      {argName="blockIndexX",argType="number"},
      {argName="blockIndexY",argType="number"},
      {argName="blockStatus",argType="stageBlockState"},
    },
    StageBlockCurrentSmallBlockIndexUpdated={
      {argName="blockIndexX",argType="number"},
      {argName="blockIndexY",argType="number"},
      {argName="clusterIndex",argType="number",argCanBeNil=true,argAlert=this.alertFuncs.notNil},
    },
  },
  Demo={
    crtnburn=this.signatureTypes.demoSimple,
    crtnhide=this.signatureTypes.demoSimple,
    BattleFx_on=this.signatureTypes.demoSimple,
    hrtwvdng={
      {argName="playId",argType="str32"},
    },
    hrtwvnm={
      {argName="playId",argType="str32"},
    },
    hrtwvflt={
      {argName="playId",argType="str32"},
    },
    hrtwvnmb={
      {argName="playId",argType="str32"},
    },
    start_endroll01=this.signatureTypes.demoSimple,
    start_endroll02=this.signatureTypes.demoSimple,
    -- following events from CLOAKED IN DARKNESS
    nwvocn=this.signatureTypes.demoSimple,
    nwvocn02=this.signatureTypes.demoSimple,
    qwvocn=this.signatureTypes.demoSimple,
    SetQuietKillGame=this.signatureTypes.demoSimple,
    radio_on=this.signatureTypes.demoSimple,
    radio_off=this.signatureTypes.demoSimple,
    -- following events are from TRUTH
    --[3210671346]=this.signatureTypes.demoSimple,
    --[2982900371]=this.signatureTypes.demoSimple,
    --[3107613017]=this.signatureTypes.demoSimple,
    --[2863902432]=this.signatureTypes.demoSimple,
    --[495071023]=this.signatureTypes.demoSimple,
    --[3046137689]=this.signatureTypes.demoSimple,
    --[3121960109]=this.signatureTypes.demoSimple,
    --[218189829]=this.signatureTypes.demoSimple,
    --[1733730059]=this.signatureTypes.demoSimple,
    --[3056593576]=this.signatureTypes.demoSimple,
    --[1314461310]=this.signatureTypes.demoSimple,
    --[2214019146]=this.signatureTypes.demoSimple,
    --[1881981136]=this.signatureTypes.demoSimple,
    --[24866945]=this.signatureTypes.demoSimple,
    --[431492954]=this.signatureTypes.demoSimple,
    --[754886327]=this.signatureTypes.demoSimple,
    --[564761330]=this.signatureTypes.demoSimple,
    --[3130597158]=this.signatureTypes.demoSimple,
    --[2853392484]=this.signatureTypes.demoSimple,
    p21_010000_epigraph_on=this.signatureTypes.demoSimple,
    p21_010000_telop_kde_on=this.signatureTypes.demoSimple,
    p21_010000_telop_kde_off=this.signatureTypes.demoSimple,
    p21_010000_telop_kjp_on=this.signatureTypes.demoSimple,
    p21_010000_telop_game_on=this.signatureTypes.demoSimple,
    p21_010000_telop_game_off=this.signatureTypes.demoSimple,
    p21_010000_casttelop_on=this.signatureTypes.demoSimple,
    p21_010000_iconon01=this.signatureTypes.demoSimple,
    p21_010000_curtainswing=this.signatureTypes.demoSimple,
    p21_010000_cyprtitle_on=this.signatureTypes.demoSimple,
    p21_010000_focusdistanceoff_ps3xbox360=this.signatureTypes.demoSimple,
    p21_010000_telop_kjp_off=this.signatureTypes.demoSimple,
    p21_010000_openeyelids=this.signatureTypes.demoSimple,
    p21_010000_missiontelop_on=this.signatureTypes.demoSimple,
    p21_010050_chaptertelop_on=this.signatureTypes.demoSimple,
    p21_010100_iconon01=this.signatureTypes.demoSimple,
    p21_010100_playerRise=this.signatureTypes.demoSimple,
    p21_010100_iconon02=this.signatureTypes.demoSimple,
    p21_010100_radiooff=this.signatureTypes.demoSimple,
    p21_010100_beatup01=this.signatureTypes.demoSimple,
    p21_010100_beatup02=this.signatureTypes.demoSimple,
    p21_010200_iconon01=this.signatureTypes.demoSimple,
    p21_010230_iconon01=this.signatureTypes.demoSimple,
    p21_010230_beatup01=this.signatureTypes.demoSimple,
    p21_010230_beatup02=this.signatureTypes.demoSimple,
    p21_010230_sheetchange=this.signatureTypes.demoSimple,
    p21_010240_iconon01=this.signatureTypes.demoSimple,
    p21_010250_windowbreak02=this.signatureTypes.demoSimple,
    p21_010250_gim_cartON=this.signatureTypes.demoSimple,
    p21_010250_ishstart=this.signatureTypes.demoSimple,
    p21_010270_elvtlamp_on=this.signatureTypes.demoSimple,
    p21_010270_envbreak=this.signatureTypes.demoSimple,
    p21_010270_emergencybell=this.signatureTypes.demoSimple,
    p21_010310_wssstart=this.signatureTypes.demoSimple,
    p21_010340_corpse_on=this.signatureTypes.demoSimple,
    p21_010360_iconon01=this.signatureTypes.demoSimple,
    p21_010360_window_brk01=this.signatureTypes.demoSimple,
    p21_010360_window_brk02=this.signatureTypes.demoSimple,
    p21_010360_window_brk03=this.signatureTypes.demoSimple,
    p21_010370_padon=this.signatureTypes.demoSimple,
    p21_010380dooroff=this.signatureTypes.demoSimple,
    p21_010380_cutter=this.signatureTypes.demoSimple,
    p21_010380_door=this.signatureTypes.demoSimple,
    p21_010380_ish=this.signatureTypes.demoSimple,
    p21_010410_dooroff=this.signatureTypes.demoSimple,
    p21_010410_002_Interruption=this.signatureTypes.demoSimple,
    p21_010410_003_Interruption=this.signatureTypes.demoSimple,
    p21_010410_004_Interruption=this.signatureTypes.demoSimple,
    p21_010410_005_Interruption=this.signatureTypes.demoSimple,
    p21_010420_01_closedoor=this.signatureTypes.demoSimple,
    p21_010420_playercrawling=this.signatureTypes.demoSimple,
    p21_010420_breakcurtainon=this.signatureTypes.demoSimple,
    p21_010420_curtainon=this.signatureTypes.demoSimple,
    p21_010420_padon=this.signatureTypes.demoSimple,
    p21_010440_volginattack=this.signatureTypes.demoSimple,
    p21_010440_iconon01=this.signatureTypes.demoSimple,
    p21_010440_iconon02=this.signatureTypes.demoSimple,
    p21_010440_breakwindow=this.signatureTypes.demoSimple,
    p21_010440_heliattack01=this.signatureTypes.demoSimple,
    p21_010440_heliattack02=this.signatureTypes.demoSimple,
    p21_010440_heliattack03=this.signatureTypes.demoSimple,
    p21_010440_heliattack04=this.signatureTypes.demoSimple,
    p21_010440_breakwall=this.signatureTypes.demoSimple,
    p21_010440_breakspkr=this.signatureTypes.demoSimple,
    p21_010440_corpse_on=this.signatureTypes.demoSimple,
    p21_010490_CloseDoor=this.signatureTypes.demoSimple,
    p21_010490_EneChange=this.signatureTypes.demoSimple,
    p21_010490_IshRouteStart=this.signatureTypes.demoSimple,
    p21_010510_enemychange=this.signatureTypes.demoSimple,
    p21_010510_GlassDestruction=this.signatureTypes.demoSimple,
    p21_010520_breakhelioff=this.signatureTypes.demoSimple,
    p21_010520_BreakPillar=this.signatureTypes.demoSimple,
    p21_010520_RubbleOn=this.signatureTypes.demoSimple,
    p21_020010_ShootVolginStart=this.signatureTypes.demoSimple,
    p21_020010_iconon01=this.signatureTypes.demoSimple,
    p21_020010_hospwall_brk_on=this.signatureTypes.demoSimple,
    p21_020010_breakTunnel=this.signatureTypes.demoSimple,
    p31_040130_DemoEnd_hyu=this.signatureTypes.demoSimple,
    p31_0400140_Player_setpos01=this.signatureTypes.demoSimple,
    p31_0400140_Player_setpos02=this.signatureTypes.demoSimple,
    -- birthday cutscenes:
    p51_010270_001_HBDbox_on=this.signatureTypes.demoSimple, 
    DisablePhantomRoom={
      {argName="playId",argType="str32"},
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
    },
    Play={
      {argName="playId",argType="str32"},
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
    },
    PlayEnd={
      -- fires after Finish
      {argName="playId",argType="str32"},
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
    },
    Playing={
      -- fires after Start
      {argName="playId",argType="str32"},
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
    },
    PlayInit={
      -- fires before Play
      {argName="playId",argType="str32"},
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
    },
    PlayerOverrideOff=this.signatureTypes.demoSimple,
    PlayerOverrideOn=this.signatureTypes.demoSimple,
    Skip={
      -- automatically fired during TRUTH
      {argName="playId",argType="str32"},
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
    },
    Start={
      -- fires after Play
      {argName="playId",argType="str32"},
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
    },
    StartMissionTelop=this.signatureTypes.demoSimple,
    Finish={
      -- fires after FinishMotion
      {argName="playId",argType="str32"}, -- playId
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
    },
    FinishMotion={
      -- fires [some time] after Playing
      {argName="playId",argType="str32"}, -- playId
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
    },
    visibleOnNPC={
      {argName="playId",argType="str32"}, -- playId
      {argName="npcLocator",argType="str32"}, -- npc locator
    },
  },--Demo
  GameObject={
    AimedFromPlayer={ -- when the children in White Mamba are aimed at at via scope or readied weapon
      {argName="gameId",argType="gameId"},
      {argName="playerIndex",argType="gameId"},
    },
    AntiSniperNoticed=this.signatureTypes.none,--FOB
    --ej ^^^ supposedly when binocular men peep you
    ArrivedAtLandingZoneSkyNav={--SupportHeli
      {argName="heliId",argType="gameId"},
      {argName="landingZone",argType="str32"},
    },
    ArrivedAtLandingZoneWaitPoint={--SupportHeli
      {argName="heliId",argType="gameId"},
      {argName="landingZone",argType="str32"},
    },
    BreakGimmick={
      {argName="gimmickId",argType="gimmickId"},
      {argName="locatorNameS32",argType="str32"},
      {argName="dataSetPath32",argType="dataSetPath32"},
      {argName="attackerId",argType="gameId"},
    },
    BreakGimmickBurglarAlarm={
      {argName="attackerId",argType="gameId"},--VERIFY is gameId
    },
    BuddyAppear={
      -- on the sortie prep menu, is only the buddyLocatorId and appears to only run for:
      --  BuddyDogGameObjectLocator
      --  BuddyQuietGameObjectLocator
      {argName="buddyLocatorId",argType="gameId"},
    },
    BuddyArrived={
      -- buddy arrived at the correct spot
      {argName="buddyId",argType="gameId"}, -- quiet's instance
      {argName="unk1",argType="gameId",argAlert=this.alertFuncs.notZero}, -- ??? the player?
    },
    BuddyDogFinishSnarlAndStay={
      {argName="buddyId",argType="gameId"}, --ej TODO: D-Dog? whoever he snarled at?
    },
    BuddyEspionage={
      {argName="buddyId",argType="gameId"}, -- quiet's instance
      {argName="outpostName",argType="str32"},
      {argName="unk",argType="gameId"}, -- the outpost?
    },
    BulletGuardArmor={
      {argName="gameId",argType="gameId"},
      {argName="attackId",argType="attackId"}, -- matches subsequent Damage messages
      {argName="attackerId",argType="gameId"}, --ej TODO VERIFY: player?
      {argName="bulletGuardArmorMessageFlags",argType="bulletGuardArmorMessageFlags"},
    },
    BurglarAlarmTrap={
      {argName="bAlarmId",argType="gimmickId"},--VERIFY is gameId
      {argName="bAlarmHash",argType="str32"},--tex from ly<layout>.lua .itemTable.stolenAlarms
      {argName="bAlarmDataSet",argType="dataSetPath32"},--VERIFY
      {argName="triggerer",argType="gameId"},--tex who tripped alarm
    },
    CalledFromStandby={--SupportHeli
      {argName="gameId",argType="gameId"},
    },
    CancelReinforce={
      {argName="cpId",argType="cpId"}
    },
    Carried={--carry soldier/hostage
      {argName="gameId",argType="gameId"},
      {argName="carryState",argType="carryState"},
    },
    ChangeLife={ --ej HASH-CONFIRMED
      -- when your buddy gets hurt, specifically quiet
      {argName="buddyId",argType="gameId"}, -- quiet's instance
      {argName="lifeValue",argType="number"}, -- for quiet goes down from 100
    },
    ChangePhase={
      {argName="cpId",argType="cpId"},
      {argName="phase",argType="phase"},
      {argName="priorPhase",argType="phase"},
    },
    ChangePhaseForAnnounce={
      {argName="cpId",argType="cpId"},
      {argName="phase",argType="phase"},
    },
    CheckEventDoorNgIcon={
      -- called every tick when you are standing in a trap with a prompt to lockpick a door
      -- ensures that there are no conditions that should trigger a subsequent prompt to show
      -- a "Not Good" [X] on top of the icon, indicating you cannot do it now

      -- happens during shining lights, and also when you rescue the children from the diamond mine
      {argName="playerIndex",argType="gameId"},
      {argName="gimmickId",argType="gameId"}, --ej TODO VERIFY
    },
    CommandPostAnnihilated={ --✅
      {argName="cpId",argType="cpId"},
      {argName="playerPhase",argType="phase"},
      {argName="dominated",argType="number",argAlert=function(x) return x == nil end},--[[
        nil == ??? does this happen ???
        0   == it means we dominated the cp, inexplicably
        1   == "beep-beep" alert cleared / re-claimed an outpost (someone wandered through it and left)
      ]]
    },
    ComradeFultonDiscovered=this.signatureTypes.none,-- when someone discovers a fulton in progress
    Conscious={
      {argName="gameId",argType="gameId"},
      {argName="wakerUpper",argType="gameId"},--tex UNKNOWN 65535 or ?, 0 or ?
      {argName="arg2",argType="number",argAlert=this.alertFuncs.notZero},--tex UNKNOWN
      --[[

      ]]
    },
    ConversationEnd={
      {argName="cpId",argType="cpId"},
      {argName="speechLabel",argType="str32"},
      {argName="isSuccess",argType="number"},--boolasnumber
    },
    Damage={--On Damage
      {argName="damagedId",argType="gameId"},--object that took damage
      {argName="attackId",argType="attackId"},
      {argName="attackerId",argType="gameId",argCanBeNil=true},
      --[[
        similar to below, attacks on skulls frequently refuse to attribute to a particular player
      ]]
      {argName="damageMessageFlag",argType="damageMessageFlags",argCanBeNil=true},
      --[[
        nil = helicopters/birds/some bound hostages don't give a shit
          0 = typical non-"DMG" damage (ZZZ/STN/---)
          1 = happened at some point, idk what that was about
          4 = bullet / explosion / typical "DMG"
           
      ]]
    },
    Dead={
      --tex still unsure if some calls to messages have more args than others, while most Dead msg reesponse functions only care about thr first two args, and the only msg calls ive seen logged only have
      --but then you have TppResult Dead - function(gameId,attackerId,playerPhase,deadMessageFlag)
      {argName="gameId",argType="gameId"},
      {argName="attackerId",argType="gameId",argCanBeNil=true},--apparently Sahelanthropus is the only thing that ignores this
      {argName="phase",argType="phase",argCanBeNil=true},--occurs as nil during FOB (global phase?)
      {argName="deadMessageFlag",argType="deadMessageFlags",argCanBeNil=true},
      --[[
        0  = died from typical damage==4 (tragic)
        2  = killed someone that was in the dying state, no matter what their consciousness was
        6  = went from dying => dead via bleeding out
        8  = died due to explosion of containing vehicle /
             died due to a vehicle that exploded previously (body charred)
        16 = shot/exploded to death by SupportHeli (player friendly)
        17 = burned to death from petrol (either direct contact or being thrown in later)
      ]]
    },
    DescendToLandingZone={--SupportHeli
      {argName="heliId",argType="gameId"},
      {argName="landingZone",argType="str32"},
    },
    DiscoveredBySniper={
      -- "Boss, get down! That's an enemy sniper.""
      {argName="discovererId",argType="gameId"}, -- you been peeped
    },
    DiscoveredObject={
      {argName="gameObjectId",argType="gameId"}, -- discovered object
      {argName="discovererId",argType="gameId",argAlert=this.alertFuncs.notZero}, -- player, usually
    },
    DiscoveryHostage={
      {argName="hostageId",argType="gameId"}, -- the hostage being checked for
      {argName="soldierId",argType="gameId"}, -- the soldier looking for the hostage
    },
    Down={
      {argName="downedId",argType="gameId"},--tex when soldier downed
    },
    Dying={--ej when soldier critically wounded
      {argName="soldierId",argType="gameId"},
      {argName="attackerId",argType="gameId",argCanBeNil=true}, -- sometimes nil? was 0 for FOB mission (i was attacking)
      -- if someone is shot while stunned and they wake up and begin dying, it will not be attributed to anyone
      -- will also happen if you repeatedly do nonlethal damage to someone changing them between stunned and awake
    },
    DyingAll={
      -- when all 4 skulls in a group are eliminated
      {argName="enemyId",argType="gameId"},
    },
    EndInvestigate={
      {argName="cpId",argType="cpId"},
      {argName="phase",argType="phase"},
    },
    EspionageBoxGimmickOnGround={
      {argName="gimmickId",argType="gameId"}, --44032/3/4
      {argName="unk1",argType="str32"},
      {argName="unk2",argType="str32"},
      -- always 2777582117?
    },
    EventGimmickFinish={
      -- called when transitioning between the battlegear hangar and motherbase
      {argName="unk1",argType="gameId",argAlert=this.alertFuncs.any},
      {argName="locator",argType="str32"},
      {argName="unk2",argType="str32",argAlert=this.alertFuncs.any},
    },
    FobReinforceRespawn={--[450758143]
      {argName="soldierId",argType="gameId"},
    },
    Fulton={
      {argName="gameId",argType="gameId"},
      {argName="gimmickInstanceOrAnimalId",argType="gimmickInstanceOrAnimalId",argCanBeNil=true,this.alertFuncs.notNil},
      --[[
        follows animalId up until a point, is also really high sometimes

        ?NULL_ID for hostages

        can be nil for parasites
      ]]
      {argName="gimmickDataSet",argType="dataSetPath32",argCanBeNil=true},
      --[[
        TODO:
        when isn't it?
        can be nil for parasites
      ]]
      {argName="staffIdOrResourceId",argType="staffIdOrResourceId",argCanBeNil=true},
      --[[
        TODO:
        nil for everything but staff?
      ]]
    },
    FultonFailed={
      {argName="gameId",argType="gameId"},
      {argName="unknown2",argType="str32"},
      {argName="unknown3",argType="str32"},
      {argName="unknown4",argType="number"},
    },
    FultonFailedEnd={
      {argName="gameId",argType="gameId"},
      {argName="unknown2",argType="str32"},
      {argName="unknown3",argType="str32"},
      {argName="unknown4",argType="number"},
    },
    FultonInfo={
      {argName="gameId",argType="gameId"},
      {argName="playerIndex",argType="gameId"},
      {argName="reduceThisContainer",argType="number",argCanBeNil=true,argAlert=this.alertFuncs.truthy},
      --[[
        TODO:

        nil for most things,
        0 for resource-associated items
      ]]
    },
    GetInEnemyHeli={
      -- when a soldier gets promoted to helicopter passenger
      -- i've only ever seen this during Mission 21 (THE WAR ECONOMY) to "sol_pfCamp_vip_guard"
      {argName="gameId",argType="gameId"},
    },
    HeadShot={
      {argName="gameId",argType="gameId"},
      {argName="attacker",argType="attackId"},
      {argName="attackerId",argType="gameId"},
      {argName="headshotMessageFlags",argType="headshotMessageFlags"},
    },
    HeadShotDistance={
      {argName="gameId",argType="gameId"},
      {argName="attacker",argType="attackId"},
      {argName="attackerId",argType="gameId"},
      {argName="distance",argType="number"},
    },
    HeliDoorClosed={
      {argName="gameId",argType="gameId"},--helicopter whose door is closing
    },
    Holdup={
      {argName="gameId",argType="gameId"},-- victim being held up
    },
    InAnimalLocator={
      {argName="animalId",argType="number"},--ej TODO what do the numbers mean: 66 = Gray Wolf
      {argName="gameId",argType="gameId"},--ej player, usually
    },
    InSight={--tex when heli spots player
      {argName="heliId",argType="gameId"},
      {argName="targetId",argType="gameId"},
    },
    Interrogate={
      {argName="soldierId",argType="gameId"},
      {argName="cpId",argType="cpId"},
      {argName="allowCollectionInterr",argType="number"},--boolasnumber
    },
    InterrogateEnd={
      {argName="soldierId",argType="gameId"},
      {argName="cpId",argType="cpId"},
      {argName="strCodeName",argType="str32"},
      {argName="index",argType="number"},
    },
    InterrogateSetMarker={--ej doesn't seem to indicate what he marked?
      {argName="soldierId",argType="gameId"},
    },
    InterrogateUpHero=this.signatureTypes.none,-- when you do an interrogation that increases heroism? FOB friendly
    LandedAtLandingZone={--SupportHeli
      {argName="heliId",argType="gameId"},
      {argName="landingZone",argType="str32"},
    },
    LiquidChangePhase={
      {argName="gameId",argType="gameId"}, --the liquid
      {argName="phase",argType="phase"}, --the liquid phase
    },
    LiquidEnterCombatPhaseTwo={
      {argName="gameId",argType="gameId"}, --the liquid
    },
    LiquidPutInHeli={
      {argName="gameId",argType="gameId"}, --the liquid
    },
    LostContainer={
      -- when an NPC notices a container disappeared
      -- also fired during an FOB event
      {argName="noticerId",argType="gameId"}, -- in the 39446/39445 range?
      {argName="locator",argType="str32"},
    },
    LostControl={--attack heli
      {argName="heliId",argType="gameId"},
      {argName="sequenceName",argType="str32"}, -- Start = begin spinout, End = explosion
      {argName="attackerId",argType="gameId"}, -- can be the player or SupportHeli
    },
    LostHostage={
      {argName="gameId",argType="gameId"}, -- the hostage who was discovered missing
      {argName="unknown2",argType="number",argAlert=this.alertFuncs.any}, -- sometimes zero, sometimes nil?
    },
    MapUpdate={--ej doesn't seem to indicate what he is telling you about
      {argName="soldierId",argType="gameId"},
    },
    MonologueEnd={
      {argName="gameId",argType="gameId"},
      {argName="monologueId",argType="str32"},
      {argName="unknown",argType="number",argAlert=function(x) return x~=1 end},
    },
    Neutralize={
      {argName="gameId",argType="gameId"},
      {argName="attackerId",argType="gameId"},
      {argName="neutralizeType",argType="neutralizeType"},
      {argName="neutralizeCause",argType="neutralizeCause"},
    },
    NeutralizeFob={
      {argName="gameId",argType="gameId"},
      {argName="attackerId",argType="gameId"},
      {argName="neutralizeType",argType="neutralizeType"},
      {argName="neutralizeFobCause",argType="neutralizeFobCause"},
    },
    NoticeVehicleInvalid={
      -- fired when vehicle that noticed us is no longer loaded, like when loading from checkpoint
      -- unsure if it fires for anything other than walker gears (2304X)
      {argName="gameId",argType="gameId"},
    },
    OutSight={--[4049779088]
      -- a suspcious helicopter is shining their light right at you
      {argName="helicopterId",argType="gameId"},
      {argName="unk1",argType="gameId"}, --ej TODO VERIFY: 65535
    },
    PazGotPicture={
      {argName="pazLocatorId",argType="gameId"},
    },
    PazHasAimedDefault={
      {argName="pazLocatorId",argType="gameId"},
    },
    PazHideIcon={
      {argName="pazLocatorId",argType="gameId"},
    },
    PazInAngle={
      {argName="pazLocatorId",argType="gameId"},
    },
    PazOutAngle={
      {argName="pazLocatorId",argType="gameId"},
    },
    PazPerceiveSnake={
      {argName="pazLocatorId",argType="gameId"},
    },
    PazShowIcon={
      {argName="pazLocatorId",argType="gameId"},
    },
    PazSnakeIsStopping={
      {argName="pazLocatorId",argType="gameId"},
    },
    PazSnakeIsMoving={
      {argName="pazLocatorId",argType="gameId"},
    },
    PazRelaxEndTiming={
      {argName="pazLocatorId",argType="gameId"},
    },
    PlacedIntoVehicle={
      {argName="gameId",argType="gameId"}, --subject
      {argName="vehicleId",argType="gameId"},
      {argName="unknown3",argType="str32",argAlert=this.alertFuncs.any},
    },
    PlayerGetAway={ --ej: i've only ever seen InMission after wandering away from Malik
      -- also fires after you put Malik into a helicopter and fly away with them?!
      {argName="gameId",argType="gameId"}, -- the gameobject you're getting away from, after PlayerGetNear
    },
    PlayerGetNear={ --ej: i've only ever seen InMission after wandering near Malik
      {argName="gameId",argType="gameId"}, -- the gameobject you're getting near, required for PlayerGetAway
    },
    PlayerHideHorse={
      {argName="playerIndex",argType="gameId"},
    },
    PlayerIsWithinRange={
      {argName="gameId",argType="gameId"}, -- inquiring gameId
      {argName="areaName",argType="str32"}, -- "CheckRange400"
      {argName="radius",argType="number"}, -- the range from the point to check
    },
    QuietEraseMarker={
      -- when quiet (boss) erases her own marker and disappears
      -- other skulls don't seem to have a similar signal?
      {argName="quietId",argType="gameId"},
    },
    QuietFinishUseDeathBullet={
      -- when quiet (boss) stops trying to kill you (as much)
      {argName="quietId",argType="gameId"},
    },
    QuietLostPlayer={
      -- when quiet (boss) loses visual contact with snake
      {argName="quietId",argType="gameId"},
    },
    QuietSnipeAtGrenade={
      -- every time a soldier shoots a weapon in shining lights
      -- but only when it happens on-camera
      {argName="buddyLocatorId",argType="gameId"},
    },
    QuietStartSniping={
      -- when quiet (boss) begins to aim down sights looking for snake
      {argName="quietId",argType="gameId"},
    },
    QuietStartUseDeathBullet={
      -- when quiet (boss) next shot will kill you
      {argName="quietId",argType="gameId"},
    },
    QuietThroughLaserSight={
      -- when quiet (boss) is staring down at you with the laser
      -- not sure what technical difference there is with her AI in this phase
      {argName="quietId",argType="gameId"},
    },
    RadioEnd={--tex fired by soldier calling via radio? in mission script msgs they mostly have variables/comments saying 'conversation'
      {argName="gameId",argType="gameId"},--tex gamobjectid of what soldier is reporting on? is player in the case of soldier reporting spotted player to cp
      {argName="cpId",argType="cpId"},--tex cp theyre calling? calling from?
      {argName="speechLabel",argType="str32"},--tex there's a bunch of labels referenced in mission CPR0081 (cp radio I guess), the param is most often named speechLabel, but these dont match subpids like other conversations (unless I've missed some subp hashes somehow).
      {argName="isSuccess",argType="number"},
    },
    ReinforceRespawn={--tex on each normal reinforce soldier respawn
      {argName="soldierId",argType="gameId"},
    },
    ReportDiscoveryHostage={
      -- when someone is guarding a hostage but they ain't there no more
      {argName="hostageId",argType="gameId"},
      {argName="reporterId",argType="gameId"},
    },
    RequestLoadReinforce={--tex prior call for super reinforce
      {argName="reinforceCpId",argType="cpId"},
    },
    Restraint={
      -- whenever a soldier gets taken 
      -- note: fires every time any parameter changes
      {argName="soldierId",argType="gameId"},--ej victim
      {argName="releaseType",argType="number"},--boolAsNumber 0 = idle, 1 = moving / throwing
      {argName="restraintType",argType="number"},--ej TODO TYPEDEF
      -- 0 & 0 == regular hold
      -- 1 & 1 == human shield 
      -- 1 & 2 == throw flip / shove into wall
      -- 1 & 3 == execution
      -- 1 & 4 == choke-out
      -- 1 & 5 == punch combo
    },
    Returned={
      -- usually when an attack heli retreats
      {argName="gameId",argType="gameId"},
    },
    RideHeli={
      -- happens when a buddy such as D-Dog boards the helicopter, because Snake is already on it
      {argName="buddyLocatorId",argType="gameId"},
    },
    RouteEventFaild={--tex AI route event failed
      {argName="gameId",argType="gameId"},
      {argName="routeId",argType="str32"},--tex TODO gather route names
      {argName="failureType",argType="routeEventFailedType"},
    },
    RoutePoint={ -- only ever seen during White Mamba, not sure why; happens right as the mission loads
      -- occurs during VOICES, pretty much constantly as volgin walks around looking for you
      {argName="gameId",argType="gameId"},
      {argName="routeId",argType="str32",argAlert=this.alertFuncs.any},
      --[[
        rts_s10120_d_TppLiquid2
        rts_vol_sneak
      ]]
      {argName="routeNodeIndexOrParam",argType="number",argAlert=this.alertFuncs.notZero},
    },
    RoutePoint2={--tex fire by Route Event 'SendMessage', and some other unknown Route Events
      {argName="gameId",argType="gameId"},--tex gameId of agent on route VERIFY because SendEvent param3 is a str32 game object name.
      {argName="routeId",argType="str32"},--tex TODO gather route names
      {argName="routeNodeIndexOrParam",argType="str32"},--tex --tex SendMessage event  param 8(from 0), VERIFY what it is on events that param is 0
      {argName="messageId",argType="str32"},--tex SendMessage event  param 7(from 0)
    },
    SahelanAllDead={
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
    },
    Sahelan1stRailGun={
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
    },
    SahelanBlastDamageToWeakPoint={
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
    },
    SahelanChangePhase={
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
      {argName="phase",argType="phase"},
      -- TppSahelan2.SAHELAN2_PHASE_*
      -- you would never fucking guess this enum with a gun to your head

    },
    SahelanEnableHeliAttack={
      --ej guess: allows sally to attack the support helicopter?
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
    },
    SahelanGrenadeExplosion={
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
    },
    SahelanPartsBroken={
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
      {argName="partId",argType="number"}, --[[
         3 = torso
         5 = ??? near the head
         7 = right leg?
         8 = left leg?
         9 = ??? near the head
        10 = radome orb
        11 = dick flame thrower?
      ]]
    },
    SahelanPatrolMissile={
      -- during HELLBOUND when the funny exploding things sweep around with the IR-SENSORs
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
    },
    SahelanReturned1stRailGun={
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
    },
    SahelanStopped={
      -- when you're taking off in the support heli
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
    },
    SahelanVulcunStartToHeli={
      -- if the funny pills see the helicopter during HELLBOUND
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
    },
    SahelanVulcunStopToHeli={
      {argName="gameId",argType="gameId"}, -- the Sahelanthropus
    },
    SaluteRaiseMorale={
      {argName="saluter",argType="gameId"},
    },
    SmokeDiscovered=this.signatureTypes.none,-- when a smoke goes off during discovery
    SleepingComradeRecoverd=this.signatureTypes.none,-- when someone is woken up another sleeping person
    SpecialActionEnd={--tex after some SpecialAction anim has ended
      {argName="gameId",argType="gameId"},
      {argName="actionId",argType="str32"},
      {argName="commandId",argType="str32"},
    },
    SpecialActionSuicide={--[3468216400]
      -- every time a soldier shoots a weapon in shining lights
      -- but only when it happens on-camera
      {argName="soldierId",argType="gameId"},
    },
    StartInvestigate={
      {argName="cpId",argType="cpId"},
      {argName="phase",argType="phase"},--ej TODO VERIFY
    },
    StartedCombat={--enemy heli, skulls
      {argName="unk0",argType="gameId"},--tex assuming gameId from the look of it, but it wasn't picking up enemy heli, is it attacker or attacked?
    },
    StartedDiscovery={
      -- after a mist scull StartedSearch
      -- initiates reflex mode
      -- all skulls will call this after one spots you
      {argName="enemyId",argType="gameId"},
      {argName="phaseName",argType="str32"}, -- str32:1907917584
    },
    StartedMoveToLandingZone={--SupportHeli
      {argName="gameId",argType="gameId"},
      {argName="landingZone",argType="str32"},--str32
    },
    StartedPullingOut={--SupportHeli
      {argName="gameId",argType="gameId"},
    },
    StartedSearch={
      -- when a mist skull initiates a search for the player from idle?
      -- only one skull needs to call this
      {argName="enemyId",argType="gameId"},
      {argName="phaseName",argType="str32"}, -- Normal
    },
    StartedSmokeAction={
      -- when mist skulls shoot out a bunch of smoke bombs
      {argName="enemyId",argType="gameId"},
      {argName="phaseName",argType="str32"}, -- Fog
    },
    SwitchCamera={
      {argName="gimmickId",argType="gameId"}, --ej TODO VERIFY: the camera gameobject instance?
      {argName="switchFlag",argType="number"},--assumed to be similar to SwitchGimmick
    },
    SwitchGimmick={
      {argName="gameId",argType="gameId"},
      {argName="locatorName",argType="str32"},
      {argName="dataSetName",argType="dataSetPath32"},
      {argName="switchFlag",argType="number"},--tex 0,1,255 state of switch. 0 seems to be off, 1 is on? 255 is 'broken' (used to trigger buzz sound on mfinda oilfield switch)
    },
    TapCqc={
      {argName="gameId",argType="gameId"},
      {argName="attackerId",argType="gameId",argAlert=this.alertFuncs.notZero},--ej usually the player,
    },
    TapFoundPlayerInAlert={
      {argName="gameId",argType="gameId"}, --soldier that spotted player
    },
    TapHeadShotFar={
      {argName="gameId",argType="gameId"}, --victim
      {argName="attackerId",argType="gameId",argAlert=this.alertFuncs.notZero},--ej usually the player,
    },
    TapHeadShotNear={
      {argName="gameId",argType="gameId"}, --victim
    },
    TapHoldup={
      -- fired after Holdup, but not every time Holdup is fired?
      -- maybe only if they're upright
      {argName="gameId",argType="gameId"},
      {argName="attackerId",argType="gameId",argAlert=this.alertFuncs.notZero},--ej usually the player,
    },
    TapRocketArm={--ej knocked over while mid-flight
      {argName="gameId",argType="gameId"},
      {argName="attackerId",argType="gameId",argAlert=this.alertFuncs.notZero},--ej usually the player,
    },
    Unconscious={
      {argName="gameId",argType="gameId"},
      {argName="attackerId",argType="gameId",argCanBeNil=true},
      -- can sometimes be nil if the player warped them with the Jehuty
      -- is nil for things like skulls or Eli
      {argName="phase",argType="phase",argCanBeNil=true},
      -- if attackerId is nil, then this will be as well, generally
    },
    Unlocked={
      {argName="hostageId",argType="gameId"},
    },
    VehicleAction={
      {argName="rideMemberId",argType="gameId"},
      {argName="vehicleId",argType="gameId"},
      {argName="vehicleActionType",argType="vehicleActionType"},
    },
    Vanished={
      -- not sure when this occurs, but if a sideop NPC ever fails to spawn, it's highly probable this happened
      {argName="gameId",argType="gameId"},
    },
    VehicleBroken={
      {argName="vehicleId",argType="gameId"},
      {argName="sequenceName",argType="str32"}, -- Start = begin breakdown, End = explosion
    },
    VehicleDisappeared={
      {argName="gameId",argType="gameId"},--vehicle gameid
    --{argName="unk1",argType="str32"}, --tex UNKNOWN s10052 == "CanNotMove", otherwise doesn't seem to be set in most calls TODO test that mission to see if it actually does
    },
    VehicleTrouble={
      {argName="gameId",argType="gameId"},--vehicle gameid
      {argName="reason",argType="str32"},
      -- 2117880453 = FultonStart (abducted)
      -- 1936681293 = CanNotMove (tires shot)
    },
    VolginAttack={
      {argName="gameId",argType="gameId"}, -- the volgin (can there be several?)
      {argName="volginAttackChargeState",argType="number"}, -- only ever seen as 1
      -- TppVolgin2.VOLGIN_ATTACK_CHARGE_*
      --[[
        0 = begin?
        1 = end? 3 seconds later
      ]]
    },
    VolginChangePhase={
      {argName="gameId",argType="gameId"}, -- the volgin (can there be several?)
      {argName="phase",argType="number"}, -- only ever seen as 1 unless you reload checkpoint after the tunnel collapses
      -- TppVolgin2.VOLGIN_PHASE_*
      VOLGIN_PHASE_SNEAK = 0,
    },
    VolginDamagedByType={
      {argName="gameId",argType="gameId"}, -- the volgin (can there be several?)
      {argName="volginDamagedType",argType="number",argAlert=this.alertFuncs.notZero}, --ej TODO build lookup
      -- TppVolgin2.VOLGIN_DAMAGED_TYPE_*
    },
    VolginDestroyedFactoryWall={ -- during VOICES
      {argName="gameId",argType="gameId"}, -- the volgin (can there be several?)
    },
    VolginDestroyedTunnel={
      {argName="gameId",argType="gameId"}, -- the volgin (can there be several?)
    },
    VolginGameOverAttackSuccess={
      {argName="gameId",argType="gameId"}, -- the volgin (can there be several?)
    },
    VolginLifeStatusChanged={
      {argName="gameId",argType="gameId"}, -- the volgin (can there be several?)
      {argName="volginLifeStatusType",argType="number"}, --ej TODO build lookup
      -- TppVolgin2.VOLGIN_LIFE_STATUS_*
    },
    WalkerGearBroken={
      {argName="gameId",argType="gameId"},--vehicle gameid
      {argName="sequenceName",argType="str32"}, -- Start = begin breakdown, End = explosion; 5 seconds between usually
    },
    WarningGimmick={--tex on ir sensor trigger
      {argName="irSensorId",argType="gimmickId"},--TODO can't seem to get any hits for str32 or TppGimmick.GetGameObjectId > gameObjectId name
      {argName="irHash",argType="str32"},--tex from ly<layout>.lua .itemTable.irsensors
      {argName="irDataSet",argType="dataSetPath32"},
      {argName="triggerer",argType="gameId"},--tex who tripped sensor
    },
  },--GameObject
  Marker={
    ChangeToEnable={
      {argName="instanceName",argType="str32"},
      {argName="markerType",argType="str32"},--[[
        tex fox2 TppMarker2LocatorParameter markerType 
        {"TYPE_COMMON",
         "TYPE_FIRE",
         "TYPE_INTELLI_FILE",
         "TYPE_MB_SPOT",
         "TYPE_MISSION_KEY_PLACE",
        }, or "TYPE_ENEMY" or ??
      ]]
      {argName="gameId",argType="gameId"},
      {argName="markedBy",argType="str32",argCanBeNil=true},
      --[[
        nil = system, restoring from GameOver
      ]]
      --tex alias: identificationCode 
      --what set the marker, "Player" or ? buddy or ??, TODO arg not present some times?
    },
  },
  Mission={
    GameOverByCrime=this.signatureTypes.none,-- shooting a UAV on your own FOB during security cam settings
    OnAddTacticalActionPoint={--tex see bottom of TppResult.AddTacticalActionPoint where it manually fires the message
      {argName="gameId",argType="gameId"},--victim id
      {argName="tacticalTakeDownType",argType="str32"},
      -- "TapCqc"
      -- "TapHeadShotFar"
    },
  },
  MotherBaseManagement={
    -- AssignedStaff [section,amount] 
    AssignedStaff={
      {argName="section",argType="staffSectionId"}, --ej TODO: typedef
      -- TppMotherBaseManagementConst.SECTION_SEPARATION
      {argName="amount",argType="number"},
    },
    ChangedStaffListTab={
      {argName="tabId",argType="staffTabId"},
    },
    MbDvcActOpenDevelopWeapon=this.signatureTypes.none,
    RequestSaveMbManagement=this.signatureTypes.none,
    --[[
    StartFobMission={ --ej TODO VERIFY
      --{41, 3, 50050, 2811246262} -- FOB Event: Kill Count
      --{93, 0, 50050, 1051363200} -- device security settings FOB1 Command Platform / North Atlantic Ocean
    }
    ]]
    StartFobMission={
      {argName="motherBaseLayoutCode",argType="number"}, -- thanks conveninetly located IH print
      {argName="unknown2",argType="number"}, -- maybe has something to do with the selected character
      {argName="missionId",argType="missionId",argAlert=function(n) return n ~= 50050 end}, -- always 50050 I'm guessing
      {argName="unknown4",argType="str32"}, --ej TODO: beats me
    },
  },
  MotherBaseStage={
    MotherBaseCurrentClusterLoadStart={
      {argName="clusterId",argType="number"},--TODO clusterid to name, but would still want to present the number
    },
    MotherBaseCurrentClusterActivated={
      {argName="clusterId",argType="number"},--TODO clusterid to name, but would still want to present the number
    },
    MotherBaseCurrentClusterDeactivated={
      {argName="clusterId",argType="number"},--TODO clusterid to name, but would still want to present the number
    },
  },
  Network={
    DisconnectFromKonami=this.signatureTypes.none,
    DisconnectFromPsn=this.signatureTypes.none, -- despite the name, it also occurs when your connection to Steam dies (Tuesday moment)
    DiscoverFraud={
      {argName="playerIndex",argType="gameId"},
      --ej it is possible this is a boolAsNumber, but if it ever turns to 1, I suspect I won't be able to test anymore
    },
    NoticeSneakMotherBase={ -- an emergency invasion has occured
      {argName="playerIndex",argType="gameId"},
      {argName="playerIndex",argType="gameId"},
    },
    -- NoticeSneakSupportedMotherBase, via TppTerminal
    EndLogin=this.signatureTypes.none,
    StartLogin={
      {argName="playerIndex",argType="gameId"},
    },
  },
  Placed={
    OnActivatePlaced={
      {argName="equipId",argType="equipId"},
      {argName="index",argType="number"},
    },
    OnBreakPlaced={
      {argName="gameId",argType="gameId"},--instigator
      {argName="equipId",argType="equipId"},--the item the placed item was
      {argName="index",argType="number"},--ej TODO where does this come from
      {argName="isPlacedByPlayer",argType="number",argAlert=function(x) return x < 0 or x > 1 end},--boolAsNumber
      -- 1 when placed by player
      -- 0 when found on map
    },
  },
  Player={
    AdjustFulton={
      -- when the player/target adjust angle to begin a fulton animation 
      {argName="playerIndex",argType="gameId"},
      {argName="gameId",argType="gameId"},
    },
    CalcFultonPercent={--tex TODO: only first two arg appear? test to see if gimmick args do actually show when next to container or some other gimmick
      {argName="playerIndex",argType="gameId"},--tex assumed
      {argName="gameId",argType="gameId"},
    --          {argName="gimmickInstanceOrAnimalId",argType="number"},
    --          {argName="gimmickDataSet",argType="number"},--TODO:
    --          {argName="stafforResourceId",argType="number"},--TODO:
    },
    CalcDogFultonPercent={
      {argName="playerIndex",argType="gameId"},--tex assumed
      {argName="gameId",argType="gameId"},
    --          {argName="gimmickInstanceOrAnimalId",argType="number"},
    --          {argName="gimmickDataSet",argType="number"},--TODO:
    --          {argName="stafforResourceId",argType="number"},--TODO:
    },
    CallMenuMessage_HideCallMenu={
      {argName="playerIndex",argType="gameId"},
    },
    CallMenuMessage_ShowCallMenu={
      {argName="playerIndex",argType="gameId"},
    },
    CBoxSlideEnd={
      {argName="playerIndex",argType="gameId"},
      {argName="distance",argType="number"},--tex distance of slide
    },
    CqcContinuePass={
      -- when someone investigates you in a box and you don't CQC them (opportunity no longer available)
      -- possibly any other fleeting CQC event, not sure which
      --ej TODO TEST MORE
      {argName="playerIndex",argType="gameId"},
    },
    CqcHoldStart={
      {argName="playerIndex",argType="gameId"},
      {argName="gameId",argType="gameId"},--victim
    },
    CqcHoldReleseChild={ -- when a child soldier slips out of a Restraint
      {argName="playerIndex",argType="gameId"},
      {argName="gameId",argType="gameId"},--victim
    },
    CqcThrowAction={--[3038279949]
      {argName="playerIndex",argType="gameId"},--ej TODO VERIFY
      {argName="victimId",argType="gameId"},--ej TODO VERIFY
    },
    Dead={
      {argName="playerIndex",argType="gameId"},
      {argName="deathType",argType="str32"},
    },
    DeadInFOB={
      -- when you die in a FOB, notably, not nil, unk1 could be gameId of invader
      {argName="playerIndex",argType="gameId"}, -- will be 1 in FOB, sometimes?
      {argName="unk1",argType="number",argAlert=this.alertFuncs.notZero},
      {argName="unk2",argType="number",argAlert=this.alertFuncs.notZero},
      {argName="unk3",argType="number",argAlert=this.alertFuncs.notZero},
    },
    DemoSkipped={
      {argName="playerIndex",argType="gameId"},
    },
    DemoSkipStart={
      {argName="playerIndex",argType="gameId"},
    },
    DogBiteConnect={
      -- when a jackal/wolf/??? lunges at you and bites
      {argName="playerIndex",argType="gameId"},
      {argName="dogId",argType="gameId"}, --the dog that intitiated the attack
    },
    DirectMotion={--tex after Player.RequestToPlayDirectMotion is called  TODO clarify, is it called on anim start? anim end? is it called repeatedly for each animstage?
      {argName="animName",argType="str32"},
      {argName="animStage",argType="str32"},
      --[[
        usually, in order:
          Start
          ??? 1351137991
          PlayEnd
          End
      ]]
      {argName="isFinished",argType="number"},--boolAsNumber
      -- normally 0, only 1 for when "End" is fired
    },
    EndCarryAction={
      -- player forced to drop something (via death)
      {argName="playerIndex",argType="gameId"},
    },
    EnableCQC={
      -- when you get a prompt to CQC nearby targets
      {argName="playerIndex",argType="gameId"},
    },
    Enter={--tex mission zones
      {argName="zoneType",argType="str32"},--tex outerZone,innerZone,hotZone
    },
    Exit={
      {argName="zoneType",argType="str32"},--tex fallDeath
      -- hotZone
    },
    FinishMovingOnRoute={
      {argName="routeName",argType="str32"}, -- fires on SkullFace walk
    },
    FinishMovingToPosition={
      {argName="playerIndex",argType="str32"},
      {argName="state",argType="str32"}, -- fires in cyprus with just "failure"
    },
    FinishOpeningDemoOnHeli={
      {argName="playerIndex",argType="gameId"},
    },
    FinishReflexMode={
      {argName="playerIndex",argType="gameId"},
    },
    FireSkullFace={
      -- when on your back, firing at Volgin, probably other times as well
      {argName="playerIndex",argType="gameId"},
      {argName="unknown",argType="number",argAlert=this.alertFuncs.notZero},-- the times shot in sequence? 
    },
    GetIntel={ 
      -- fires during HELLBOUND
      -- begin intel scanning cutscene
      {argName="intelName",argType="str32"},
    },
    HostageUnlock={
      {argName="playerIndex",argType="gameId"},
      {argName="hostageId",argType="gameId"},
    },
    IconClimbOnShown={
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
      {argName="climbState",argType="number",argAlert=function(x) return x < 0 or x > 1 end},
      -- 0 = climbing down a crack
      -- 1 = climbing   up a crack
    },
    IconCrawlStealthShown={
      {argName="playerIndex",argType="gameId"},
      {argName="unknownId",argType="gameId",argAlert=this.alertFuncs.notNullId},-- appears as NULL_ID
    },
    IconFultonShown={--✅
      {argName="playerIndex",argType="gameId"},
      {argName="targetObjectId",argType="gameId"},
      {argName="isContainer",argType="boolAsNumber"},
      {argName="isNuclear",argType="boolAsNumber"},
    },
    IconMBCBoxShown={
      {argName="playerIndex",argType="gameId"},
    },
    IconOk={
      --when handing Paz the pictures, 
      {argName="purposeHash",argType="str32"},
      -- 3205930904???--thats str32 of "" an empty string
    },
    IconToiletOnShown={
      {argName="playerIndex",argType="gameId"},
      {argName="gimmickId",argType="gimmickId"},
      -- equal to NULL_ID when removing a body from the toilet
      -- equal to NULL_ID when carrying a body to the toilet, fires again & switches to toilet instance ID after loading body inside
    },
    IconRideHelicopterStartShown={
      {argName="playerIndex",argType="gameId"},
    },
    IconSwitchShown={
      {argName="playerIndex",argType="gameId"},
      {argName="gimmickId",argType="gimmickId"},
      {argName="locatorNameS32",argType="str32"},
      {argName="dataSetPath32",argType="dataSetPath32"},
    },
    IconTBoxOnShown={
      -- same carry conditions as IconToiletOnShown
      {argName="playerIndex",argType="gameId"},
      {argName="gimmickId",argType="gimmickId"},
    },
    IconWormholeOnShown={
      {argName="playerIndex",argType="gameId"},
      {argName="gimmickId",argType="gimmickId",argAlert=this.alertFuncs.notNullId},
      --ej always NULL_ID even if it is a prompt from the portable wormhole revive / the entry wormhole during scripted missions
    },
    IntelIconInDisplay={
      {argName="intelName",argType="str32"},
      {argName="unknown2",argType="number",argAlert=this.alertFuncs.any},
    },
    IntoWormhole={
      -- when player begins wormhole warp from helicopter
      -- anticipate subsequent OutFromWormhole
      {argName="playerIndex",argType="gameId"},
    },
    LandingFromHeli={
      {argName="playerIndex",argType="gameId"},
    },
    LookingTarget={
      {argName="locatorNameS32",argType="str32"},
      {argName="targetId",argType="gameId"},
    },
    MBTerminalSleep={--[2307345963] -- when player closes idroid
      {argName="playerIndex",argType="gameId"},--ej TODO VERIFY
    },
    NearVehicle={-- doesn't specify which vehicle
      {argName="playerIndex",argType="gameId"},
    },
    NotifyChangedPlayerRailAction={
      {argName="playerIndex",argType="gameId"},
      {argName="railAction",argType="number"}, --[[
        -1 = motion starts
        -2 = input stops / goal reached / generally one "step" forward (crawling)
      ]]
    },
    NotifyCyprusMotionEvent={
      {argName="playerIndex",argType="gameId"},
      {argName="notifyEventName",argType="str32"},
      --[[
        1170183343
        1168064913
        468438705  = MTEV_RAIL_ACTION_KNOCK_THE_CART_OVER
      ]]
    },
    OnAmmoLessInMagazine={
      {argName="playerIndex",argType="gameId"},
      {argName="belongsToPlayer",argType="number"},
      --0 primaryHip, 1 primaryBack, 2 secondary, 3 = item (grenade/etc)
      --boolAsNumber: 1 for DD weapon, 0 for found weapon, both yellow (chimera?)
      {argName="equipId",argType="equipId"},
      --873 for player sniper
      --24 for found KABARGA-83 (equipId:EQP_WP_Com_sg_020)
    },
    OnAmmoStackEmpty={
      -- identical arguments to OnAmmoLessInMagazine, please depend on that
      {argName="playerIndex",argType="gameId"},
      {argName="belongsToPlayer",argType="number"},
      -- slot 
      {argName="equipId",argType="equipId"}, -- TODO: find slot? WEAPONSLOT.HIP
    },
    OnBehind={
      {argName="playerIndex",argType="gameId"},
    },
    OnBinocularsMode={
      {argName="playerIndex",argType="gameId"},
    },
    OnClimb={--[2614541283]--Begin climbing crack
      {argName="playerIndex",argType="gameId"},--ej TODO VERIFY
    },
    OnComeOutSupplyCbox={
      -- individual item requested via development menu
      {argName="playerIndex",argType="gameId"},
    },
    OnCrawl={
      -- event fires whenever you enter crawl state,
      -- also fires every time the camera passes a threshold in a first-person crawl tunnel
      {argName="playerIndex",argType="gameId"},--ej assumed
    },
    OnElude={
      -- whenever you hop a fence
      {argName="playerIndex",argType="gameId"},
    },
    OnEquipHudClosed={
      {argName="playerIndex",argType="gameId"},
      {argName="equipId",argType="equipId"},
      {argName="equipType",argType="equipType"},
    },
    OnEquipItem={
      {argName="playerIndex",argType="gameId"},
      {argName="equipId",argType="equipId"},
    },
    OnEquipWeapon={
      {argName="playerIndex",argType="gameId"},
      {argName="equipId",argType="equipId"},
      {argName="slot",argType="number"},--tex TODO VERIFY, build lookup
    },
    OnInjury={
      {argName="playerIndex",argType="gameId"},
    },
    OnLadder={--[4225550632] --climbing a ladder, every tick there is a ladder input
      {argName="playerIndex",argType="gameId"},--ej TODO VERIFY
    },
    OnPickUpCollection={
      {argName="playerIndex",argType="gameId"},
      {argName="resourceId",argType="number"},--tex TODO
      {argName="resourceType",argType="resourceType"},
      {argName="langId",argType="str32"},
    },
    OnPickUpPlaced={
      {argName="playerIndex",argType="gameId"},
      {argName="equipId",argType="equipId"},
      {argName="itemIndex",argType="number"},--TODO
      {argName="isPlayers",argType="number"},--boolAsNumber
    },
    OnPickUpSupplyCbox={
      -- the kind that has a weapon inside
      {argName="playerIndex",argType="gameId"},
    },
    OnPickUpWeapon={
      {argName="playerIndex",argType="gameId"},
      {argName="equipId",argType="equipId"},
      {argName="pickupNumber",argType="number"},--blueprint number or casset number or ? VERIFY doesnt seem to directly match countRaw on the TppPickableLocatorParameter as arg3 was returning 60 for a rawcount 1
    },
    OnPipe={--[3136097041]
      -- no corresponding event for dismount
      {argName="playerIndex",argType="gameId"},
    },
    OnPlayerElude={
      -- whenever you hop a fence
      {argName="playerIndex",argType="gameId"},
    },
    OnPlayerGatling={
      {argName="playerIndex",argType="gameId"},
      {argName="gimmickId",argType="gameId"},
    },
    OnPlayerHeliHatchOpen={
      {argName="playerIndex",argType="gameId"},
    },
    OnPlayerMachineGun={
      {argName="playerIndex",argType="gameId"},
      {argName="gimmickId",argType="gameId"},
    },
    OnPlayerMortar={
      {argName="playerIndex",argType="gameId"},
      {argName="gimmickId",argType="gameId"},
    },
    OnPlayerPipeAction={
      {argName="playerIndex",argType="gameId"},
    },
    OnPlayerUseBoosterScope={ -- a weapon with two optical slots working together?
      {argName="playerIndex",argType="gameId"},
    },
    OnPlayerSearchLight={
      -- player begins operating search light
      {argName="playerIndex",argType="gameId"},
      {argName="gimmickId",argType="gameId"},
    },
    OnPlayerStaminaOut={
      {argName="playerIndex",argType="gameId"},
      {argName="isSelfInflicted",argType="boolAsNumber"},
    },
    OnPlayerToilet={
      {argName="playerIndex",argType="gameId"},
    },
    OnPlayerTrashBox={
      {argName="playerIndex",argType="gameId"},
    },
    OnRefresh={--[2766584503]
      -- 2nd event after entering a shower,
      -- also plays during the shower cutscene with quiet
      {argName="playerIndex",argType="gameId"},
    },
    OnVehicleDrive={
      {argName="playerIndex",argType="gameId"},
      {argName="vehicleId",argType="gameId"}, --2560X?
    },
    OnVehicleRide_Start={
      {argName="playerIndex",argType="gameId"},
      {argName="rideFlag",argType="number"},--0== get on, 1 == get off ?
      {argName="vehicleId",argType="gameId"},
    },
    OnWalkerGearDrive={
      {argName="playerIndex",argType="gameId"},
      {argName="walkerGearId",argType="gameId"},--BuddyWalkerGearGameObjectLocator or gameId
    },
    OutFromWormhole={
      -- fires after IntoWormhole
      {argName="playerIndex",argType="gameId"},
    },
    PlayerCatchFulton={
      -- fulton self-extraction?
      {argName="playerIndex",argType="gameId"},
    },
    PlayerCureComplete={
      -- fires when the cure is finished
      {argName="playerIndex",argType="gameId"},
    },
    PlayerCureCompleteMotEnd={
      -- fires after PlayerCureComplete when control regained
      {argName="playerIndex",argType="gameId"},
    },
    PlayerCureStart={
      -- fires after the QTE button pressed
      {argName="playerIndex",argType="gameId"},
    },
    PlayerDamaged={
      {argName="playerIndex",argType="gameId"},
      {argName="attackId",argType="attackId"},
      {argName="attackerId",argType="gameId"},
    },
    PlayerFulton={
      {argName="playerIndex",argType="gameId"},
      {argName="targetId",argType="gameId"},
    },
    PlayerFultoned={
      {argName="playerIndex",argType="gameId"},
      {argName="targetId",argType="gameId",argCanBeNil=true}, --[[
        was nil when self-fulton (non-wormhole)
        assumed: was equal to playerIndex when self-fulton container extraction (wormhole)
        was 6261210180837704 when extracted via resource similar to (gimmickInstanceOrAnimalId)
      ]]
      {argName="unknown1",argType="number",argAlert=this.alertFuncs.any}, --boolAsNumber --ej TODO VERIFY, assumed: was 1 when self-fulton container extraction (wormhole?)
      -- 1 when wormhole extracted on resource
      {argName="unknown2",argType="number",argAlert=this.alertFuncs.any}, --boolAsNumber --ej TODO VERIFY, assumed: was 0 when self-fulton container extraction (wormhole?)
      -- 0 when wormhole extracted on resource
    },
    PlayerHeliGetOff={
      {argName="playerIndex",argType="gameId"},
      {argName="departingHeliId",argType="gameId"},
    },
    PlayerHeliWarpToFobStart={
      {argName="playerIndex",argType="gameId"},
      {argName="departingHeliId",argType="gameId"}, -- the player's support heli
    },
    PlayerHoldWeapon={
      {argName="equipId",argType="equipId"},
      {argName="equipType",argType="equipType"},
      {argName="hasGunLight",argType="number"},--tex TODO: boolAsNumber?
      {argName="isSheild",argType="number"},
    },
    PlayerHurt={
      -- upon critical injuries
      {argName="playerIndex",argType="gameId"},
    },
    PlayerLifeLessThanHalf={
      {argName="playerIndex",argType="gameId"},
    },
    PlayerShowerEnd={
      {argName="playerIndex",argType="gameId"},
    },
    PlayerShowerStart={
      {argName="playerIndex",argType="gameId"},
    },
    PlayerSwitchStart={
      {argName="playerIndex",argType="gameId"},
      {argName="gimmickId",argType="gameId"},
    },
    PlayerTapCqc={
      {argName="playerIndex",argType="gameId"}, -- you, the player
      {argName="attackerId",argType="gameId",argAlert=this.alertFuncs.notZero}, -- could also be zero due to simlar reasons as below
      {argName="unk3",argType="number",argAlert=this.alertFuncs.notZero}, -- zero instead of nil
      {argName="unk4",argType="number",argAlert=this.alertFuncs.notZero}, -- zero instead of nil
    },
    PlayerTapHeadShot={
      {argName="gameId",argType="gameId"}, -- the victim (probably you)
      {argName="attackerId",argType="attackerId",argAlert=this.alertFuncs.notZero}, -- could also be zero due to simlar reasons as below
      {argName="attacker",argType="attackId"}, -- out of order from GameObject.HeadShot
      {argName="headshotMessageFlags",argType="headshotMessageFlags"},
    },
    PressedCarryIcon={
      {argName="playerIndex",argType="gameId"},
      {argName="targetId",argType="gameId"},
    },
    PressedFultonIcon={--✅
      {argName="playerIndex",argType="gameId"},
      {argName="targetObjectId",argType="gameId"},
      {argName="isContainer",argType="boolAsNumber"},
      {argName="isNuclear",argType="boolAsNumber"},
    },
    PressedFultonNgIcon={
      -- when you fill up the fulton hold action but you ain't got no fultons left
      {argName="playerIndex",argType="gameId"},
      {argName="targetId",argType="gameId"},
    },
    PutMarkerWithBinocle={
      {argName="x",argType="number"},
      {argName="y",argType="number"},
      {argName="z",argType="number"},
    },
    QuestStarted={
      {argName="questId",argType="str32"},
    },
    Respawn={
      -- fires after WarpEnd and UI.RespawnClose
      {argName="phaseName",argType="str32"},
      --[[
        Start
        End
      ]]
    },
    Ride_WalkerGear={ -- the one in HELLBOUND
      {argName="rideName",argType="str32"} -- "RideMetal"
    },
    RideHelicopter={
      {argName="playerIndex",argType="gameId"},
    },
    RideHelicopterWithHuman={
      -- for some reason does not even bother referencing the human
      {argName="playerIndex",argType="gameId"},
      {argName="heliId",argType="gameId"}, -- the helicopter?
    },
    RideOk={
      {argName="unknown1",argType="str32"},
    },
    SetMarkerBySearch={--tex object was marked by looking at it
      {argName="typeIndex",argType="typeIndex"},
    },
    SetWetEffect={
      {argName="playerIndex",argType="gameId"},
    },
    StartCarryIdle={
      {argName="playerIndex",argType="gameId"},
    },
    StartPlayerBrainFilter={--ej target hurts us a lot, TODO find out what that means
      {argName="playerIndex",argType="gameId"},
      {argName="targetId",argType="gameId"},
    },
    SuppressorIsBroken={
      {argName="playerIndex",argType="gameId"},
    },
    Volgin_Start={
      {argName="volgin",argType="str32"}, -- 1808862749:Volgin
    },
    WarpEnd={
      {argName="playerIndex",argType="gameId"},
    },
    WeaponPutPlaced={
      {argName="playerIndex",argType="gameId"},
      {argName="equipId",argType="equipId"},
    },
    ZombBiteConnect={
      {argName="playerIndex",argType="gameId"},
      {argName="zombieId",argType="gameId",argAlert=this.alertFuncs.notNullId}, -- i would assume it to be a zombie, but, is usually NULL_ID
    },
  },--Player
  Radio={
    EspionageRadioCandidate={
	    -- when you look at something that has a radio/call message
	    -- sometimes, the call message can be overridden by a mission and may not fire
      {argName="gameId",argType="gameId"},
      {argName="radioTargetId",argType="radioTargetId",argAlert=this.radioTargets.radioGapSeeker},
    },
    EspionageRadioPlay={
      -- when the radioTargetId is -1 (INVALID),
      -- this is what picks up from there to play the radio context?
      {argName="radioGroupName32",argType="str32"}, --ej TODO some sort of script
      {argName="targetId",argType="gameId"},
      {argName="radioTargetId",argType="radioTargetId",argAlert=this.radioTargets.radioGapSeeker},
    },
    Start={
      {argName="radioGroupName32",argType="str32"},--radioGroupName
      {argName="unk1",argType="number"},--tex UNKNOWN
    },
    Finish={
      {argName="radioGroupName32",argType="str32"},--radioGroupName
      {argName="unk1",argType="number"},--tex UNKNOWN
    },
  },--Radio
  Sound={
    ChangeBgmPhase={
      {argName="bgmPhase",argType="bgmPhase"},
    },
  },
  Subtitles={
    SubtitlesStartEventMessage={--tex no use cases, but looks the same as SubtitlesEndEventMessage
      {argName="speechLabel",argType="subtitleId"},
      {argName="status",argType="number"},--tex TODO
    },
    SubtitlesEndEventMessage={
      {argName="speechLabel",argType="subtitleId"},--TODO argType="subtitleId"-- TEST
      {argName="status",argType="number"},--tex TODO
    },
  },
  SupportAttack={
    OnRequested={
      -- only fired when requested via iDROID
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
      {argName="supportStrikeId",   argType="supportStrikeId"},
      -- if WEATHER_MODIFICATION, weather request type never specified here???) [always S rank?]
      {argName="gradeId",argType="gradeId"},
      },
  },
  Terminal={
    MbDvcActAcceptMissionList={
      {argName="missionId",argType="missionId"},
      {argName="unknown2",argType="number", argCanBeNil=true}, -- was 40 when responding to invasion
      {argName="unknown3",argType="number", argCanBeNil=true}, -- was 2 when responding to invasion

    },
    MbDvcActCallRescueHeli={
      -- MISSIONS > HELICOPTER > PICK UP
      {argName="gameId",argType="gameId"},--NULL_ID
      {argName="gameId",argType="gameId"},--calling player
    },
    MbDvcActCallBuddy={
      {argName="unk1",argType="number",argAlert=function(x) return x~=4 end},
      -- 2 = D-Dog upon deployment \
      -- 3 = Quiet
      -- 4 = D-Horse, dismounted me from him
      {argName="focusedGameId",argType="gameId",argAlert=this.alertFuncs.notZero}, --the player?!
      -- was 1 when deploying Quiet to scout a position
    },
    MbDvcActCloseTop=this.signatureTypes.none,
    MbDvcActFocusMapIcon={
      -- when we highlight something that DIRECTLY relates to a marked, existing gameobject
      -- including virtual ones like placed markers or predicted mines
      {argName="focusedGameId",argType="gameId"},
    },
    MbDvcActHeliLandStartPos={
      {argName="set",argType="number"},--boolAsNumber
      {argName="x",argType="number"},
      {argName="y",argType="number"},
      {argName="z",argType="number"},
    },
    MbDvcActOpenHeliCall=this.signatureTypes.none,
    MbDvcActOpenMenu=this.signatureTypes.none,
    MbDvcActOpenMissionList=this.signatureTypes.none,
    MbDvcActOpenStaffList=this.signatureTypes.none,
    MbDvcActOpenTop=this.signatureTypes.none,
    MbDvcActSelectAvatarMenu=this.signatureTypes.none,
    MbDvcActSelectCboxDelivery={
      {argName="gameId",argType="gameId"},-- the location the player was moved to
    },
    MbDvcActSelectItemDropPoint={
      -- equal to vars.supCboxEquipId == TppEquip.EQP_AB_PrimaryCommon (431)???
      {argName="equipId",argType="equipId",argAlert=function(x) return x ~= vars.supCboxEquipId end},
    },
    MbDvcActSelectLandPoint={
      {argName="nextMissionId",argType="number"},
      {argName="routeName",argType="str32"},--landingZone??
      {argName="layoutCode",argType="number"},
      {argName="clusterId",argType="number"},
    },
    MbDvcActSelectNonActiveMenu={
      -- i've only seen this during DIAMOND DOGS, fires when [NO IMAGE] visible 
      {argName="menuName",argType="str32"}, --MSN_DROP
    },
    MbDvcActTopModeMap=this.signatureTypes.none,
    MbDvcActTopModeMenu=this.signatureTypes.none,
    MbDvcActWatchPhoto={
      -- when you select a photo to look at during the menu
      {argName="photoId",argType="number",argAlert=function(x)return x~=255 end},
      -- 255 == no photo (during DIAMOND DOGS)
    },
  },--Terminal
  Throwing={
    NotifyStartWarningFlare={
      {argName="x",argType="number"},
      {argName="y",argType="number"},
      {argName="z",argType="number"},
      {argName="unknown4",argType="number",argAlert=function(x) return x ~= 1 end},
    },
  },
  Timer={
    Start={
      {argName="timerName",argType="str32"},
    },
    Finish={
      {argName="timerName",argType="str32"},
    },
  },
  TppSystem={
    NotifyCyprusTargetHit={
      {argName="targetName",argType="str32"},
      -- if you run into the fire during the leg break scene:
      -- offenceTarget_3f_0000
      -- offenceTarget_3f_0001 
      -- offenceTarget_1f_0002
      -- wall_0005
      -- wall_0006
    },
  },
  Trap={
    Enter={
      {argName="trapName",argType="str32"},--tex msg usually filtered by sender anyway, so only useful if passing trap name through to another function
      {argName="gameId",argType="gameId"},
    },
    Exit={
      {argName="trapName",argType="str32"},--tex msg usually filtered by sender anyway, so only useful if passing trap name through to another function
      {argName="gameId",argType="gameId"},
    },
  },
  UI={
    -- fires twice, has no corresponding Begin call other than Terminal.MbDvcActSelectAvatarMenu
    AvatarEditEnd=this.signatureTypes.ui,
    BonusPopupClose={
      {argName="popupId",argType="popupId"},
    },
    BonusPopupAllClose={
      {argName="popupId",argType="popupId"},
    },
    ConfigurationUpdated=this.signatureTypes.none, -- when you equip a chicken or chick hat
    Customize_End=this.signatureTypes.none,
    Customize_ChangePart={
      {argName="thingHash",argType="str32"},
      -- Customize_Target_Vehicle = mother base color selector
    },
    Customize_Start={
      {argName="thingHash",argType="str32"},
      -- Customize_Target_Vehicle = mother base color selector
    },
    CustomizeSelectorEnd=this.signatureTypes.none, -- exiting customizer
    DemoPauseSkip=this.signatureTypes.none,
    DispFobResultAtkGet=this.signatureTypes.ui,
    DispFobResultFobGet=this.signatureTypes.ui,
    -- when you get your ass kicked against an invader
    DispFobResultFobLost=this.signatureTypes.ui,
    DispFobResultWinlose=this.signatureTypes.ui,
    -- when you can retaliate against an invader
    DispFobResultWormHole=this.signatureTypes.ui,
    DisplayTimerLap={
      -- happens about once every second the stopwatch is visible
      {argName="timeRemaining",argType="number"},
      {argName="timeElapsed",argType="number"},
    },
    DisplayTimerTimeUp=this.signatureTypes.none,
    EmblemEditEnd=this.signatureTypes.ui,
    EndAnnounceLog=this.signatureTypes.none,
    EndDlcAnnounce={
      -- not actually sure why this has two args, usually only runs onceb
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
    },
    EndFadeOut={
      {argName="fadeInName",argType="str32"},
      {argName="unk1",argType="number"},--tex UNKNOWN
    },
    EndFadeIn={
      {argName="fadeInName",argType="str32"},
      {argName="unk1",argType="number"},--tex UNKNOWN
    },
    EndMissionTelopDisplay=this.signatureTypes.ui,
    EndMissionTelopFadeIn=this.signatureTypes.ui,
    EndMissionTelopFadeOut=this.signatureTypes.ui,
    EndMissionTelopHalfFadeOut=this.signatureTypes.ui,
    EndMissionTelopRadioStop=this.signatureTypes.ui,
    EndReloginSync=this.signatureTypes.ui,
    EndResultBlockLoad=this.signatureTypes.none,
    EndTelopCast=this.signatureTypes.ui,
    GameOverAbortMissionGoToAcc=this.signatureTypes.none,
    GameOverOpen={
      {argName="fadeInName",argType="str32"},
    },
    GameOverContinue={
      -- when i die and continue
      -- TODO:
      -- 1 & 0 during a singleplayer campaign death
      -- 0 & 0 during a singleplayer freeroam sideop death?
      -- 0 & 0 when died from fall damage in GNTN freeroam
      -- 1 & 0 when died from enemy truck running me over in GNTN freeroam
      {argName="isSelfInflicted",argType="boolAsNumber"},
      {argName="playerIndex",argType="gameId",argAlert=this.alertFuncs.notZero},
    },
    GameOverFadeIn={
      -- why is this number so fucking huge
      -- it is always matched up with the argument of "GameOverOpen"
      -- so maybe some variety 
      {argName="fadeInName",argType="str32"},
    },
    GameOverReturnToTitle=this.signatureTypes.none,
    HideTelopCast={--[117313536]
      {argName="creditHash",argType="str32"},--ej TODO VERIFY, may also be a hash for the position
      --[[
        CenterLarge
      ]]
    },
    MissionPreparationAbort=this.signatureTypes.none,
    MissionPreparationEnd=this.signatureTypes.none,
    MissionPrep_ChangeEditTarget={
      {argName="target",argType="str32"},
      -- MissionPrep_FocusTarget_None
      -- MissionPrep_FocusTarget_Weapon
        -- MissionPrep_FocusTarget_PrimaryWeapon
          -- MissionPrep_FocusTarget_PrimaryWeapon_HIP
          -- MissionPrep_FocusTarget_PrimaryWeapon_BACK
        -- MissionPrep_FocusTarget_SecondaryWeapon
          -- MissionPrep_FocusTarget_SecondaryWeapon_WEAPON
          -- MissionPrep_FocusTarget_SecondaryWeapon_ARM
        -- MissionPrep_FocusTarget_SupportWeapon
        -- MissionPrep_FocusTarget_Item
      -- MissionPrep_FocusTarget_Vehicle
      -- MissionPrep_FocusTarget_Player
      -- MissionPrep_FocusTarget_None
        -- MissionPrep_FocusTarget_BuddyHorsew
    },
    MissionPrep_ChangeItem=this.signatureTypes.none,
    MissionPrep_ChangeSlot=this.signatureTypes.none,
    MissionPrep_End={
      {argName="unknown1",argType="number",argCanBeNil=true,argAlert=this.alertFuncs.truthy}
    },
    MissionPrep_EndItemSelect=this.signatureTypes.none,
    MissionPrep_EndSlotSelect=this.signatureTypes.none,
    MissionPrep_EndSortieTimeSelect=this.signatureTypes.none,
    MissionPrep_EnterWeaponChangeMenu={
      {argName="target",argType="str32"},
      -- MissionPrep_FocusTarget_Player
    },
    MissionPrep_ExitWeaponChangeMenu=this.signatureTypes.none,
    MissionPrep_Start=this.signatureTypes.none,
    MissionPrep_StartEdit=this.signatureTypes.none,
    MissionPrep_StartItemSelect=this.signatureTypes.none,
    MissionPrep_StartSlotSelect=this.signatureTypes.none,
    MissionPrep_StartSortieTimeSelect=this.signatureTypes.none,
    --MissionPreparationAbort
    PauseMenuAbortMission=this.signatureTypes.none,
    PauseMenuAbortMissionGoToAcc=this.signatureTypes.none,
    PauseMenuCheckpoint=this.signatureTypes.none,
    PauseMenuGotoMGO=this.signatureTypes.ui,
    PauseMenuRestart=this.signatureTypes.none,
    PauseMenuRestartFromHelicopter=this.signatureTypes.none, --ej: how did i even do this, why does it distinguish a difference?
    PauseMenuReturnToTitle=this.signatureTypes.none,
    PopupClose={
      {argName="popupId",argType="popupId"},
      {argName="unk1",argType="number"},--tex UNKNOWN, haven't seen any value but 0 yet
    },
    PushEndLoadingTips=this.signatureTypes.none,
    QuestAreaAnnounceLog={
      {argName="questId",argType="questId"},--tex TODO questId to name lookup
    },
    QuestAreaAnnounceText={
      {argName="questId",argType="questId"},--tex TODO questId to name lookup
    },
    RequestPlayRecordClearInfo=this.signatureTypes.none,
    RespawnChange={
      -- FOB defense: respawn menu character selection index changes
      {argName="selectionIndex",argType="number"},--ej TODO verify?
      -- remainder: nil
    },
    RespawnClose={
      -- FOB defense: after a RespawnChange event fired
      {argName="unk1",argType="number"}, -- matches number from corresponding RespawnChange
      -- remainder: nil
    },
    SelectMGO={--[3775668277]--on title screen
      {argName="playerIndex",argType="gameId"}, --ej TODO VERIFY? not most of the UI events use playerIndex
    },
    ShowTelopCast={--[3188684021]
      {argName="creditHash",argType="str32"},--ej TODO VERIFY, may also be a hash for the position,
    },
    StartAnnounceLog={
      {argName="locationName",argType="str32"},
      -- CenterLarge
    },
    StartMGO=this.signatureTypes.ui, -- from the title screen
    StartTelopCast=this.signatureTypes.ui,
    StartMissionTelopBgFadeOut=this.signatureTypes.none,-- fires between StartMissionTelop(FadeIn|FadeOut)
    StartMissionTelopFadeIn=this.signatureTypes.none,
    StartMissionTelopFadeOut=this.signatureTypes.none,
    TelopTypingEnd=this.signatureTypes.none,
    TitleMenu={
      {argName="action",argType="str32"},
    },
    TitleMenuReady=this.signatureTypes.ui,
    TppEndingAllStaffFinish=this.signatureTypes.none,
    TppEndingFinish=this.signatureTypes.none, -- fires a second and third time after the mirror scene
    TppEndingHistoryFinish=this.signatureTypes.none,
    TppEndingHistoryStart=this.signatureTypes.none,
    TppEndingMainStaffFinish=this.signatureTypes.none,
    TppEndingMainStaffStart=this.signatureTypes.none,
    WorldMarkerAboutErase=this.signatureTypes.none,-- when you get into a yellow FOM during a mission
    WormHoleTimerTimeUp=this.signatureTypes.none,-- when the invader's wormhole is no longer available as a retreat target
  },--UI
  Weather={
    ChangeWeather={
      {argName="weatherType",argType="weatherType"},
    },
    Clock={
      {argName="sender",argType="str32"},
      {argName="time",argType="time"},
    },
    StartRain=this.signatureTypes.none,
    FinishRain=this.signatureTypes.none,
    WeatherForecast={
      {argName="weatherType",argType="weatherType"},
    },
  },
}--messageSignatures
--signatures where the sender or messageId str is unknown
--name is to give some idea of what the sender / messageId is about
this.messageAssumptions={
  Radio={
    messages={
      [2719725902]={
        name="DynamicRadioStart",
        signature={
          {argName="unk1",argType="str32"},--ej TODO VERIFY
          -- these clearly relate to some sort of radio sequence
          -- idk how they're different from the other telops

          -- example values:
          -- 2964234252 = lecture during mission 22 retake platform
          -- 187995122  = mission failure due to killing a MB staff before allowed on shining lights
          -- not related to hostages dying:
          -- 275624682  = when find masked soldier in shining lights 
          -- 2096570881 = keep exploring during shining lights
          -- 1334185636
        },
      },
      [1809879683]={
        -- called with the same argument as StaffDiedHostageKilled, usually 3-7 seconds later
        name="DynamicRadioEnd",
        signature={
          {argName="unk1",argType="str32"},--ej TODO VERIFY
        },
      },
    },
  },--Radio
  Terminal={
    messages={
      [1972763954]={
        name="MbDvcActHeliGoHere",
        signature=this.signatureTypes.none,
      },
      [2888288908]={
        name="MbDvcActHeliDismiss",
        signature=this.signatureTypes.none,
      },
      [1336082019]={
        name="PlayerHeliTaxiSelectedDestination",
        signature={
          {argName="unk1",argType="gameId"},--ej TODO VERIFY what is this why is it like this
          {argName="playerIndex",argType="gameId"},--ej TODO VERIFY
        }
      },
      [4275806845]={
        -- only after bombardment support via the idroid
        name="ImmediatelyAfterSelectingBombardmentSupport",
        signature={
          {argName="unk1",argType="number"},--ej TODO VERIFY 
          -- 1 = bombardment
          -- 3 = sleeping gas
          -- pretty much just indicates what happened
          -- must be some indirection for the inf-scope one?

        }
      },
    }
  },--Terminal
  MotherBaseManagement={
    messages={
      [4080112078]={
        -- 4 of these happened 3 seconds apart not sure what else it could be
        name="DeploymentCompleted",
        signature={
          {argName="playerIndex",argType="gameId"},--ej TODO VERIFY
        }
      },
      [497211464]={
        name="DevelopmentCompleted",
        signature={
          {argName="playerIndex",argType="gameId"},--ej TODO VERIFY
        }
      },
      [2865828198]={
        name="MotherBaseUpdate",
        signature={
          {argName="mbEventId",argType="number"},--ej TODO VERIFY: FIND SOME ENUM
          -- 2 = prisoner has died (sideop cancelled)?
          --[[
            1: extraction arrived at motherbase
            6: extraction received
            5: sideop list updated
          ]]
        }
      },
      [1625350245]={
        name="MotherBaseEvents",
        signature={
          {argName="unk1",argType="guess"},--ej TODO VERIFY
          {argName="unk2",argType="guess"},--ej TODO VERIFY
          {argName="unk3",argType="guess"},--ej TODO verify
          {argName="unk4",argType="guess"},--ej TODO VERIFY
        }
      }
    }
  },--MotherBaseManagement
  Network={
    messages={
      [3581811033]={
        name="NetworkUpdate",
        signature={
          {argName="unk1",argType="number"},--ej TODO VERIFY
          {argName="unk2",argType="number"},--ej TODO VERIFY
          {argName="unk3",argType="number"},--ej TODO verify
        },
      },
    },
  },
  Nt={
    messages={
      [2334271666]={
        name="NtUpdate",
        signature={
          {argName="unk1",argType="number"},--ej TODO VERIFY
          {argName="unk2",argType="number"},--ej TODO VERIFY
          {argName="unk3",argType="number"},--ej TODO verify
          --[[
            during FOB invasion begin:
            0 & 0 & 1
            1 & 1 & 0

          ]]
        },
      },
    },
  },
  SupplyCbox={
    messages={
      [3768843497]={ 
        -- when the box becomes a real one and explodes into supplies
        name="DeliveryBoxResupplyCreated",
        signature={
          {argName="boxGameId",argType="gameId"},--ej TODO VERIFY
        },
      },
      [2414690884]={ 
        -- when the box is solid and you have to climb inside
        name="DeliveryBoxWeaponOrLoadoutCreated",
        signature={
          {argName="boxGameId",argType="gameId"},--ej TODO VERIFY
        },
      },
    },
  },
  GameObject={
    messages={
      [313390177] = {
        -- sometimes fired without CqcGunSteal ever firing?
        name="CqcGunStolen",
        signature={
          {argName="victimId",argType="gameId"},
          {argName="slot",argType="number"}, --ej TODO VERIFY
        }
      },
      [3311396607]={ -- when the soldier does anything other than tell you to fuck off
        name="InterrogateSoldierEnd",
        signature={
          {argName="soldierId",argType="gameId"},
        },
      },
      [2185647124]={ -- shoot a bird and make them fall out of the sky
        name="BirdDisabled",
        signature={
          {argName="birdId",argType="gameId"},
          {argName="distanceFromPlayer",argType="number"}, --ej TODO VERIFY
        },
      },
    }
  },--GameObject
  Demo={
    messages={
      [993613272]={
        name="AfterWhereDoTheBeesSleep",
        signature=this.signatureTypes.demoSimple,
      },
      [1560936471]={
        name="DuringAfricaFacility",
        signature=this.signatureTypes.demoSimple,
      },
      [580071290]={
        name="DuringAfricaFacility2",
        signature=this.signatureTypes.demoSimple,
      },
    },
  },--Demo
  UI={
    messages={
      [3548619023]={
        -- fires directly after TppEndingMainStaffFinish
        name="TppEndingMainStaffSomething2",
        signature=this.signatureTypes.none,
      },
      [1534855474]={
        name="MissionPrep_EnteringIntoFOBSelectEquipment",
        signature=this.signatureTypes.none,
      },
      [1896534743]={
        name="MissionPrep_ExitingOutFromFOBSelectEquipment",
        signature=this.signatureTypes.none,
      },
      [1946843289]={
        name="EndTelopDownloadGzRecruitsAndShowAnimalsWeCaught ",
        signature={
          {argName="playerIndex",argType="gameId"},--ej TODO VERIFY, may also be a hash for the position
        },
      },
      [948921710]={
        name="Customize_StartSlotSelect",
        signature={
          {argName="purposeHash",argType="str32"},--ej TODO VERIFY
          -- for base customization: Customize_Target_Vehicle
          -- for d-walker: arg0=4175754393
          -- for d-dog: Customize_Target_BuddyDog
        },
      },
      [399331582]={
        -- fires after Customize_ChangePart, entering into the menu399331582
        name="Customize_ChangeEditTarget",
        signature={
          {argName="purposeHash",argType="str32"},--ej TODO VERIFY
        },
      },
      [1809607257]={
        -- fired at the end of most customization sessions (D-Dog, Mother Base)
        name="Customize_EndItemSelect",
        signature={
          {argName="purposeHash",argType="str32"},--ej TODO VERIFY
          -- for base customization: Customize_Target_Vehicle
        },
      },
      [2281090964]={
        -- probably something to do with setting the next UI popup confirmation, same as TitleScreenHighlightMetalGearOnline
        name="TitleScreenUnhighlightMetalGearOnline",
        signature={
          {argName="playerIndex",argType="gameId"}, --ej TODO VERIFY? not most of the UI events use playerIndex
        },
      },
      [4107358660]={
        name="DispFobResultGmpGet",
        signature={
          {argName="playerIndex",argType="gameId"}, --ej TODO VERIFY? not most of the UI events use playerIndex
        },
      },
      [3956781774]={
        name="DispFobResultHeroismGet",
        signature={
          {argName="playerIndex",argType="gameId"}, --ej TODO VERIFY? not most of the UI events use playerIndex
        },
      },
      [1527893626]={
        name="DispFobResultEspionageScoreGet",
        signature={
          {argName="playerIndex",argType="gameId"}, --ej TODO VERIFY? not most of the UI events use playerIndex
        },
      },
      [1684944454]={
        name="DispFobResultMissionScore",
        signature={
          {argName="playerIndex",argType="gameId"}, --ej TODO VERIFY? not most of the UI events use playerIndex
        },
      },
    },
  },--UI
  Player={
    messages={
      [1061149313]={
        -- machete cqc disarm counter:
          -- the front stab, back-elbow maneuver
          -- the air-drop slice, 
          -- the air-drop slice [with pipe]
        name="CqcLiquidEvade",
        signature={
          {argName="playerIndex",argType="gameId"},
          {argName="gameId",argType="gameId"}, -- the liquid
        },
      },
      [3205930904]={--tex this is weird, 3205930904 is str32 "" an empty string
        name="WhatHappenedHere",
        signature={
          {argName="playerIndex",argType="gameId"},
        },
      },
      [2987965439]={
        -- plays during snap to helicopter first person
        name="OnFirstPerson",
        signature={
          {argName="playerIndex",argType="gameId"},
        },
      },
      [1419934966]={
        -- fires every time the player enters a NgIcon trap volume
        name="PlayerCheckEventDoorNgIconFail",
        signature={
          {argName="playerIndex",argType="gameId"},
        },
      },
      [838860623]={
        -- fires when the player is granted input prior to opening the helicopter door
        -- and again after pressing the wormhole prompt
        name="PlayerAllowInputFOBIntro",
        signature={
          {argName="playerIndex",argType="gameId"},
          {argName="unknownGameId",argType="gameId"},--usually NULL_ID
        },
      },
      [3691348800]={
        -- 2nd event after entering a shower,
        -- also plays during the shower cutscene with quiet
        name="OnPlayerShower",
        signature={
          {argName="playerIndex",argType="gameId"},
        },
      },
      [583818078]={
        -- when you initially light up the time cigarette
        name="TimeCigaretteBegin",
        signature={
          {argName="playerIndex",argType="gameId"},
        },
      },
      [3367663002]={
        -- when the time speed up effect begins after the camera zoom
        name="TimeCigaretteSpeedupStart",
        signature={
          {argName="playerIndex",argType="gameId"},
        },
      },
      [1144333753]={
        -- when you press the button to unequip the cigarette
        name="TimeCigaretteCancel",
        signature={
          {argName="playerIndex",argType="gameId"},
        },
      },
      [32226917]={
        -- ui reactivating after using time cigarette
        name="TimeCigaretteComplete",
        signature={
          {argName="playerIndex",argType="gameId"},
        },
      },
      [1076192754]={
        name="PlayerSitIdleInHelicopterMotherBase",
        signature={
          {argName="playerIndex",argType="gameId"},
        },
      },
      [4119053966]={
        -- fired when you have control after being pounced, in regular time, when you finally kick a jackal off of you
        -- D-Dog also can provoke this when he protects you
        name="JackalFoughtOffPlayer",
        signature={
          {argName="playerIndex",argType="gameId"},
          {argName="jackalId",argType="gameId"},
        },
      },
      [2533923076]={
        -- fired right when a jackal lunges at you
        -- reflex/slowmo only happens the first time
        name="JackalPouncePlayer",
        signature={
          {argName="playerIndex",argType="gameId"},
          {argName="jackalId",argType="gameId"},
        },
      },
      [3073853049]={
        -- fired with boardStatus = 0 upon entry
        -- fired with boardStatus = 1 upon exit
        name="BoardWalkerGear", 
        signature={
          {argName="playerIndex",argType="gameId"},
          {argName="boardStatus",argType="number"},
          --0 == begin
          --1 == complete
        },
      },
      [4117713728]={
        -- fired with exitStatus = 0 and then exitStatus = 1 within a frame of each-other
        -- fired with exitStatus = 0 on the same frame as BoardWalkerGear(..., 1)
        name="ExitWalkerGear",
        signature={
          {argName="playerIndex",argType="gameId"},
          {argName="exitStatus",argType="number"},
          --0 == begin
          --1 == complete
        },
      },
      [2311886128]={ --ej TODO VERIFY
        -- either the 3/4th health warning 
        -- or just the red damage indicator
        name="HideDirectionalDamageIndicatorRed",
        signature={
          {argName="playerIndex",argType="gameId"},
        },
      },
      [2819912508]={
        name="CqcMacheteBackstab",
        signature={
          {argName="playerIndex",argType="gameId"},-- the player
          {argName="victimId",argType="gameId"}, -- usually a Skull 
        },
      },
      [221977019]={
        name="CqcChainThrow",
        signature={
          {argName="playerIndex",argType="gameId"},--ej TODO verify
          {argName="sequenceCount",argType="number"},-- fires for the first time at 1, as the 2nd person thrown
          {argName="victimId",argType="gameId"},--ej TODO VERIFY
        },
      },
      [3169422578]={
        -- CQC close range notice reflex, for when you enter range of a
        -- wandering puppet to notice you
        name="CqcWanderingPuppetChargeBegin",
        signature={
          {argName="playerIndex",argType="gameId"},--ej TODO VERIFY
          {argName="victimId",argType="gameId"},--ej usually 65535
        },
      },
      [3434378852]={
        -- if the prompt for CqcWanderingPuppetChargeBegin is hit successfully
        -- may only applied to wandering puppets
        name="CqcRightHookPunch",
        signature={
          {argName="playerIndex",argType="gameId"},--ej TODO VERIFY
          {argName="victimId",argType="gameId"},--ej usually 65535
        },
      },
      [545199978]={
        name="CqcStealGun",
        signature={
          {argName="playerIndex",argType="gameId"},--ej TODO VERIFY
          {argName="victimId",argType="gameId"},--ej TODO VERIFY
        },
      },
      [2990447840]={ --when player opens idroid
        name="PlayerMbDvcOpen",
        signature={
          {argName="playerIndex",argType="gameId"},--ej TODO VERIFY: sometimes a 2nd argument that is 1
        },
      },
    }
  }--Player
}--messageAssumptions

--tex actually add the message names to strcode32 lookup since there's some messages only subscribed in specific missions, but still called all the time
--note: this will still only catch those you have a signature for, so the actual solution is to throw strings from mgsv-lookup-strings repo (ex tpp-lua.txt) into mod\strings 
for objectType, messages in pairs(this.messageSignatures)do
  InfCore.StrCode32(objectType)
  for messageName, messageArgs in pairs(messages) do
    InfCore.StrCode32(messageName)--tex adds to InfCore.str32ToString which is verified strcode lookups
  end
end

for objectType, messages in pairs(this.messageSignatures)do
  if type(objectType)~="number" then
    InfCore.StrCode32(objectType)
  end
  for messageName, messageArgs in pairs(messages) do
    if type(messageName)~="number" then
      InfCore.StrCode32(messageName)
    end
  end
end

-- all these messages kill logging by writing too often
this.bannedIdentities = {
  -- line noise
  "UI.EndAnnounceLog",
  "Subtitles.SubtitlesStartEventMessage",
  "Subtitles.SubtitlesEndEventMessage",

  -- runs too many times per tick
  "UI.DisplayTimerLap",
  "Player.PlayerLifeLessThanHalf",
  -- trip a false positive about nil values and signatures
  "UI.StartAnnounceLog",
}

this.watchedIdentities = {
  "MotherBaseManagement?.MotherBaseEvents?",
  "Terminal.MbDvcActOpenTop",
}

local function serType(dat)
  local t = type(dat)
  if t == "string" then
    return "\""..tostring(dat).."\""
  elseif t == "number" then
    return string.format("%.f",dat)
  elseif t == "nil" then
    return "nil"
  else
    return "/!\\HELP:"..tostring(dat)
  end
end
--treats args as varargs, even though the rest of the existing uses are pretty solid with the contract
--works out because there's no strLogText like rest of OnMessage calls in TppMain.OnMessage to mess up the lua varargs magic 
--TODO: give example of printed messages / document legendize stuff (like the ! and ? for unknown/assumption messages)
--StringifyArg already has its output documented
--tex since the way messageExecTables are set up to eat the origin/only provide the reciever functions, 
--reciever only for debugMessages modes DEBUGMODULE,ALL_RECIEVERS, ie will be nil for ALL_SENDERS (the original On mode)
function this.PrintOnMessage(recievers,sender,messageId,...)
  --InfCore.PCall(function(sender,messageId,...)--DEBUG
  local senderStr=this.StrCode32ToString(sender,true)
  local messageIdStr=this.StrCode32ToString(messageId,true)
  local assSenderStr = senderStr
  local assMessageIdStr = messageIdStr

  if type(senderStr)=="number" then
    assSenderStr = "["..tostring(senderStr).."]/!\\"
    --InfCore.Log("InfLookup.PrintOnMessage: Unknown sender: "..senderStr)
    InfCore.unknownMessages[senderStr]=InfCore.unknownMessages[senderStr] or {}
    InfCore.unknownMessages[senderStr][messageIdStr]=true
  end
  if type(messageIdStr)=="number" then
    assMessageIdStr = "["..tostring(assMessageIdStr).."]/!\\"
    --InfCore.Log("InfLookup.PrintOnMessage: Unknown messageId: "..messageIdStr)
    InfCore.unknownMessages[senderStr]=InfCore.unknownMessages[senderStr] or {}
    InfCore.unknownMessages[senderStr][messageIdStr]=true
  end

  local senderSignatures=this.messageSignatures[senderStr]
  if senderSignatures then
    local signature=senderSignatures[messageIdStr]

    if signature then
      this.PrintMessageSignature(recievers,senderStr,messageIdStr,signature,...)
      return
    end
  end
  
  local assumption=this.messageAssumptions[senderStr]
  if assumption then
    if assumption.name ~= nil and assSenderStr ~= assumption.name then
      assSenderStr = assumption.name.."/?\\"
    end

    local assumptionMessage=assumption.messages[messageIdStr]
    if assumptionMessage then
      if assumptionMessage.name ~= nil and assMessageIdStr ~= assumptionMessage.name then
        assMessageIdStr = assumptionMessage.name.."/?\\"
      end

      local assumptionSignature=assumptionMessage.signature
      this.PrintMessageSignature(recievers,assSenderStr,assMessageIdStr,assumptionSignature,...)
      return
    end
  end

  this.PrintMessageSignature(recievers,assSenderStr,assMessageIdStr,nil,...)
  --end,sender,messageId,arg0,arg1,arg2,arg3)--DEBUG
end

function this.StringifyArg(arg, argDef)
  local argDat = tostring(serType(arg))
  local argTypeDat = ""
  local postComments = {}

  -- argTypeDat samples: --[[ /!\ argName:typeName:lookupValue]]
  -- type names match:   --[[argName:~:lookupValue]]
  -- no lookup return:   --[[argName:typeName:~]]
  if argDef then
    local lookupValue=this.Lookup(argDef.argType,arg)
    argTypeDat = argTypeDat .. "--[["

    if argDef.argAlert and argDef.argAlert(arg) then
      argTypeDat = argTypeDat .. " /!\\ "
      --table.insert(postComments, "alert triggered")
    end
    if argDef.argName then
      argTypeDat = argTypeDat .. tostring(argDef.argName)
    end
    argTypeDat = argTypeDat .. ":"
    if argDef.argType then
      argTypeDat = argTypeDat .. ((argDef.argName~=argDef.argType) and tostring(argDef.argType) or "~")
      if argDef.argCanBeNil then
        argTypeDat = argTypeDat .. "?"
      end
    end
    argTypeDat = argTypeDat .. ":"
    if lookupValue then
      argTypeDat = argTypeDat .. ((tostring(lookupValue)~=tostring(arg)) and tostring(lookupValue) or "~")
    end
    argTypeDat = argTypeDat .. "]] "
  end

  if (argDef and argDef.argType == "guess") or (argDef == nil) then
    local guess = this.GuessArgType(arg)
    if guess ~= "nil" then
      table.insert(postComments, "typeguess: " .. guess)
    end
  end

  return argTypeDat .. argDat, postComments
end
--tex just attempt to throw a bunch of lookups at the args
--most times they won't be right, but when it does can let you figure out what the arg is
function this.GuessArgType(arg)
  local argValue=""

  if type(arg)=="number" then
    local lookupReturns={}--tex possible number/id collisions, so return all
    lookupReturns[#lookupReturns+1]=arg
    --tex KLUDGE too many collisions on low numbers, pretty arbitrary cut-off point though.
    for lookupType,_ in pairs(this.lookups) do
      --local lookup=this.lookups[lookupType]
      local lookupReturn = this.Lookup(lookupType, arg)
      if lookupReturn then
        lookupReturns[#lookupReturns+1] = lookupType..":"..lookupReturn
      end
    end

    local addSeperator=#lookupReturns>1
    for lookupReturnIndex,lookupReturn in ipairs(lookupReturns) do
      if addSeperator and lookupReturnIndex>1 then
        argValue=argValue.."||"
      end
      argValue=argValue..lookupReturn
    end

    if not addSeperator then
      argValue=serType(arg)
    end
  else
    argValue=serType(arg)
  end

  return argValue
end
--CULL pre ej rework
--[[
function this.PrintMessage(senderStr,messageIdStr,...)
  local lookupTypes={
    "str32",
    "gameId",
    "typeIndex",
    "attackId",
    "damageSource",
    "equipId",
    "equipType",
  --"time",
  }

  local hasArgs=true
  local argsString=""
  for i=1,select("#",...) do
    local arg = select(i,...)
    local argNum=i-1
    --local argPreStr="arg"..argNum.."="
    

    

    argsString=argsString..argPreStr..argValue..", "
  end

  local messageInfoString="OnMessage|sender: "..senderStr..", messageId: "..messageIdStr
  if hasArgs then
    messageInfoString=messageInfoString..", (no signature): "..argsString
  else
  end
  InfCore.Log(messageInfoString)
end
]]

function this.PrintMessageSignature(recievers,senderStr,messageIdStr,signature,...)
  local identity = senderStr .. "." .. messageIdStr
  if InfUtil.FindInTable(this.bannedIdentities, identity) then return end

  local noSignature = signature == nil
  if noSignature then signature = {} end

  local argLimit = math.max(select("#",...), select("#",signature))
  local argStrings={}
  local postComments={}
  local foundArgs = 0
  for i=1, argLimit do
    local arg = select(i,...)
    local argDef=signature[i]
    if argDef ~= nil then foundArgs = foundArgs + 1 end

    local argIdent = argDef and argDef.argName or "unnamed"..tostring(i)

    if arg==nil and argDef ~= nil and (not argDef.argCanBeNil) then
      -- novelty: we don't have any documented sometimes-nil arguments; nil arg, has def
      table.insert(postComments, "/!\\ arg "..argIdent.." had definition, occured as nil without being marked")
    elseif arg~=nil and argDef == nil and (not noSignature) then
      -- we should raise some alarms; value arg, no def
      table.insert(postComments, "/!\\ arg "..argIdent.." missing definition")
    end
    -- else (this is anticipated): (arg~=nil and argDef ~= nil) or (arg==nil and argDef == nil)

    -- prefix all the arguments for an easier time jumping to them
    local argsString, postCommentAdditions = this.StringifyArg(arg, argDef)
    for _, postCommentAddition in ipairs(postCommentAdditions) do
      postComments[#postComments+1] = "/!\\ arg "..argIdent.." "..postCommentAddition
    end

    table.insert(argStrings, argsString)
  end

  -- additional checks
  if foundArgs > 4 then
    table.insert(postComments, "/!\\/!\\/!\\ goldrush, found command with more than the standard argument amount")
  end
  if noSignature then
    table.insert(postComments, "/!\\ new identity")
  end

  local postComment = (#postComments>0 and " --[[ " .. table.concat(postComments, "; ") .. " ]]") or ""
  local messageInfoString = identity .. "(" .. table.concat(argStrings, ", ") .. ")" .. postComment
  local badge = ""
  --tex TODO: something more performant
  -- if string.find(messageInfoString, "/!\\") then
  --   badge = "/!\\"
  -- elseif string.find(messageInfoString, "/?\\") then
  --   badge = "/?\\"
  -- elseif InfUtil.FindInTable(this.watchedIdentities, identity) then
  --   badge = "<o>"
  -- end

  local recieverString="None"
  if type(recievers)=='table'then
    if #recievers>0 then
      recieverString=table.concat(recievers,", ")
    end
  end--if recievers
  --tex was: OnMessage[".. badge .. "]:
  InfCore.Log("OnMessage[".. recieverString .. "]: " .. messageInfoString)
end--PrintMessageSignature

function this.OnShowAnnounceLog(announceId,param1,param2)
  if Ivars.debugMessages:Is(1) then
    local langId=TppUI.ANNOUNCE_LOG_TYPE[announceId]
    InfCore.Log("InfLookup.OnShowAnnounceLog: langId="..tostring(langId)..", param1="..tostring(param2)..", param2="..tostring(param2))
    --InfCore.StrCode32(langId) --tex would allready be in there from InfStrCode lua scrape
  end
end

--CALLER: PostAllModulesLoad
function this.AddObjectNamesToStr32List()
  if InfCore.debugMode then
    InfCore.Log"InfLookup.AddObjectNamesToStr32List:"
    for listName,list in pairs(this.objectNameLists) do
      if type(list[1])=="table" then
        for i,objectName in ipairs(list[1]) do
          InfCore.StrCode32(objectName)
        end
      else
        for i,objectName in ipairs(list) do
          InfCore.StrCode32(objectName)
        end
      end
    end
  end
end

--IN/SIDE: this.dictionaries
function this.BuildDictionaryLookup(name,lookupTable)
  InfUtil.ClearTable(lookupTable)

  local dictionaryPath=InfCore.paths.mod..[[\strings\]]..this.dictionaries[name].fileName
  local lines=InfCore.GetLines(dictionaryPath)
  if lines==nil then
    InfCore.Log("WARNING: InfLookup.BuildDictionaryLookup: could not load "..this.dictionaries[name].fileName)
    return
  end
  local HashFunction=this.dictionaries[name].HashFunction
  for i,str in ipairs(lines) do
    local hash=HashFunction(str)--tex is just StrCode32, but whatevs
    if (lookupTable[hash]) then
      InfCore.Log("WARNING: InfLookup.BuildDictionaryLookup("..name.."): collision for hash:"..hash.." between "..str.." and "..lookupTable[hash])
    end
    lookupTable[hash]=str
  end
end
--CALLER: PostAllModulesLoad
function this.LoadGameObjectNames()
  InfCore.LogFlow("InfLookup.LoadGameObjectNames")

  local dictionaryPath=InfCore.paths.mod..[[\strings\]].."IHStringsGameObjectNames.txt"
  local lines=InfCore.GetLines(dictionaryPath)
  if lines==nil then
    InfCore.Log("LoadGameObjectNames: could not load IHStringsGameObjectNames.txt")
  else
    InfCore.Log("LoadGameObjectNames: Adding IHStringsGameObjectNames to gameObjectNames")
    for i,gameObjectName in ipairs(lines)do
      this.gameObjectNames[gameObjectName]=true
    end
  end
  
  if this.debugModule then
    InfCore.PrintInspect(this.lookups,"InfLookups.lookups")
    --InfCore.PrintInspect(this,"InfLookups")--DEBUGNOW
  end
end
--CALLER: InfMain.OnIntializeTop, since it needs gameobjects to have been loaded
--Actual names (re)loaded in PostAllModulesLoad
function this.BuildGameIdToNames()
  InfUtil.ClearTable(InfCore.gameIdToName)--tex clear since different gameIds/mapped differently each level
  for listName,list in pairs(this.objectNameLists) do
    local objectName
    --tex {{nameList},"objectType"}
    if type(list[1])=="table" then
      list=list[1]
    end
    for i,gameObjectName in ipairs(list)do
      InfCore.GetGameObjectId(gameObjectName)--tex
    end
  end

  InfCore.Log("BuildGameIdToNames: Adding gameObjectName to InfCore.gameIdToName")
  for gameObjectName,bool in pairs(this.gameObjectNames)do
    InfCore.GetGameObjectId(gameObjectName)--tex adds to InfCore.gameIdToName
  end
  if this.debugModule then
    InfCore.PrintInspect(InfCore.gameIdToName,"InfCore.gameIdToName")
  end
end

function this.BuildSoldierSvarIndexes()
  InfCore.LogFlow("InfLookup.BuildSoldierSvarIndexes:")
  InfUtil.ClearTable(this.soldierSvarIndexes)
  local soldierNames={}


  if mvars.ene_soldierDefine then
    for cpName,cpDefine in pairs(mvars.ene_soldierDefine)do
      for i,soldierName in ipairs(cpDefine)do
        soldierNames[Fox.StrCode32(soldierName)]=soldierName
      end
    end
  end
  
  local fmt="sol_quest_%04d"
  local num=8
  for i=0,num-1 do
    local soldierName=string.format(fmt,i)
    soldierNames[Fox.StrCode32(soldierName)]=soldierName
  end

  --TODO: + reserve?

  --InfCore.PrintInspect(soldierNames,"soldierNames")--DEBUG

  for i=0,mvars.ene_maxSoldierStateCount-1 do
    local soldierNameStr32=svars.solName[i]
    if soldierNameStr32>0 then
      this.soldierSvarIndexes[soldierNameStr32]=i
    end
  end
  if this.debugModule then
    InfCore.PrintInspect(this.soldierSvarIndexes,"soldierSaveIndexes")
  end
end

function this.DumpValidStrCode()
  local ins=InfInspect.Inspect(InfCore.str32ToString)
  InfCore.Log(ins)--TODO dump to seperate file
end

function this.PrintStatus(gameId)
  InfCore.Log("PrintStatus "..tostring(gameId))
  local status=GameObject.SendCommand(gameId,{id="GetStatus"})
  local lifeStatus=GameObject.SendCommand(gameId,{id="GetLifeStatus"})
  InfCore.Log("status:"..tostring(status).." lifeStatus:"..tostring(lifeStatus))
end--PrintStatus

return this
