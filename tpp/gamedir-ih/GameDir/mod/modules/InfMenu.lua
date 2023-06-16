-- InfMenu.lua
local this={}
--LOCALOPT:
local InfCore=InfCore
local InfButton=InfButton
local InfMain=InfMain
--tex TODO cant reference modules that reload (unless you build a system to update this reference)
--local InfLang=InfLang
--local Ivars=Ivars
local IvarProc=IvarProc
local IsFunc=Tpp.IsTypeFunc
local IsTable=Tpp.IsTypeTable
local GetAssetConfig=AssetConfiguration.GetDefaultCategory
local TppUiCommand=TppUiCommand
--CULL local GetElapsedTime=Time.GetRawElapsedTimeSinceStartUp
local GetElapsedTime=os.clock--GOTCHA: os.clock wraps at ~4,294 seconds
local insert=table.insert
local abs=math.abs
local pairs=pairs
local tostring=tostring

local ivars=ivars
local InfQuickMenuDefs--PostAllModulesLoad

this.updateOutsideGame=true

this.autoDisplayDefault=2.4
this.autoRateHeld=0.85
this.autoRatePressed=0.1
this.repeatRateDefault=0.85
this.repeatRateIHExt=0.25
this.repeatRateIHHMenu=0.25
this.toggleMenuHoldTime=1.25
this.quickMenuHoldTime=0.8
this.menuAltButtonHoldTime=0.2
this.stickInputRate=0.25
this.stickInputRateIHExt=0.25
this.stickInputRateIHHMenu=0.15

this.menuAltButton=InfButton.ZOOM_CHANGE
this.menuAltActive=InfButton.RELOAD
this.toggleMenuButton=InfButton.EVADE--SYNC: InfLang "menu_keys"
this.toggleMenuButtonAlt=InfButton.DASH
this.menuRightButton=InfButton.RIGHT
this.menuLeftButton=InfButton.LEFT
this.menuUpButton=InfButton.UP
this.menuDownButton=InfButton.DOWN
this.resetSettingButton=InfButton.BINOCULARS
this.menuBackButton=InfButton.STANCE
this.activateSettingButton=InfButton.ACTION
this.bigIncrementButton=InfButton.FIRE
this.smallIncrementButton=InfButton.HOLD
this.minSettingButton=InfButton.RELOAD

--tex menu on and menuAltButton down
this.stickLPadMask={
  settingName="stickLPadMask",
  sticks=PlayerPad.STICK_L,
}

--STATE
this.menuOn=false
this.quickMenuOn=false
this.currentMenu=nil
this.currentMenuOptions=nil
this.topMenu=nil
this.currentIndex=1--tex lua tables are indexed from 1
this.lastDisplay=0
this.autoDisplayRate=this.autoDisplayDefault
this.lastStickInput=0

function this.PreModuleReload()
end

function this.PostAllModulesLoad()
  if IHH then--tex close ihmenu from start
    this.MenuOff(true)
  end

  InfQuickMenuDefs=InfQuickMenuDefs_User or _G.InfQuickMenuDefs
  if InfQuickMenuDefs_User then
    InfCore.Log("InfMenu: Using InfQuickMenuDefs_User")
  end

  --DEBUGNOW
  --tex set up hold buttons
  --InfButton.buttonStates[this.toggleMenuButton].holdTime=this.toggleMenuHoldTime
  InfButton.buttonStates[this.menuAltButton].holdTime=this.menuAltButtonHoldTime
end

--IN/SIDE: InfMenuCommands.commandItems
function this.GetOptionFromRef(optionRef)
  local option,name=InfCore.GetStringRef(optionRef)
  if option then
    if type(option)=="function" then
      local itemName=InfMenuCommands.ItemNameForFunctionName(name)
      local commandItem=InfMenuCommands.commandItems[itemName]
      if commandItem==nil then
        InfCore.Log("WARNING: InfMenu.GetOptionFromRef: could not find "..tostring(optionRef).." in InfMenuCommands.commandItems")
      end
      return commandItem
    else
      if option.name==nil then
        --tex while GetStringRef will catch this if the ref is to Ivars module, since if it's not added to registerVars it wont have been built and migrated there
        --if the stringref points to a module with the base ivar def it will be happy, which will cause problems down the line
        --while we cant really do much to protect against that here, this is a good single point to warn
        InfCore.Log("WARNING: InfMenu.GetOptionFromRef option.name==nil for ".. optionRef..". Likely wasn't added to registerIvars",false,true)
      end
      return option
    end
  end
  return nil
end

function this.GetCurrentOption()
  if this.currentMenuOptions==nil then
    InfCore.Log("WARNING: InfMenu.GetCurrentOption: this.currentMenuOptions==nil")--DEBUG
    return
  end

  local optionRef=this.currentMenuOptions[this.currentIndex]
  local option=this.GetOptionFromRef(optionRef)
  if option==nil then
    InfCore.Log("WARNING: option == nil! currentIndex="..tostring(this.currentIndex),true)--DEBUG
    return
  end
  return option
end

function this.GetSettingIndex(option)
  local currentSetting=ivars[option.name]
  if option.settingIsValue then
    local listIndex=InfUtil.FindInList(option.settings,currentSetting)
    if listIndex==false then
      InfCore.Log("WARNING: GetSettingIndex settingIsValue "..option.name.." "..currentSetting.." could not find currentSetting in list")
      return nil
    else
      currentSetting=listIndex-1
    end
  end
  if this.debugModule then
    InfCore.Log("InfMenu.GetSettingIndex("..option.name..") currentSetting: "..currentSetting)
  end
  return currentSetting
end

--tex mod settings menu manipulation
function this.NextOption(incrementMult)
  local oldIndex=this.currentIndex

  local increment=1
  if incrementMult then
    increment=increment*incrementMult
    increment=math.ceil(increment)
  end

  this.currentIndex=this.currentIndex+increment
  if this.currentIndex>#this.currentMenuOptions then
    this.currentIndex=1
  end
  this.GetSetting(oldIndex)
