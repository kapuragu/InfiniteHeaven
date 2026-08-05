--InfChimera.lua
local this={}
--chimera
--3x slots x 8 categories
--= 24
--12 parts slots per weapon, including color
--3x equipped (primary, secondary, tertiary)
this.SLOTS_PER_CATEROGRY=3
this.PARTS_COUNT=12--tex chimera parts slots per weapon, includes color

this.infosPath="chimeras"
this.saveName="chimera"
this.infoType="CHIMERA"

--REF vars
--tex user presets
--#24 ==3slots*12parts
--  userPresetChimeraColorIndex = { [0] = 64, 0, 0, 62, 0, 0, 59, 53, 0, 0, 0, 0, 0, 0, 0, 64, 64, 45, 58, 64, 0, 0, 0, 0,},
--  userPresetChimeraPaintType = { [0] = 2, 0, 0, 2, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, },
--  userPresetCustomizedWeapon = { [0] = 7, 36, 42, 666, 0, 0, 122, 105, 0, 708, 144, 0, 182, 208, 0, 243, 220, 214, 256, 831, 0, 817, 0, 0, },
--#288  ==3slots*8categories*12parts
--  userPresetChimeraParts = { [0] = 15, 5, 7, 0, 0, 1, 0, 0, 2, 0, 0, 0, 29, 11, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 16, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 59, 23, 47, 4, 0, 17, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 46, 64, 20, 9, 28, 5, 3, 4, 9, 14, 89, 68, 40, 56, 15, 1, 32, 3, 0, 4, 8, 11, 86, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 196, 63, 148, 23, 11, 0, 1, 0, 5, 0, 0, 0, 88, 57, 73, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 116, 71, 0, 28, 0, 0, 9, 0, 0, 9, 11, 86, 142, 77, 101, 10, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 163, 88, 113, 39, 19, 33, 19, 0, 0, 9, 3, 0, 150, 81, 106, 36, 25, 33, 5, 1, 0, 9, 0, 0, 145, 83, 104, 28, 17, 33, 16, 0, 0, 0, 0, 0, 170, 96, 120, 0, 0, 20, 3, 0, 4, 8, 0, 0, 208, 99, 152, 18, 25, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 210, 0, 157, 0, 0, 0, 22, 0, 3, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},

--player selected/sortie chimera vars

--3==primary,secondary,tertiary
--  isUseCustomizedWeapon = { [0] = 0, 0, 0,},
--  customizedWeapon = { [0] = 856, 790, 573,},
--  customizedWeaponSlotIndex = { [0] = 0, 0, 0,},

--3==primary,secondary,tertiary
--  chimeraColorIndex = { [0] = 0, 0, 0,},
--  chimeraPaintType = { [0] = 0, 0, 0,},
--#36 = 3(pri,sec,ter)*12parts
--  chimeraParts = { [0] = 199, 46, 64, 17, 9, 38, 4, 3, 4, 0, 4, 0, 155, 83, 109, 35, 17, 33, 16, 0, 0, 0, 0, 0, 10, 5, 6, 0, 0, 1, 0, 0, 2, 0, 0, 0,},

--saved on sorite prep or something then transferer the the equivalent chimera* vars above
--  initChimeraColorIndex = { [0] = 59, 0, 62,},
--  initChimeraPaintType = { [0] = 2, 0, 2, },
--  initCustomizedWeapon = { [0] = 856, 790, 573,},
--  initChimeraParts = { [0] = 199, 46, 64, 17, 9, 38, 4, 3, 4, 0, 4, 0, 155, 83, 109, 35, 17, 33, 16, 0, 0, 0, 0, 0, 10, 5, 6, 0, 0, 1, 0, 0, 2, 0, 0, 0,},

--REF chimeraInfo
--local this={
--  infoType="CHIMERA",
--  colorIndex=0,
--  category="HANDGGUN",
--  paintType=0,
--  weaponId=50,
--  parts={40,18,28,0,0,0,0,0,0,6,0,0},
--}--this
--return this

this.names={}
this.infos={}

this.weaponCategories={
  "HANDGGUN",
  "SMG",
  "ASSAULT",
  "SHOTGUN",
  "GRENADELAUNCHER",
  "SNIPER",
  "MG",
  "MISSILE",
}--weaponCategories
this.weaponCategoriesEnum=Tpp.Enum(this.weaponCategories)
this.slots={
  "SLOT1",
  "SLOT2",
  "SLOT3",
}--slots
this.slotsEnum=Tpp.Enum(this.slots)
--tex VERIFY, just cribbing from TppDebug DEBUG_ChangeChimeraWeapon chimeraInfo
--gotcha here maybe being edit mode has color/camo which is saved in different vars, and does not have underBarrelAmmo seperate from underBarrel
--comments are edit mode labels
this.parts={
  "reciever",--not in DEBUG_ChangeChimeraWeapon --'Base' 
  "barrel",
  "ammo",--'Magazine'
  "stock",
  "muzzle",
  "muzzleOption",--'muzzle accessory'
  "rearSight",--'Optics 1'
  "frontSight",--'Optics 2'
  "option1",--'Flashlight'
  "option2",--'Laser Sight'
  "underBarrel",
  "underBarrelAmmo",
}--parts
this.partsEnum=Tpp.Enum(this.parts)

