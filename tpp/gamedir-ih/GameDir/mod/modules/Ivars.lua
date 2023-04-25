-- Ivars.lua
--tex Ivar system
--Intially loaded in InfInit
--Property system used by IH menu and code to provide modifyable and savable settings.
--Ivars can be defined in other IH modules and their names added to <module>.registerIvars, these will actually be built in to the Ivars module.

--workings:
--combines gvar setup, enums, functions per setting in one ungodly mess.
--lots of shortcuts/ivar setup depending-on defined values is done in SetupIvars
--Ivars as a whole are actually split across several modules/tables
--this module is mostly defintion of the bounds, settings and functions to run on changing Ivar state
--the working state/value of an Ivar is in the global ivar table, with save values in either gvars (the game save system) or evars (IHs save system)
--the IvarProc module ties together the Ivar definitions and their live state in igvars{} (global) via utility functions
--save values are split out to evars{} (global), this mirrors the prior setup of ivar/gvar pair split and is currently mostly to allow ivars to be temporarily disconnected from their
--saved state as in ih events

--NOTE: Resetsettings will call OnChange, so/and make sure defaults are actual default game behaviour,
--in general this means all stuff should have a 0 that at least does nothing,
--dont let the lure of nice straight setting>game value lure you, just -1 it

--REF TODO: ref of ivar with all vars and methods

--load requires InfUtil

local this={}

this.debugModule=false

--LOCALOPT:
local Ivars=this
local InfCore=InfCore

local NULL_ID=GameObject.NULL_ID
local GetGameObjectId=GameObject.GetGameObjectId
local SendCommand=GameObject.SendCommand

local GLOBAL=TppScriptVars.CATEGORY_GAME_GLOBAL
local MISSION=TppScriptVars.CATEGORY_MISSION
local RETRY=TppScriptVars.CATEGORY_RETRY
local MB_MANAGEMENT=TppScriptVars.CATEGORY_MB_MANAGEMENT
local QUEST=TppScriptVars.CATEGORY_QUEST
local CONFIG=TppScriptVars.CATEGORY_CONFIG
local RESTARTABLE=TppScriptVars.CATEGORY_MISSION_RESTARTABLE
local PERSONAL=TppScriptVars.CATEGORY_PERSONAL

local EXTERNAL=IvarProc.CATEGORY_EXTERNAL

--STATE
this.isSaveDirty=true--tex start dirty so BuildSaveText actually builds initial savetext

--tex set via IvarsProc.MissionModeIvars, used by IsForMission,EnabledForMission
this.missionModeIvarsNames={}
--tex built via RegisterMissionModeIvars
this.missionModeIvars={
  --[missionModeIvarsName]={
  --  <missionMode Ivar>
  --  ...
  --}
}

this.profiles={}
--
local int8=256
local int16=2^16
local int32=2^32

this.MAX_SOLDIER_STATE_COUNT = 360--tex from <mission>_enemy.lua, free missions/whatever was highest

this.switchRange={max=1,min=0,increment=1}
this.percentRange={max=100,min=0,increment=1}

this.switchSettings={"OFF","ON"}
this.simpleProfileSettings={"DEFAULT","CUSTOM"}
--

--ivar definitions
--tex NOTE: should be mindful of max setting for save vars,
--currently the ivar setup fits to the nearest save size type and I'm not sure of behaviour when you change ivars max enough to have it shift save size and load a game with an already saved var of different size

this.debugMode={
  inMission=true,
  nonConfig=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  -- CULL settings={"OFF","NORMAL","BLANK_LOADING_SCREEN"},
  allowOnline=true,
  OnChange=function(self,setting)
    InfMain.DebugModeEnable(setting==1)
  end,
}

this.debugMessages={
  inMission=true,
  nonConfig=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={"OFF","ALL","RECIEVED"},--tex TODO: ,ONLY_DEBUGMODULE
  allowOnline=true,
}

this.debugFlow={
  inMission=true,
  nonConfig=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  allowOnline=true,
}

this.debugOnUpdate={
  inMission=true,
  nonConfig=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  allowOnline=true,
  OnChange=function(self,setting)
    InfCore.debugOnUpdate=setting==1
  end,
}

