-- InfMenuDefs.lua
--
local this={}
--LOCALOPT
local InfCore=InfCore
--tex NOTE its ok to reference modules that are reloaded before this is reloaded
local Ivars=Ivars
local InfMenuDefs=this

this.debugModule=false

--tex root menus are mostly built out from menu def entries in other modules, search for parentRefs with InfMenuDefs.inSafeSpaceMenu etc

--tex root menu, in ACC
this.safeSpaceMenu={
  options={
    "InfMenuDefs.systemMenu",--tex forced order (first) rather than just by context
    "InfMenuCommands.GeneralHelpItem",--DEBUGNOW insert in bottom (lol) instead?
  }
}

--tex root menu, in mission
this.inMissionMenu={
  options={
    "InfHelicopter.RequestHeliLzToLastMarkerAlt",
    "InfHelicopter.ForceExitHeliAlt",
    "InfMenuCommandsTpp.DropCurrentEquip",
    "Ivars.warpPlayerUpdate",
    "InfUserMarker.WarpToLastUserMarker",
    "InfMenuCommands.GeneralHelpItem",--DEBUGNOW insert in bottom (lol) instead?
    "InfMenuDefs.systemMenuMission",
  }
}

--tex root menu, in demo
this.inDemoMenu={
  options={
    "InfDemo.RestartDemo",
    "InfDemo.PauseDemo",
  },
}

this.systemMenu={
  options={
    --DEBUGNOW split into it's own menu
    "Ivars.enableIHExt",
    "Ivars.menu_enableHelp",
    "InfMgsvToExt.TakeFocus",--tex while this is inserted to root menus on postallmodules, it still needs an non dynamic entry somewhere to make sure BuildCommandItems hits it
    "Ivars.menu_enableCursorOnMenuOpen",
    "Ivars.menu_disableToggleMenuHold",
    "InfMenuCommands.ShowStyleEditor",
    --
    "Ivars.selectProfile",
    --WIP "InfMenuCommands.ApplySelectedProfile",
    "InfMenuCommands.ResetSelectedProfile",
    "InfMenuCommands.SaveToProfile",
    --WIP "InfMenuCommands.ViewProfile",
    "Ivars.enableQuickMenu",
    "Ivars.startOffline",
    "Ivars.skipLogos",
    --"Ivars.langOverride",
    "Ivars.loadAddonMission",
    "Ivars.ihMissionsPercentageCount",
    "InfAutoDoc.RunAutoDoc",
    "InfMenuCommands.ResetAllSettingsItem",
  },
}

this.systemMenuMission={
  options={
    --DEBUGNOW split into it's own menu
    "Ivars.enableIHExt",
    "Ivars.menu_enableHelp",
    "InfMgsvToExt.TakeFocus",--tex while this is inserted to root menus on postallmodules, it still needs an non dynamic entry somewhere to make sure BuildCommandItems hits it
    "Ivars.menu_enableCursorOnMenuOpen",
    "Ivars.menu_disableToggleMenuHold",
    "InfMenuCommands.ShowStyleEditor",
    "Ivars.enableQuickMenu",
  },
}

this.debugMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu"},
  options={
    "Ivars.debugMode",
    "Ivars.debugMessages",
    "Ivars.debugFlow",
    "Ivars.debugOnUpdate",
    "Ivars.log_SetFlushLevel",
    "InfMenuCommands.LoadExternalModules",
    "InfMenuCommands.CopyLogToPrev",
    "Ivars.printPressedButtons",
    "InfCamera.ShowFreeCamPosition",
    "InfMenuCommands.ShowPosition",
    "InfMenuCommands.ShowMissionCode",
    "InfMenuCommands.ShowLangCode",
    "InfFovaIvars.appearanceDebugMenu",
    --OFF: TODO: "InfFovaIvars.characterDebugMenu",
    "Ivars.telopMode",--tex TODO move, odd one out, mission/presentation?
    "Ivars.manualMissionCode",
    "Ivars.manualSequence",
    "Ivars.debug_WriteLoadedModulesHint",
    "InfDebug.WriteLoadedModulesHint",
  }
}--debugMenu