local infoVarOrder={
  "category",
  "weaponId",
  "parts",
  "colorIndex",
  "paintType",
}

function this.PostAllModulesLoad(isReload)
  if isReload then
    this.LoadLibraries()
  end
end--PostAllModulesLoad
function this.LoadLibraries()
  InfUtil.ClearArray(this.names)
  local infoFiles=InfCore.GetFileList(InfCore.files[this.infosPath],".lua")
  for i,fileName in ipairs(infoFiles)do
    InfCore.Log("LoadLibraries "..fileName)
    local name=InfUtil.StripExt(fileName)
    local module=InfCore.LoadSimpleModule(InfCore.paths[this.infosPath],fileName)
    if module==nil then
    --tex LoadSimpleModule should give the error
    else
      --TODO VALIDATE
      this.infos[name]=module
      table.insert(this.names,name)
    end--if module
  end--for emblemFiles

  for name,info in pairs(this.infos)do

  end--for infos
end--LoadLibraries
function this.TypesToVarsIndex(category,slot,part)
  local categoryIdx=this.weaponCategoriesEnum[category]-1
  local slotIdx=this.slotsEnum[slot]-1
  local partIdx=this.partsEnum[part]-1
  return InfUtil.From3Dto1D(partIdx,slotIdx,categoryIdx,#this.parts,#this.slots)
end--TypesToVarsIndex
function this.VarsIndexToTypeIndexes(index)
  local partIdx,slotIdx,catIdx=InfUtil.From1Dto3D(index,#this.parts,#this.slots)
  return catIdx+1,slotIdx+1,partIdx+1
end--VarsIndexToTypeIndexes

function this.BuildSaveText(saveName,infoType,info)
  local saveTextList={
    "-- "..saveName,
    "-- ",
    "local this={",
  }
  table.insert(saveTextList,'\tinfoType="'..infoType..'",')
  for i,varName in ipairs(infoVarOrder)do
    local value=info[varName]
    if type(value)=="table"then
      if varName=="parts"then
        saveTextList[#saveTextList+1]='\t'..varName..'={'
        for j,partName in ipairs(this.parts)do
          local aValue=value[j]
          local enumStr=this.VarToTppEquipEnumStr(partName,aValue) or aValue
          saveTextList[#saveTextList+1]='\t\t'..enumStr..',--'..partName
        end
        saveTextList[#saveTextList+1]='\t},--parts'
      else
        saveTextList[#saveTextList+1]='\t'..varName..'={'..table.concat(value,',')..'},'
      end
    elseif type(value)=="string"then
      saveTextList[#saveTextList+1]='\t'..varName..'="'..value..'",'
    else
      local enumStr=this.VarToTppEquipEnumStr(varName,value) or value
      saveTextList[#saveTextList+1]='\t'..varName..'='..enumStr..','
    end
  end 
  saveTextList[#saveTextList+1]="}--this"
  saveTextList[#saveTextList+1]="return this"

  return saveTextList
end--BuildSaveText
function this.VarToTppEquipEnumStr(varName,value)
  local prefix=InfLookup.tppEquipPrefix[varName]
  if prefix~=nil then
    local enumName=InfLookup.TppEquip[varName][value]
    if enumName==nil then
      InfCore.Log("WARNING: InfChimera.VarToTppEquipEnumStr: no enumname found for InfLookup.TppEnum."..varName.."["..tostring(value).."]")
    else
      return "TppEquip."..enumName
    end
  end
end--VarToTppEquipEnum
function this.VarsToInfo(category,slot)
  local info={}

  info.category=this.weaponCategories[category+1]
 
  info.parts={}
  local part=0
  local startIdx=InfUtil.From3Dto1D(part,slot,category,#this.parts,#this.slots)
  for i=startIdx,startIdx+#this.parts-1 do
    table.insert(info.parts,vars.userPresetChimeraParts[i])
  end

  local weaponSlotIndex=(category*#this.slots)+slot
  info.weaponId=vars.userPresetCustomizedWeapon[weaponSlotIndex]
  info.colorIndex=vars.userPresetChimeraColorIndex[weaponSlotIndex]
  info.paintType=vars.userPresetChimeraPaintType[weaponSlotIndex]

  return info
end--VarsToInfo
function this.SaveVars(saveName,infoType,category,slot)
  InfCore.LogFlow"InfChimera.SaveVars"

  InfUtil.InsertUniqueInList(this.names,saveName)
  local info=this.VarsToInfo(category,slot)
  this.infos[saveName]=info
  InfCore.PrintInspect(info,saveName.." info")

  local saveTextList=this.BuildSaveText(saveName,infoType,info)
  local fileName=InfCore.paths.chimeras..saveName..".lua"
  InfCore.WriteStringTable(fileName,saveTextList)
  InfCore.Log("Saved "..saveName,true,true)--TODO  lang
end--SaveVars
function this.LoadVars(saveName,category,slot)
  local fileName=saveName..".lua"
  local module=InfCore.LoadSimpleModule(InfCore.paths[this.infosPath],fileName)
  if module==nil then
  --tex LoadSimpleModule should give the error
  else
    --TODO VALIDATE
    this.infos[saveName]=module
    --table.insert(this.names,name)
  end--if module
  --
  local info=this.infos[saveName]
  --tex should be filtered before even getting to this point
  if info.category~=this.weaponCategoriesEnum[category+1] then
    InfMenu.PrintLangId"chimera_wrong_weapon_category"
    return
  end

  if this.debugModule then
  local line=""--DEBUG
  for i=0,(#this.weaponCategories*#this.slots*#this.parts)-1 do
    line=line..vars.userPresetChimeraParts[i]..","
  end
  InfCore.Log("vars.userPresetChimeraParts prev = "..line)--
  end

  local part=0
  local startIdx=InfUtil.From3Dto1D(part,slot,category,#this.parts,#this.slots)
  local partNum=0
  for i=startIdx,startIdx+#this.parts-1 do
    partNum=partNum+1
    vars.userPresetChimeraParts[i]=info.parts[partNum]
  end

  local weaponSlotIndex=(category*#this.slots)+slot
  vars.userPresetCustomizedWeapon[weaponSlotIndex]=info.weaponId--DEBUGNOW equipid?
  vars.userPresetChimeraColorIndex[weaponSlotIndex]=info.colorIndex
  vars.userPresetChimeraPaintType[weaponSlotIndex]=info.paintType

  if this.debugModule then
  local line=""--DEBUG
  for i=0,(#this.weaponCategories*#this.slots*#this.parts)-1 do
    line=line..vars.userPresetChimeraParts[i]..","
  end
  InfCore.Log("vars.userPresetChimeraParts post = "..line)--
  end

  this.TppSave()
end--LoadVars

function this.TppSave()
  --Seq_Game_WeaponCustomizeEnd
  TppSave.SaveOnlyMbManagement()
end

--Ivars
this.registerIvars={
  'chimera_weaponCategory',
  'chimera_clearSlot',
}

this.registerMenus={
  'chimeraMenu',
}

this.chimeraMenu={
  --parentRefs={"InfMenuDefs.customizeMenu"},
  options={
    'Ivars.chimera_weaponCategory',
  },
}

this.chimera_weaponCategory={
  --save=IvarProc.CATEGORY_EXTERNAL,
  settings=this.weaponCategories,
}--chimera_weaponCategory

for i=0,#this.slots-1 do
  local ivarName="chimera_loadSlot"..i+1--1 indexed
  table.insert(this.registerIvars,ivarName)
  table.insert(this.chimeraMenu.options,"Ivars."..ivarName)
  this[ivarName]={
    --save=IvarProc.CATEGORY_EXTERNAL,
    slot=i,--0 indexed
    settings={"None found"},--DYNAMIC
    settingNamesDoc=[[<list of \mod\chimeras>]],
    default=0,
    OnSelect=function(self)
      InfUtil.ClearArray(self.settings)
      if #this.names==0 then
        table.insert(self.settings,1,"None Found")
      else
        local category=ivars.chimera_weaponCategory
        local categoryName=this.weaponCategories[category+1]
        for i,name in ipairs(this.names)do
          local info=this.infos[name]
          if info.category==categoryName then
            table.insert(self.settings,name)
          end
        end
      end
      IvarProc.SetSettings(self,self.settings)
    end,
    OnActivate=function(self,setting)
      local saveName=self.settings[setting+1]
      local category=ivars.chimera_weaponCategory
      this.LoadVars(saveName,category,self.slot)
      InfCore.DebugPrint(InfLangProc.LangString"chimera_loaded_slot"..self.slot+1)
    end,
  }--chimera_loadSlot
end--for slots

for i=0,#this.slots-1 do
  local ivarName="chimera_saveSlot"..i+1--1 indexed
  table.insert(this.registerIvars,ivarName)
  table.insert(this.chimeraMenu.options,"Ivars."..ivarName)
  this[ivarName]={
    --save=IvarProc.CATEGORY_EXTERNAL,
    slot=i,--0 indexed
    settings={"New",},--DYNAMIC
    settingNamesDoc=[[New,<list of \mod\bionicHand>]],
    OnSelect=function(self)
      InfUtil.ClearArray(self.settings)
      local category=ivars.chimera_weaponCategory
      local categoryName=this.weaponCategories[category+1]
      for i,name in ipairs(this.names)do
        local info=this.infos[name]
        if info.category==categoryName then
          table.insert(self.settings,name)
        end
      end--for names
      table.insert(self.settings,1,"New")
      IvarProc.SetSettings(self,self.settings)
    end,
    OnActivate=function(self,setting)
      local saveName=self.settings[setting+1]

      local category=ivars.chimera_weaponCategory
      local categoryName=this.weaponCategories[category+1]

      --TODO: IHHook text entry?
      if saveName=="New" then
        saveName=this.saveName..categoryName..os.time()
      end
      this.SaveVars(saveName,this.infoType,category,self.slot)
      self:OnSelect()
      InfCore.DebugPrint(InfLangProc.LangString"chimera_saved_slot"..self.slot+1)
    end,
    OnInput=function(self,input)
      local setting=ivars[self.name]--tex turns out an Ivar doesn't actually know its own value
      if setting==0 then--New
        --self.settings[1]=input   
        local category=ivars.chimera_weaponCategory
        local categoryName=this.weaponCategories[category+1]
        local saveName=input--..categoryName
        this.SaveVars(saveName,this.infoType,category,self.slot)
        self:OnSelect()
        for i,name in ipairs(self.settings)do
          if name==input then
            self:Set(i-1)
            InfMenu.DisplayCurrentSetting()
            break
          end
        end
        InfCore.DebugPrint(InfLangProc.LangString"chimera_saved_slot"..self.slot+1)
      end
    end,
  }--saveChimera
end--for slots

--interleave into menus
--for i=0,#this.slots-1 do
--  local ivarName="chimera_loadSlot"..i+1--1 indexed
--  table.insert(this.chimeraMenu.options,"Ivars."..ivarName)
--  local ivarName="chimera_saveSlot"..i+1--1 indexed
--  table.insert(this.chimeraMenu.options,"Ivars."..ivarName)
--end--for slots

this.chimera_clearSlot={
  settings=this.slots,
  OnActivate=function(self,setting)
    local category=ivars.chimera_weaponCategory
    local part=0
    local slot=setting
    
    vars.customizedWeapon[slot] = 0
    vars.initCustomizedWeapon[slot] = 0

    local startIdx=InfUtil.From3Dto1D(part,slot,category,#this.parts,#this.slots)
    for i=startIdx,startIdx+#this.parts-1 do
      vars.userPresetChimeraParts[i]=0
    end

    local weaponSlotIndex=(category*#this.slots)+slot
    vars.userPresetCustomizedWeapon[weaponSlotIndex]=0
    vars.userPresetChimeraColorIndex[weaponSlotIndex]=0
    vars.userPresetChimeraPaintType[weaponSlotIndex]=0
    InfCore.DebugPrint(InfLangProc.LangString"chimera_cleared_slot"..setting+1)
  end,
}--chimera_clearSlot
table.insert(this.chimeraMenu.options,"Ivars.chimera_clearSlot")

this.langStrings={
  eng={
    chimera_weaponCategory="Weapon category",
    chimera_loadSlot1="Load to slot 1",
    chimera_loadSlot2="Load to slot 2",
    chimera_loadSlot3="Load to slot 3",
    chimera_saveSlot1="Save from slot 1",
    chimera_saveSlot2="Save from slot 2",
    chimera_saveSlot3="Save from slot 3",
    chimera_clearSlot="Clear slot",
    chimeraMenu="Chimera menu",
    chimera_loaded_slot="Loaded to slot ",
    chimera_saved_slot="Saved from slot ",
    chimera_cleared_slot="Cleared slot ",
  },
  help={
    eng={
      chimeraMenu="Chimera is MGSVs weapon cusomization system, this menu lets you save/load from the Customize > Weapons idroid menu",
      chimera_weaponCategory="Changes which weapon category the slots refer to.",
      chimera_loadSlot1="Load chimera from MGS_TPP\\mod\\chimeras to specified slot",
      chimera_saveSlot1="Save chimera of specified slot for to MGS_TPP\\mod\\chimeras ",
    },
  }
}--langStrings

return this
