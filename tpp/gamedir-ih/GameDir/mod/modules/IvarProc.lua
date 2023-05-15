-- IvarProc.lua
-- tex functions for working on Ivars and their associated ivars,evars,gvars
-- STATELESS (except for debugModule) and saveTextList
-- EXECLESS
local this={}

--LOCALOPT
local InfCore=InfCore
local ivars=ivars
local evars=evars
local igvars=igvars

local vars=vars

local type=type
local numberType="number"
local functionType="function"
local tostring=tostring
local format=string.format
local pairs=pairs
local ipairs=ipairs
local insert=table.insert
local concat=table.concat
local OsClock=os.clock

local ClearArray=InfUtil.ClearArray
local MergeArray=InfUtil.MergeArray

local GLOBAL=TppScriptVars.CATEGORY_GAME_GLOBAL
local MISSION=TppScriptVars.CATEGORY_MISSION
local RETRY=TppScriptVars.CATEGORY_RETRY
local MB_MANAGEMENT=TppScriptVars.CATEGORY_MB_MANAGEMENT
local QUEST=TppScriptVars.CATEGORY_QUEST
local CONFIG=TppScriptVars.CATEGORY_CONFIG
local RESTARTABLE=TppScriptVars.CATEGORY_MISSION_RESTARTABLE--NMC don't know why the vanilla code uses TppDefine.CATEGORY_MISSION_RESTARTABLE and not TppScriptVars.CATEGORY_MISSION_RESTARTABLE
local PERSONAL=TppScriptVars.CATEGORY_PERSONAL

this.CATEGORY_EXTERNAL=1024--tex SYNC Ivars

this.debugModule=false

--tex muddies the point of this being named Proc, but it's more of a cache than state
--would be cleaner to have in seperate files, but would lose on io overhead
local saveTextList={}
local evarsTextList={}
local igvarsTextList={}
local igvarsPrev={}

--GOTCHA: LOCALOPT: use InfMain.IsOnlineMission instead
function this.IsOnlineMission(missionCode)
  local firstDigit=math.floor(missionCode/1e4)
  if firstDigit==5 then
    return true
  else
    return false
  end
--tex revisit if ever ssd
--  if InfCore.gameId=="TPP" then
--    return this.IsFOBMission(missionCode)
--  else--SSD
--    return false
--      --DEBUGNOW return this.IsMultiPlayMission(missionCode)
--  end
end

function this.IsFOBMission(missionCode)
  local firstDigit=math.floor(missionCode/1e4)
  if firstDigit==5 then
    return true
  else
    return false
  end
end

function this.IsIvar(ivar)--TYPEID
  return type(ivar)=="table" and (ivar.range or ivar.settings) --DEBUGNOW or (ivar.name and ivars[ivar.name])
end

function this.GetSetting(self)
  return ivars[self.name]
end

--tex TODO bounds checking?
function this.GetSaved(self)
  local gvar=nil
  if self.save then
    if self.save==this.CATEGORY_EXTERNAL then
      gvar=evars[self.name]
    elseif gvars then
      gvar=gvars[self.name]
    end
    if gvar==nil and gvars then
      InfCore.Log("WARNING: IvarProc.GetSaved: ivar.save but no gvar found for "..tostring(self.name),true)
    end
  end
  return gvar
end

function this.SetSaved(self,value)
  if value~=nil and self.save then
    if self.save==this.CATEGORY_EXTERNAL then
      evars[self.name]=value
    else
      gvars[self.name]=value
    end
  end
end

--tex currently not used. GOTCHA currently only supports settingsTable as array, see GetTableSetting
function this.GetTableSettingDirect(self,setting)
  if not self.settingsTable then
    InfCore.Log("GetTableSettingDirect no settingsTable for "..self.name)
    return nil
  end

  if not setting then
    setting=ivars[self.name]
  end
  return self.settingsTable[setting+1]
end

--tex return ivars settingsTable setting for setting
this.GetTableSetting=function(self)
  local returnValue=nil
  if self.settingsTable then
    local currentSetting
    if this.IsOnlineMission(vars.missionCode) and not self.allowOnline then
      currentSetting=self.default
    else
      currentSetting=ivars[self.name]
    end

    local tableSetting
    if #self.settingsTable>0 then
      tableSetting=self.settingsTable[currentSetting+1]
    else
      local settingName=self.settings[currentSetting+1]
      tableSetting=self.settingsTable[settingName]
    end

    if type(tableSetting)=="function" then
      returnValue=tableSetting()
    else
      returnValue=tableSetting
    end
  end
  return returnValue
end
--UNUSED
function this.GetSettingNameDirect(self,setting)
  if not self.settings then
    InfCore.Log("GetSettingNameDirect no settings for "..self.name)
    return nil
  end

  if not setting then
    setting=ivars[self.name]
  end
  return self.settings[setting+1]
end
--tex ivar .settings are strings
function this.GetSettingName(self,setting)
  if not self.settings then
    InfCore.Log("GetSettingName no settings for "..self.name)
    return nil
  end

  if not setting then
    setting=self:Get()
  end
  return self.settings[setting+1]
end--GetSettingName

function this.SetDirect(self,setting)
  ivars[self.name]=setting
  Ivars.isSaveDirty=true