end
function this.PreviousOption(incrementMult)
  local oldIndex=this.currentIndex

  local increment=1
  if incrementMult then
    increment=increment*incrementMult
    increment=math.ceil(increment)
  end

  this.currentIndex = this.currentIndex-increment
  if this.currentIndex < 1 then
    this.currentIndex = #this.currentMenuOptions
  end
  this.GetSetting(oldIndex)
end

function this.GetSetting(previousIndex,previousMenuOptions)
  if this.currentMenuOptions==nil then
    InfCore.Log("WARNING: currentMenuOptions == nil!",true)--DEBUG
    return
  end

  --WIP
  --  if previousIndex then
  --    local menuOptions=previousMenuOptions or this.currentMenuOptions
  --    local previousOption=this.menuOptions[this.previousIndex]
  --    if previousOption then
  --      if IsFunc(previousOption.OnDeselect) then
  --        previousOption:OnDeselect()
  --      end
  --    else
  --      InfCore.DebugPrint"InfMenu.GetSetting - no previousOption for previousIndex"--DEBUG
  --    end
  --  end

  local optionRef=this.currentMenuOptions[this.currentIndex]
  local option=this.GetOptionFromRef(optionRef)
  if option==nil then
    InfCore.Log("WARNING: option == nil! currentIndex="..tostring(this.currentIndex),true)--DEBUG
    return
  end

  --tex make sure ivar is synced from saved
  local gvar=IvarProc.GetSaved(option)
  if gvar~=nil then
    ivars[option.name]=gvar
  end
  if IsFunc(option.OnSelect) then
    InfCore.PCallDebug(option.OnSelect,option,ivars[option.name])
  end

  if InfCore.IHExtRunning() then
    if this.debugModule then
      InfCore.Log("InfMenu.GetSetting: update gui menu")
    end
    InfCore.ExtCmd('ClearCombo','menuSetting')
    if option.optionType=="OPTION" then
      local currentSetting=this.GetSettingIndex(option)

      local menuSettings={}

      if type(option.GetSettingText)=="function" then
        local min,max=IvarProc.GetRange(option)
        for i=min,max do
          local settingText=InfCore.PCallDebug(option.GetSettingText,option,i)
          table.insert(menuSettings,tostring(settingText))
        end
      elseif option.settingNames then
        if type(option.settingNames)=="table" then
          menuSettings=option.settingNames
        else
          menuSettings=InfLangProc.LangTable(option.settingNames)
        end
      --tex DEBUGNOW, will always have settingNames thanks to SetSettings and InfLangProc PostAllModulesLoad
      --so this wont be hit?
      elseif option.settings then
        menuSettings=option.settings
      end

      if this.debugModule then
        InfCore.PrintInspect(menuSettings,option.name.." menuSettings")
      end

      if #menuSettings>0 then
        for i,settingText in ipairs(menuSettings)do
          InfCore.ExtCmd('AddToCombo','menuSetting',tostring(i-1)..":"..settingText)
        end
      elseif currentSetting then
        InfCore.ExtCmd('AddToCombo','menuSetting',currentSetting)
      end

      if #menuSettings>0 then
        InfCore.ExtCmd('SelectCombo','menuSetting',currentSetting)
      elseif currentSetting then
        InfCore.ExtCmd('SelectCombo','menuSetting',0)
      end
    end--if option

    if ivars.menu_enableHelp>0 then
      local helpString=InfLangProc.LangStringHelp(option.name) or InfLangProc.LangStringHelp("simple_help")
      if helpString then
        if this.menuOn then
          InfCore.ExtCmd('UiElementVisible','menuHelp',1)
        end
        InfCore.ExtCmd('SetText','menuHelp',helpString)
      else
        InfCore.ExtCmd('UiElementVisible','menuHelp',0)
      end
    end
    --InfCore.Log("GetSetting",false,true)--DEBUG
    InfCore.WriteToExtTxt()
  end
end

--tex takes a table of numbers and number ranges, ex: {1,5,{6-10},{14-20}}
--returns the next valid for a given value
--I'm obviously no mathmagitian
function this.NextInRange(rangeTable,value,direction)
  local bottom=1
  local top=#rangeTable

  local start
  if direction>0 then
    start=bottom
  else
    start=top
  end
  local ending
  if direction>0 then
    ending=top
  else
    ending=bottom
  end

  for i=start,ending,direction do
    local range=rangeTable[i]
    local low, hi
    --tex check direct match
    if value >= range[1] and value <= range[2] then
      return value
    end

    --tex figure out gap values
    if direction>0 then
      low=range[2] or range
    else
      hi=range[1] or range
    end

    local dirRange=rangeTable[i+direction]
    if dirRange==nil then--tex reached an end, let the callee handle the wrap
      return -1
    end

    if direction>0 then
      hi=dirRange[1] or dirRange
    else
      low=dirRange[2] or dirRange
    end

    --in gap?
    if value>low and value<hi then
      if direction>0 then
        return hi
      else
        return low
      end
    end
  end--for
end

function this.IncrementWrap(current,increment,min,max)
  local newSetting=current+increment
  if increment > 0 then
    if newSetting > max then
      newSetting = min
    end
  elseif increment < 0 then
    if newSetting < min then
      newSetting = max
    end
  end
  return newSetting
end

