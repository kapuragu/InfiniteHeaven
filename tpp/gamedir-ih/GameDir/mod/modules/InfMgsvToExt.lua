-- InfMgsvToExt.lua
local this={}

local InfCore=InfCore
local ivars=ivars
local ExtCmd=InfCore.ExtCmd

local concat=table.concat
local type=type

this.debugModule=false

--FORMAT
--uiElements={
--  name={<uielement info>}
--}
this.uiElements={}

function this.PostModuleReload(prevModule)
  this.uiElements=prevModule.uiElements
end

function this.Init()
  --DEBUGNOW
--  if vars.missionCode <=5 then
--    ExtCmd("UiElementVisible","runningLabel",1)
--  else
--    ExtCmd("UiElementVisible","runningLabel",0)
--  end
--  InfCore.WriteToExtTxt()
end

--mgsvtoext commands
--tex creates a ui element from a wpf xaml definition
function this.CreateUiElement(name,xamlStr)
  if this.uiElements[name] then
    InfCore.Log('WARNING: CreateUiElement: uiElement '..name..' already exists')
    --DEBUGNOW return
  end

  this.uiElements[name]=xamlStr

  --InfCore.PrintInspect(xamlStr,'xamlStr')--DEBUG
  ExtCmd('CreateUiElement',name,xamlStr)
end

function this.RemoveUiElement(name)
  if not this.uiElements[name] then
    InfCore.Log('WARNING: RemoveElement: could not find uiElement '..name)
    return
  end

  ExtCmd('RemoveUiElement',name)
end

--Menu specific

--tex TODO: IHExt currently uses line end as command end so cant wrap whole lot in [[]]
--but this way defeats the purpose of being able to just copy over xaml from vs
local menuLineXaml={
  [[<Label ]],
  [[xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" ]],
  [[Name="menuLine" ]],
  [[Content="--menuLine--" ]],
  [[Foreground="White" ]],
  [[Background="Transparent" ]],
  [[FontSize="25" ]],
  [[Canvas.Left="45" ]],
  [[Canvas.Top="545">]],
  [[<Label.Effect>]],
  [[<DropShadowEffect ]],
  [[ShadowDepth="2" ]],
  [[Direction="325" ]],
  [[Color="Black" ]],
  [[Opacity="1" ]],
  [[BlurRadius="0.0"/>]],
  [[</Label.Effect>]],
  [[</Label>]],
}

local inputLineXaml={
  [[<TextBox ]],
  [[xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" ]],
  [[xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" ]],
  [[Name="inputLine" ]],
  [[Height="26" ]],
  [[MinWidth="36" ]],
  [[Foreground="White" ]],
  [[Background="Black" ]],
  [[FontSize="16"  ]],
  [[VerticalContentAlignment="Center" ]],
  [[Canvas.Left="140"  ]],
  [[Canvas.Top="558" ]],
  [[KeyDown="TextControl_OnEnter" ]],
  [[/>]],
}

local menuLine='menuLine'
local menuItems='menuItems'
local menuSetting='menuSetting'
local inputElementName='inputLine'
local UiElementVisible='UiElementVisible'

function this.ShowMenu()
  --CULL this.CreateUiElement(menuLine,table.concat(menuLineXaml))
  --CULL this.CreateUiElement(inputLine,table.concat(inputLineXaml))
  ExtCmd(UiElementVisible,'menuWrap',1)
  ExtCmd(UiElementVisible,'menuItems',1)
  ExtCmd(UiElementVisible,'menuTitle',1)
  ExtCmd(UiElementVisible,'menuHelp',ivars.menu_enableHelp)
end

function this.HideMenu()
  ExtCmd(UiElementVisible,'menuWrap',0)
  ExtCmd(UiElementVisible,'menuItems',0)
  ExtCmd(UiElementVisible,'menuTitle',0)
  ExtCmd(UiElementVisible,'menuHelp',0)
end

function this.SetMenuLine(fullText,text)
  if this.debugModule then
    InfCore.Log("InfMgsvToExt.SetMenuLine:")
  end
  --CULL ExtCmd('SetContent',menuElementName,text)
  ExtCmd('SetTextBox',menuLine,text)
  ExtCmd('UpdateTable',menuItems,InfMenu.currentIndex-1,fullText)
  ExtCmd('SelectItem',menuItems,InfMenu.currentIndex-1)
  --tex setting the combo settings only needs to be run on selection of setting, selectcombo still needs to be run though
  local currentOption=InfMenu.GetCurrentOption()
  if currentOption then
    if currentOption.optionType=="OPTION" then
      local currentSetting=ivars[currentOption.name]
      --      InfCore.Log("currentOption:"..currentOption.name.." ivar="..tostring(currentSetting))
      --      if currentOption.OnSelect then
      --        currentOption:OnSelect(ivars[currentOption.name])
      --      end
  
      local settingNames=currentOption.settingNames
      if type(currentOption.GetSettingText)=="function" then
        ExtCmd('SelectCombo',menuSetting,currentSetting)
      elseif settingNames then
        ExtCmd('SelectCombo',menuSetting,currentSetting)
      elseif currentOption.settings then
        ExtCmd('SelectCombo',menuSetting,currentSetting)
      elseif currentSetting then--tex just a straight value
        ExtCmd('ClearCombo',menuSetting)
        ExtCmd('AddToCombo',menuSetting,currentSetting)
        ExtCmd('SelectCombo',menuSetting,0)
      end
    else--currentOption.optionType
      InfCore.ExtCmd('ClearCombo','menuSetting')
    end--currentOption.optionType
  end--if currentOption
end--SetMenuLine

function this.TakeFocus()
  ExtCmd('TakeFocus')
  InfCore.WriteToExtTxt()
end

return this