this.log_SetFlushLevel={
  inMission=true,
  nonConfig=true,
  requiresIHHook=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={"trace","debug","info","warn","error","critical","off"},
  default=InfCore.level_warn,
  --settingNames="set_switch",
  OnChange=function(self,setting)
    local level=InfCore.logLevels[setting]
    if IHH then
      IHH.Log_SetFlushLevel(setting)
    end
  end,
}

this.enableIHExt={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnSelect=function(self)
    if not InfCore.IHExtInstalled() then
      self.settingNames="ihext_not_installed_settings"
    end
  end,
  PreChange=function(self,prevSetting,setting)
    if setting==0 then
      if InfCore.extSession==0 then
      else
        InfCore.ExtCmd("Shutdown")
        InfCore.WriteToExtTxt()
      end
    end
  end,
  OnChange=function(self,setting)
    if setting==1 then
      --tex extSession 0 should catch this without
      --      if not InfCore.IHExtInstalled() then
      --        --InfCore.Log("WARNING: could not find IHExt.exe")
      --        self:Set(0)
      --        return
      --      end

      --if InfCore.extSession==0 then
      InfCore.StartIHExt()
      InfMenu.MenuOff()--tex stuff is only triggered on menu on
      InfCore.manualIHExtStart=true
      --else
      --InfCore.ExtCmd("shutdown")--DEBUGNOW TODO wont actually fire since ExtCmd aborts on enableIHExt off
      --InfCore.WriteToExtTxt()
      --end
    end
  end,
}

this.menu_enableHelp={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    InfCore.ExtCmd("UiElementVisible","menuHelp",setting)--tex TODO: shouldnt be nessesary, DisplayCurrentSetting should handle it DEBUGNOW
    InfCore.WriteToExtTxt()
    InfMenu.DisplayCurrentSetting()
  end,
}