function this.ChangeSetting(option,increment)
  local currentSetting=this.GetSettingIndex(option)
  local min,max=IvarProc.GetRange(option)
  local newSetting=this.IncrementWrap(currentSetting,increment,min,max)
  if option.settingIsValue then
    newSetting=option.settings[newSetting+1]
  end
  if option.SkipValues and IsFunc(option.SkipValues) then
    while option:SkipValues(newSetting) do
      newSetting=this.IncrementWrap(newSetting,increment,min,max)
    end
  end
  if this.debugModule then
    InfCore.Log("InfMenu.ChangeSetting: "..option.name.." value:"..increment.." min:"..min.." max:"..max.." currentSetting:"..currentSetting.." newSetting:"..newSetting)
  end

  IvarProc.SetSetting(option,newSetting)
end

function this.SetCurrent()--tex refresh current setting/re-call OnChange
  local optionRef=this.currentMenuOptions[this.currentIndex]
  local option=this.GetOptionFromRef(optionRef)
  if option then
    local currentSetting=this.GetSettingIndex(option)
    if currentSetting then
      if option.settingIsValue then
        currentSetting=option.settings[currentSetting+1]
      end
      IvarProc.SetSetting(option,currentSetting)
    end
  end
end

function this.ActivateCurrent()--tex run activate function
  local optionRef=this.currentMenuOptions[this.currentIndex]
  local option=this.GetOptionFromRef(optionRef)
  if option then
    if IsFunc(option.OnActivate) then
      InfCore.PCallDebug(option.OnActivate,option,ivars[option.name])
    else
      this.SetCurrent()
    end
  end
end

function this.NextSetting(incrementMult)
  local optionRef=this.currentMenuOptions[this.currentIndex]
  local option=this.GetOptionFromRef(optionRef)
  if option==nil then
    InfCore.Log("WARNING: InfMenu.NextSetting: option==nil")
    return
  end
 
  local increment=option.range and option.range.increment or 1
  if incrementMult then
    increment=increment*incrementMult
    if not option.isFloat then
      increment=math.ceil(increment)
    end
  end
  if option.options then--tex is menu
    this.GoMenu(option)
  elseif IsFunc(option.GetNext) then
    local newSetting=option:GetNext(ivars[option.name],increment)
    IvarProc.SetSetting(option,newSetting)
  else
    this.ChangeSetting(option,increment)
  end
end--NextSetting
function this.PreviousSetting(incrementMult)
  local optionRef=this.currentMenuOptions[this.currentIndex]
  local option=this.GetOptionFromRef(optionRef)
  if option==nil then
    InfCore.Log("WARNING: InfMenu.PreviousSetting: option==nil")
  end
  local increment=option.range and option.range.increment or 1
  increment=-increment
  if incrementMult then
    increment=increment*incrementMult
    if not option.isFloat then
      increment=math.floor(increment)
    end
  end
  if IsFunc(option.GetPrev) then
    local newSetting=option:GetPrev(ivars[option.name],increment)
    IvarProc.SetSetting(option,newSetting)
  else
    this.ChangeSetting(option,increment)
  end
end

function this.GoMenu(menu,goBack)
  if menu.options==nil then
    InfCore.Log("WARNING: GoMenu menu var "..tostring(menu.name).." is not a menu",true,true)
    return
  end
  InfCore.LogFlow("InfMenu.GoMenu:"..menu.name)--DEBUG

  if not goBack and menu~=this.topMenu and menu~=this.currentMenu then
    menu.parent=this.currentMenu
    menu.parentOption=this.currentIndex
  end

  local previousIndex=this.currentIndex
  if goBack then
    this.currentIndex=this.currentMenu.parentOption
  else
    this.currentIndex=1
  end

  local previousMenuOptions=this.currentMenuOptions

  this.currentMenu=menu
  this.currentMenuOptions=menu.options

  this.DisplayCurrentMenu()

  this.GetSetting(previousIndex,previousMenuOptions)
end

function this.GoBackCurrent()
  if this.currentMenu.parent==nil then
    if this.currentMenu~=this.topMenu then
      InfCore.Log("ERROR GoBackCurrent parent == nil")
    end
    return
  end
  this.GoMenu(this.currentMenu.parent,true)
  if this.currentMenu.name and this.menuOn then
    if not InfCore.IHExtRunning() then
      this.PrintLangId(this.currentMenu.name)
    end
  end
end

--tex display settings
function this.DisplayCurrentSetting()
  if this.menuOn then
    this.DisplaySetting(this.currentIndex)
  end
end

function this.DisplayCurrentMenu()
  if InfCore.IHExtRunning() then
    local menuName=InfLangProc.LangString(this.currentMenu.name)
    InfCore.ExtCmd('SetContent','menuTitle',menuName)

    InfCore.ExtCmd('ClearTable','menuItems')
    for optionIndex=1,#this.currentMenuOptions do
      local optionRef=this.currentMenuOptions[optionIndex]
      local option=this.GetOptionFromRef(optionRef)
      local optionAndSettingText=optionIndex..":"..optionRef.." not found"
      if option==nil then
        InfCore.ExtCmd('ClearCombo','menuSetting')
      else
        if option.OnSelect then
          option:OnSelect(ivars[option.name])
        end
        optionAndSettingText=this.GetOptionAndSettingText(optionIndex,option)
      end
      InfCore.ExtCmd('AddToTable','menuItems',optionAndSettingText)
    end
    --InfCore.Log("Gomenu",false,true)--DEBUG
    InfCore.WriteToExtTxt()
  end  
end--DisplayCurrentMenu
--tex no actual logic, but keeping it consitant with the rest of the below functions
--optionIndex: index of option in options list of menu its in
function this.GetOptionIndexText(optionIndex)
  return optionIndex..":"
end--
function this.GetOptionText(option)
  return option.description or InfLangProc.LangString(option.name) or ""
