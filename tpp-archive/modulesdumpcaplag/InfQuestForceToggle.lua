local this={}

this.registerIvars={
    "forceChangeQuest",
}

this.registerMenus={
    "forceChangeQuestMenu",
}

this.forceChangeQuest={
    range={max=157},--DYNAMIC, DEBUGNOW: AutoDoc won't pull an accurate count, also this wont update till actually selected meaning profile wont be able to set to new sideops.
    GetSettingText=function(self,setting)
        local questName=TppQuest.QUESTTABLE_INDEX[setting] or "OFF"
        return questName
    end,
    SkipValues=function(self,newSetting)
        local questName=TppQuest.QUESTTABLE_INDEX[newSetting]
        --InfCore.Log(questName)--DEBUG
        return not this.IsQuestInCurrentLocation(questName)
    end,
    OnSelect=function(self,setting)
        --range 0==OFF - #questInfoTable
        local indexFrom1=true
        local indexFrom1=true
        IvarProc.SetMaxToList(self,TppQuest.GetQuestInfoTable(),indexFrom1)
    end,
    OnActivate=function(self,setting)
        local questName=TppQuest.QUESTTABLE_INDEX[setting]
        
        this.OpenAndActivateSpecialQuest(questName)
    end,
}

this.forceChangeQuestMenu={
    parentRefs={"InfMenuDefs.inMissionMenu","InfMenuDefs.safeSpaceMenu"},
    options={
        "Ivars.forceChangeQuest",
    },
}

--TppQuest
local QUEST_STATUS_TYPES=TppDefine.Enum{"OPEN","CLEAR","FAILURE","UPDATE"}

--TppQuest
function this.OpenAndActivateSpecialQuest(questName)
    InfCore.Log("InfQuestForceToggle.OpenAndActivateSpecialQuest")
    local opened=true
    InfCore.Log("OpenAndActivateSpecialQuest: "..questName)
    if this.CanOpenAndActivateSpecialQuest(questName)then
        TppQuest.OpenQuestForce(questName)
        this.SwitchActiveQuest(questName)
    else
        opened=false
    end
    if opened then
        TppQuest.ShowAnnounceLog(QUEST_STATUS_TYPES.OPEN)
    end
    return opened
end

--TppQuest
function this.CanOpenAndActivateSpecialQuest(questName)
    InfCore.Log("InfQuestForceToggle.CanOpenAndActivateSpecialQuest "..questName)
    local areaName=this.GetQuestAreaName(questName)
    if not areaName then
        InfCore.Log("CanOpenAndActivateSpecialQuest areaName is nil")
        return false
    end
    local questAreaTable, questInfo = TppQuest.GetQuestTable(questName)
    if not questAreaTable or not questInfo then
        InfCore.Log("CanOpenAndActivateSpecialQuest "..questName.." has no quest tables")
        return
    end
    local locationName=TppPackList.GetLocationNameFormMissionCode(vars.missionCode)
    local locationId=TppDefine.LOCATION_ID[locationName]
    if questAreaTable.locationId==locationId then
        local blockIndexX,blockIndexY=Tpp.GetCurrentStageSmallBlockIndex()
        if not TppQuest.IsInsideArea("loadArea",questAreaTable,blockIndexX,blockIndexY) then
            return true
        end
    else
        InfCore.Log("CanOpenAndActivateSpecialQuest Player is not in the location of "..questName)
    end
    InfCore.Log("CanOpenAndActivateSpecialQuest Nothing done")
    return false
end

--TppQuest
function this.SwitchActiveQuest(questName)
    InfCore.Log("InfQuestForceToggle.SwitchActiveQuest "..questName)
    local questAreaTable, questInfo = TppQuest.GetQuestTable(questName)
    if not questAreaTable or not questInfo then
        InfCore.Log("SwitchActiveQuest "..questName.." has no quest tables")
        return
    end
    for j,info in ipairs(questAreaTable.infoList)do
        local _questName=info.name
        local questIndex=TppDefine.QUEST_INDEX[_questName]
        if questIndex then
            if _questName==questName then
                InfCore.Log("SwitchActiveQuest gvars.qst_questActiveFlag of "..questName.." is set")
                local blockIndexX,blockIndexY=Tpp.GetCurrentStageSmallBlockIndex()
                if TppQuest.IsInsideArea("loadArea",questAreaTable,blockIndexX,blockIndexY) then
                    InfCore.Log("SwitchActiveQuest Player is within the area of "..questName)
                    --[[
                    local loaded=TppScriptBlock.Load(mvars.qst_blockName,questName)
                    if loaded==false then
                        InfCore.Log("Didn't load "..questName)
                        return
                    else
                        InfCore.Log("Loaded "..questName)
                        TppQuest.ResetQuestStatus()
                        TppQuest.SetCurrentQuestName(questName)
                        TppQuest.ActivateCurrentQuestBlock()
                    end
                    ]]
                else
                    TppQuest.AddStaffsFromTempBuffer()
                    TppQuest.Save()
                end
                gvars.qst_questActiveFlag[questIndex]=true
            else
                gvars.qst_questActiveFlag[questIndex]=false
            end
        end
    end
end

function this.GetQuestAreaName(questName)
    InfCore.Log("InfQuestForceToggle.GetQuestAreaName "..questName)
    local questAreaTable, questInfo = TppQuest.GetQuestTable(questName)
    if questAreaTable then
        InfCore.Log("GetQuestAreaName "..questName.." is in "..questAreaTable.areaName)
        return questAreaTable.areaName
    else
        InfCore.Log("GetQuestAreaName "..questName.." areaName is nil")
        return nil
    end
end

--Use current location quests only
function this.IsQuestInCurrentLocation(questName)
    local sideOpInfo = TppQuest.GetSideOpsInfo(questName)
    if sideOpInfo then
        if sideOpInfo.locationId==vars.locationCode then
            return true
        end
    end
    return false
end

return this