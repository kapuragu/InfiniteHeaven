-- InfSoldierFaceAndBody.lua
-- extends Soldier2FaceAndBodyData face fovas and definitions / vars.playerFaceId, enemy and staff faceIds

-- extends Soldier2FaceAndBodyData eneny body fovas and bodyIds--TODO: split out body stuffto InfSoldierBod
-- See also InfBodyInfo

-- SYNC: DEBUGNOW to some external document explaining fova addons (collate this, Solder2FaceAndBodyData, InfBodyInfo comments, and the mgo head, us ih body addon stuff)
-- Loads addons in \mod\fovaInfo which add face or body fova entries to Solder2FaceAndBodyData
-- TODO split this too?
-- See: Mgo headgear fova mod r1
-- and: US Soldier - IH body addon (or caplags version)
-- on the IH nexus page for working examples
-- Soldier entities enemies and staff on mb (but not when playing that staff) use body addon, which can also used for customSoldierType ((see the IH body addon example and modules/InfBodyInfo.lua)
--tex: these functions are kinda verbose in debugMode so developers can debug their fova addons
--LIMIT GOTCHA: There seems to be a limit to the number of additions for body fovas, which manifests in fovas past that not applying
--dont know if its for bodyDefinition or bodyFova count though.
--seems to be vanilla count + 64 = 366
--TODO: figure out what limits to the other entries are
--TODO: when fv2 random variation is figured out could crush down the FATIGUES_CAMO_MIX from ~60 to just 1, or a few similar sets

local this={}

--STATE
this.debugModule=false

--tex: headFova (these lua files, in mod\fovaInfo) notes:
--headDefinitions: IH uses each entry to either modifiy or add a new faceDefinition in Solder2FaceAndBodyData .faceDefinition
--(https://github.com/TinManTex/mgsv-deminified-lua/blob/master/data1/Assets/tpp/level_asset/chara/enemy/Soldier2FaceAndBodyData.lua)
--headDefinition > faceDefinition support is not complete as there's a bunch of unknown vars

--overwriteFaceId will only overwrite supplied vars, the rest of the var will default to the values of the face you are overwriting.
--Due to that, if you need to set faceFova, faceDecoFova, hairFova or hairDecoFova to empty/off set them to EnemyFova.INVALID_FOVA_VALUE
--New face (non overwriteFaceId) entries will default to INVALID_FOVA_VALUE for any of the above mention *Fova vars you omit.

--Using the faceId in code: New faces are given an incremental faceId depending on the order the headFovas are loaded,
--which means you can't really guarantee on a static, persistant faceId since you don't know what headFovas your user might have installed.
--You can however get the faceId assigned for the game session using TppEnemyFaceId.<head definition entry name>

--See mod\modules\InfSoldierFaceAndBody.lua when IH is installed for the implementation of the system and the newest version of these notes.

--REF mod\fovaInfo\example_head_fovaInfo - adding head/faces
--local this={
--  faceFova={
--    {"/Assets/tpp/fova/common_source/chara/cm_head/face/example_face1.fv2","/Assets/tpp/pack/fova/common_source/chara/cm_head/face/example_face1.fpk"},
--  },
--  faceDecoFova={
--    {"/Assets/tpp/fova/common_source/chara/cm_head/face_deco/example_faceDeco1.fv2","/Assets/tpp/pack/fova/common_source/chara/cm_head/face_deco/example_faceDeco1.fpk"},
--  },
--  hairFova={
--    {"/Assets/tpp/fova/common_source/chara/cm_head/hair/example_hair1.fv2","/Assets/tpp/pack/fova/common_source/chara/cm_head/hair/example_hair1.fpk"},
--  },
--
--  hairDecoFova={
--    {"/Assets/tpp/fova/common_source/chara/cm_head/hair_deco/example_hairDeco1.fv2","/Assets/tpp/pack/fova/common_source/chara/cm_head/hair_deco/example_hairDeco1.fpk"},
--  },
--
--  headDefinitions={
--    example_head1={--TppEnemyFaceId name, ex example_head1=<faceId>
--      overwriteFaceId=686,--Will overwrite the faceId entry in Soldier2FaceAndBodyData .faceDefinition, instead of adding a new face.
--      description="Example 1",
--      gender="FEMALE",-- "MALE", "FEMALE" - must be allcaps
--      faceFova="example_face1.fv2",--Indexes into faceFova by .fv2 name, can be existing Soldier2FaceAndBodyData entry
--      faceDecoFova="example_faceDeco1.fv2",
--      hairFova="example_hair1.fv2",
--      hairDecoFova="example_hairDeco1.fv2",
--      uiTextureName="ui_face_686",--idroid staff texture name, only nessesary if you want it to show for staff using the faceId
--      --actual texture is /Assets/tpp/ui/texture/StaffImage/<uiTextureName>_<n = 0-2>.ftex (.<1-3>.ftexs etc)
--    },
--  },
--}--this
--return this

--REF mod\fovaInfo\uss0_main0 - adds bodyIds
--local this={
--  bodyFova={
--    {"/Assets/tpp/fova/chara/uss/uss0_main0_v00.fv2","/Assets/tpp/pack/fova/chara/uss/uss0_main0_v00.fpk"},
--    {"/Assets/tpp/fova/chara/uss/uss0_main0_v01.fv2","/Assets/tpp/pack/fova/chara/uss/uss0_main0_v01.fpk"},
--    {"/Assets/tpp/fova/chara/uss/uss0_main0_v02.fv2","/Assets/tpp/pack/fova/chara/uss/uss0_main0_v02.fpk"},
--    {"/Assets/tpp/fova/chara/uss/uss0_main0_v03.fv2","/Assets/tpp/pack/fova/chara/uss/uss0_main0_v03.fpk"},
--    {"/Assets/tpp/fova/chara/uss/uss0_main0_v04.fv2","/Assets/tpp/pack/fova/chara/uss/uss0_main0_v04.fpk"},
--  },
--
--  bodyDefinitions={
--    uss0_main0_v00={
--      description="USS Soldier - fatigues camo, no equipment",
--      bodyFova="uss0_main0_v00.fv2",
--    },
--    uss0_main0_v01={
--      description="USS Soldier - fatigues drab, no equipment",
--      bodyFova="uss0_main0_v01.fv2",
--    },
--    uss0_main0_v02={
--      description="USS Soldier - fatigues camo, harness, all belt equipment",
--      bodyFova="uss0_main0_v02.fv2",
--    },
--    uss0_main0_v03={
--      description="USS Soldier - fatigues drab, harness, all belt equipment",
--      bodyFova="uss0_main0_v03.fv2",
--    },
--    uss0_main0_v04={
--      description="USS Soldier - fatigues drab, heli gear",
--      bodyFova="uss0_main0_v04.fv2",
--    },
--  },
--}--this
--return this

local BODY_FOVA_LIMIT=366--LIMIT

this.fovaInfos={}

--tex fova index lookups by fv2 - this[fovaTypeName][fovaName]=fovaIndex, see TABLESETUP in Setup()
this.bodyFova={}
--TODO put lookups in InfEneFova instead, merge or shift the current tables there
--TODO also integrate fv2 info from external fovainfo modules
--tex cleared in .Setup
--EnemyFova.INVALID_FOVA_VALUE=32767
local INVALID_FOVA_VALUE=32767
this.faceFova={
  [INVALID_FOVA_VALUE]=INVALID_FOVA_VALUE,
}
this.faceDecoFova={
  [INVALID_FOVA_VALUE]=INVALID_FOVA_VALUE,
}
this.hairFova={
  [INVALID_FOVA_VALUE]=INVALID_FOVA_VALUE,
}
this.hairDecoFova={
  [INVALID_FOVA_VALUE]=INVALID_FOVA_VALUE,
}

this.headDefinitions={}--headInfo headDefinitions entries
this.faceDefinitions={}--Entries for Solder2FaceAndBodyData.faceDefinition

this.hasFaceFova=false--tex for Ivar playerFaceId
--
this.fovaTypes={
  "faceFova",
  "faceDecoFova",
  "hairFova",
  "hairDecoFova",
  "bodyFova",
}

this.faceFovaTypes={
  "faceFova",
  "faceDecoFova",
  "hairFova",
  "hairDecoFova",
}

this.bodyFovaTypes={
  "bodyFova",
}
--tex fovaInfo keys that have multiple fovaDefinitions in them, which might have fova entries
this.definitionsTypes={
  "headDefinitions",
  "bodyDefinitions",
}

--tex I'm manually indexing these enums so that I can keep legacy ones and add new names if their purpose is clarified.
this.faceDefEnum={
  faceId=1,
  unk1=2,
  gender=3,
  unk2=4,
  faceFova=5,
  faceDecoFova=6,
  hairFova=7,
  hairDecoFova=8,
  eyeFova=9,
  skinFova=10,
  unk5=11,
  uiTextureName=12,
  uiTextureCount=13,
  unk7=14,
  unk8=15,
  unk9=16,
  unk10=17
}--faceDefEnum

this.bodyDefEnum={
  bodyId=1,
  bodyFovaId=2,
  unk3=3,--isArmor? or something else common to armor?
}

--CALLER: InfInit
function this.LoadFovaInfo()
  InfCore.Log("InfSoldierFaceAndBody.LoadFovaInfo")
  this.fovaInfos={}
  if not InfCore.files.fovaInfo then
    return
  end

  local fovaInfoFiles=InfCore.GetFileList(InfCore.files.fovaInfo,".lua")
  for i,fileName in ipairs(fovaInfoFiles)do
    InfCore.Log("InfSoldierFaceAndBody.LoadFovaInfo: "..fileName)
    local box=false
    local fovaInfo=InfCore.LoadSimpleModule(InfCore.paths.fovaInfo,fileName,box)
    if fovaInfo==nil then
      InfCore.Log("ERROR: InfSoldierFaceAndBody.LoadFovaInfo: fovaInfo "..fileName.." ==nil")
    else
      this.fovaInfos[fileName]=fovaInfo
    end
  end
  if this.debugModule then
    InfCore.PrintInspect(fovaInfoFiles,"fovaInfoFiles")--DEBUG
    InfCore.PrintInspect(this.fovaInfos,"IvarProc.fovaInfos")--DEBUG
  end
end

--IN/SIDE this[fovaTypeName]
function this.CheckDefinition(definition,fovaTypes,definitionName)
  local definitionOK=true
  for i,fovaTypeName in ipairs(fovaTypes) do
    local fovaName=definition[fovaTypeName]
    --TODO type check fovaName
    if fovaName then
      if fovaName==EnemyFova.INVALID_FOVA_VALUE then

      elseif not this[fovaTypeName][fovaName] then
        InfCore.Log("WARNING: InfSoldierFaceAndBody.CheckDefinition: invalid definition "..definitionName..", could not find "..fovaTypeName.."."..fovaName)
        definitionOK=false
        break
      end
    end--if fovaName
  end--for fovaTypes

  return definitionOK
end

--tex patches Solder2FaceAndBodyData.faceDefinition acording to fovaInfo files
--IN/OUT Solder2FaceAndBodyData
function this.Setup(faceAndBodyData)
  InfCore.LogFlow"InfSoldierFaceAndBody.Setup:"
  if this.debugModule then
    InfCore.PrintInspect(faceAndBodyData,"Soldier2FaceAndBodyData pre setup")
  end
  
  this.CheckFaceAndBodyData(faceAndBodyData)
  if this.debugModule then--tex TODO squelching this until I can return to it
    this.BuildTppEnemyBodyId(faceAndBodyData,TppEnemyBodyId)
  end

  --tex clear this state
  for i,fovaTypeName in ipairs(this.fovaTypes) do
    this[fovaTypeName]={
      [EnemyFova.INVALID_FOVA_VALUE]=EnemyFova.INVALID_FOVA_VALUE,
    }
  end

  --tex add fova entries from fovaInfos to faceAndBodyData
  --tex TODO validate
  for moduleName,module in pairs(this.fovaInfos)do
    for i,fovaTypeName in ipairs(this.fovaTypes) do
      local moduleFova=module[fovaTypeName]
      if moduleFova then
        for i,fovaPathInfo in ipairs(moduleFova)do
          if type(fovaPathInfo)=="table" then
          	table.insert(faceAndBodyData[fovaTypeName],fovaPathInfo)
          end
        end--for module fovaType table
      end--if module fovaType table
    end--for fovaTypes
  end--for fovaInfos
   
  --tex TABLESETUP build fova file name lookup to fova index tables (this[fovaTypeName][fovaName])
  for i,fovaTypeName in ipairs(this.fovaTypes) do
    for fovaIndex,fovaInfo in ipairs(faceAndBodyData[fovaTypeName]) do
      --tex uses 'filename of fovaInfo entries as an id, 
      --ex bodyFova{   {"/Assets/tpp/fova/chara/pfs/pfs0_unq_v210.fv2","/Assets/tpp/pack/fova/chara/pfs/pfs0_uniq0_v00.fpk"},--116,250,,black beret, glases, black vest, red shirt, tan pants, fingerless gloves, white hands
      --fovaInfo[1] == "/Assets/tpp/fova/chara/pfs/pfs0_unq_v210.fv2"
      --fileName/fovaName == "pfs0_unq_v210.fv2"
      local fovaName=InfUtil.GetFileName(fovaInfo[1])
      local existing=this[fovaTypeName][fovaName]
      if existing~=nil then
        InfCore.Log("InfSoldierFaceAndBody.Setup: "..fovaTypeName.."."..fovaName.." already has index "..existing)
      end
      this[fovaTypeName][fovaName]=fovaIndex-1--tex shift from lua indexed (from 1), to fova indexed (from 0)
      if this.debugModule then
        InfCore.Log("Added faceAndBodyData fova table lookup: this["..fovaTypeName.."]["..fovaName.."]="..fovaIndex-1)
        InfCore.PrintInspect(fovaInfo,"fovaIndex points to")
      end
    end--for faceAndBodyData[fovaTypeName]
  end--for fovaType

  this.SetupFaceFova(faceAndBodyData)
  this.SetupBodyFova(faceAndBodyData)--FLOW DEPENDENCY InfBodyInfo relies on TppEnemyBodyId being set by the time it does its PostAllModulesLoaded

  if this.debugModule then
    InfCore.PrintInspect(faceAndBodyData,"Soldier2FaceAndBodyData post setup")
    InfCore.Log("#faceAndBodyData.bodyFova:"..#faceAndBodyData.bodyFova)
    for i,fovaTypeName in ipairs(this.fovaTypes) do
      InfCore.PrintInspect(this[fovaTypeName],"this."..fovaTypeName.." set up")
    end
  end
end
--tex patches Solder2FaceAndBodyData.faceDefinition acording to fovaInfo files
--CALLER: Solder2FaceAndBodyData
--IN/OUT Solder2FaceAndBodyData.lua
function this.SetupFaceFova(faceAndBodyData)
  InfCore.LogFlow"InfSoldierFaceAndBody.SetupFaceFova"
  local genders={
    MALE=0,
    FEMALE=1,
  }

  this.headDefinitions={}
  this.faceDefinitions={}

  this.hasFaceFova=false
  
  local overwrittenFaceIds={}

  --tex build faceAndBodyData faceDefinition from fovaInfo head definitions
  for moduleName,module in pairs(this.fovaInfos)do
    local headDefinitions=module.headDefinitions
    if headDefinitions then
      this.hasFaceFova=true
      local defTableCount=#faceAndBodyData.faceDefinition
      local topFaceId=faceAndBodyData.faceDefinition[defTableCount][1]
      InfCore.Log("#faceDefinitions:"..defTableCount.." start faceId:"..topFaceId)--DEBUG
      local defCount=0
      for definitionName,headDefinition in pairs(headDefinitions)do
        if this.CheckDefinition(headDefinition,this.faceFovaTypes,definitionName) then
          if InfCore.debugMode then
            InfCore.Log("headDefinition: "..definitionName)
            InfCore.PrintInspect(headDefinition)
          end
          local definitionIndex=-1
          local currentFaceId
          local oldFace={}
          if headDefinition.overwriteFaceId then
            currentFaceId=headDefinition.overwriteFaceId
            if overwrittenFaceIds[currentFaceId] then
              InfCore.Log("WARNING: SetupFaceFova: overwriteFaceId for face "..currentFaceId.." already has a fovaInfo addon");--DEBUGNOW this needs to be user facing.
            end
            overwrittenFaceIds[currentFaceId]=true
            definitionIndex=this.FindFaceDefForFaceId(faceAndBodyData,currentFaceId)
            if InfCore.debugModule then
              InfCore.Log("FindFaceDefForFaceId("..currentFaceId.."):"..definitionIndex)
            end
            if definitionIndex==-1 then
              InfCore.Log("WARNING: could not find face defintion for overwriteFaceId: "..tostring(currentFaceId),false,true)
            else
              oldFace=faceAndBodyData.faceDefinition[definitionIndex]
            end
          else--tex add new
            defCount=defCount+1
            currentFaceId=topFaceId+defCount
            definitionIndex=defTableCount+defCount
          end
          if definitionIndex~=-1 then
            local newFace={
              currentFaceId,
              headDefinition.unk1 or oldFace[this.faceDefEnum.unk1] or 0,
              genders[headDefinition.gender] or oldFace[this.faceDefEnum.gender] or 0,
              headDefinition.unk2 or oldFace[this.faceDefEnum.unk2] or 0,
              this.faceFova[headDefinition.faceFova] or oldFace[this.faceDefEnum.faceFova] or EnemyFova.INVALID_FOVA_VALUE,
              this.faceDecoFova[headDefinition.faceDecoFova] or oldFace[this.faceDefEnum.faceDecoFova] or EnemyFova.INVALID_FOVA_VALUE,
              this.hairFova[headDefinition.hairFova] or oldFace[this.faceDefEnum.hairFova] or EnemyFova.INVALID_FOVA_VALUE,
              this.hairDecoFova[headDefinition.hairDecoFova] or oldFace[this.faceDefEnum.hairDecoFova] or EnemyFova.INVALID_FOVA_VALUE,
              headDefinition.eyeFova or headDefinition.unk3 or oldFace[this.faceDefEnum.eyeFova] or 0,
              headDefinition.skinFova or headDefinition.unk4 or oldFace[this.faceDefEnum.skinFova] or 0,
              headDefinition.unk5 or oldFace[this.faceDefEnum.unk5] or 0,
              headDefinition.uiTextureName or oldFace[this.faceDefEnum.uiTextureName] or "",
              headDefinition.uiTextureCount or headDefinition.unk6 or oldFace[this.faceDefEnum.uiTextureCount] or 1,
              headDefinition.unk7 or oldFace[this.faceDefEnum.unk7] or 0,
              headDefinition.unk8 or oldFace[this.faceDefEnum.unk8] or 0,
              headDefinition.unk9 or oldFace[this.faceDefEnum.unk9] or 0,
              headDefinition.unk10 or oldFace[this.faceDefEnum.unk10] or 0,
            }--newFace
            if InfCore.debugMode then
              InfCore.PrintInspect(oldFace,"oldFace")
              InfCore.PrintInspect(newFace,"newFace")
            end

            faceAndBodyData.faceDefinition[definitionIndex]=newFace
            TppEnemyFaceId[definitionName]=currentFaceId

            headDefinition.faceId=currentFaceId
            headDefinition.faceDefinitionIndex=definitionIndex

            this.faceDefinitions[definitionName]=newFace
            this.headDefinitions[definitionName]=headDefinition
            this.headDefinitions[currentFaceId]=definitionName
          end--if definitionIndex
        end--if checkDefintion
      end--for module.headDefinitions
    end--if module.headDefinitions
  end--for fovaInfos

  --tex update fova counts for TppSoldierFace.SetFovaFileTable
  if this.debugModule then
    InfCore.PrintInspect(faceAndBodyData.fovaFileTable,"faceAndBodyData.fovaFileTable pre ")
  end
  for i,fovaTypeName in ipairs(this.faceFovaTypes) do
    local defaultCount=faceAndBodyData.fovaFileTable[fovaTypeName].maxCount
    faceAndBodyData.fovaFileTable[fovaTypeName].maxCount=math.max(defaultCount,#faceAndBodyData[fovaTypeName]+1)
  end
  if this.debugModule then
    InfCore.PrintInspect(faceAndBodyData.fovaFileTable,"faceAndBodyData.fovaFileTable post")
  end

  if this.debugModule then
    InfCore.PrintInspect(this,"InfSoldierFaceAndBody")
    InfCore.PrintInspect(faceAndBodyData,"faceAndBodyData")
  end
end--SetupFaceFova

-- bodies

--REF CULL
--  {--MSF_MEDIC
--    name="DDS0_MAIN2",
--    chara="dds",
--    fpkChara="dds",
--    idFmt="uss0_main0_v%02d",
--    fpkFmt="/Assets/tpp/pack/fova/chara/dds/dds0_main2_v%02d_ih",
--    fovas={
--      1,
--      2,
--      4,
--      5,
--    },
--  },

--TODO look at the incomplete wss4_main0 entries in soldier2faceandbodydata
--  {"/Assets/tpp/fova/chara/wss/wss4_main0_v00.fv2","/Assets/tpp/pack/fova/chara/wss/wss4_main0_v00_ih.fpk"},--256,410,,
--  {"/Assets/tpp/fova/chara/wss/wss4_main0_v01.fv2","/Assets/tpp/pack/fova/chara/wss/wss4_main0_v00_ih.fpk"},--257,411,,
--  {"/Assets/tpp/fova/chara/wss/wss4_main0_v01.fv2","/Assets/tpp/pack/fova/chara/wss/wss4_main0_v00_ih.fpk"},--258,412,,
--<

--tex Adds body fova info to Solder2FaceAndBodyData
--IN/OUT Solder2FaceAndBodyData.lua
function this.SetupBodyFova(faceAndBodyData)
  InfCore.LogFlow("InfEneBodyFova.SetupBodyFova:")

  this.bodyDefinitions={}

  for moduleName,module in pairs(this.fovaInfos)do
    if module.bodyDefinitions then
      local definitionIndex=#faceAndBodyData.bodyDefinition
      local currentBodyId=faceAndBodyData.bodyDefinition[definitionIndex][1]
      InfCore.Log("#bodyDefinitions:"..definitionIndex.." start bodyId:"..currentBodyId)--DEBUG
      for definitionName,definition in pairs(module.bodyDefinitions)do
        if this.CheckDefinition(definition,this.bodyFovaTypes,definitionName) then
          --tex add to faceAndBodyData.bodyDefinition
          currentBodyId=currentBodyId+1
          definitionIndex=definitionIndex+1
          local bodyFovaId=this.bodyFova[definition.bodyFova]--tex GOTCHA: definition.bodyFova really fovaName/bodyFovaName ex "svs0_rfl_v00_a.fv2"
          local isArmor=definition.isArmor or 0
          local newBodyDef={
            currentBodyId,
            bodyFovaId,
            isArmor
          }
          faceAndBodyData.bodyDefinition[definitionIndex]=newBodyDef
          TppEnemyBodyId[definitionName]=currentBodyId

          definition.bodyId=currentBodyId
          --CULL definition.bodyDefinitionIndex=definitionIndex

          this.bodyDefinitions[definitionName]=definition
          this.bodyDefinitions[currentBodyId]=definitionName
        end--if checkDefintion
      end--for module.bodyDefinitions
    end--if module.bodyDefinitions
  end--for fovaInfos

  --tex set .maxCount
  for i,fovaTypeName in ipairs(this.bodyFovaTypes) do
    local fileTableInfo=faceAndBodyData.fovaFileTable[fovaTypeName]
    local defaultCount=fileTableInfo.maxCount
    fileTableInfo.maxCount=math.max(defaultCount,#faceAndBodyData[fovaTypeName]+1)
  end

  if #faceAndBodyData.bodyFova>=BODY_FOVA_LIMIT then
    InfCore.Log("WARNING: SetupBodyFova: hit bodyFova limit, too many additional body fovaInfos installed",false,true)
  end

  if this.debugModule then
    InfCore.PrintInspect(this,"InfEneBodyFova")
    InfCore.PrintInspect(faceAndBodyData,"faceAndBodyData")
    InfCore.PrintInspect(TppEnemyBodyId,"TppEnemyBodyId")
    InfCore.Log("#bodyDefinition:"..#faceAndBodyData.bodyDefinition..", #bodyFova:"..#faceAndBodyData.bodyFova)
  end
end--SetupBodyFova

function this.CheckFaceAndBodyData(faceAndBodyData)
  InfCore.LogFlow("InfSoldierFaceAndBody.CheckFaceAndBodyData")
  --tex verify bodyFovas have a bodyDefinition
  --there are no cases of these in vanilla faceAndBodyData
  for bodyFovaIndex,bodyFova in ipairs(faceAndBodyData.bodyFova)do
    local hasBodyDefinition=0
    for j,bodyDefinition in ipairs(faceAndBodyData.bodyDefinition)do
      if bodyDefinition[this.bodyDefEnum.bodyFovaId]==bodyFovaIndex-1 then--tex bodyFovaId is from 0
        hasBodyDefinition=hasBodyDefinition+1
      end--for bodyFovaId
    end--for bodyDefinition
    
    if hasBodyDefinition==0 then
       InfCore.Log("No bodyDefinition for bodyFova["..bodyFovaIndex.."]")
       InfCore.PrintInspect(bodyFova,"bodyFova") 
    elseif hasBodyDefinition>1 then
      InfCore.Log("More than 1 bodyDefinition for bodyFova["..bodyFovaIndex.."]")
      InfCore.PrintInspect(bodyFova,"bodyFova") 
    end--if hasBodyDefinition
  end--for bodyFova
  
  --tex TODO same for other fovas vs headefintion
   
  --tex OFF just for curiosity, see where fv2 name vs fpk name mismatch (see comments in the function)
  if this.debugModule then
    --this.CheckFovaTypes(faceAndBodyData)
  end
end--CheckFaceAndBodyData

function this.CheckFovaTypes(faceAndBodyData)
  for i,fovaTypeName in ipairs(this.fovaTypes)do
    local fovaTable=faceAndBodyData[fovaTypeName]
    for j,fovaPathInfo in ipairs(fovaTable)do
      --tex in vanilla fovaPathInfo[1] never empty, 
      --but theres a few incomplete fovaPathInfo[2] with empty "" 
      if fovaPathInfo[1]==nil or fovaPathInfo[1]=="" then
        InfCore.PrintInspect(fovaPathInfo,"fovaPathInfo[1] empty")
      elseif fovaPathInfo[2]==nil or fovaPathInfo[2]=="" then
        InfCore.PrintInspect(fovaPathInfo,"fovaPathInfo[2] empty")
      else           
        local fv2Name=InfUtil.GetFileName(fovaPathInfo[1])
        local fpkName=InfUtil.GetFileName(fovaPathInfo[2])
        if InfUtil.StripExt(fv2Name)~=InfUtil.StripExt(fpkName)then
          --tex not too interesting, already know that theres fpks that bundle multiple fv2s
          InfCore.PrintInspect(fovaPathInfo,"fovaPathInfo fileName mismatch")
        end
      end--if fovaPathInfo[] empty
    end--for fovaTable
  end--for fovaTypes
end--CheckFovaTypes

function this.BuildTppEnemyBodyId(faceAndBodyData,currentEnemyBodyIdTable)
  InfCore.LogFlow("InfSoldierFaceAndBody.BuildTppEnemyBodyId:")
  local ignoreKeys={
    _scriptInstanceId=true,
    _scriptPath=true,
  }
  
  local newEnemyBodyIdTable={}
  for bodyDefinitionIndex,bodyDefinition in ipairs(faceAndBodyData.bodyDefinition)do
    --{bodyId,bodyFovaId, isArmor? or something else common to armor?}
    local bodyFovaIndex=bodyDefinition[this.bodyDefEnum.bodyFovaId]+1--GOTCHA: bodyFovaId is from 0
    local bodyFova=faceAndBodyData.bodyFova[bodyFovaIndex]
    if bodyFova==nil then
      InfCore.Log("ERROR: InfSoldierFaceAndBody.BuildTppEnemyBodyId: could not find bodyFova for bodyDefinition["..bodyDefinitionIndex.."]",true,true)
      InfCore.PrintInspect(bodyDefinition,"bodyDefinition")
    else   
      local fv2Name=InfUtil.GetFileName(bodyFova[1])
      local bodyIdName=InfUtil.StripExt(fv2Name)
      local bodyId=bodyDefinition[this.bodyDefEnum.bodyId]
      if newEnemyBodyIdTable[bodyIdName]~=nil then
        InfCore.Log("WARNING: Existing entry in newEnemyBodyIdTable found: "..bodyIdName.."="..tostring(newEnemyBodyIdTable[bodyIdName]))
        InfCore.PrintInspect(bodyDefinition,"...for bodyDefinition["..bodyDefinitionIndex.."]")
      else
        newEnemyBodyIdTable[bodyIdName]=bodyId
      end--if newEnemyBodyIdTable[bodyIdName]
    end--if bodyFova
  end--for faceAndBodyData
  
  --DEBUGNOW tex compare new vs current
  for bodyIdName,bodyId in pairs(newEnemyBodyIdTable)do
    if currentEnemyBodyIdTable[bodyIdName]==nil then
      InfCore.Log("New addition from newEnemyBodyIdTable: "..bodyIdName.."="..bodyId)
    elseif currentEnemyBodyIdTable[bodyIdName]~=bodyId then
      InfCore.Log("Existing entry doesnt match new:")
      InfCore.Log("currentEnemyBodyIdTable: "..bodyIdName.."="..currentEnemyBodyIdTable[bodyIdName])
      InfCore.Log("    newEnemyBodyIdTable: "..bodyIdName.."="..bodyId)
    else
    
    end--if currentEnemyBodyIdTable[bodyIdName]
  end--for newEnemyBodyIdTable

  --tex compare current vs new
  for bodyIdName,bodyId in pairs(currentEnemyBodyIdTable)do
    if not ignoreKeys[bodyIdName]then
      if newEnemyBodyIdTable[bodyIdName]==nil then
        InfCore.Log("InfSoldierFaceAndBody.BuildTppEnemyBodyId: newEnemyBodyIdTable does not have entry for existing bodyIdName:"..bodyIdName)
      --tex mismatching bodyIds covered above
      end--if newEnemyBodyIdTable[bodyIdName]
    end-- if not ignoreKeys
  end--for currentEnemyBodyIdTable  
  
  --DEBUGNOW

  
  InfCore.PrintInspect(newEnemyBodyIdTable,"newEnemyBodyIdTable")--DEBUGNOW
end--BuildTppEnemyBodyId

--tex since loading at setup is pre all modules load we need to keep existing stuff around
function this.PostModuleReload(prevModule)
  this.headDefinitions=prevModule.headDefinitions
  this.faceDefinitions=prevModule.faceDefinitions

  this.hasFaceFova=prevModule.hasFaceFova
  
  this.fovaInfos=prevModule.fovaInfos
  
  for i,fovaTypeName in ipairs(this.fovaTypes) do
    this[fovaTypeName]=prevModule[fovaTypeName]
  end
end--PostModuleReload

--tex return Soldier2FaceAndBodyData .faceDefinition index for a given faceId , or -1 if not found
function this.FindFaceDefForFaceId(faceAndBodyData,faceId)
  for index,faceDef in ipairs(faceAndBodyData.faceDefinition) do
    if faceDef[1]==faceId then
      return index
    end
  end

  return -1
end

return this