end--GetOptionText
local itemIndicators={
  equals=" = ",
  colon=" :",
  menu=" > ",
  command=" >> ",
  command_menu_off=" >] ",
  mode=" >[] ",
  activate=" >! ",
  on_change=" <> ",
}
function this.GetOptionIndicator(option)
  if option.isMenuOff then
    return itemIndicators.command_menu_off
  elseif option.optionType=="COMMAND" then
    return itemIndicators.command
  elseif option.optionType=="MENU" then
    return itemIndicators.menu
  --elseif option.isMode then
  --  return itemIndicators.mode
  --DEBUGNOW see if there's any ivars with both OnActivate and OnChange
  elseif option.OnActivate then
     return itemIndicators.activate
  elseif option.OnChange then
    return itemIndicators.on_change      
  elseif IsFunc(option.GetSettingText) then
    return itemIndicators.equals
  elseif IsTable(option.settingNames) then--tex direct table of names (like mbSelectedDemo) or the fallback - settings table
    return itemIndicators.equals
  elseif option.settingNames then
    return itemIndicators.equals
  else
    return itemIndicators.equals
  end
end--GetOptionIndicator
function this.GetSettingIndexText(option,setting)
  --tex TODO: rethink complicated conditions
  if option.optionType=="OPTION" and (option.settingNames or option.settingsTable or option.GetSettingText) then--
    return tostring(setting)..":"
  else
    return ""
  end
end--GetSettingIndex
function this.GetSettingText(option,setting)
  local settingText=""
  if option.isMenuOff then
    settingText=""
  elseif option.optionType=="COMMAND" then
    settingText=""
  elseif option.optionType=="MENU" then
    settingText=""
  elseif setting==nil then
    --tex this is very specifically at this point because MENU options dont have an ivar entry (I think commands might, but we don't need their setting)
    --see option.name==nil warning in GetOptionFromRef for other reason this could be hit
    settingText=": ERROR: setting==nil"
  elseif IsFunc(option.GetSettingText) then
    settingText=InfCore.PCallDebug(option.GetSettingText,option,setting)
    if settingText==nil then
      settingText=" WARNING: GetSettingText nil"
      InfCore.Log(settingText.." for option "..option.name,false,true)
    end
    settingText=tostring(settingText)
  elseif IsTable(option.settingNames) then--tex direct table of names (like mbSelectedDemo) or the fallback - settings table
    if option.settingIsValue then
      local currentIndex=InfUtil.FindInList(option.settingNames,setting)
      if currentIndex==false then
        settingText=" WARNING: could not find value in settings: "..tostring(setting)
      else
        settingText=option.settingNames[currentIndex]
      end
    elseif setting < 0 or setting > #option.settingNames-1 then
      settingText=" WARNING: current setting out of settingNames bounds"
      InfCore.Log(settingText.." for option "..option.name)
      InfCore.PrintInspect(option.settingNames,option.name..".settingNames")
    else
      settingText=option.settingNames[setting+1]
    end
  elseif option.settingNames then--tex just a string langTable id
    settingText=InfLangProc.LangTableString(option.settingNames,setting+1)
  else
    settingText=tostring(setting)
  end
  return settingText
end--GetSettingText
function this.GetSettingSuffix(option)
  if option.isPercent then
    return "%"
  end
  
  return ""
end--GetSettingSuffix
--Gets full options and settings line for use in both the legacy/announcelog menu, and for the IHExt/IHHook menu items/options list
function this.GetOptionAndSettingText(optionIndex,option)
  if this.debugModule then
    if option and option.name then
      InfCore.Log("InfMenu.GetOptionAndSettingText("..tostring(optionIndex)..',"'..option.name..'")')
    end
    --InfCore.PrintInspect(option,"InfMenu.GetOptionAndSettingText "..tostring(optionIndex))
  end

  --tex GetOptionFromRef warning should give more info
  if option.name==nil then
    local err="WARNING: option.name==nil for optionIndex "..optionIndex
    InfCore.Log(err,true,true)
    --InfCore.PrintInspect(option,"option")
    return err
  end
  
  local currentSetting=ivars[option.name]
  --DEBUGNOW tex any other option types that dont ivars?
  --TODO: should commit to either everything having ivars, or make it clear what doesnt 
  if option.optionType=="MENU" then
    currentSetting=0
  elseif currentSetting==nil then
    InfCore.Log("ERROR: ivars["..option.name.."]==nil",true,true)
  end

  --REF
  --1:SomeOption = 102
  --4:SomeOption = 102%
  --5:SomeOption = 3:SomeSetting
  --2:SomeOption >! 3:SomeActivateSetting
  --3:SomeOption <> 2:SomeSettingWithOnChange
  --8:SomeCommand >>
  --2:SomeMenu >
  --9:Go back >>
  --3:Do and close >]
  --optionIndexText..optionText..optionSeperator..settingIndex..settingText..settingSuffix
  --ex ['4: ' optionIndexText]['SomeOption' optionText][' = ' optionSeperator]['' settingIndex]['102' settingText]['%' settingSuffix]
  --with settingIndex being empty string in that case because it's for an option with a direct number value instead of a number of different identified settings
  --otherwise would be something like ['2:' settingIndex]

  local optionIndexText=this.GetOptionIndexText(optionIndex)
  local optionText=this.GetOptionText(option)
  local optionSeperator=this.GetOptionIndicator(option)
  local settingIndex=this.GetSettingIndexText(option,currentSetting)
  local settingText=this.GetSettingText(option,currentSetting)
  local settingSuffix=this.GetSettingSuffix(option)

  return optionIndexText..optionText..optionSeperator..settingIndex..settingText..settingSuffix