this.debugInMissionMenu={
  parentRefs={"InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.debugMode",
    "Ivars.debugMessages",
    "Ivars.debugFlow",
    "Ivars.debugOnUpdate",
    "Ivars.log_SetFlushLevel",
    "InfMenuCommands.LoadExternalModules",
    "InfMenuCommands.CopyLogToPrev",
    "Ivars.selectedCp",
    "InfMenuCommands.SetSelectedCpToMarkerObjectCp",
    "InfMenuCommands.SetSelectedCpToMarkerClosestCp",
    "InfMenuCommandsTpp.DEBUG_ShowRevengeConfig",
    "InfFovaIvars.appearanceDebugMenu",
    --OFF: TODO: "InfFovaIvars.characterDebugMenu",
    --"InfMenuCommandsTpp.DEBUG_ChangePhase",
    --"InfMenuCommandsTpp.DEBUG_KeepPhaseOn",
    --"InfMenuCommandsTpp.DEBUG_KeepPhaseOff",
    --"InfMenuCommandsTpp.printPlayerPhase",
    --"InfMenuCommandsTpp.DEBUG_SetPlayerPhaseToIvar",
    --"InfMenuCommandsTpp.DEBUG_PrintVarsClock",
    --"InfMenuCommands.ShowMissionCode",
    --"InfMenuCommandsTpp.ShowMbEquipGrade",
    "Ivars.printPressedButtons",
    "Ivars.printOnBlockChange",
    "Ivars.disableGameOver",
    "Ivars.disableKillChildSoldierGameOver",--DEBUGNOW move these
    "Ivars.disableOutOfBoundsChecks",
    "InfMenuCommands.SetAllFriendly",
    "InfMenuCommands.SetAllZombie",
    "InfParasite.DEBUG_ToggleParasiteEvent",
    "InfMenuCommands.ResetStageBlockPosition",
    "InfMenuCommands.SetStageBlockPositionToMarkerClosest",
    "InfMenuCommands.SetStageBlockPositionToFreeCam",
    "InfCamera.ShowFreeCamPosition",
    "InfMenuCommands.ShowPosition",
    "InfMenuCommands.CheckPointSave",
    --"InfMenuCommands.DEBUG_ClearAnnounceLog",
    "Ivars.manualMissionCode",
    "Ivars.manualSequence",
  }
}--debugInMissionMenu

this.searchMenu={
  noDoc=true,
  nonConfig=true,
  options={
    "Ivars.searchItem",
    "InfMenuCommands.GoBackTopItem",
  }
}

this.objectListsMenu={
  parentRefs={"InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.warpToListPosition",
    "Ivars.warpToListObject",
    "Ivars.setCamToListObject",
  }
}

--<
this.rootMenus={
  safeSpaceMenu=true,
  inMissionMenu=true,
  inDemoMenu=true,
}

local OPTIONTYPE_MENU="MENU"
local IsTable=Tpp.IsTypeTable
local IsFunc=Tpp.IsTypeFunc

function this.IsMenu(item)
  if IsTable(item) then
    if item.options then
      return true
    end
  end

  return false
end

--tex build up full item object from partial definition
function this.BuildMenuItem(name,item)
  if this.IsMenu(item) then
    item.optionType=OPTIONTYPE_MENU
    item.name=name
    item.parent=nil
  end
end

