--InfLangProc.lua
--Processing methods for IH Lang strings
local this={}
local IsTable=Tpp.IsTypeTable

local GetAssetConfig=AssetConfiguration.GetDefaultCategory
--tex my own shizzy langid stuff since games is too limitied
function this.GetLanguageCode()
  --Cht over Jpn
  local languageCode=GetAssetConfig"Language"
  if Ivars.langOverride:Is(1) then
    if languageCode=="jpn" then
      languageCode="cht"
    end
  end
  if Ivars[languageCode]==nil then
    languageCode="eng"
  end
  return languageCode
end

function this.LangString(langId)
  if langId==nil or langId=="" then
    InfCore.Log("WARNING: InfLangProc.LangString langId is empty",false,true)
    TppUiCommand.AnnounceLogView"LangString langId empty"
    return ""
  end
  local languageCode=this.GetLanguageCode()
  local langString=InfLang[languageCode][langId]
  if (langString==nil or langString=="") and languageCode~="eng" then
    --TppUiCommand.AnnounceLogView("no langstring for " .. languageCode)
    langString=InfLang.eng[langId]
  end
  
  --DEBUGNOW
  if type(langString)=="table"then
    InfCore.Log('WARNING: InfLangProc.LangString("'..tostring(langId)..'") is a table')
  end

  if langString==nil or langString=="" then
    --TppUiCommand.AnnounceLogView"PrintLangId langString empty"
    return langId
  end

  return langString
end

function this.LangTableString(langId,index)
  if langId==nil or langId=="" then
    InfCore.Log("LangTableString langId empty",true)
    return ""
  end
  local languageCode=this.GetLanguageCode()
  local langTable=InfLang[languageCode][langId]
  if (langTable==nil or langTable=="" or not IsTable(langTable)) and languageCode~="eng" then
    --TppUiCommand.AnnounceLogView("no langTable for " .. languageCode)
    langTable=InfLang.eng[langId]
  end

  if langTable==nil or langTable=="" or not IsTable(langTable) then
    --TppUiCommand.AnnounceLogView"LangTableString langTable empty"
    return langId .. ":" .. index
  end

  if index < 1 or index > #langTable then
    --TppUiCommand.AnnounceLogView("LangTableString - index for " .. langId " out of bounds")
    return langId .. " OUTOFBOUNDS:" .. index
  end

  return langTable[index],langTable
end

function this.LangTable(langId)
  if langId==nil or langId=="" then
    InfCore.Log("ERROR: GetLangTable langId empty",false,true)
    return {}
  end
  local languageCode=this.GetLanguageCode()
  local langTable=InfLang[languageCode][langId]
  if (langTable==nil or langTable=="" or not IsTable(langTable)) and languageCode~="eng" then
    --TppUiCommand.AnnounceLogView("no langTable for " .. languageCode)--DEBUG
    langTable=InfLang.eng[langId]
  end

  if langTable==nil or langTable=="" or not IsTable(langTable) then
    InfCore.Log("ERROR: LangTableString langTable empty",false,true)--DEBUG
    return {langId .. ":" .. "n"}
  end

  return langTable
end

function this.LangStringHelp(langId)
  if langId==nil or langId=="" then
    InfCore.Log("WARNING: InfLangProc.LangString langId is empty",false,true)
    TppUiCommand.AnnounceLogView"LangString langId empty"
    return ""
  end
  local languageCode=this.GetLanguageCode()
  local langTable=InfLang.help[languageCode] or InfLang.help.eng
  local langString=langTable[langId] or InfLang.help.eng[langId] -- or langId
  return langString
end

--TODO split out to its own module?
function this.CpNameString(cpName,location)
  local location=location or TppLocation.GetLocationName()
  local languageCode=this.GetLanguageCode()
  local locationCps=InfLangCpNames.cpNames[location]
  if locationCps==nil then
    InfCore.Log("WARNING: InfMenu.CpNameString: No name for "..tostring(cpName).." in "..tostring(location),false,true)
    return nil
  end
  local cps=locationCps[languageCode] or locationCps["eng"]
  return cps[cpName]
end

--REF
--this.langStrings={
--  eng={
--    someLangString="Some lang string",
--  },
--  help={
--    eng={
--      someLangString="Some lang string help",
--    },
--  },
--}
function this.PostAllModulesLoad()
  InfCore.LogFlow("Adding module Lang strings")
  --tex add module ivars to this
  --just straight up merging for now so I don't have to change any lang lookup code
  for i,module in ipairs(InfModules) do
    if module.langStrings and module~=InfLang then
      --InfCore.LogFlow("Adding LangStrings for "..module.name)
      if this.debugModule then
        InfCore.PrintInspect(module.langStrings,module.name..".langStrings")
      end
      --tex ASSUMPTION, only two levels deep (.help.<lang>)
      --should just do a full table merge function
      for k,v in pairs(module.langStrings)do
        --<lang>, help
        for k2,v2 in pairs(v)do
          --help.<lang>
          if type(v2)=="table" and k=="help" then--tex KLUDGE settings are actually a table
            for k3,v3 in pairs(v2)do
              InfLang[k][k2][k3]=v3
          end
          else
            InfLang[k][k2]=v2
          end
        end
      end
    end

    --tex check to see if theres a settingNames in InfLang
    --has to be postmodules since InfLang is loaded after Ivars
    --GOTCHA this will lock in language till next modules reload (not that there's any actual InfLang translations I'm aware of lol)
    local settingsStr="Settings"
    local languageCode=AssetConfiguration.GetDefaultCategory"Language"
    local langTable=InfLang[languageCode] or InfLang.eng
    for name,ivar in pairs(Ivars) do
      if Ivars.IsIvar(ivar) then
        local settingNames=name..settingsStr
        if langTable[settingNames] then
          ivar.settingNames=settingNames
        end
        --tex fall back to settings table
        --GOTCHA: ivars with dynamic settings will also need to update settingNames
        if not ivar.settingNames then
          if ivar.settings and #ivar.settings>0 then
            ivar.settingNames=ivar.settings
          end
        end
      end--if Ivar
    end--for Ivars
  end--for InfModules

  if this.debugModule then
  --InfCore.PrintInspect(InfLang,"InfLang")
  end
end--PostAllModulesLoad

return this