end--GetOptionAndSettingText
--For IHExt/IHHook menu 'menuLine' which is just below the options list and above 'menuSetting' text/combo box
function this.GetMenuLineText(optionIndex,option)
  --tex GetOptionFromRef warning should give more info
  if option.name==nil then
    local err="WARNING: option.name==nil for optionIndex "..optionIndex
    InfCore.Log(err,true,true)
    --InfCore.PrintInspect(option,"option")
    return err
  end

  --REF: menuLine: is pretty much normal option and setting text (see GetOptionAndSettingText for REF), minus the actual setting text
  --keeping the settingSuffix since the line below menuLine is menuSetting(s) which is plain value for if you're typing to enter value
  --TODO rethink that
  --menuLine:     4:SomeOption = %
  --menuSetting:  40

  local optionIndexText=this.GetOptionIndexText(optionIndex)
  local optionText=this.GetOptionText(option)
  local optionSeperator=this.GetOptionIndicator(option)
  local settingIndex=""
  local settingText=""
  local settingSuffix=this.GetSettingSuffix(option)

  return optionIndexText..optionText..optionSeperator..settingIndex..settingText..settingSuffix
end--GetMenuLineText

function this.DisplaySetting(optionIndex)      
  local optionRef=this.currentMenuOptions[optionIndex]
  local option=this.GetOptionFromRef(optionRef)

  local optionAndSettingText=optionIndex..":"..optionRef.." not found"
  if option==nil then
    InfCore.Log("ERROR: InfMenu.DisplaySetting: "..optionAndSettingText,true,true)
  end
  
  if InfCore.IHExtRunning() then
    if option==nil then
      InfCore.ExtCmd('ClearCombo','menuSetting')
      InfMgsvToExt.SetMenuLine(optionAndSettingText,optionAndSettingText)
    else
      local optionAndSettingText=this.GetOptionAndSettingText(optionIndex,option)
      local menuLineText=this.GetMenuLineText(optionIndex,option)
      InfMgsvToExt.SetMenuLine(optionAndSettingText,menuLineText)
    end
    --InfCore.Log("DisplaySetting",false,true)--DEBUG
    InfCore.WriteToExtTxt()
  else

    if option==nil then
    else
      optionAndSettingText=this.GetOptionAndSettingText(optionIndex,option)
    end
    TppUiCommand.AnnounceLogDelayTime(0)
    TppUiCommand.AnnounceLogView(optionAndSettingText)
  end
  this.lastDisplay=GetElapsedTime()
end
--tex display all UNUSED CULL 
function this.DisplaySettings()
  for i=1,#this.currentMenuOptions do
    this.DisplaySetting(i)
  end
end

function this.AutoDisplay()
  if this.autoDisplayRate > 0 then
    if GetElapsedTime()-this.lastDisplay>this.autoDisplayRate then
      this.DisplayCurrentSetting()
    end
  end
  --OFF
  --  if GetElapsedTime()-this.lastDisplay>this.autoRatePressed then
  --    this.DisplayQueue()
  --  end
end
function this.GetCurrentHelpText()
  local optionRef=this.currentMenuOptions[this.currentIndex]
  local option=this.GetOptionFromRef(optionRef)
  if option then
    --this.lastDisplay=GetElapsedTime()
    return InfLangProc.LangStringHelp(option.name)
  end
end
function this.ResetSetting()
  local optionRef=this.currentMenuOptions[this.currentIndex]
  local option=this.GetOptionFromRef(optionRef)
  if option and option.optionType=="OPTION" then
    IvarProc.SetSetting(option,option.default)
    this.PrintLangId"setting_default"--"Setting to default.."
    this.DisplayCurrentSetting()
  end
end
function this.MinSetting()
  local optionRef=this.currentMenuOptions[this.currentIndex]
  local option=this.GetOptionFromRef(optionRef)
  if option and option.optionType=="OPTION" then
    local min,max=IvarProc.GetRange(option)
    IvarProc.SetSetting(option,min)
    this.PrintLangId"setting_minimum"--"Setting to minimum.."
    this.DisplayCurrentSetting()
  end
end
function this.ResetSettings()
  for n,menu in pairs(InfMenuDefs.allMenus) do
    --InfCore.DebugPrint(menu.name)
    for m,optionRef in pairs(menu.options) do
      --InfCore.DebugPrint(option.name)
      local option=this.GetOptionFromRef(optionRef)
      if option and option.save then--tex using identifier for all ivar/resetable settings
        --InfCore.DebugPrint(option.name)--DEBUG
        if ivars[option.name]~=option.default then
          IvarProc.SetSetting(option,option.default)
        end
      end
    end
  end
end
function this.ResetSettingsDisplay()
  this.PrintLangId"setting_defaults"--"Setting mod options to defaults..."
  for i=1,#this.currentMenuOptions do
    local optionRef=this.currentMenuOptions[i]
    local option=this.GetOptionFromRef(optionRef)
    if option and option.save then
      IvarProc.SetSetting(option,option.default)
      this.DisplaySetting(i)
    end
  end
  this.GetSetting()
  if InfCore.IHExtRunning() then
    this.GoMenu(this.currentMenu)--tex update IHMenu the easy way.
  end
end
--
function this.Print(message,...)
  if ... then
    TppUiCommand.AnnounceLogView(string.format(message,...))
  else
    TppUiCommand.AnnounceLogView(message)
  end
end

function this.PrintLangId(langId)
  TppUiCommand.AnnounceLogView(InfLangProc.LangString(langId))
end

function this.PrintFormatLangId(langId,...)
  TppUiCommand.AnnounceLogView(string.format(InfLangProc.LangString(langId),...))
end

function this.ToggleMenu(currentChecks)
  InfCore.LogFlow"InfMenu.ToggleMenu"
  --DEBUGNOW if this.CheckActivate(currentChecks) then
  this.menuOn = not this.menuOn
  if this.menuOn then
    this.OnActivate()
  else
    this.OnDeactivate()
    return
  end
  -- end
end

function this.MenuOff(skipSave)
  InfCore.LogFlow"InfMenu.MenuOff"
  this.menuOn=false
  this.OnDeactivate(skipSave)
end