--tex IHs menu system works through Options, of which Ivars,Menus and Commands are effectively subclasses of
--the runtime operation of the menu is in InfMenu, initial setup of the menu is through InfMenuDefs.SetupMenu --DEBUGNOW
--Menu definitions, or MenuDefs list the options as StringRefs which are just a string representation of <module name>.<option name>
--InfMenuDefs has a few basic menudefs, the rest are in respective IH modules which may also contain the Ivar and Commands they are referencing.
function this.SetupMenuDefs()
  InfCore.LogFlow("InfMenuDefs.SetupMenuDefs: generate menus")
  for i,module in ipairs(InfModules) do
    if module.GenerateMenus then
      InfCore.Log(module.name..".GenerateMenus")
      module.GenerateMenus()
    end
  end

  InfCore.LogFlow("InfMenuDefs.SetupMenuDefs: register menus")
  --tex add menus in this module to be picked up by registermodules
  --TODO: possibly replace registermodules completely with this, change .options to .menuOptions to give it a more explicit identifier
  this.registerMenus={}
  for name,item in pairs(this) do
    if this.IsMenu(item) then
      table.insert(this.registerMenus,name)
    end
  end

  InfCore.LogFlow("InfMenuDefs.SetupMenuDefs: build menu items and gather children menus")
  local parentRefs={}
  for i,module in ipairs(InfModules) do
    if module.registerMenus then
      if this.debugModule then
        InfCore.PrintInspect(module.registerMenus,module.name..".registerMenus")
      end
      for j,name in ipairs(module.registerMenus)do
        local menuDef=module[name]
        if not menuDef then
          InfCore.Log("WARNING: InfMenuDefs.PostAllModulesLoad: could not find "..name.." in "..module.name)
          --TODO: elseif not IsMenu(menuDef) or something
        elseif this.IsMenu(menuDef) then
          local newRef=module.name.."."..name
          if this.debugModule then
            InfCore.Log(newRef)
          end

          --tex build up full menu item object from partial definition
          this.BuildMenuItem(name,menuDef)--tex NOTE: unlike Ivars module menudefs arent built in-to InfMenuDefs

          --tex add to menus in parentRef
          if menuDef.parentRefs then
            for k,parentRef in ipairs(menuDef.parentRefs)do
              local parentMenu,name,moduleName=InfCore.GetStringRef(parentRef)
              if not parentMenu then

              else
                local childrenForMenu=parentRefs[parentRef] or {}
                parentRefs[parentRef]=childrenForMenu

                table.insert(childrenForMenu,newRef)
              end
            end
          end--if parentRefs
        end--if menudef
      end--for registermenu
    end--if registermenu
  end--for infmodules

  InfCore.LogFlow("InfMenuDefs.SetupMenuDefs: add children menus to parents")
  if this.debugModule then
    InfCore.PrintInspect(parentRefs,"parentRefs")
  end

  local function SortRefByLangName(refA, refB)
    local itemA,nameA=InfCore.GetStringRef(refA)
    local itemB,nameB=InfCore.GetStringRef(refB)

    local langA=InfLangProc.LangString(nameA)
    local langB=InfLangProc.LangString(nameB)

    return langB > langA
  end

  --tex add the gathered children menus to the parents
  for parentRef,childrenRefs in pairs(parentRefs)do
    local parentMenu,name=InfCore.GetStringRef(parentRef)
    if not parentMenu then
      InfCore.Log("WARNING: InfMenuDefs.SetupMenus: could not find parentMenu:"..parentRef)
    else
      --tex TODO: would want to sort by inflang menu name
      table.sort(childrenRefs,SortRefByLangName)--DEBUGNOW
      for i,childRef in ipairs(childrenRefs)do
        table.insert(parentMenu.options,childRef)
      end
    end
  end

  InfCore.LogFlow("InfMenuDefs.SetupMenuDefs: add bottom items")
  for i,module in ipairs(InfModules) do
    if module.registerMenus then
      if this.debugModule then
      --InfCore.PrintInspect(module.registerMenus,module.name..".registerMenus")
      end
      for j,name in ipairs(module.registerMenus)do
        local menuDef=module[name]
        if not menuDef then
          InfCore.Log("WARNING: InfMenuDefs.PostAllModulesLoad: could not find "..name.." in "..module.name)
          --TODO: elseif not IsMenu(menuDef) or something
        elseif this.IsMenu(menuDef) then
          --tex add bottom commands
          --TODO: add option to skip
          --tex see if it actually needs resetitem
          for k,optionRef in ipairs(menuDef.options)do
            local option,name=InfCore.GetStringRef(optionRef)
            if option and type(option)~="function" then
              if IvarProc.IsIvar(option) then
                menuDef.addResetItem=true
              end
              break
            end
          end

          if menuDef.addResetItem then
            table.insert(menuDef.options,"InfMenuCommands.ResetSettingsItem")
          end

          if this.rootMenus[menuDef.name] then
            table.insert(menuDef.options,"InfMenuCommands.MenuOffItem")
          else
            table.insert(menuDef.options,"InfMenuCommands.GoBackItem")
          end
          --
        end--if menudef
      end--for registermenu
    end--if registermenu
  end--for infmodules

  --DEBUGNOW doesnt insert correctly for autodoc
  if not isMockFox then
    if ivars.enableIHExt>0 then-- TODO another ivar, also change 'Turn off menu' to only add if ivar
    --local alreadyAdded=false
    --tex shouldnt be needed, assuming that it's not tranfering anything on modulereload
    --    for i,optionRef in ipairs(this.safeSpaceMenu.options)do
    --      if optionRef=="InfMgsvToExt.TakeFocus" then
    --        alreadyAdded=true
    --        break
    --      end
    --    end
    --if not alreadyAdded then
    --      local insertPos=#this.safeSpaceMenu.options-this.safeSpaceMenu.insertEndOffset
    --      table.insert(this.safeSpaceMenu.options,insertPos,"InfMgsvToExt.TakeFocus")
    --
    --      local insertPos=#this.inMissionMenu.options-this.inMissionMenu.insertEndOffset
    --      table.insert(this.inMissionMenu.options,insertPos,"InfMgsvToExt.TakeFocus")
    -- end
    end
  end