end
--CALLERS: ivar:Set, ivar being changed via menu (via various InfMenu calls)
--which also includes 'command' type ivars which are really just switch options that the value doesnt matter, since they just care about running their OnChanged
function this.SetSetting(self,setting,noSave)
  if this.debugModule then InfCore.Log("Ivars.SetSetting "..self.name.." "..setting) end--DEBUG
  if self==nil then
    InfCore.Log("WARNING: SetSetting: self==nil, did you use ivar.Set instead of ivar:Set?",true)
    return
  end
  if type(self)~="table" then
    InfCore.Log("WARNING: SetSetting: self ~= table!",true)
    return
  end
  if self.option then
    InfCore.Log("WARNING: SetSetting called on menu",true)
    return
  end

  local currentSetting=ivars[self.name]
  if currentSetting==nil then
    InfCore.Log("WARNING: SetSetting: ivar setting==nil",true)
    return
  end

  if type(setting)=="string" then
    if not self.enum then
      InfCore.Log("WARNING: SetSetting: no enum settings on "..self.name,true)--DEBUG
      return
    end
    local settingParam=setting--KLUDGE so it can be logged since its overwritten below
    setting=self.enum[setting]
    if setting==nil then
      InfCore.Log("WARNING: SetSetting: no setting "..settingParam.." on "..self.name,true)--DEBUG
      return
    end
  end

  if self.noBounds~=true then
    if self.settings and (setting < 0 or setting > #self.settings-1) then
      InfCore.Log("WARNING: SetSetting "..setting.." for "..self.name.." OUT OF BOUNDS",true)
      InfCore.PrintInspect(self.settings,self.name..".settings")
      return    
    elseif self.range and (setting < self.range.min or setting > self.range.max) then
      InfCore.Log("WARNING: SetSetting "..setting.." for "..self.name.." OUT OF BOUNDS",true)
      InfCore.PrintInspect(self.range,self.name..".range")
      return
    end
  end

  --InfCore.DebugPrint("Ivars.SetSetting "..self.name.." "..setting)--DEBUG
  local prevSetting=currentSetting
  if self.PreChange then
    --InfCore.Log("SetSetting OnChange for "..self.name)--DEBUG
    InfCore.PCallDebug(self.PreChange,self,prevSetting,setting)
  end

  ivars[self.name]=setting
  if self.save and not noSave then
    local gvar=this.GetSaved(self)
    if gvar~=nil then
      this.SetSaved(self,setting)
    end
    Ivars.isSaveDirty=true
  end
  if self.OnChange and not this.IsOnlineMission(vars.missionCode) then--tex DEBUGNOW add after exploring problem
    --InfCore.Log("SetSetting OnChange for "..self.name)--DEBUG
    InfCore.PCallDebug(self.OnChange,self,setting,prevSetting)
  end
end--SetSetting

function this.ResetSetting(self,noSave)
  this.SetSetting(self,self.default,noSave)
end

function this.GetRange(option)
  local min=0
  if option.settings then
    min=0
  elseif option.range then
    min=option.range.min
  end
  local max=0
  if option.settings then
    max=#option.settings-1
  elseif option.range then
    max=option.range.max
  end
  return min,max
end--GetRange
--GOTCHA: doesnt set min, but min shouldnt be dynamic anyhoo
function this.SetMaxToList(self,list,indexFrom1)--DEBUGNOW trying to shift to range being optional if settings existst
  if list==nil then
    InfCore.Log("ERROR: IvarProc.SetMaxToList("..self.name.."): list==nil")
    return
  end
  if self.range==nil then
    InfCore.Log("ERROR: IvarProc.SetMaxToList "..self.name..": self.range==nil")
    return
  end

  local indexShift=1--tex default to index from 0 since the majority of ivars are.
  if indexFrom1 then
    indexShift=0
  end
  local newMax=#list-indexShift
  if newMax<0 then
    newMax=0
  end
  
  self.range.max=newMax
  if self:Get()>self.range.max then
    self:Set(self.range.min)
  end
end

function this.SetSettings(self,list)
  self.settings=list

--  if self.settingsCount~=#list then
--    InfCore.Log("IvarProc.SetSettings settings count changed")
    local currentSetting=self:Get()
    if not self.noBounds and currentSetting>#list-1 then
      --tex note this will also trip from setsettings with an empty list
      InfCore.Log("WARNING: IvarProc.SetSettings: "..tostring(self.name).." current setting:"..tostring(currentSetting).." out of bounds for #list:"..#list..", setting to 0",true,true)
      self:Set(0)
    end
    self.enum=InfUtil.EnumFrom0(list)
    self.settingNames=list--DEBUGNOW rethink
--    self.settingsCount=#list
--  end
end

this.OptionIsDefault=function(self)
  local currentSetting
  if this.IsOnlineMission(vars.missionCode) and not self.allowOnline then
    currentSetting=self.default
  else
    currentSetting=ivars[self.name]
  end

  return currentSetting==self.default
end

--tex NOTE: returns currentsetting if no setting given
--currentSetting is ivars current value
--setting is setting we want to check against current setting
--can be called with setting=nil to just get the value
--so is used for both ivar:Is and ivar:Get
this.OptionIsSetting=function(self,setting)
  if self==nil then
    InfCore.DebugPrint("WARNING: OptionIsSetting self==nil, Is or Get called with . instead of :")
    return
  end

  if not this.IsIvar(self) then
    InfCore.DebugPrint("self not Ivar. Is or Get called with . instead of :")
    return
  end

  local currentSetting
  if this.IsOnlineMission(vars.missionCode) and not self.allowOnline then
    currentSetting=self.default
  else
    currentSetting=ivars[self.name]
  end

  if setting==nil then
    return currentSetting
  elseif type(setting)==numberType then
    return setting==currentSetting
  end
  --tex setting to test not a number, so must be string to test against ivars enum
  if self.enum==nil then
    InfCore.DebugPrint("Is function called on ivar "..self.name.." which has no settings enum")
    return false
  end

  local settingIndex=self.enum[setting]
  if settingIndex==nil then
    InfCore.DebugPrint("WARNING: ivar "..self.name.." has no setting named "..tostring(setting))
    return false
  end
  return settingIndex==currentSetting
end

this.OnChangeProfile=function(self,setting)
  local returnValue=nil
  local currentSetting=setting or ivars[self.name]
  if self.settingsTable then
    local settingName=self.settings[currentSetting+1]
    local settingTable=self.settingsTable[settingName]

    if type(settingTable)=="function" then
      returnValue=settingTable()
    elseif type(settingTable)=="table" then
      this.ApplyProfile(settingTable)
    end
  end
  return returnValue
end

function this.AddIvarToModule(module,ivarName,ivar,menuName)
  module[ivarName]=ivar
  table.insert(module.registerIvars,ivarName)

  if menuName then
    table.insert(module[menuName].options,table.concat({"Ivars",ivarName},"."))
    table.insert(module.registerIvars,ivarName)
  end
end--AddIvarToModule

--tex use as Ivar GetNext and GetPrev (increment will already be negative for GetPrev)
--this lets you have a Ivar .settings have a list of pretty much anything () and still inrement/decrement via menu
function this.IncrementSetting(self,currentSetting,increment)
  local currentIndex=InfUtil.FindInList(self.settings,currentSetting)
  if currentIndex==false then
    InfCore.Log("WARNING: "..self.name.." could not find "..tostring(currentSetting).." in list")
    currentSetting=0
  end

  local nextIndex=InfMenu.IncrementWrap(currentIndex,increment,1,#self.settings)
  local nextSetting=self.settings[nextIndex]
  if this.debugModule then
    InfCore.Log("IncrementSetting: currentSetting:"..tostring(currentSetting).." currentIndex:"..tostring(currentIndex).." nextIndex: "..tostring(nextIndex).." nextSetting:"..tostring(nextSetting))--DEBUGNOW
  end
  return nextSetting
end--IncrementSettings

--paired min/max ivar setup
local minSuffix="_MIN"
local maxSuffix="_MAX"
function this.PushMax(ivar,setting,prevSetting)
  local maxName=ivar.subName..maxSuffix
  local currentSetting=ivars[ivar.name]
  if currentSetting>ivars[maxName] then
    Ivars[maxName]:Set(currentSetting)
  end
end
function this.PushMin(ivar,setting,prevSetting)
  local minName=ivar.subName..minSuffix
  local currentSetting=ivars[ivar.name]
  if currentSetting<ivars[minName] then
    Ivars[minName]:Set(currentSetting)
  end
end
--tex creates someIvarName_MIN,someIvarName_MAX
--and adds them to Ivars
--IvarProc.MinMaxIvar(
--  Ivars,
--  "someIvarName",
--  {default=3},
--  {default=15},
--  {
--    range={min=1,max=15}
--  },
--)
--OUT: module[ivarName...], module.registerIvars
function this.MinMaxIvar(module,name,minSettings,maxSettings,ivarSettings,dontSetIvars)
  local ivarMin={
    subName=name,
    save=this.CATEGORY_EXTERNAL,
    OnChange=this.PushMax,
  }
  local ivarMax={
    subName=name,
    save=this.CATEGORY_EXTERNAL,
    OnChange=this.PushMin,
  }

  for k,v in pairs(minSettings) do
    ivarMin[k]=v
  end

  for k,v in pairs(maxSettings) do
    ivarMax[k]=v
  end

  for k,v in pairs(ivarSettings) do
    ivarMin[k]=v
    ivarMax[k]=v
  end

  module.registerIvars=module.registerIvars or {}
  module.registerIvars[#module.registerIvars+1]=name..minSuffix
  module.registerIvars[#module.registerIvars+1]=name..maxSuffix

  if not dontSetIvars then
    module[name..minSuffix]=ivarMin
    module[name..maxSuffix]=ivarMax
  end
  return {
    [name..minSuffix]=ivarMin,
    [name..maxSuffix]=ivarMax
  }
end

local Xstr="X"
local Ystr="Y"
local Zstr="Z"
local vectorRange={max=1000,min=-1000,increment=0.1}
--tex creates 3 ivars to represent a vector3
function this.Vector3Ivar(module,name,ivarSettings,dontSetIvars)
  local XName=name..Xstr
  local YName=name..Ystr
  local ZName=name..Zstr

  module.registerIvars=module.registerIvars or {}
  module.registerIvars[#module.registerIvars+1]=XName
  module.registerIvars[#module.registerIvars+1]=YName
  module.registerIvars[#module.registerIvars+1]=ZName

  local X={
    vectorName=name,
    inMission=true,
    default=0,
    range=vectorRange,
    noBounds=true,
    GetVector3=this.GetVector3,
    SetVector3=this.SetVector3,
  }
  local Y={
    vectorName=name,
    inMission=true,
    default=0,
    range=vectorRange,
    noBounds=true,
    GetVector3=this.GetVector3,
    SetVector3=this.SetVector3,
  }
  local Z={
    vectorName=name,
    inMission=true,
    default=0,
    range=vectorRange,
    noBounds=true,
    GetVector3=this.GetVector3,
    SetVector3=this.SetVector3,
  }

  for k,v in pairs(ivarSettings) do
    X[k]=v
    Y[k]=v
    Z[k]=v
  end

  local vec3Ivars={
    X=X,Y=Y,Z=Z
  }

  X.vec3Ivars=vec3Ivars
  Y.vec3Ivars=vec3Ivars
  Z.vec3Ivars=vec3Ivars

  if not dontSetIvars then
    module[XName]=X
    module[YName]=Y
    module[ZName]=Z
  end
  return {
    [XName]=X,
    [YName]=Y,
    [ZName]=Z,
  }
end--Vector3Ivar

function this.GetVector3(ivar)
  if ivar.vec3Ivars==nil then
    InfCore.Log("ERROR: IvarProc.GetVector3: "..ivar.name..".vec3Ivars==nil")
    return nil
  end
  return Vector3(ivar.vec3Ivars.X:Get(),ivar.vec3Ivars.Y:Get(),ivar.vec3Ivars.Z:Get())
end
function this.SetVector3(ivar,vec3)
  if ivar.vec3Ivars==nil then
    InfCore.Log("ERROR: IvarProc.SetVector3: "..ivar.name..".vec3Ivars==nil")
    return nil
  end
  --TODO: if vec3.GetX (is Vector3),
  --if is table and .X, else X=vec3[1]
  return {ivar.vec3Ivars.X:Set(vec3[0]),ivar.vec3Ivars.Y:Set(vec3[0]),ivar.vec3Ivars.Z:Set(vec3[0])}
end
function this.Scale(ivar,value)
  local ivarScale=ivar:Get()
  if ivarScale~=100 then
    local scale=ivarScale/100
    return value*scale
  else
    return value
  end
end--Scale

local mbFreeMissions={[30050]=true,[30150]=true,[30250]=true}

function this.MissionCheckAll()
  return true
end

--tex just the vanilla games free missions
function this.MissionCheckFreeVanilla(self,missionCode)
  local missionCode=missionCode or vars.missionCode
  if missionCode==30010 or missionCode==30020 then
    return true
  end
  
  return false
end

--free roam missions, excluding mb
--IN/SIDE: mbFreeMissions
function this.MissionCheckFree(self,missionCode)
  local missionCode=missionCode or vars.missionCode

  local firstDigit=math.floor(missionCode/1e4)
  if firstDigit==3 then
    return not mbFreeMissions[missionCode]
  end
  
  return false
end

function this.MissionCheckMb(self,missionCode)
  local missionCode=missionCode or vars.missionCode
  return missionCode==30050
end

function this.MissionCheckMbqf(self,missionCode)
  local missionCode=missionCode or vars.missionCode
  return missionCode==30250
end

--IN/SIDE: mbFreeMissions
function this.MissionCheckMbAll(self,missionCode)
  local missionCode=missionCode or vars.missionCode
  return mbFreeMissions[missionCode] or false
end

function this.MissionCheckMission(self,missionCode)
  local missionCode=missionCode or vars.missionCode
  local firstDigit=math.floor(missionCode/1e4)
  return firstDigit==1
end

this.missionModeChecks={
  FREE=this.MissionCheckFree,
  FREE_VANILLA=this.MissionCheckFreeVanilla,
  MISSION=this.MissionCheckMission,
  MB=this.MissionCheckMb,
  MB_ALL=this.MissionCheckMbAll,
}
--tex Creates variants of ivars for each mission mode: <ivarName><missionMode> ex someIvarNameMB,someIvarNameFREE in module
--and adds the to module registerIvars
--as well as module.missionModeIvars for IsForMission,EnabledForMission support
--USAGE
--IvarProc.MissionModeIvars(
--  Ivars,--module
--  "someIvarName",--name
--  {--ivarDefine
--    save=EXTERNAL,
--    range=this.switchRange,
--    settingNames="set_switch",
--  },
--  {"FREE","MISSION",},--missionModes
--)
--OUT: module[name..], module.missionModeIvars, module.registerIvars
--GOTCHA: you should only supply missionModes that will uniquely identify as one missionMode for a given missionCode
--ie dont set { "MB","MB_ALL"}
function this.MissionModeIvars(module,name,ivarDefine,missionModes)
  if not missionModes then
    InfCore.Log("ERROR IvarProc.MissionModeIvars: cannot missionModes for "..tostring(name))
    return
  end

  for i,missionMode in ipairs(missionModes)do
    local ivar={}
    for k,v in pairs(ivarDefine) do
      ivar[k]=v
    end

    ivar.missionMode=missionMode
    ivar.MissionCheck=this.missionModeChecks[missionMode]
    local fullName=name..missionMode
    module[fullName]=ivar

    --tex used by IsForMission/EnabledForMission --TODO: implementation need a rethink
    module.missionModeIvarsNames=module.missionModeIvarsNames or {}
    module.missionModeIvarsNames[name]=module.missionModeIvarsNames[name] or {}
    table.insert(module.missionModeIvarsNames[name],fullName)

    module.registerIvars=module.registerIvars or {}
    module.registerIvars[#module.registerIvars+1]=fullName
  end
end--MissionModeIvars

--tex ivarList can be missionModeIvar name or ivar list
function this.IsForMission(ivarList,setting,missionCode)
  local missionId=missionCode or vars.missionCode
  if type(ivarList)=="string" then
    ivarList=Ivars.missionModeIvars[ivarList]
  end
  local passedCheck=false
  for i=1,#ivarList do
    local ivar=ivarList[i]
    if ivar.MissionCheck==nil then
      InfCore.Log("WARNING: IsForMission on "..ivar.name.." which has no MissionCheck func")
    elseif ivar:Is(setting) and ivar:MissionCheck(missionId) then
      passedCheck=true
      break
    end
  end
  return passedCheck
end
function this.GetForMission(ivarList,missionCode)
  local missionId=missionCode or vars.missionCode
  if type(ivarList)=="string" then
    ivarList=Ivars.missionModeIvars[ivarList]
  end
  local passedCheck=false
  for i=1,#ivarList do
    local ivar=ivarList[i]
    if ivar.MissionCheck==nil then
      InfCore.Log("WARNING: GetForMission on "..ivar.name.." which has no MissionCheck func")
    elseif ivar:MissionCheck(missionId) then
      local ret=ivar:Get()
      return ret
    end
  end
  return 0
end
function this.GetSettingNameForMission(ivarList,missionCode)
  local missionId=missionCode or vars.missionCode
  if type(ivarList)=="string" then
    ivarList=Ivars.missionModeIvars[ivarList]
    if ivarList==nil then
      InfCore.Log("ERROR: no missionModIvars for "..ivarList)
      return nil
    end
  end
  local passedCheck=false
  for i=1,#ivarList do
    local ivar=ivarList[i]
    if ivar.MissionCheck==nil then
      InfCore.Log("WARNING: GetForMission on "..ivar.name.." which has no MissionCheck func")
    elseif ivar:MissionCheck(missionId) then
      local settingName=ivar:GetSettingName()
      return settingName
    end
  end
  return 0--DEBUGNOW think this through, return default setting name or nil?
end--GetSettingNameForMission

--tex as above but with ivar>0 check
--ivarList can be missionModeIvar name or ivar list
--GOTCHA: TODO: rename or merge to stop confusion with ivar.EnabledForMission which is set to IvarEnabledForMission
function this.EnabledForMission(ivarList,missionCode)
  local missionId=missionCode or vars.missionCode
  if type(ivarList)=="string" then
    local name=ivarList
    ivarList=Ivars.missionModeIvars[ivarList]
    if ivarList==nil then
      InfCore.Log("EnabledForMission cannot find missionModeIvars:"..tostring(name))
      return false
    end
  end

  local passedCheck=false
  for i=1,#ivarList do
    local ivar=ivarList[i]
    if ivar.MissionCheck==nil then
      InfCore.Log("WARNING: EnabledFoMission on "..ivar.name.." which has no MissionCheck func")
    elseif ivar:Is()>0 and ivar:MissionCheck(missionId) then
      passedCheck=true
      break
    end
  end
  return passedCheck
end

function this.IvarEnabledForMission(self,missionCode)
  local missionId=missionCode or vars.missionCode
  if self.MissionCheck==nil then
    InfCore.Log("WARNING: EnabledForMission on "..self.name.." which has no MissionCheck func")
    return false
  end
  return self:Is()>0 and self:MissionCheck(missionId)
end

--
local random=math.random
local type=type
local tableType="table"
local stringType="string"
function this.ApplyProfile(profile,noSave)
  InfCore.LogFlow"IvarProc.ApplyProfile"

  for ivarName,setting in pairs(profile)do
    InfCore.Log("ApplyProfile: "..ivarName.." : "..tostring(setting))
    if type(setting)==tableType then
      if type(setting[1])==stringType then
        --tex setting=={"SOMESETTINGNAME",...}
        setting=setting[random(#setting)]
      else
        --tex setting=={<minnum>,<maxnum>}
        setting=random(setting[1],setting[2])
      end
    end
    local ivar=Ivars[ivarName]
    if not ivar then
      InfCore.Log("WARNING: ApplyProfile: could not find ivar "..ivarName)
    else
      ivar:Set(setting,noSave)
    end
  end
end
function this.ResetProfile(profile)
  for i,ivarName in ipairs(profile) do
    local ivar=Ivars[ivarName]
    if ivar==nil then
      InfCore.DebugPrint("WARNING: ResetProfile cant find ivar "..ivarName)
    else
      ivar:Reset()
    end
  end
end

this.UpdateSettingFromGvar=function(option)
  if option.save then
    local gvar=this.GetSaved(option)
    if gvar~=nil then
      ivars[option.name]=gvar
    end
  end
end

function this.GetIvarKeyNameValues(ivarNames,outTable)
  outTable=outTable or {}
  for name,ivarName in pairs(ivarNames)do
    outTable[name]=Ivars[ivarName]:Get()
  end--for ivarNames
  return outTable
end--GetIvarKeyValues

function this.GetIvarKeyValues(ivarNames,outTable)
  outTable=outTable or {}
  for name,ivarDef in pairs(ivarNames)do
    outTable[name]=Ivars[name]:Get()
  end--for ivarDefs
  return outTable
end--GetIvarKeyValues

function this.GetIvarValues(ivarNames,outTable)
  outTable=outTable or {}
  for i,name in ipairs(ivarNames)do
    outTable[name]=Ivars[name]:Get()
  end--for ivarDefs
  return outTable
end--GetIvarKeyValues

--CALLER: TppSave.SaveGameData (via InfHooks > InfMain)
--is just before actual game save
function this.SaveGameData(missionCode,needIcon,doSaveFunc,reserveNextMissionStartSave,isCheckPoint)
  local onGameSave=true
  InfCore.PCallDebug(this.SaveAll,onGameSave,isCheckPoint)
end
--CALLER: TppSave.MakeNewGameSaveData (via InfHooks > InfMain)
function this.MakeNewGameSaveData(acquirePrivilegeInTitleScreen)
  InfMain.CallOnModules("ClearSave")
  InfCore.PCallDebug(this.SaveAll)
end

--CALLER: TppSave.VarRestoreOnMissionStart (via InfMain > InfHooks)
function this.PostVarRestoreOnMissionStart()

end
--CALLER: TppSave.VarRestoreOnContinueFromCheckPoint (via InfMain > InfHooks)
function this.PostVarRestoreOnContinueFromCheckPoint()
  InfCore.PCallDebug(this.LoadAllSave)
end

--debug stuff
--tex only catches save vars
function this.PrintNonDefaultVars()
  local varTable=Ivars.DeclareVars()
  if varTable==nil then
    InfCore.DebugPrint("varTable not found")
    return
  end

  for name,value in pairs(evars) do
    local default=Ivars[name].default
    if value~=default then
      InfCore.DebugPrint("DEBUG: "..name.." current value "..value.." is not default "..default)
    end
  end
end

function this.PrintGvarSettingMismatch()
  --InfCore.PCall(function()--DEBUG
  for name,ivar in pairs(Ivars) do
    if this.IsIvar(ivar) then
      local gvar=this.GetSaved(ivar)
      if gvar~=nil then
        if ivars[ivar.name]~=gvar then
          InfCore.Log("WARNING: ivar setting/gvar mismatch for "..name,true)
          InfCore.Log("setting:"..tostring(ivars[ivar.name]).." gvar value:"..tostring(gvar),true)
        end
      end
    end
  end
  --end)--
end

--tex TODO update to catch evars
function this.PrintSaveVarCount()
  local varTable=Ivars.DeclareVars()
  if varTable==nil then
    InfCore.DebugPrint("varTable not found")
    return
  end

  local gvarCountCount=0
  for n,gvarInfo in pairs(varTable) do
    local gvar=gvars[gvarInfo.name]
    if gvar==nil then
      InfCore.DebugPrint("WARNING ".. gvarInfo.name.." has no gvar")
    else
      gvarCountCount=gvarCountCount+1
    end
  end
  InfCore.DebugPrint("Ivar gvar count:"..gvarCountCount.." "..#varTable)

  local bools=0
  for name, ivar in pairs(Ivars) do
    if this.IsIvar(ivar) then
      if ivar.save then
        if ivar.range.max==1 then
          bools=bools+1
        end
      end
    end
  end
  InfCore.DebugPrint("potential ivar bools:"..bools)

  local scriptVarTypes={
    [TppScriptVars.TYPE_BOOL]="TYPE_BOOL",
    [TppScriptVars.TYPE_UINT8]="TYPE_UINT8",
    [TppScriptVars.TYPE_INT8]="TYPE_INT8",
    [TppScriptVars.TYPE_UINT16]="TYPE_UINT16",
    [TppScriptVars.TYPE_INT16]="TYPE_INT16",
    [TppScriptVars.TYPE_UINT32]="TYPE_UINT32",
    [TppScriptVars.TYPE_INT32]="TYPE_INT32",
    [TppScriptVars.TYPE_FLOAT]="TYPE_FLOAT",
  }

  local function CountVarTable(scriptVarTypes,varTable,category)
    local totalCount=0
    local typeCounts={}
    local totalCountArray=0
    local arrayCounts={}
    for scriptVarType, typeName in pairs(scriptVarTypes) do
      typeCounts[typeName]=0
      arrayCounts[typeName]=0
    end

    for n, gvarInfo in pairs(varTable)do
      if category==nil or gvarInfo.category==category then
        local scriptVarTypeName=scriptVarTypes[gvarInfo.type]
        typeCounts[scriptVarTypeName]=typeCounts[scriptVarTypeName]+1

        local count=gvarInfo.arraySize or 1
        if count==0 then count=1 end
        --if Tpp.IsTypeNumber(gvarInfo.arraySize) then
        arrayCounts[scriptVarTypeName]=arrayCounts[scriptVarTypeName]+count
        --end
        totalCount=totalCount+1
        totalCountArray=totalCountArray+count
      end
    end
    return typeCounts,arrayCounts,totalCount,totalCountArray
  end

  InfCore.DebugPrint"NOTE: these are CATEGORY_MISSION counts"

  InfCore.DebugPrint"Ivars.varTable"
  local ivarTable=Ivars.DeclareVars()
  local typeCounts,arrayCounts,totalCount,totalCountArray=CountVarTable(scriptVarTypes,ivarTable,TppScriptVars.CATEGORY_MISSION)

  InfCore.DebugPrint"typeCounts"
  InfCore.PrintInspect(typeCounts)

  InfCore.DebugPrint"arrayCounts"
  InfCore.PrintInspect(arrayCounts)

  InfCore.DebugPrint("totalcount:"..totalCount.." totalcountarray:"..totalCountArray)



  --  InfCore.PrintInspect(TppScriptVars)

  --  local categories={
  --    [TppScriptVars.CATEGORY_NONE]="CATEGORY_NONE",
  --    [TppScriptVars.CATEGORY_GAME_GLOBAL]="CATEGORY_GAME_GLOBAL",
  --    [TppScriptVars.CATEGORY_MISSION]="CATEGORY_MISSION",
  --    [TppScriptVars.CATEGORY_RETRY]="CATEGORY_RETRY",
  --    [TppScriptVars.CATEGORY_MB_MANAGEMENT]="CATEGORY_MB_MANAGEMENT",
  --    [TppScriptVars.CATEGORY_QUEST]="CATEGORY_QUEST",
  --    [TppScriptVars.CATEGORY_CONFIG]="CATEGORY_CONFIG",
  --    --[TppDefine.CATEGORY_MISSION_RESTARTABLE]="TppDefine CATEGORY_MISSION_RESTARTABLE",
  --    [TppScriptVars.CATEGORY_MISSION_RESTARTABLE]="CATEGORY_MISSION_RESTARTABLE",
  --    [TppScriptVars.CATEGORY_PERSONAL]="CATEGORY_PERSONAL",
  --    --[TppScriptVars.CATEGORY_MGO]="CATEGORY_MGO",
  --    [TppScriptVars.CATEGORY_ALL]="CATEGORY_ALL",
  --  }

  --  for categoryType, categoryName in pairs(categories) do
  --    InfCore.DebugPrint(categoryName..":"..tostring(categoryType))
  --  end

  InfCore.DebugPrint"TppGVars.DeclareGVarsTable"
  local typeCounts,arrayCounts,totalCount,totalCountArray=CountVarTable(scriptVarTypes,TppGVars.DeclareGVarsTable,TppScriptVars.CATEGORY_MISSION)

  InfCore.DebugPrint"typeCounts"
  InfCore.PrintInspect(typeCounts)

  InfCore.DebugPrint"arrayCounts"
  InfCore.PrintInspect(arrayCounts)

  InfCore.DebugPrint("totalcount:"..totalCount.." totalcountarray:"..totalCountArray)

  InfCore.DebugPrint"TppMain.allSvars"
  local typeCounts,arrayCounts,totalCount,totalCountArray=CountVarTable(scriptVarTypes,TppMain.allSvars,TppScriptVars.CATEGORY_MISSION)
  InfCore.DebugPrint"typeCounts"
  InfCore.PrintInspect(typeCounts)

  InfCore.DebugPrint"arrayCounts"
  InfCore.PrintInspect(arrayCounts)

  InfCore.DebugPrint("totalcount:"..totalCount.." totalcountarray:"..totalCountArray)

  --    InfCore.PrintInspect(TppMain.allSvars)
end

local profileFormat={
  description="string",
  profile="table",
}

--OUT: profileNames,infProfiles
--SIDE: Ivars.profiles
--IN-SIDE: InfCore.files
function this.SetupInfProfiles()
  InfCore.LogFlow"IvarProc.SetupInfProfiles"

  local fileNames=InfCore.GetFileList(InfCore.files.profiles,".lua")

  --InfCore.PrintInspect(fileNames)--DEBUG
  --DEBUGNOW TODO only load loadonstart, otherwise just keep the names and only load when specific one selected in option,
  --no point keeping loaded/storing in profiles[] if it's only applied on load or via user action.

  local profiles={}
  local profileNames={}
  for i,fileName in ipairs(fileNames)do
    local profile=InfCore.LoadSimpleModule(InfCore.paths.profiles,fileName,true)
    if profile and profile.profile then
      local profileOk=InfCore.Validate(profileFormat,profile,fileName)
      if profileOk then
        insert(profileNames,fileName)
        profiles[fileName]=profile
      end
    end
  end

  --  InfCore.PrintInspect(profileNames)--DEBUG
  --  InfCore.PrintInspect(infProfiles)--DEBUG

  --CULL old single file
  --  local fileName="InfProfiles.lua"
  --  local infProfiles=InfCore.LoadSimpleModule(fileName,nil,true)
  --  if infProfiles==nil then
  --    Ivars.profiles=nil
  --    return nil
  --  end

  table.sort(profileNames)

  local firstProfileCount=0
  for i,profileName in ipairs(profileNames)do
    if profiles[profileName].firstProfile then
      local currentFirst=profileNames[1]
      profileNames[1]=profileName
      profileNames[i]=currentFirst
      firstProfileCount=firstProfileCount+1
    end
  end
  if firstProfileCount>1 then
    InfCore.DebugPrint("WARNING: multiple profiles with firstProfile set")
  end

  return {profileNames,profiles}--WORKAROUND PCall
end

function this.ApplyInfProfiles(profileNames)
  if not Ivars.profiles or profileNames==nil then
    InfCore.Log"ApplyInfProfiles: profileNames==nil"--DEBUG
    return
  else
    for i,profileName in ipairs(profileNames)do
      local profileInfo=Ivars.profiles[profileName]
      if profileInfo.loadOnACCStart then
        local profileName=profileInfo.description or profileName
        InfMenu.Print(InfLangProc.LangString"applying_profile".." "..profileName)
        InfCore.Log("Applying profile "..profileName)
        IvarProc.ApplyProfile(profileInfo.profile)
      end
    end
  end
end

function this.IsForProfile(item)
  if item.nonConfig
    or item.optionType~="OPTION"
    or item.nonUser
    or item.save==nil
  then
    return false
  end

  return true
end

function this.BuildProfile(onlyNonDefault)
  local profile={}
  for ivarName,ivar in pairs(Ivars)do
    if this.IsIvar(ivar) then
      if this.IsForProfile(ivar) then
        local currentSetting=ivars[ivar.name]
        if not onlyNonDefault or currentSetting~=ivar.default then
          if ivar.settings then
            profile[ivar.name]=ivar.settings[currentSetting+1]
          else
            profile[ivar.name]=currentSetting
          end
        end
      end
    end
  end
  return profile
end


--tex settings range on one line between braces
function this.GetSettingsLine(ivar)
  local settingsLine={}
  if ivar.settings then--tex DEBUGNOW TODO filter dynamic
    insert(settingsLine,"{ ")
    for i,setting in ipairs(ivar.settings)do
      insert(settingsLine,setting)
      if i~=#ivar.settings then
        insert(settingsLine,", ")
      end
    end
    insert(settingsLine," }")
  else
    insert(settingsLine,"{ ")
    insert(settingsLine,ivar.range.min.."-"..ivar.range.max)
    insert(settingsLine," }")
  end
  return concat(settingsLine)
end

function this.WriteProfile(defaultSlot,onlyNonDefault)
  local dateTime=os.date("%x %X")
  local profile={
    description="User-saved "..dateTime,
    --modVersion=InfCore.modVersion,
    profile=this.BuildProfile(onlyNonDefault),
  }
  --InfCore.PrintInspect(profile)--DEBUG

  local profileName="User_Saved"
  if not defaultSlot then
    profileName=profileName..os.time()
  end

  local ivarNames={}
  for k,v in pairs(profile.profile) do
    ivarNames[#ivarNames+1]=k
  end
  table.sort(ivarNames)

  local lang=InfLang.eng
  local helpLang=InfLang.help.eng

  local saveLineFormatStr="\t\t%s=%s, --[[%s -- %s -- %s]]"
  local saveText={}
  saveText[#saveText+1]="local this={"
  saveText[#saveText+1]="\tdescription=\""..profile.description.."\","
  saveText[#saveText+1]="\tprofile={"
  for i,name in ipairs(ivarNames)do
    local ivar=Ivars[name]

    local value=profile.profile[name]
    if value then
      if type(value)=="string"then
        value="\""..value.."\""
      end

      local settingsString=this.GetSettingsLine(ivar)
      local nameLangString=lang[name] or ""
      local helpLangString=helpLang[name] or ""
      local line=format(saveLineFormatStr,name,value,settingsString,nameLangString,helpLangString)

      saveText[#saveText+1]=line
    end
  end
  saveText[#saveText+1]="\t}"
  saveText[#saveText+1]="}"
  saveText[#saveText+1]="return this"

  --InfCore.PrintInspect(concat(saveText))--DEBUG
  profileName=profileName..".lua"
  if not Ivars.profiles[profileName] then
    insert(Ivars.profileNames,1,profileName)
  end
  Ivars.profiles[profileName]=profile
  local profilesFileName=InfCore.paths.profiles..profileName
  --CULL  InfPersistence.Store(InfCore.paths.mod..profilesFileName,Ivars.savedProfiles)
  InfCore.WriteStringTable(profilesFileName,saveText)
end

--local gameVer=IHH and IHH.gameVer 
local saveHeader={
  "-- "..InfCore.saveName,
  "-- Save file for IH options",
  "-- While this file is editable, editing an inMission save is likely to cause issues, and it's preferable that you use InfProfiles.lua instead.",
  "-- See Readme for more info",
  "local this={}",
  "this.loadToACC=false",
  "this.ihVer="..InfCore.modVersion,
  "this.ihhookVer="..tostring(_IHHook),
  --TODO: bit of a mess at the moment on IHHook side --"this.gameVer="..tostring(gameVer),
}

--tex knocks about 0.005s vs previous (with ivars and quest not dirty)
--IN-Side evars
--returns nil if save is not dirty
function this.BuildSaveText(inMission,onlyNonDefault,newSave)
  local inMission=inMission or false

  local isDirty=false

  if Ivars.isSaveDirty then
    isDirty=true
    if this.debugModule then
      InfCore.Log("evars isDirty")
    end
    ClearArray(evarsTextList)
    this.BuildEvarsText(evars,evarsTextList,onlyNonDefault)
    Ivars.isSaveDirty=false
  end

  --tex TODO: better
  local igvarsDirty=false
  for k,v in pairs(igvars)do
    if igvarsPrev[k]~=v then
      igvarsPrev[k]=v
      igvarsDirty=true
      isDirty=true
    end
  end
  if igvarsDirty then
    if this.debugModule then
      InfCore.Log("igvarsDirty isDirty")
    end
    ClearArray(igvarsTextList)
    this.BuildTableText("igvars",igvars,igvarsTextList)
  end

  --tex also skips depenancy on InfQuest
  --DEBUGNOW CULL
--  if not newSave then
--    if InfQuest then
--      local questStates=InfQuest.GetCurrentStates()
--      if questStates then
--        isDirty=true
--        if this.debugModule then
--          InfCore.Log("questStates isDirty")
--        end
--        ClearArray(questStatesTextList)
--        this.BuildTableText("questStates",questStates,questStatesTextList)
--      end
--    end
--  end

  if not isDirty and not newSave then
    if this.debugModule then
      InfCore.Log("save not dirty")
    end
    return nil
  end

  ClearArray(saveTextList)

  --tex header
  for i,v in ipairs(saveHeader)do
    saveTextList[i]=v
  end
  saveTextList[#saveTextList+1]="this.saveTime="..os.time()
  saveTextList[#saveTextList+1]="this.inMission="..tostring(inMission)

  MergeArray(saveTextList,evarsTextList)
  MergeArray(saveTextList,igvarsTextList)
  --DEBUGNOW CULL MergeArray(saveTextList,questStatesTextList)

  saveTextList[#saveTextList+1]="return this"

  return saveTextList
end

--IN/OUT saveTextList
local evarLineFormatStr="\t%s=%g,"
local evarOpen="this.evars={"
local tableClose="}"
function this.BuildEvarsText(evars,saveTextList,onlyNonDefault)
  InfCore.LogFlow("BuildEvarsText")
  local Ivars=Ivars
  saveTextList[#saveTextList+1]=evarOpen
  for name,value in pairs(evars)do
    local ivar=Ivars[name]
    if not ivar then
      InfCore.Log("WARNING: IvarProc.BuildEvarsText: Could not find ivar for evar "..name)
    elseif not onlyNonDefault or value~=ivar.default then
      if ivar.save and ivar.save==this.CATEGORY_EXTERNAL then
        saveTextList[#saveTextList+1]=format(evarLineFormatStr,name,value)
      end
    end
  end
  saveTextList[#saveTextList+1]=tableClose
end

local saveLineKeyNumber="\t[%s]="
local saveLineKeyExplicitString='\t["%s"]='
local saveLineKeyOther="\t%s="

local saveLineValueStr="%q,"
local saveLineValueOther="%s,"
local tableHeaderFmt="this.%s={"

local Format=string.format
local sub=string.sub
local tonumber=tonumber
function this.BuildTableText(tableName,sourceTable,saveTextList)
  saveTextList[#saveTextList+1]=Format(tableHeaderFmt,tableName)--tex TODO guard against tableName 1st char is a number like bleow
  for k,v in pairs(sourceTable)do
    local keyLine=""
    if type(k)=="number" then
      keyLine=Format(saveLineKeyNumber,k)
    --elseif tonumber(sub(k, 1, 1))~=nil then--tex first char is number TODO TEST
    --  keyLine=Format(saveLineKeyExplicitString,k)
    else
      keyLine=Format(saveLineKeyOther,k)
    end
    
    local valueLine=""
    if type(v)=="string" then
      valueLine=Format(saveLineValueStr,tostring(v))
    else
      valueLine=Format(saveLineValueOther,tostring(v))
    end
    
    saveTextList[#saveTextList+1]=keyLine..valueLine
  end
  saveTextList[#saveTextList+1]=tableClose
end

function this.WriteSave(saveTextLines,saveName)
  local filePath=InfCore.paths.saves..saveName

  local saveFile,openError=io.open(filePath,"w")
  if not saveFile or openError then
    local errorText="WriteEvars: Create save error: "..tostring(openError)
    InfCore.DebugPrint(errorText)
    InfCore.Log(errorText)
    return
  end

  saveFile:write(concat(saveTextLines,"\r\n"))
  saveFile:close()
end

local typeString="string"
local typeNumber="number"
local typeFunction="function"
local typeTable="table"
--tex validates loadfiled module and returns table of just evars
function this.ReadEvars(ih_save)
  if ih_save==nil then
    local errorText="ERROR: ReadEvars: ih_save==nil"
    InfCore.Log(errorText,true,true)
    return
  end

  if type(ih_save.evars)~=typeTable then
    local errorText="ERROR: ReadEvars: ih_save.evars~=typeTable"
    InfCore.Log(errorText,true,true)
    return
  end

  local loadedEvars={}
  for name,value in pairs(ih_save.evars) do
    if type(name)~=typeString then
      InfCore.Log("WARNING: ReadEvars ih_save: name~=string:"..tostring(name),false,true)
    else
      if type(value)~=typeNumber then
        InfCore.Log("WARNING: ReadEvars ih_save: value~=number: "..name.."="..tostring(value),false,true)
      else
        --tex used to use this to clear out unknown ivars,
        --but now that ivars can be defined in modules, and ReadEvars is run once before modules are loaded
        --they're now cleared in Ivars.PostAllModulesLoad / after the module ivars are added
        if ivars and ivars[name]==nil then
        --InfCore.Log("WARNING: ReadEvars ih_save: cannot find ivar for evar "..name,false,true)
        end
        loadedEvars[name]=value
      end
    end
  end
  return loadedEvars
end
--CALLER: TppSave.SaveGameData > IvarProc.OnSave, InfMenu.OnMenuClose 
--onGameSave: true if called by TppSave.SaveGameData
--isCheckPoint: TppSave.SaveGameData isCheckPoint
function this.SaveAll(onGameSave,isCheckPoint)
  InfCore.LogFlow"IvarProc.SaveAll"
  this.SaveEvars()
  InfMain.CallOnModules("Save",onGameSave,isCheckPoint)
end

function this.SaveEvars()
  InfCore.LogFlow"IvarProc.SaveEvars"
  local saveName=InfCore.saveName
  local onlyNonDefault=true

  --tex TODO: figure out some last-know good method and write a backup

  local inGame=not mvars.mis_missionStateIsNotInGame

  local inHeliSpace=vars.missionCode and math.floor(vars.missionCode/1e4)==4--tex heli missions are in 40k range--DEBUGNOW TODO inSafeSpace
  local inMission=inGame and not inHeliSpace

  local buildSaveTextTime=OsClock()
  local saveTextList=this.BuildSaveText(inMission,onlyNonDefault)
  --tex save wasnt dirty
  if saveTextList==nil then
    if this.debugModule then
      InfCore.Log("IvarProc.SaveEvars: save wasnt dirty, no need to write")
    end
    return
  end

  buildSaveTextTime=OsClock()-buildSaveTextTime
  --InfCore.PrintInspect(evarsTextList)
  local writeTime=OsClock()
  this.WriteSave(saveTextList,saveName)
  writeTime=OsClock()-writeTime

  if this.debugModule then
    InfCore.Log("buildSaveTextTime:"..buildSaveTextTime..", writeTime:"..writeTime)
  end
end

function this.CreateNewSave(filePath,saveName)
  local inMission=false
  local onlyNonDefault=true
  local newSave=true
  local saveTextList=this.BuildSaveText(inMission,onlyNonDefault,newSave)
  --InfCore.PrintInspect(evarsTextList)
  this.WriteSave(saveTextList,saveName)
  ih_save_chunk,loadError=loadfile(filePath)--KLUDGE for creating new save when existing one fails to load
  return ih_save_chunk
end
--tex ih_save only, see also LoadAllSave
function this.LoadIHSave()
  InfCore.LogFlow"IvarProc.LoadSave"
  local saveName=InfCore.saveName
  local filePath=InfCore.paths.saves..saveName

  if not InfCore.FileExists(filePath) then
    if not InfCore.ihSaveFirstLoad then
      InfCore.Log("WARNING: LoadSave: ih_save.lua not found, creating new",false,true)
      this.CreateNewSave(filePath,saveName)
    end
  end

  local box=true
  local ih_save=InfCore.LoadSimpleModule(InfCore.paths.saves,saveName,box)

  if ih_save==nil then
    local errorText="LoadSave Error: ih_save==nil"
    InfCore.Log(errorText,true,true)

    return nil
  end

  if type(ih_save)~="table"then
    local errorText="LoadSave Error: ih_save==table"
    InfCore.Log(errorText,true,true)

    return nil
  end

  return ih_save
end--LoadIHSave
--See Also InfMain.LoadLibraries 
--and init_sequence.Seq_Demo_CreateOrLoadSaveData (GOTCHA: first game load, so if you're doing any gvars wrangling in LoadSave you may have to make sure its called after too)
function this.LoadAllSave()
  InfCore.LogFlow"IvarProc.LoadAllSave"
  this.LoadEvars()
  for i,module in ipairs(InfModules) do
    if type(module.LoadSave)=="function" then
      InfCore.LogFlow(module.name..".LoadSave")
      InfCore.PCallDebug(module.LoadSave)
    end
  end
end
--CALLERS: InfInit load exec, LoadAllSave above -^- (which resolves to TppSave.VarRestoreOnMissionStart and VarRestoreOnContinueFromCheckPoint)
--SIDE: ih_save (global module)
function this.LoadEvars()
  InfCore.LogFlow"IvarProc.LoadEvars"
  ih_save=this.LoadIHSave()
  if ih_save then
    local loadedEvars=this.ReadEvars(ih_save)
    if this.debugModule then
      InfCore.PrintInspect(loadedEvars,"loadedEvars")
    end
    if loadedEvars then
      for name,value in pairs(loadedEvars) do
        evars[name]=value
      end
    end

    if ih_save.igvars then
      --InfCore.PrintInspect(igvars,"igvars, preload")--DEBUG
      --InfCore.PrintInspect(ih_save.igvars,"ih_save.igvars")--DEBUG

      for name,value in pairs(ih_save.igvars) do
        if type(name)=="string" then
          igvars[name]=value--tex just dumped straight, cant check to see if it's valid because all the modules arent up at first load
        end
      end
      --InfCore.PrintInspect(igvars,"igvars, loaded")--DEBUG
    end

    if InfCore.doneStartup and igvars.inf_event and igvars.inf_event==true then
      InfCore.Log("IvarProc.LoadEvars: is mis event, skiping UpdateSettingFromGvar."..vars.missionCode)--DEBUG
    else
      for name,ivar in pairs(Ivars) do
        if this.IsIvar(ivar) then
          this.UpdateSettingFromGvar(ivar)
        end
      end
    end

    InfCore.OnLoadEvars()
  end
end

return this