function this.OnActivate()
  InfCore.LogFlow"InfMenu.OnActivate"
  this.ActivateControlSet()

  this.GetSetting()
  TppUiStatusManager.ClearStatus"AnnounceLog"

  local message=InfCore.modName.." r"..InfCore.modVersion.." ".. InfLangProc.LangString"menu_open_help"--(Press Up/Down,Left/Right to navigate menu)
  TppUiCommand.AnnounceLogView(message)

  if InfCore.IHExtRunning() then
    InfMgsvToExt.ShowMenu()
    if Ivars.menu_enableCursorOnMenuOpen:Is(1)then
      InfCore.ExtCmd('EnableCursor',1)
    end
    --InfCore.WriteToExtTxt()--tex handled in DisplaySetting
    this.DisplayCurrentSetting()
  end

  InfMain.OnMenuOpen()
end

function this.OnDeactivate(skipSave)
  InfCore.LogFlow"InfMenu.OnDeactivate"
  this.PrintLangId"menu_off"--"Menu Off"
  --InfMain.RestoreActionFlag()
  this.DeactivateControlSet()
  InfMain.OnMenuClose(skipSave)

  if InfCore.IHExtRunning() then
    InfMgsvToExt.HideMenu()
    InfCore.WriteToExtTxt()
  end
end

function this.CheckActivate(currentChecks)
  local disallowCheck=currentChecks.inGroundVehicle or currentChecks.onBuddy or currentChecks.inBox
  return not disallowCheck and not TppUiCommand.IsMbDvcTerminalOpened()
end

--tex CULL, handled on a command by command basis
--function this.CheckActivateQuickMenu(execCheck)
--  local disallowCheck=execCheck.inGroundVehicle or execCheck.onBuddy or execCheck.inBox
--  return not disallowCheck and not TppUiCommand.IsMbDvcTerminalOpened()
--end
--tex called directly from InfMain.UpdateBottom
function this.Update(currentChecks,currentTime,execChecks,execState)
  local InfMenuDefs=InfMenuDefs

  --tex current stuff in OnDeactivate doesnt need/want to be run in !inGame, so just dump out
  --TODO NOTE controlset deactivate on game state change
  --DEBUGNOW this blocks SSD title, and potenially other stuff like a loading screen recovery/debug menu
  --DEBUGNOW test not indemo
  if not currentChecks.inGame and not currentChecks.inDemo and not currentChecks.isAtTitle then
    if this.menuOn then
      this.MenuOff()
    end
    return
  end

  if not currentChecks.missionCanStart then
    if this.menuOn then
      this.MenuOff()
    end
    return
  end

  if this.menuOn then
    --TODO NOTE controlset deactivate on game state change
    --DEBUGNOW if not this.CheckActivate(currentChecks) then
    if currentChecks.inIdroid then
      if not currentChecks.usingGuiMenu then
        this.MenuOff()
        return
      end
    end
    --tex while pause is bound to escape key by default it is not actually the ESCAPE button mask
    --so if pause is bound to something else this wont catch it.
    if not IHH and InfButton.OnButtonDown(InfButton.ESCAPE) then--DEBUGNOW not IHH test
      this.MenuOff()
      return
    end
  end--menuOn

  local rootMenu=InfMenuDefs.nonMenu
  if currentChecks.inDemo then
    rootMenu=InfMenuDefs.inDemoMenu
  elseif InfMain.isAtTitle then
    rootMenu=InfMenuDefs.titleMenu
  elseif not currentChecks.inGame then
    rootMenu=InfMenuDefs.loadingMenu
  elseif currentChecks.inSafeSpace then
    rootMenu=InfMenuDefs.safeSpaceMenu
  elseif currentChecks.inGame then
    rootMenu=InfMenuDefs.inMissionMenu
  end
  if this.topMenu~=rootMenu then
    if rootMenu==InfMenuDefs.safeSpaceMenu then
      IvarProc.PrintGvarSettingMismatch()--DEBUG
    end
    this.topMenu=rootMenu
    this.GoMenu(rootMenu)
  end--if ~=rootMenu


  if ivars.menu_disableToggleMenuHold==0 and InfButton.OnButtonHoldTime(this.toggleMenuButton) then
    --InfCore.DebugPrint"OnButtonHoldTime toggleMenuButton"--DEBUG
    if this.CheckActivate(currentChecks) then
      this.ToggleMenu(currentChecks)
    end
  end

  if InfButton.ButtonHeld(this.menuAltButton) then
    if InfButton.OnButtonDown(this.toggleMenuButtonAlt) then
      --DEBUGNOW not doing CheckActivate?
      this.ToggleMenu(currentChecks)
      return
    end
  end

  if this.menuOn then
    if InfButton.ButtonHeld(this.menuAltButton) then
      if InfButton.OnButtonDown(this.menuAltActive) then
        if currentChecks.usingGuiMenu then
          InfCore.ExtCmd('TakeFocus')
          InfCore.WriteToExtTxt()
        end
        return
      end
    end
  end--menuOn

  if this.menuOn then
    this.DoControlSet(currentChecks,currentTime,execChecks,execState)

    if not currentChecks.usingGuiMenu then
      this.AutoDisplay()
    end
  end--menuOn

  --quickmenu>
  if InfQuickMenuDefs and not this.menuOn then
    if InfQuickMenuDefs.forceEnable or ivars.enableQuickMenu==1 then
      local quickMenuHoldButton=InfQuickMenuDefs.quickMenuHoldButton or this.menuAltButton
      this.quickMenuOn=InfButton.ButtonHeld(quickMenuHoldButton)
      local quickMenu=InfQuickMenuDefs.inMission
      if currentChecks.inSafeSpace then
        quickMenu=InfQuickMenuDefs.inSafeSpace or InfQuickMenuDefs.inHeliSpace--LEGACY
      end
      if currentChecks.inDemo then
        quickMenu=InfQuickMenuDefs.inDemo
      end
      if quickMenu==nil then

      else
        this.DoQuickMenu(quickMenu,quickMenuHoldButton)
      end--quickMenu
    end--forceEnable or enableQuickMenu
  end--menuOn
  --<