this.menu_disableToggleMenuHold={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.menu_enableCursorOnMenuOpen={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.sys_increaseMemoryAlloc={--DEBUGNOW
  nonConfig=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.printPressedButtons={
  inMission=true,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.printOnBlockChange={
  inMission=true,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--patchup
this.langOverride={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  allowOnline=true,
}

this.startOffline={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.skipLogos={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.enableQuickMenu={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.selectedCp={--DEBUGNOW
  inMission=true,
  nonConfig=true,
  --save=IvarProc.CATEGORY_EXTERNAL,
  range={max=0},--DYNAMIC
  prev=nil,--STATE
  OnSelect=function(self,setting)
    if not mvars.ene_cpList then
      self:Set(0)
      return
    end

    IvarProc.SetMaxToList(self,mvars.ene_cpList)
  end,
  GetNext=function(self,currentSetting)
    self.prev=self.setting
    if mvars.ene_cpList==nil then
      InfCore.DebugPrint"mvars.ene_cpList==nil"--DEBUG
      return 0
    end--

    local nextSetting=currentSetting
    if currentSetting==0 then
      nextSetting=next(mvars.ene_cpList)
    else
      nextSetting=next(mvars.ene_cpList,currentSetting)
    end
    if nextSetting==nil then
      --InfCore.DebugPrint"self setting==nil"--DEBUG
      nextSetting=next(mvars.ene_cpList)
    end
    return nextSetting
  end,
  GetPrev=function(self,currentSetting)
    local nextSetting=currentSetting
    if self.prev~=nil then
      nextSetting=self.prev
      self.prev=nil
    else
      nextSetting=next(mvars.ene_cpList)--tex go back to start
    end
    return nextSetting
  end,
  GetSettingText=function(self,setting)
    if setting==nil then
      return "nil"
    end
    return mvars.ene_cpList and mvars.ene_cpList[setting+1] or "no cp for setting"
  end,
}

--
this.dropLoadedEquip={--WIP
  inMission=true,
  nonConfig=true,
  --OFF save=IvarProc.CATEGORY_EXTERNAL,
  range={max=0},--tex DYNAMIC
  OnSelect=function(self)
    self.settingsTable={}
    for equipId,bool in pairs(InfEquip.currentLoadTable)do
      self.settingsTable[#self.settingsTable+1]=equipId
    end
    IvarProc.SetMaxToList(self,self.settingsTable)
  end,
  GetSettingText=function(self,setting)
    local equipId=self.settingsTable[setting+1]
    local equipName=InfLookup.TppEquip.equipId[equipId]
    return tostring(equipName)
  end,
  OnActivate=function(self,setting)
    local equipId=self.settingsTable[setting+1]
    local equipName=InfLookup.TppEquip.equipId[equipId]
    if equipId==nil then
      InfCore.DebugPrint("no equipId found for "..equipName)
      return
    else
      InfCore.DebugPrint("drop "..equipName)
      local dropPosition=Vector3(vars.playerPosX,vars.playerPosY+1,vars.playerPosZ)

      local linearMax=2
      local angularMax=14

      local number=100

      TppPickable.DropItem{
        equipId=equipId,
        number=number,
        position=dropPosition,
        rotation=Quat.RotationY(0),
        linearVelocity=Vector3(math.random(-linearMax,linearMax),math.random(-linearMax,linearMax),math.random(-linearMax,linearMax)),
        angularVelocity=Vector3(math.random(-angularMax,angularMax),math.random(-angularMax,angularMax),math.random(-angularMax,angularMax)),
      }
    end
  end,
}

this.dropTestEquip={--WIP --DEBUGNOW
  inMission=true,
  nonConfig=true,
  --OFF save=IvarProc.CATEGORY_EXTERNAL,
  range={max=0,min=0},--tex DYNAMIC
  OnSelect=function(self)
    IvarProc.SetMaxToList(self,InfEquip.tppEquipTableTest)
  end,
  GetSettingText=function(self,setting)
    return tostring(InfEquip.tppEquipTableTest[setting+1])
  end,
  OnActivate=function(self,setting)
    local equipName=InfEquip.tppEquipTableTest[setting+1]
    local equipId=TppEquip[equipName]
    if equipId==nil then
      InfCore.DebugPrint("no equipId found for "..equipName)
      return
    else
      --      InfCore.DebugPrint("set "..equipName)
      --      Player.ChangeEquip{
      --        equipId = equipId,
      --        stock = 30,
      --        stockSub = 30,
      --        ammo = 30,
      --        ammoSub = 30,
      --        suppressorLife = 100,
      --        isSuppressorOn = true,
      --        isLightOn = false,
      --        dropPrevEquip = true,
      --      -- toActive = true,
      --      }
      --    end

      --      Player.ChangeEquip{
      --        equipId = equipId,
      --        stock = 30,
      --        stockSub = 0,
      --        ammo = 30,
      --        ammoSub = 0,
      --        suppressorLife = 0,
      --        isSuppressorOn = false,
      --        isLightOn = false,
      --        toActive = false,
      --        dropPrevEquip = false,
      --        temporaryChange = true,
      --      }

      InfCore.DebugPrint("drop "..equipName)
      local dropPosition=Vector3(vars.playerPosX,vars.playerPosY+1,vars.playerPosZ)

      local linearMax=2
      local angularMax=14

      local number=100

      TppPickable.DropItem{
        equipId=equipId,
        number=number,
        position=dropPosition,
        rotation=Quat.RotationY(0),
        linearVelocity=Vector3(math.random(-linearMax,linearMax),math.random(-linearMax,linearMax),math.random(-linearMax,linearMax)),
        angularVelocity=Vector3(math.random(-angularMax,angularMax),math.random(-angularMax,angularMax),math.random(-angularMax,angularMax)),
      }
    end
  end,
}

this.selectProfile={
  nonConfig=true,
  --save=IvarProc.CATEGORY_EXTERNAL,
  settings={},--DYNAMIC
  GetSettingText=function(self,setting)
    if Ivars.profileNames==nil or #Ivars.profileNames==0 or self.settings==nil then
      return InfLangProc.LangString"no_profiles_installed"
    else
      local profileName=self.settings[setting+1]
      local profileInfo=Ivars.profiles[profileName]
      return profileInfo.description or profileName
    end
  end,
  OnSelect=function(self)
    IvarProc.SetSettings(self,Ivars.profileNames)
  end,
  OnActivate=function(self,setting)
    if self.settings==nil or #self.settings==0 then
      InfMenu.PrintLangId"no_profiles_installed"
    end

    local profileName=self.settings[setting+1]
    local profileInfo=Ivars.profiles[profileName]
    --local profileDescription=profileInfo.description or profileName
    InfMenu.PrintLangId"applying_profile"
    IvarProc.ApplyProfile(profileInfo.profile)
  end,
  GetProfileInfo=function(self)
    if not Ivars.profiles or self.settings==nil then
      return nil
    else
      local profileName=self:GetTableSetting()
      return Ivars.profiles[profileName]
    end
  end,
}

this.warpToListObject={--DEBUGNOW
  inMission=true,
  range={max=0},--DYNAMIC
  GetSettingText=function(self,setting)
    local objectName,info,position=InfObjects.GetObjectInfoOrPos(setting+1)
    if info and not position then
      return info
    end

    return objectName.." pos:".. math.ceil(position[1])..",".. math.ceil(position[2]).. ","..math.ceil(position[3])
  end,
  OnSelect=function(self)
    local objectList=InfObjects.objectNames
    IvarProc.SetMaxToList(self,objectList)
  end,
  OnActivate=function(self,setting)
    local objectName,info,position=InfObjects.GetObjectInfoOrPos(setting+1)
    if position==nil then
      return
    end

    if position[1]~=0 or position[2]~=0 or position[3]~=0 then
      position[2]=position[2]+1
      InfCore.Log(objectName.." pos:".. position[1]..",".. position[2].. ","..position[3],true)
      TppPlayer.Warp{pos=position,rotY=vars.playerCameraRotation[1]}
    end
  end,
}

this.warpToListPosition={--DEBUGNOW
  inMission=true,
  range={max=0},--DYNAMIC
  GetSettingText=function(self,setting)
    local positionsList=InfPositions.positions
    if #positionsList==0 then
      return "no positions"
    end
    local position=positionsList[setting+1]
    return "pos:".. math.ceil(position[1])..",".. math.ceil(position[2]).. ","..math.ceil(position[3])
  end,
  OnSelect=function(self)
    local positionsList=InfPositions.positions
    IvarProc.SetMaxToList(self,positionsList)
  end,
  OnActivate=function(self,setting)
    local positionsList=InfPositions.positions
    local position=positionsList[setting+1]

    if position[1]~=0 or position[2]~=0 or position[3]~=0 then
      position[2]=position[2]+1
      InfCore.Log("pos:".. position[1]..",".. position[2].. ","..position[3],true)
      TppPlayer.Warp{pos=position,rotY=vars.playerCameraRotation[1]}
    end
  end,
}

this.setCamToListObject={--DEBUGNOW
  inMission=true,
  range={max=0},--DYNAMIC
  GetSettingText=function(self,setting)
    local objectName,info,position=InfObjects.GetObjectInfoOrPos(setting+1)
    if info and not position then
      return info
    end

    return objectName.." pos:".. math.ceil(position[1])..",".. math.ceil(position[2]).. ","..math.ceil(position[3])
  end,
  OnSelect=function(self)
    local objectList=InfObjects.objectNames
    IvarProc.SetMaxToList(self,objectList)
  end,
  OnActivate=function(self,setting)
    local objectName,info,position=InfObjects.GetObjectInfoOrPos(setting+1)
    if position==nil then
      return
    end

    if position[1]~=0 or position[2]~=0 or position[3]~=0 then
      position[2]=position[2]+1
      InfCore.Log(objectName.." pos:".. position[1]..",".. position[2].. ","..position[3],true)
      InfCamera.WritePosition("FreeCam",Vector3(position[1],position[2],position[3]))
    end
  end,
}

this.debugValue={
  inMission=true,
  nonConfig=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=400,
  range={max=400,min=0,increment=10},
  OnChange=function(self,setting)
    InfCore.Log("debugValue:"..setting)
  end,
}

--tex dummy for search
this.searchItem={
  inMission=true,
  range={max=0,min=0},
  GetSettingText=function()return " " end,
  OnSelect=function(self)
    InfCore.ExtCmd("SelectAllText","menuLine")
    InfCore.WriteToExtTxt()
  end,
}
--end ivar defines

function this.IsIvar(ivar)--TYPEID
  return type(ivar)=="table" and (ivar.range or ivar.settings)
end

--ivar system setup>
--gvars setup
function this.DeclareGVars()
  local varTable={}
  --varTable={
  --   {name="ene_typeForcedName",type=TppScriptVars.UINT32,value=false,arraySize=this.MAX_SOLDIER_STATE_COUNT,save=true,category=TppScriptVars.CATEGORY_MISSION},--NONUSER:
  --   {name="ene_typeIsForced",type=TppScriptVars.TYPE_BOOL,value=false,arraySize=this.MAX_SOLDIER_STATE_COUNT,save=true,category=TppScriptVars.CATEGORY_MISSION},--NONUSER:
  --}
  --  from MakeSVarsTable, a bit looser, but strings to strcode is interesting
  --    local valueType=type(value)
  --    if valueType=="boolean"then
  --      type=TppScriptVars.TYPE_BOOL,value=value
  --    elseif valueType=="number"then
  --      type=TppScriptVars.TYPE_INT32,value=value
  --    elseif valueType=="string"then
  --      type=TppScriptVars.TYPE_UINT32,value=StrCode32(value)
  --    elseif valueType=="table"then
  --      value=value
  --    end

  for name, ivar in pairs(Ivars) do
    if this.IsIvar(ivar) then
      if ivar.save and ivar.save~=EXTERNAL then
        local ok=true
        local svarType=0
        local min,max=IvarProc.GetRange(ivar)
        if ivar.svarType then
          svarType=ivar.svarType
        elseif ivar.isFloat then
          svarType=TppScriptVars.TYPE_FLOAT
          --elseif max < 2 then --tex TODO: bool support
          --svar.type=TppScriptVars.TYPE_BOOL
        elseif max < int8 then
          svarType=TppScriptVars.TYPE_UINT8
        elseif max < int16 then
          svarType=TppScriptVars.TYPE_UINT16
        elseif max < int32 or max==0 then
          svarType=TppScriptVars.TYPE_INT32
        else
          ok=false
          InfCore.Log("WARNING Ivars.DeclareVars could not find svarType")
        end

        local gvar={name=name,type=svarType,value=ivar.default,save=true,sync=false,wait=false,category=ivar.save}--tex what is sync? think it's network synce, but MakeSVarsTable for seqences sets it to true for all (but then 50050/fob does make a lot of use of it)
        if ok then
          varTable[#varTable+1]=gvar
        end
      end--save
    end--ivar
  end

  local arrays={
    --REF {name="inf_interCpQuestStatus",arraySize=maxQuestSoldiers,type=TppScriptVars.TYPE_BOOL,value=false,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},
    }
  for i,gvar in ipairs(arrays)do
    varTable[#varTable+1]=gvar
  end

  if this.debugModule then
    InfCore.PrintInspect(varTable,"Ivars varTable")
  end

  return varTable
end

--TABLESETUP: Ivars
local OPTIONTYPE_OPTION="OPTION"
--build out full definition
function this.BuildIvar(name,ivar)
  local ivars=ivars
  local evars=evars
  local IvarProc=IvarProc
  if this.IsIvar(ivar) then
    ivar.optionType=OPTIONTYPE_OPTION
    --ivar.name=ivar.name or name
    ivar.name=name
    --DEBUGNOW settings-no-range
    if not ivar.settings then
      ivar.range=ivar.range or {}
      ivar.range.max=ivar.range.max or 1
      ivar.range.min=ivar.range.min or 0
      ivar.range.increment=ivar.range.increment or 1--DEBUGNOW roll increment into root?
      ivar.default=ivar.default or ivar.range.min

      --KLUDGE, try and surmise if it's a float
      if not ivar.isFloat then--tex already said it is
        local i,f = math.modf(ivar.range.increment)--tex get fractional part
        f=math.abs(f)
        ivar.isFloat=false
        if f<1 and f~=0 then
          ivar.isFloat=true
        end
      end
    else
      ivar.default=ivar.default or 0
      ivar.enum=InfUtil.EnumFrom0(ivar.settings)
      --      for name,enum in ipairs(ivar.enum) do
      --        ivar[name]=false
      --        if enum==ivar.default then
      --          ivar[name]=true
      --        end
      --      end
      --      ivar[ivar.settings[ivar.default] ]=true
      --DEBUGNOW ivar.range.max=#ivar.settings-1--tex ivars are indexed by 1, lua tables (settings) by 1--DEBUGNOW settings-no-range
    end

    ivar.IsDefault=IvarProc.OptionIsDefault
    ivar.Is=IvarProc.OptionIsSetting
    ivar.Get=IvarProc.OptionIsSetting--GOTCHA: usage: 0 is true in lua, so use Is(0) or 1, or Get()==0 etc
    ivar.Set=IvarProc.SetSetting
    ivar.SetDirect=IvarProc.SetDirect
    ivar.Reset=IvarProc.ResetSetting
    ivar.GetTableSetting=IvarProc.GetTableSetting
    ivar.GetSettingName=IvarProc.GetSettingName
    ivar.MissionCheck=ivar.MissionCheck--tex OFF or IvarProc.MissionCheckAll--rather have the functions on it bring up warnings than have it cause issues by going through
    ivar.EnabledForMission=IvarProc.IvarEnabledForMission
    if ivar.isPercent then
      ivar.Scale=IvarProc.Scale
    end

    ivars[ivar.name]=ivars[ivar.name] or ivar.default
    if ivar.save and ivar.save==EXTERNAL then
      evars[ivar.name]=evars[ivar.name] or ivars[ivar.name]
      ivars[ivar.name]=evars[ivar.name]--tex for late-defined/module ivars a previously saved value will already be loaded
    end
  end--is ivar
  return ivar
end--BuildIvar

function this.SetupIvars()
  InfCore.LogFlow("Ivars.SetupIvars")
  for name,ivar in pairs(this) do
    this.BuildIvar(name,ivar)
  end
end

--ivarTable: table that has ivars in it. ex: a module
--ivarNames: list of names of the ivar in the ivarTable ex module.registerIvars
--OUT/SIDE: this[ivarName]
function this.RegisterIvars(ivarTable,ivarNames)
  for j,name in pairs(ivarNames)do
    local ivarDef=ivarTable[name]
    if not ivarDef then
      InfCore.Log("WARNING: Ivars.PostAllModulesLoad: could not find "..tostring(name).." in "..ivarTable.name)
    elseif not this.IsIvar(ivarDef) then
      InfCore.Log("WARNING: Ivars.PostAllModulesLoad: "..tostring(name).." in "..ivarTable.name.." is not an Ivar.")
    else
      --InfCore.Log("Ivars.PostAllModulesLoad: Adding Ivar "..name.." from "..module.name)
      --tex set them to nonconfig by default so to not trip up AutoDoc
      --DEBUGNOW
      --          if ivarDef.nonConfig~=false then--tex unless we specficially want it to be for config
      --            ivarDef.nonConfig=true
      --          end
      --
      --          if ivarDef.noDoc~=false then
      --            ivarDef.noDoc=true
      --          end
      --tex kinda hinky, the ivar itself is built out from whatever definition it has in its ivarTable,
      --then a reference added to this (Ivars) module so all Ivars can be accessed by Ivars.<ivar name>
      this[name]=this.BuildIvar(name,ivarDef)

      if type(ivarDef.Init)=="function"then
        --tex GOTCHA: since Ivars is early in modules list (RegisterIvars is initially called via PostAllModulesLoad) any modules that do set up in PostAllModulesLoad wont be done 
        ivarDef:Init()
      end
    end--if ivar
  end--for module.registerIvars
end--RegisterIvars

--missionModeIvarsNames: missionModeIvarsNames table created by IvarProc.MissionModeIvars
--IN: this[ivarName]
--OUT/SIDE: this.missionModeIvars[ivarName]
function this.RegisterMissionModeIvars(missionModeIvarsNames)
  for name,ivarNames in pairs(missionModeIvarsNames)do
    this.missionModeIvars[name]={}
    for i,ivarName in ipairs(ivarNames)do
      local ivar=this[ivarName]
      if not ivar then
        InfCore.Log("WARNING: Ivars.RegisterMissionModeIvars: could not find missionMode Ivar ".. ivarName)
      else
        table.insert(this.missionModeIvars[name],ivar)
      end
    end--for ivarNames
  end--for module.missionModeIvarsNames
end--RegisterMissionModeIvars

function this.PostAllModulesLoad()
  InfCore.LogFlow("Adding module Ivars")
  --tex add module ivars to this
  for i,module in ipairs(InfModules) do
    if module.registerIvars and module~=Ivars then
      if this.debugModule then
        InfCore.PrintInspect(module.registerIvars,"RegisterIvars: "..module.name)
      end
      this.RegisterIvars(module,module.registerIvars)
    end--if module.registerIvars

    --tex fill actual references in missionModeIvars now that the ivars are actually added to this (Ivars)
    if module.missionModeIvarsNames then
      if this.debugModule then
        InfCore.PrintInspect(module.missionModeIvarsNames,"RegisterMissionModeIvars: "..module.name)
      end
      this.RegisterMissionModeIvars(module.missionModeIvarsNames)
    end--if module.missionModeIvarsNames
  end--for InfModules

  --tex likewise update vars
  local convertIvars={
    "active",
    "updateRate",
    "enableIvars",
  }
  for i,module in ipairs(InfModules) do
    --KLUDGE: just doing in-place conversion, these values where already Ivar or number, so why not string > Ivar fixup lol
    for j,convertName in ipairs(convertIvars)do
      if type(module[convertName])=="string" then
        local ivar=Ivars[module[convertName]]
        if not ivar then
          InfCore.Log("WARNING: Ivars.PostAllModulesLoad: could not find active Ivar ".. convertName.." from "..module.name)
        else
          module[convertName]=ivar
        end
      elseif type(module[convertName])=="table" then
        for j,ivarName in ipairs(module[convertName])do
          local ivar=Ivars[ivarName]
          if not ivar then
            InfCore.Log("WARNING: Ivars.PostAllModulesLoad: could not find active Ivar ".. convertName.." from "..module.name)
          else
            module[convertName][j]=ivar
          end
        end
      end--if string or table
    end--for convertIvars
  end--for InfModules

  if this.debugModule then
  --InfCore.PrintInspect(this.missionModeIvars,"missionModeIvars")
  end

  --CULL: moved to InfLangProc
  --  --tex check to see if theres a settingNames in InfLang
  --  --has to be postmodules since InfLang is loaded after Ivars
  --  --GOTCHA this will lock in language till next modules reload (not that there's any actual InfLang translations I'm aware of lol)
  --  local settingsStr="Settings"
  --  local languageCode=AssetConfiguration.GetDefaultCategory"Language"
  --  local langTable=InfLang[languageCode] or InfLang.eng
  --  for name,ivar in pairs(this) do
  --    if this.IsIvar(ivar) then
  --      local settingNames=name..settingsStr
  --      if langTable[settingNames] then
  --        ivar.settingNames=settingNames
  --      end
  --      ivar.settingNames=ivar.settingNames or ivar.settings--tex fall back to settings table
  --    end
  --  end

  --tex kill orphaned save values
  local evars=evars
  local ivars=ivars
  for name,value in pairs(evars)do
    if not ivars[name] then
      InfCore.Log("WARNING: Ivars.PostAllModulesLoad: Could not find ivar for evar "..name)
      evars[name]=nil
    end
  end
end--PostAllModulesLoad
--<

--EXEC
--InfCore.PCall(function()
--DEBUG
--local breakSave=false
--if breakSave then
--  for i=1,100000 do
--    this["breakVar"..i]={
--      save=MISSION,
--      default=100,
--      range={max=1000,min=0,increment=1},
--    }
--  end
--end

--DEBUG turn off saving
--for name, ivar in pairs(this) do
--  if this.IsIvar(ivar) then
--    ivar.save=nil
--  end
--end
--end)

InfCore.PCall(this.SetupIvars)

return this