end--SetupMenuDefs

function this.PostSetupMenuDefs()
  --VALIDATE
  InfCore.LogFlow("InfMenuDefs.SetupMenuDefs: validate")
  for n,item in pairs(this) do
    if this.IsMenu(item) then
      for i,optionRef in ipairs(item.options)do
        if type(optionRef)~="string"then
          InfCore.Log("WARNING: InfMenuDefs: option "..i.." on menu "..n.."~=string")
        end
      end
    end
  end

  --tex TODO RETHINK
  InfCore.LogFlow("InfMenuDefs.SetupMenuDefs: allMenus")
  this.allMenus={}
  for i,module in ipairs(InfModules) do
    if module.registerMenus then
      for j,name in ipairs(module.registerMenus)do
        local menuDef=module[name]
        if not menuDef then
        elseif this.IsMenu(menuDef) then
          this.allMenus[#this.allMenus+1]=menuDef
        end
      end
    end
  end

  --tex remove items that requiresIHHook (not strictly only menus, but good enough place as any to do it)
  --GOTCHA: really work for command options since they dont have metadata, authors will need to provide param ala resetSettingsItem
  local hasIHHook=IHH~=nil
  local function ShouldKeep(array, i, j)
    local optionRef=array[i]
    local option=InfMenu.GetOptionFromRef(optionRef)
    if option then
      if option.requiresIHHook and not hasIHHook then
        InfCore.Log("InfMenuDefs.SetupMenuDefs requiresIHHook. Removing "..option.name)
        return false
      end
    end
    return true
  end

  if not hasIHHook and not isMockFox then--tex ASSUMPTION isMockFox running AutoDoc
    InfCore.LogFlow("InfMenuDefs.SetupMenuDefs checking for requiresIHHook entries")
    for n,menu in pairs(this.allMenus) do
      InfUtil.ArrayRemove(menu.options,ShouldKeep)
    end--for allMenus
  end

  --tex for search DEBUGNOW, need some kind of context filter (safespace/inmission)
  InfCore.LogFlow("InfMenuDefs.SetupMenuDefs: allItems")
  this.allItems={
    safeSpaceMenu={},
    inMissionMenu={},
    inDemoMenu={},
  }

  local function GetOptionRefsFromMenu(source,dest)
    for i,optionRef in ipairs(source.options)do
      table.insert(dest,optionRef)

      local option,name=InfCore.GetStringRef(optionRef)
      if this.IsMenu(option) then
        GetOptionRefsFromMenu(option,dest)
      end
    end
  end

  GetOptionRefsFromMenu(this.safeSpaceMenu,this.allItems.safeSpaceMenu)
  GetOptionRefsFromMenu(this.inDemoMenu,this.allItems.inDemoMenu)
  GetOptionRefsFromMenu(this.inMissionMenu,this.allItems.inMissionMenu)

  if this.debugModule then
    InfCore.PrintInspect(this.allItems,"InfMenuDefs.allItems")
  end
end--PostSetupMenuDefs

function this.PostAllModulesLoad()
  this.SetupMenuDefs()
  InfMenuCommands.BuildCommandItems()--tex execing here rather than in InfMenuCommands so they can be up and running for requiresIHH check which uses GetOptionFromRef
  this.PostSetupMenuDefs()--tex more flow fiddling for requiresIHH
  
  if this.debugModule then
    InfCore.PrintInspect(this,"InfMenuDefs")
  end
end--PostAllModulesLoad

return this