end--Update

function this.ActivateControlSet()
  --tex set up hold buttons
  InfButton.buttonStates[this.toggleMenuButton].holdTime=this.toggleMenuHoldTime
  InfButton.buttonStates[this.menuAltButton].holdTime=this.menuAltButtonHoldTime

  if InfQuickMenuDefs and InfQuickMenuDefs.quickMenuHoldButton then
    InfButton.buttonStates[InfQuickMenuDefs.quickMenuHoldButton].holdTime=this.quickMenuHoldTime
  end

  InfButton.buttonStates[this.menuUpButton].decrement=0.1
  InfButton.buttonStates[this.menuDownButton].decrement=0.1
  InfButton.buttonStates[this.menuRightButton].decrement=0.1
  InfButton.buttonStates[this.menuLeftButton].decrement=0.1

  local repeatRate=this.repeatRateDefault
  if InfCore.IHExtRunning() then
    InfButton.incrementMultIncrementMult=1.05--tex TODO: really only want this on setting change, not option/menu up/down
    repeatRate=this.repeatRateIHExt
    if IHH then
      repeatRate=this.repeatRateIHHMenu
    end
  end
  InfButton.buttonStates[this.menuUpButton].repeatRate=repeatRate
  InfButton.buttonStates[this.menuDownButton].repeatRate=repeatRate
  InfButton.buttonStates[this.menuRightButton].repeatRate=repeatRate
  InfButton.buttonStates[this.menuLeftButton].repeatRate=repeatRate
  InfButton.buttonStates[this.resetSettingButton].repeatRate=repeatRate
  InfButton.buttonStates[this.menuBackButton].repeatRate=repeatRate

  InfMain.DisableAction(InfMain.menuDisableActions)
end--ActivateControlSet

function this.DeactivateControlSet()
  Player.ResetPadMask(this.stickLPadMask)
  InfMain.EnableAction(InfMain.menuDisableActions)
end

function this.DoControlSet(currentChecks,currentTime,execChecks,execState)
  if InfButton.OnButtonDown(this.minSettingButton) then
    this.MinSetting()
  end

  if InfButton.OnButtonDown(this.activateSettingButton) then
    this.ActivateCurrent()
    --this.DisplayCurrentSetting()
  end

  if not this.quickMenuOn and InfButton.OnButtonHoldTime(this.resetSettingButton)then
    this.ResetSetting()
  end
  if not this.quickMenuOn and InfButton.OnButtonHoldTime(this.menuBackButton) then
    this.GoBackCurrent()
  end

  --tex dont do, menu navigation buttons in idroid since its button driven itself
  --can still use menu directly with mouse
  if currentChecks.inIdroid then
    return
  end

  local incrementMod=1
  if InfButton.ButtonDown(this.bigIncrementButton) then
    incrementMod=10
  end

  if InfButton.OnButtonDown(this.menuUpButton) then
    this.PreviousOption(incrementMod)
    this.DisplayCurrentSetting()
  elseif InfButton.OnButtonRepeat(this.menuUpButton) then
    --tex stop at top/must manually step past
    if this.currentIndex>1 then
      this.PreviousOption(incrementMod)
      this.DisplayCurrentSetting()
    end
  end
  if InfButton.OnButtonDown(this.menuDownButton) then
    this.NextOption(incrementMod)
    this.DisplayCurrentSetting()
  elseif InfButton.OnButtonRepeat(this.menuDownButton) then
    --tex stop at end/must manually step past
    if this.currentIndex<#this.currentMenuOptions then
      this.NextOption(incrementMod)
      this.DisplayCurrentSetting()
    end
  end

  local incrementMod=1
  if InfButton.ButtonDown(this.bigIncrementButton) then
    incrementMod=10
  elseif InfButton.ButtonDown(this.smallIncrementButton) then
    incrementMod=0.1
  end

  if InfButton.OnButtonDown(this.menuRightButton) then
    this.NextSetting(incrementMod)
    this.DisplayCurrentSetting()
    InfButton.buttonStates[this.menuRightButton].repeatStart=GetElapsedTime()+1--tex slow initial repeat so you dont advance the setting immediately after menu
  elseif InfButton.OnButtonUp(this.menuRightButton) then
    this.autoDisplayRate=this.autoDisplayDefault
  elseif InfButton.OnButtonRepeat(this.menuRightButton) then
    --tex TODO halt on bounds/dont wrap (if there are any)
    this.autoDisplayRate=this.autoRateHeld
    this.NextSetting(incrementMod*InfButton.GetRepeatMult())
    --tex handled by autodisplay if not ihext otherwise announcelog would choke on too many updates
    if currentChecks.usingGuiMenu then
      this.DisplayCurrentSetting()
    end
  end--menuRightButton

  if InfButton.OnButtonDown(this.menuLeftButton) then
    this.PreviousSetting(incrementMod)
    this.DisplayCurrentSetting()
  elseif InfButton.OnButtonUp(this.menuLeftButton) then
    this.autoDisplayRate=this.autoDisplayDefault
  elseif InfButton.OnButtonRepeat(this.menuLeftButton) then
    --tex TODO halt on bounds/dont wrap (if there are any)
    this.autoDisplayRate=this.autoRateHeld
    this.PreviousSetting(incrementMod*InfButton.GetRepeatMult())
    if currentChecks.usingGuiMenu then
      this.DisplayCurrentSetting()
    end
  end--menuLeftButton

  --tex left stick to advance menu setting
  if InfButton.ButtonHeld(this.menuAltButton) then
    Player.SetPadMask(this.stickLPadMask)

    local leftStickX=PlayerVars.leftStickXDirect
    local leftStickY=PlayerVars.leftStickYDirect

    local deadZone=0.5
    if abs(leftStickX)<deadZone then
      leftStickX=0
    end
    if abs(leftStickY)<deadZone then
      leftStickY=0
    end

    --InfCore.Log(leftStickX..","..leftStickY)--DEBUGNOW

    --DEBUGNOW TODO: repeat timer, proportional to stick dist
    --TODO: halt at bounds (once you can differentiate with repeat)
    local elapsedTime=GetElapsedTime()
    local stickInputRate=this.stickInputRate
    if currentChecks.usingGuiMenu then
      stickInputRate=this.stickInputRateIHExt
      if IHH then
        stickInputRate=this.stickInputRateIHHMenu
      end
    end
    if elapsedTime-this.lastStickInput>stickInputRate then
      if leftStickY<0 then
        this.lastStickInput=elapsedTime
        this.PreviousOption(incrementMod)
        this.DisplayCurrentSetting()
      elseif leftStickY>0 then
        this.lastStickInput=elapsedTime
        this.NextOption(incrementMod)
        this.DisplayCurrentSetting()
      end

      if leftStickX<0 then
        this.lastStickInput=elapsedTime
        this.PreviousSetting(incrementMod)
        this.DisplayCurrentSetting()
      elseif leftStickX>0 then
        this.lastStickInput=elapsedTime
        this.NextSetting(incrementMod)
        this.DisplayCurrentSetting()
      end
    end--stick repeat
  end--menuAltButton held

  if InfButton.OnButtonUp(this.menuAltButton) then
    Player.ResetPadMask(this.stickLPadMask)
  end

