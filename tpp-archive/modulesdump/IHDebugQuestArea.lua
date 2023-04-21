-- IHDebugQuestArea.lua --DEBUGNOW
local this={}

local pairs=pairs
local tostring=tostring
local GetCurrentStageSmallBlockIndex=Tpp.GetCurrentStageSmallBlockIndex
local ExtCmd=InfCore.ExtCmd
local WriteToExtTxt=InfCore.WriteToExtTxt
local Log=InfCore.Log

--updateState
this.active="enableDebugQuestArea"
--this.execCheckTable={inGame=true,inSafeSpace=false}
this.execState={
  nextUpdate=0,
}
this.updateRate=2


this.currentQuestDeactivateTrap=nil
--

this.registerIvars={
  "enableDebugQuestArea",
}

this.enableDebugQuestArea={
  nonUser=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    InfCore.ExtCmd("UiElementVisible","questAreaInfo",setting)
    InfCore.WriteToExtTxt()
  end,
}

this.registerMenus={
  "debugQuestAreaMenu",
}

this.debugQuestAreaMenu={
  noDoc=true,
  parentRefs={"InfMenuDefs.inMissionMenu"},
  options={
    "IHDebugQuestArea.enableDebugQuestArea",
  }
}

function this.CreateUi()
  local xaml={
    [[<Label ]],
    [[xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" ]],
    [[xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" ]],
    [[Name="questAreaInfo" ]],
    [[Visibility="Hidden" ]],
    [[Content="----" ]],
    [[Foreground="White" ]],
    [[Background="Transparent" ]],
    [[FontSize="23" ]],
    [[Canvas.Left="300" ]],
    [[Canvas.Top="40">]],
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
  InfMgsvToExt.CreateUiElement("questAreaInfo",table.concat(xaml))
end

function this.Init()
  if not TppMission.IsFreeMission(vars.missionCode)then
    InfCore.ExtCmd("UiElementVisible","questAreaInfo",0)
    InfCore.WriteToExtTxt()
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  this.CreateUi()
  InfCore.ExtCmd("UiElementVisible","questAreaInfo",1)
  InfCore.WriteToExtTxt()
end

function this.OnReload(missionTable)
  if not TppMission.IsFreeMission(vars.missionCode)then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.Messages()
  return Tpp.StrCode32Table{
    Trap={
      {msg="Enter",
        func=function(trapNameS32,gameId)
          if this.trapS32ToStr[trapNameS32] then
            InfCore.Log("!!!Trap Enter "..trapNameS32)--DEBUGNOW
            this.currentQuestDeactivateTrap="Enter:"..this.trapS32ToStr[trapNameS32]
          end
        end},
      {msg="Exit",
        func=function(trapNameS32,gameId)
          if this.trapS32ToStr[trapNameS32] then
            InfCore.Log("!!!Trap Exit "..trapNameS32)--DEBUGNOW
            this.currentQuestDeactivateTrap="Exit:"..this.trapS32ToStr[trapNameS32]
          end
        end}
    },
  }
end

function this.Update(currentChecks,currentTime,execChecks,execState)
  if not TppMission.IsFreeMission(vars.missionCode)then
    return
  end

  local IsInsideArea=TppQuest.IsInsideArea

  if vars.missionCode==30050 then
    local clusterId=MotherBaseStage.GetCurrentCluster()
    if clusterId==nil then
      InfCore.Log("InfQuest.PrintQuestArea: WARNING: GetCurrentCluster==nil")
    else
      local clusterName=TppDefine.CLUSTER_NAME[clusterId+1]
      --tex not using InfMain.CLUSTER_NAME because there's currently no quest area for separation,zoo
      --GOTCHA doesn't take into account MtbsPaz area, but im not sure how it decides that area
      if clusterName==nil then
        InfCore.Log("InfQuest.PrintQuestArea: WARNING: clusterName==nil")
      else
        InfCore.Log("Quest Area: Mtbs"..clusterName)
        ExtCmd("SetContent","questAreaInfo","Quest Area: Mtbs"..clusterName)
        InfCore.WriteToExtTxt()
      end
    end
    return
  end

  local blockIndexX,blockIndexY=GetCurrentStageSmallBlockIndex()

  local blockIndexMessage="blockX:"..blockIndexX..",blockY:"..blockIndexY
  Log(blockIndexMessage,false,true)

  --tex its only on exit that CheckDeactiveQuestAreaForceFulton fires
  local trapMessage="In quest trap: "..tostring(this.currentQuestDeactivateTrap)
  Log(trapMessage)

  local areaInfoMessage=""

  local areaTypes={
    loadArea=false,
    --invokeArea=false,--tex invokeArea always the same as activeArea
    activeArea=false,
  }

  local qst_questList=mvars.qst_questList
  local numAreas=#qst_questList
  for i=1,numAreas do
    local areasQuestInfo=qst_questList[i]--TppQuestList .questList

    for areaType,inArea in pairs(areaTypes)do
      areaTypes[areaType]=IsInsideArea(areaType,areasQuestInfo,blockIndexX,blockIndexY)
    end

    local inAnyArea=false
    for areaType,inArea in pairs(areaTypes)do
      if areaTypes[areaType]==true then
        inAnyArea=true
        break
      end
    end

    if inAnyArea then
      areaInfoMessage="Quest area: "..areasQuestInfo.areaName..", in:"
      for areaType,inArea in pairs(areaTypes)do
        areaInfoMessage=areaInfoMessage.." "..areaType.."="..tostring(inArea)
      end

      Log(areaInfoMessage,false,true)
    end
  end

  trapMessage="Trap "..tostring(this.currentQuestDeactivateTrap)
  --ASSUMPTION: quest areas dont overlap (by the way it works it shouldnt).
  ExtCmd("SetContent","questAreaInfo",blockIndexMessage.."]["..areaInfoMessage.."]["..trapMessage)
  WriteToExtTxt()
end


--
local afgAreaList={"tent","field","ruins","waterway","cliffTown","commFacility","sovietBase","fort","citadel"}
local mafrAreaList={"outland","pfCamp","savannah","hill","banana","diamond","lab"}
local trapPrefix="trap_preDeactiveQuestArea_"
local trapNames={}
for i,areaName in ipairs(afgAreaList)do
  table.insert(trapNames,trapPrefix..areaName)
end
for i,areaName in ipairs(mafrAreaList)do
  table.insert(trapNames,trapPrefix..areaName)
end
this.trapS32ToStr={}
for i,trapName in ipairs(trapNames)do
  this.trapS32ToStr[InfCore.StrCode32(trapName)]=trapName
end
--DEBUGNOW
InfCore.PrintInspect(this.trapS32ToStr,"------------trapS32ToStr")

return this
