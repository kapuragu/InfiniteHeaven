-- InfAutoDoc.lua
-- Builds the features documentation by iterating Infinite Heavens menu modules
-- See the main function AutoDoc
-- and RunAutoDoc, which can run via "IH system menu"

--InfAutoDoc has been around forever to build the Features and Options documents, but has been shifted into IH (well returned since it started as an IH command)
--as of r258 due to a change in the IH dev layout that would take a bunch more work to work around.
--That does add a couple of hoops to jump to an IH release, but it removes the need to run it through an external lua distro.
--Basically have to do a release build, run it off that, and copy the modified files (docs /Features and Options txt html and profiles/All_Options_Example.lua) back over the repo versions.
--And as a bonus you can run it to add any mod added menus/options to the docs.

-- TODO: list autoDoc vars on ivars/menus
-- .noDoc ?
-- settingNamesDoc ?
-- requiresIHHook

--overrides useful for stuff that gets set dynamically
-- ivars:
--TODO: implement
-- autoDoc={
--  description="",--override
--  settingNames={}--override
--  }

local this={}

--LOCALOPT
local IsFunc=Tpp.IsTypeFunc
local IsTable=Tpp.IsTypeTable
local IsString=Tpp.IsTypeString

local nl="\n"--tex LDT uses unix endings, else "\r\n"

local tableStr="table"
local function IsMenu(item)
  if type(item)==tableStr then
    if item.options and not item.noDoc then
      return true
    end
  end
  return false
end

local skipItemsList={
  goBackItem=true,
  resetSettingsItem=true,
  menuOffItem=true,
}

local function CharacterLine(character,length)
  local characterLine=""
  for j=1,length do
    characterLine=characterLine..character
  end
  return characterLine
end

--markdown (from stack exchange)
-- Github automatically parses anchor tags out of your headers. So you can do the following:

-- [Custom foo description](#foo)

-- # Foo

-- In the above case, the Foo header has generated an anchor tag with the name foo

-- Note: just one # for all heading sizes, no space between # and anchor name, anchor tag names must be lowercase, and delimited by dashes if multi-word.

-- [click on this link](#my-multi-word-header)

-- ### My Multi Word Header

--more info:
-- As documented in their github/markup project, GitHub runs all user supplied markup through various filters, including the TableOfContentsFilter. The filter isn't fully documented, but a quick read through the code suggests that to create an id, the text of a header is filtered by having...

--     all characters converted to lowercase ASCII characters;
--     all punctuation (except hyphens and spaces) removed
--     all spaces replaced with hyphens.
local function CreateInternalLinkStr(headerName)
  local linkStr=string.lower(headerName)
  --TODO all punctuation (except hyphens and spaces) removed
  linkStr=string.gsub(linkStr, " ", "-")
  linkStr="["..headerName.."](#"..linkStr..")"
  return linkStr
end--CreateInternalLinkStr

--WORKAROUND TODO REDO
--gathers all the settings (but not the preceding setting text)
--TODO: get closer to InfMenu.GetSettingText
--TODO: option.settingNamesDoc
--TODO: search workspace for options that have OnSelect, add settingNamesDoc to 
local function GetSettingsText(option)
  local settingText=""
  local settingNames=option.settingNames or option.settings
  if option.isMenuOff then
    settingText=""
  elseif option.optionType=="COMMAND" then
    settingText=""
  elseif option.optionType=="MENU" then
    settingText=""
  elseif option.settingNamesDoc then
    settingText=InfLangProc.LangString(option.settingNamesDoc)
  elseif settingNames and IsTable(settingNames) then  --tex old style direct non localized table, or the settings themselves, 
  --normally GetSettingText would before this, but that's a lot more complicated since you need to OnSelect them first if its doing something dynamic
    for i,settingName in ipairs(settingNames)do
      if type(settingName)~="string" then
        InfCore.Log("WARNING: type settingName ~= string for option "..tostring(option.name))
      else
      settingText=settingText..settingName..", "
      end
    end

    settingText=string.sub(settingText,1,#settingText-2)
  elseif settingNames then--tex just a string langTable id
    local settingTable=InfLangProc.LangTable(settingNames)
    --settingText=InfInspect.Inspect(settingTable)
    for i,settingName in ipairs(settingTable)do
      settingText=settingText..settingName..", "
    end
    settingText=string.sub(settingText,1,#settingText-2)
    --tex OFF rethink
    --settingText=InfMenu.LangTableString(settingNames,option.setting+1)
--  elseif IsFunc(option.GetSettingText) then
--    --tex TODO: output whole range instead of just first
--    local i=0
--    if option:GetSettingText(i)==nil then
--      InfCore.Log("option:GetSettingText("..i..")==nil for "..option.name)--DEBUG
--      settingText="nil"
--    else
--      settingText=tostring(option:GetSettingText(i))
--    end
  elseif option.isPercent then
    if option.range then
      settingText=option.range.min.."-"..option.range.max.."%"
    else
      settingText="Percentage"
    end
    --settingText=option.setting .. "%"
    --  elseif option.options~=nil then--tex menu
    --    settingText=""
    --    optionSeperator=optionSeperators.menu
  else
    if option.range or option.settings then
      local min,max=IvarProc.GetRange(option)
      settingText=min.."-"..max
    else
      settingText="DEBUGNOW GetSettingsText no decent output found"--DEBUG TODO
    end
  end
  if option.requiresIHHook then
    settingText=settingText.." (Requires IHHook)"
  end
  return settingText
end--GetSettingsText

local function GatherMenus(currentMenu,skipItems,menus,menuNames)
  --InfCore.Log("GatherMenus:")
  for i,itemRef in ipairs(currentMenu)do
    local item=InfMenu.GetOptionFromRef(itemRef)
    if item==nil then
      InfCore.Log("WARNING: InfAutoDoc.GatherMenus: item==nil for itemRef: "..tostring(itemRef))
    else
      if skipItems and skipItemsList[item.name] then
      else
        if IsMenu(item) and not menuNames[item.name] then
          menuNames[item.name]=true
          table.insert(menus,item)
          GatherMenus(item.options,skipItems,menus,menuNames)
        end
      end
    end
  end
end

local function IsForProfileAutoDoc(item,currentMenu,priorMenus,priorItems)
  if priorMenus then
    for i,menu in ipairs(priorMenus) do
      if currentMenu==menu then
        return
      end
    end
  end

  if item==nil then
    InfCore.Log("WARNING: InfAutoDoc.IsForProfileAutoDoc: item==nil")
    return false
  end

  if priorItems[item.name] then
    return false
  end

  if currentMenu.nonConfig then
    return false
  end

  return IvarProc.IsForProfile(item)
end

--NOTE: all lines get nl when written, so just insert "" to get nl
local function PrintMenuSingle(priorMenus,menu,priorItems,skipItems,menuCount,textTable,markdownTable,htmlTable,profileTable)
  menuCount=menuCount+1

  do--menu header
    local menuDisplayName=InfLangProc.LangString(menu.name)

    table.insert(textTable,menuDisplayName)

    table.insert(markdownTable,"### "..menuDisplayName)

    table.insert(htmlTable,[[<div id="menu">]])
    table.insert(htmlTable,[[<div id="menuTitle">]])
    table.insert(htmlTable,string.format([[<div id="%s">%s</div>]],menu.name,menuDisplayName))

    local hasItems=false
    for i,itemRef in ipairs(menu.options)do
      local item=InfMenu.GetOptionFromRef(itemRef)
      if IsForProfileAutoDoc(item,menu,priorMenus,priorItems) then
        hasItems=true
      end
    end
    if hasItems then
      table.insert(profileTable,"\t\t--"..menuDisplayName)
    end
    
    if menu.requiresIHHook then
      --table.insert(textTable," [Requires IHHook]")
      --table.insert(htmlTable," [Requires IHHook]")
    end

    local menuHelpLangString=InfLang.help.eng[menu.name]
    if menuHelpLangString then
      table.insert(textTable,"- "..menuHelpLangString)

      table.insert(markdownTable,"- "..menuHelpLangString)
      --table.insert(markdownTable,">"..menuHelpLangString.."  ")--markdown blockquote

      menuHelpLangString=string.gsub(menuHelpLangString,nl,"<br/>")
      table.insert(htmlTable,string.format([[<div id="menuHelp">%s</div>]],menuHelpLangString))

      --table.insert(profileTable,"-- "..menuHelpLangString)
    end
    table.insert(htmlTable,"</div>")

    local underLineLength=string.len(menuDisplayName)
    local underLine=CharacterLine("-",underLineLength)
    table.insert(textTable,underLine)

    --table.insert(markdownTable,underLine)

    table.insert(markdownTable,"")
  end--menu header

  for i,itemRef in ipairs(menu.options)do
    local item=InfMenu.GetOptionFromRef(itemRef)
    table.insert(htmlTable,[[<div id="menuItem">]])

    if item==nil then
      InfCore.Log("WARNING: InfAutoDoc.PrintMenuSingle: item==nil for itemRef:"..tostring(itemRef))
    else

      if skipItems and skipItemsList[item.name] then

      else        
        --DEBUG
        --      InfCore.Log("name:"..item.name)
        --      InfCore.Log("desc:"..tostring(item.description))
        --      InfCore.Log("langstr:"..tostring(InfLangProc.LangString(item.name))) 
        
        --tex see InfMenu.GetSettingText for how option and setting usually displayed
        local optionIndex=i
        local option=item
        
        local optionIndexText=InfMenu.GetOptionIndexText(optionIndex)
        local optionText=InfMenu.GetOptionText(option)
        local optionSeperator=InfMenu.GetOptionIndicator(option)
        local settingIndex=""
        local settingText=""--tex really settingsText, but keeping naming the same as InfMenu.GetSettingText for easier comparison
        local settingSuffix=""  

        --table.insert(htmlTable,string.format([[<div id="itemIndex">%s</div>]],optionIndexText))

        if IsMenu(item) then
          menuCount=menuCount+1

          table.insert(textTable,optionIndexText..optionText.."  ")
     
          local optionTextLink=CreateInternalLinkStr(optionText)
          local optionAndSettingText=optionIndexText.." "..optionTextLink..optionSeperator
          table.insert(markdownTable,optionAndSettingText.."  ")

          table.insert(htmlTable,string.format([[<div>%s<a href="#%s">%s</a></div>]],optionIndexText,item.name,optionText))
        else
          local settingText=GetSettingsText(item) 
          
          local optionAndSettingText=optionIndexText.." "..optionText..optionSeperator..settingIndex..settingText..settingSuffix
          table.insert(textTable,optionAndSettingText)

          table.insert(markdownTable,optionAndSettingText.."  ")

          optionAndSettingText=string.gsub(optionAndSettingText,"<","&lt")
          optionAndSettingText=string.gsub(optionAndSettingText,">","&gt")
          table.insert(htmlTable,string.format([[<div>%s</div>]],optionAndSettingText))
          --table.insert(htmlTable,string.format([[<div id="%s">%s</div>]],item.name,itemIndexText..settingDescription))

          local helpLangString=InfLang.help.eng[item.name]
          if not helpLangString then
            --table.insert(markdownTable,"  ")
          else
            table.insert(textTable,helpLangString)
 
            --table.insert(mardownTable,"> "..helpLangString.."  ")--markdown blockquote
            table.insert(markdownTable,"- "..helpLangString.."  ")--markdown unordered list
            --table.insert(markdownTable,"")

            helpLangString=string.gsub(helpLangString,"<","&lt")
            helpLangString=string.gsub(helpLangString,">","&gt")
            helpLangString=string.gsub(helpLangString, nl, "<br/>")
            table.insert(htmlTable,string.format([[<div id="itemHelp">%s</div>]],helpLangString))
          end
          --table.insert(textTable,nl)
          if IsForProfileAutoDoc(item,menu,priorMenus,priorItems) then
            local profileLine=this.GetProfileLine(item)
            table.insert(profileTable,table.concat(profileLine))
          
            priorItems[item.name]=true
          end--if IsForProfileAutoDoc
        end-- if isMenu
        table.insert(markdownTable,"")
      end--if skipItem
    end--if item
    table.insert(htmlTable,"</div>")
  end--for menu.options

  do--menu footer
    -- table.insert(markdownTable,"---")--markdown line is just 3 or more chars
    table.insert(markdownTable,"# ")--tex KLUDGE empty header for the thinner line
    table.insert(markdownTable,"")

    table.insert(htmlTable,"</div>")--id=menu
  end--menu footer
end--PrintMenuSingle

function this.GetProfileLine(item)
  local profileLine={}
  table.insert(profileLine,"\t\t"..item.name.."=")
  --InfCore.Log("profileline --- "..item.name)--DEBUG
  if item.settings then
    local setting=item.settings[item.default+1]
    if setting and setting~="DEFAULT" and setting~="OFF" then
      table.insert(profileLine,"\""..setting.."\"")
    else
      table.insert(profileLine,item.default)
    end
  else
    table.insert(profileLine,item.default)
  end
  table.insert(profileLine,",")

  local optionName=InfLang.eng[item.name] or InfLang.help.eng[item.name] or ""
  table.insert(profileLine,"--[[")
  if item.settings then
    table.insert(profileLine,"{ ")
    for i,setting in ipairs(item.settings)do
      table.insert(profileLine,setting)
      if i~=#item.settings then
        table.insert(profileLine,", ")
      end
    end
    table.insert(profileLine," }")
  else
    table.insert(profileLine,"{ ")
    table.insert(profileLine,item.range.min.."-"..item.range.max)
    table.insert(profileLine," }")
  end
  if not item.save then
    table.insert(profileLine," -- Non-save")
  end
  table.insert(profileLine," -- "..optionName)
  if item.isPercent then
    table.insert(profileLine," (percentage)")
  end
  table.insert(profileLine,"]]")
  return profileLine
end--GetProfileLine

local function EscapeHtml(line)
  line=string.gsub(line,"<","&lt")
  line=string.gsub(line,">","&gt")
  line=string.gsub(line,nl,"<br/>")
  return line
end

function this.AutoDoc(outputFolder,profilesFolder,FeaturesHeader,featuresOutputName)
  InfCore.Log("AutoDoc:")

  local textTable={}
  local markdownTable={}
  local htmlTable={}
  local profileTable={}


  table.insert(htmlTable,"<!DOCTYPE html>")
  table.insert(htmlTable,"<html>")
  table.insert(htmlTable,"<head>")
  table.insert(htmlTable,[[<link rel="stylesheet" type="text/css" href="features.css">]])
  table.insert(htmlTable,string.format([[<title>%s</title>]],featuresOutputName))
  table.insert(htmlTable,"</head>")
  table.insert(htmlTable,"<body>")

  InfCore.Log("FeaturesHeader:")
  for i,section in pairs(FeaturesHeader)do
    if section.title then
      table.insert(textTable,section.title)
      local underLineLength=string.len(section.title)
      local underLine=CharacterLine("=",underLineLength)
      table.insert(textTable,underLine)
      table.insert(textTable,"")

      table.insert(markdownTable,"## "..section.title)
  
      table.insert(htmlTable,[[<div id="menu">]])
      table.insert(htmlTable,string.format([[<div id="menuTitle">%s</div>]],section.title))
      for i,line in ipairs(section)do
        if type(line)=="table" then
          if line.link then
            table.insert(textTable,line[1])
            table.insert(textTable,"[url="..line.link.."]"..line.link.."[/url]")--nexusmods bbcode 
            
            table.insert(markdownTable,"["..line.link.."]("..line.link..")  ")
  
            table.insert(htmlTable,string.format([[<div id="menuItem"><a href="%s">%s</a></div>]],line.link,line[1]))
          elseif line.featureDescription then
            table.insert(textTable,line.featureDescription.."  ")
            table.insert(textTable,line.featureHelp)

            table.insert(markdownTable,line.featureDescription.."  ")
            table.insert(markdownTable,line.featureHelp)
  
            table.insert(htmlTable,string.format([[<div id="menuItem">%s</div>]],EscapeHtml(line.featureDescription)))
            table.insert(htmlTable,string.format([[<div id="itemHelp">%s</div>]],EscapeHtml(line.featureHelp)))
          end
        else
          table.insert(textTable,line)

          table.insert(markdownTable,line)
  
          line=EscapeHtml(line)
          table.insert(htmlTable,string.format([[<div id="menuItem">%s</div>]],line))
        end
        table.insert(textTable,"")

        table.insert(markdownTable,"  ")
      end
  
      table.insert(htmlTable,[[</div>]])
      table.insert(htmlTable,"<br/>")
    end
  end

  --  local headerFilePath=projectFolder.."!modlua\\InfProfiles\\ProfilesHeader.txt"
  --  local headerFile=io.open(headerFilePath)
  --  local header=headerFile:read("*all")
  --  headerFile:close()
  local header={
    "-- Profiles are lists of settings for IH options.",
    "-- IH only reads this file/does not write to it.",
    "-- You can load a profile through the IH system menu by pressing <Action> on the Selected profile.",
    "-- Or by setting loadOnACCStart=true, below.",
    "-- This profile lists all options, with their default settings.",
    "-- See Features and Options.html for longer descriptions of some settings.",
    "-- Options are added and sometimes changed as IH develops, use the defaults profile and compare with a prior version using a tool like WinMerge to see changes to make sure your own profiles are correct.",
  }

  table.insert(profileTable,"-- All_Options_Example.lua")
  table.insert(profileTable,"-- Defaults / example of all profile options for IH r"..InfCore.modVersion)
  table.insert(profileTable,table.concat(header,nl))
  table.insert(profileTable,"local this={")
  table.insert(profileTable,"\tdescription=\"Defaults/All disabled\",")
  table.insert(profileTable,"\tfirstProfile=false,--puts profile first for the IH menu option, only one profile should have this set.")
  table.insert(profileTable,"\tloadOnACCStart=false,--If set to true profile will be applied on first load of ACC (actual, not just title). Any profile can have this setting, profiles will be applied in same order as listed in IH menu (alphabetical, and firstProfile first)")

  table.insert(profileTable,"\tprofile={")

  local menu=InfMenuDefs.safeSpaceMenu.options
  local skipItems=true
  local safeSpaceMenus={}
  local safeSpaceMenuNames={}

  InfCore.Log("GatherMenus safeSpace:")
  GatherMenus(menu,skipItems,safeSpaceMenus,safeSpaceMenuNames)
  --InfCore.PrintInspect(safeSpaceMenus)
  table.insert(safeSpaceMenus,1,InfMenuDefs.safeSpaceMenu)

  local priorItems={}

  InfCore.Log("PrintMenuSingle safeSpace:")
  local menuCount=1
  for i,menu in ipairs(safeSpaceMenus)do
    PrintMenuSingle(nil,menu,priorItems,skipItems,menuCount,textTable,markdownTable,htmlTable,profileTable)
    table.insert(textTable,"  ")
    --table.insert(markdownTable,nl)
    table.insert(htmlTable,"<br/>")
  end

  table.insert(textTable,"===============")
  table.insert(textTable,"")
  InfCore.Log("GatherMenus inMissionMenu:")
  menu=InfMenuDefs.inMissionMenu.options
  local inMissionMenus={}
  local inMissionMenuNames={}
  GatherMenus(menu,skipItems,inMissionMenus,inMissionMenuNames)
  table.insert(inMissionMenus,1,InfMenuDefs.inMissionMenu)
  --InfCore.PrintInspect(inMissionMenus)
  InfCore.Log("PrintMenuSingle inMissionMenus:")
  local menuCount=1
  for i,menu in ipairs(inMissionMenus)do
    PrintMenuSingle(safeSpaceMenus,menu,priorItems,skipItems,menuCount,textTable,markdownTable,htmlTable,profileTable)
    table.insert(textTable,"  ")
    table.insert(markdownTable,"  ")
    table.insert(htmlTable,"<br/>")
  end

  table.insert(htmlTable,"</body>")
  table.insert(htmlTable,"</html>")

  table.insert(profileTable,"\t}")
  table.insert(profileTable,"}")
  table.insert(profileTable,"")

  --  local heavenProfilesPath=projectFolder.."!modlua\\InfProfiles\\InfHeavenProfiles.lua"
  --  local heavenProfilesFile=io.open(heavenProfilesPath)
  --  local heavenProfiles=heavenProfilesFile:read("*all")
  --  heavenProfilesFile:close()
  --
  --  table.insert(profileTable,heavenProfiles)

  table.insert(profileTable,"")
  table.insert(profileTable,"return this")

  InfCore.Log("Writing output:")
  local textFilePath=outputFolder..featuresOutputName..".txt"
  InfCore.Log("io.open: "..textFilePath)
  local textFile=io.open(textFilePath,"w")

  local mdFilePath=outputFolder..featuresOutputName..".md"
  InfCore.Log("io.open: "..mdFilePath)
  local mdFile=io.open(mdFilePath,"w")

  local htmlFilePath=outputFolder..featuresOutputName..".html"
  InfCore.Log("io.open: "..htmlFilePath)
  local htmlFile=io.open(htmlFilePath,"w")

  local profileFilePath=profilesFolder.."All_Options_Example.lua"
  InfCore.Log("io.open: "..profileFilePath)
  local profileFile=io.open(profileFilePath,"w")

  textFile:write(table.concat(textTable,nl))
  mdFile:write(table.concat(markdownTable,nl))
  htmlFile:write(table.concat(htmlTable,nl))
  profileFile:write(table.concat(profileTable,nl))

  textFile:close()
  mdFile:close()
  htmlFile:close()
  profileFile:close()
  
  InfCore.Log"--autodoc done--"
end--AutoDoc

--tex in InfMenuDefs.systemMenu
function this.RunAutoDoc()
  InfCore.Log("RunAutoDoc start",true,true)
  
  local docsFolder=InfCore.gamePath..InfCore.modSubPath.."/docs/Infinite Heaven/"
  local profilesFolder=InfCore.gamePath..InfCore.modSubPath.."/profiles/"

  local featuresOutputName="Features and Options"

  local FeaturesHeaderChunk=LoadFile(docsFolder.."FeaturesHeader.lua")
  local FeaturesHeader=FeaturesHeaderChunk()
  
  --InfCore.PrintInspect(FeaturesHeader,"FeaturesHeader dump")--DEBUG

  this.AutoDoc(docsFolder,profilesFolder,FeaturesHeader,featuresOutputName)
  InfCore.Log("RunAutoDoc done",true,true)
end

this.langStrings={
  eng={
    runAutoDoc="Run AutoDoc",
  },
  help={
    eng={
      runAutoDoc="AutoDoc creates the Features and Options txt and html in docs folder, and profiles/All_Options_Example based on the current menus and options, including any added by other mod IH modules. It will overwrite any existing files.",
    },
  },
}--langStrings

return this