end--DoControlSet

function this.DoQuickMenu(quickMenu,quickMenuHoldButton)
  for button,commandInfo in pairs(quickMenu) do
    if button==this.menuAltButton then

    else
      InfButton.buttonStates[button].holdTime=0.9--DEBUGNOW --commandInfo.immediate and 0.05 or 0.9
      if commandInfo.immediate then
        this.quickMenuOn=InfButton.ButtonDown(quickMenuHoldButton)--WORKAROUND: TODO why?
      end

      if (commandInfo.immediate and InfButton.OnButtonDown(button)) or
        InfButton.OnButtonHoldTime(button) then
        --tex have to be careful with order when doing combos since OnButtonHold (and others) update state
        if this.quickMenuOn then
          local Command=InfCore.GetStringRef(commandInfo.Command)
          if Command==nil then
            InfCore.Log("WARNING: Could not find function for QuickMenu command:"..tostring(commandInfo.Command))
          elseif type(Command)~="function"then
            InfCore.Log("WARNING: QuickMenu command "..tostring(commandInfo.Command).." is not a function")
          else
            Command()
          end
        end--quickMenuOn
      end--immediate or command button
    end--!|menuAltButton
  end--for quickMenu
end--DoQuickmenu

local didWelcome=false
function this.ModWelcome()
  if this.menuOn then
    return
  end
  if didWelcome then
    return
  end
  didWelcome=true

  --if gvars.disableModWelcome==1 and InfMain.version==InfMain.lastVersion then TODO:
  --  return
  --end
  TppUiCommand.AnnounceLogDelayTime(0)

  InfMenu.Print(InfCore.modName.." r"..InfCore.modVersion)
  InfMenu.PrintLangId"menu_keys"
end

function this.BuildProfileMenu(profile)
  local revertProfile={}
  local options={}
  for ivarName,setting in pairs(profile)do
    local ivar=Ivars[ivarName]
    if ivar==nil then
      InfCore.DebugPrint("WARNING: BuildProfileMenu - could not find ivar "..ivarName)--DEBUG
    else
      revertProfile[ivarName]=ivars[ivar.name]
      options[#options+1]=ivar
    end
  end
  options[#options+1]='InfMenuCommands.RevertProfile'
  options[#options+1]='InfMenuCommands.GoBackItem'

  return {
    isProfileMenu=true,
    revertProfile=revertProfile,
    options=options
  }
end

function this.RevertProfileMenu()
  --tex profile menu applies with nosave, so revert
  if this.currentMenu.isProfileMenu then
    for i,option in pairs(this.currentMenu.options) do
      IvarProc.UpdateSettingFromGvar(option)
    end
  end
end

local nonSearchItems={
  menuOffItem=true,
  searchItem=true,
}

function this.BuildMenuDefForSearch(searchString)
  local newMenuDef={
    options={}
  }
  local foundItems={}
  if searchString and searchString~="" then
    searchString=searchString:lower()

    local searchItems
    if InfMain.IsSafeSpace(vars.missionCode) then
      searchItems=InfMenuDefs.allItems.safeSpaceMenu
    else
      searchItems=InfMenuDefs.allItems.inMissionMenu
    end

    for i,optionRef in ipairs(searchItems)do
      local option,name=InfCore.GetStringRef(optionRef)
      local langName=InfLangProc.LangString(name):lower()
      if string.find(langName,searchString,1,true) then
        foundItems[optionRef]=true
      end
    end
  end
  for optionRef,found in pairs(foundItems)do
    insert(newMenuDef.options,optionRef)
  end
  table.sort(newMenuDef.options)
  if #newMenuDef.options == 0 then--DEBUGNOW tex not sure why I had this -v- item in the first place, but I've now added a check to make it a 'search found nothing' indicator
    insert(newMenuDef.options,1,"Ivars.searchItem")
  end
  insert(newMenuDef.options,"InfMenuCommands.GoBackTopItem")
  return newMenuDef
end

--MenuCommand
function this.GoBackTop()
  if InfMain.IsSafeSpace(vars.missionCode) then
    this.topMenu=InfMenuDefs.safeSpaceMenu
  else
    this.topMenu=InfMenuDefs.inMissionMenu
  end
  this.GoMenu(this.topMenu)
end

return this
