--InfMBStaff.lua
--tex for saving mbs staffid
--TODO: VERIFY feature working
--ex
--[16368353832909]=true,
--[5.7851078131189e+015]=true,
--[5.3151040400756e+015]=true,
--SetupStaffList only finds the non e notation staffid 16368353832909
--staffid is a double or something, and the conversion/saving isnt catching?
--or is it simply GetOutOnMotherBaseStaffs doesn't return all staff on cluster? 
--(though several different loads, and a location change between gives same issue)
local this={}

this.isSaveDirty=false

this.saveName="ih_priority_staff.lua"

--tex don't lose existing on modulereload
ih_priority_staff=ih_priority_staff or {
  staffIds={}
}

--CALLER: MakeNewGameSaveData
--TODO: delete file outright
function this.ClearSave()
  --tex only bother saving if there was something in previous
  if next(ih_priority_staff.staffIds)~=nil then
    this.isSaveDirty=true
  end
  --tex clear
  ih_priority_staff={
    staffIds={}
  }
end--ClearSave

function this.BuildSaveText(saveName)
  local saveTextList={
    "-- "..saveName,
    "-- This is the list of staff ids for the staff priority on MB feature.",
    "local this={}",
  }

  IvarProc.BuildTableText("staffIds",ih_priority_staff.staffIds,saveTextList)

  saveTextList[#saveTextList+1]="return this"

  return saveTextList
end

function this.Save()
  if not this.isSaveDirty then
    return
  end

  if vars.missionCode~=30050 then
    return
  end

  InfCore.LogFlow"InfMBStaff.Save"
  local saveName=this.saveName
  local saveTextList=this.BuildSaveText(saveName)
  IvarProc.WriteSave(saveTextList,saveName)
  this.isSaveDirty=false
end
--OUT: ih_priority_staff
function this.LoadSave()
  InfCore.LogFlow"InfMBStaff.LoadSave"
  local saveName=this.saveName
  local filePath=InfCore.paths.saves..saveName
  if not InfCore.FileExists(filePath) then
    InfCore.Log(filePath.." does not exist. (File is only created if MB priority staff feature used)",false,true);
    return nil
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
  
  ih_priority_staff=ih_save

  return ih_save
end

function this.AddPlayerStaff()
  local staffIds=ih_priority_staff.staffIds
  --tex staffId will be 0 when player not DD
  --will be that of staff selected when mission joined (or rather the last actually selected through proper sortie character selection)
  --so will stay same when changing between dd male/female, and still be 0 on switching to dd if joined map as snake/avatar
  --TODO: how to make clear to user in helispace, or anywhere of this?
  --On sortie character select
  --save playerType
  --save playerStaffId
  --save faceId??
  --if playerstaffid==0
  --elseif playerType~=lastSortieSelectedPlayerType
  --print current player type different from last selected
  local staffId=Player.GetStaffIdAtInstanceIndex(0)
  --InfCore.Log("playerStaffId:"..tostring(staffId),false,true)--DEBUG

  if staffId==0 then
    InfMenu.PrintLangId"please_select_dd"
  else
    if staffIds[staffId] then
      InfMenu.PrintFormatLangId("staff_id_exists",staffId)
    else
      InfMenu.PrintFormatLangId("add_staff_id",staffId)

      staffIds[staffId]=true
    end
  end
  this.isSaveDirty=true
end

function this.RemovePlayerStaff()
  local staffIds=ih_priority_staff.staffIds

  local staffId=Player.GetStaffIdAtInstanceIndex(0)
  --InfCore.Log("playerStaffId:"..tostring(staffId),false,true)--DEBUG

  if staffId==0 then
    InfMenu.PrintLangId"please_select_dd"
  else
    if staffIds[staffId] then
      staffIds[staffId]=false
      InfMenu.PrintFormatLangId("removing_staff_id",staffId)
    else
      InfMenu.PrintFormatLangId("staff_id_not_exist",staffId)
    end
  end
  
  this.isSaveDirty=true
end

function this.AddMarkerStaff()
  if vars.missionCode~=30050 then
    InfMenu.PrintLangId"only_on_mb"
    return
  end

  local lastMarkerIndex=InfUserMarker.GetLastAddedUserMarkerIndex()
  if lastMarkerIndex==nil then
    --InfCore.DebugPrint("lastMarkerIndex==nil")
    InfMenu.PrintLangId"no_marker_found"
    return
  end

  local gameId=vars.userMarkerGameObjId[lastMarkerIndex]
  if gameId==GameObject.NULL_ID then
    InfMenu.PrintLangId"soldier_not_marked"
    return
  end

  local typeIndex=GameObject.GetTypeIndex(gameId)
  if typeIndex~=TppGameObject.GAME_OBJECT_TYPE_SOLDIER2 then
    InfMenu.PrintLangId"soldier_not_marked"
    return
  end

  local staffIds=ih_priority_staff.staffIds
  local staffId=TppMotherBaseManagement.GetStaffIdFromGameObject{gameObjectId=gameId}
  --InfCore.Log("playerStaffId:"..tostring(staffId),false,true)--DEBUG

  if staffId==0 then
  --InfCore.Log("WARNING staffId==0 ",true,true)--DEBUG
  else
    if staffIds[staffId] then
      InfMenu.PrintFormatLangId("staff_id_exists",staffId)
    else
      InfMenu.PrintFormatLangId("add_staff_id",staffId)

      staffIds[staffId]=true
    end
  end
  
  this.isSaveDirty=true
end

function this.RemoveMarkerStaff()
  if vars.missionCode~=30050 then
    InfMenu.PrintLangId"only_on_mb"
    return
  end

  local lastMarkerIndex=InfUserMarker.GetLastAddedUserMarkerIndex()
  if lastMarkerIndex==nil then
    --InfCore.DebugPrint("lastMarkerIndex==nil")
    InfMenu.PrintLangId"no_marker_found"
    return
  end

  local gameId=vars.userMarkerGameObjId[lastMarkerIndex]
  if gameId==GameObject.NULL_ID then
    InfMenu.PrintLangId"soldier_not_marked"
    return
  end

  local typeIndex=GameObject.GetTypeIndex(gameId)
  if typeIndex~=TppGameObject.GAME_OBJECT_TYPE_SOLDIER2 then
    InfMenu.PrintLangId"soldier_not_marked"
    return
  end

  local staffIds=ih_priority_staff.staffIds
  local staffId=TppMotherBaseManagement.GetStaffIdFromGameObject{gameObjectId=gameId}
  --InfCore.Log("playerStaffId:"..tostring(staffId),false,true)--DEBUG

  if staffId==0 then
  --InfCore.Log("WARNING staffId==0 ",true,true)--DEBUG
  else
    if staffIds[staffId] then
      staffIds[staffId]=false
      InfMenu.PrintFormatLangId("removing_staff_id",staffId)
    else
      InfMenu.PrintFormatLangId("staff_id_not_exist",staffId)
    end
  end
  
  this.isSaveDirty=true
end

function this.ClearPriorityStaff()
  ih_priority_staff.staffIds={}
  this.isSaveDirty=true
  InfMenu.PrintLangId"staff_clear"
end

function this.IsPriorityStaff(staffId)
  --tex trying to match direct staffList value to ih_priority_staff doesnt work due to some difference in original float value and value after is been converted to text for the save file and back.
  --UGH, but it works.
  local staffStr=tostring(staffId)
  staffId=tonumber(staffStr)

  return ih_priority_staff.staffIds[staffId]
end

this.registerMenus={
  "mbStaffMenu",
  "mbStaffInMissionMenu",
}

this.mbStaffMenu={
  options={
    "InfMBStaff.AddPlayerStaff",
    "InfMBStaff.RemovePlayerStaff",
    "InfMBStaff.ClearPriorityStaff",
    "Ivars.mbPrioritizeFemale",
    "Ivars.mbMoraleBoosts",
    "Ivars.mbIncreaseStaffSaluteReactions",
  }
}

this.mbStaffInMissionMenu={
  parentRefs={"InfMenuDefs.inMissionMenu"},
  options={
    "InfMBStaff.AddPlayerStaff",
    "InfMBStaff.RemovePlayerStaff",
    "InfMBStaff.AddMarkerStaff",
    "InfMBStaff.RemoveMarkerStaff",
    "InfMBStaff.ClearPriorityStaff",
    --"Ivars.mbIncreaseStaffSaluteReactions",--tex TODO if in mission then apply IfMBVisit.SetSaluteVoiceList, only if convos can be added in-mission too, and any are worth adding
  }
}
--<
this.langStrings={
  eng={
    mbStaffMenu="Staff menu",
    mbStaffInMissionMenu="Staff menu",
    addPlayerStaff="Add player staff to MB priority",
    removePlayerStaff="Remove player staff to MB priority",
    addMarkerStaff="Add marked staff to MB priority",
    removeMarkerStaff="Remove marked staff from MB priority",
    clearPriorityStaff="Clear MB staff priority list",
    please_select_dd="Player staff id is 0, please select a DD character from sortie character selection",
    staff_id_not_exist="Staff id %s was not in priority staff list",
    staff_id_exists="Staff id %s was already in priority staff list",
    add_staff_id="Adding staff id %s to priority on MB",
    removing_staff_id="Removing staff id %s from priority on MB",
    staff_clear="Priority staff cleared",
    only_on_mb="This command can only be used on MB",
    soldier_not_marked="No marked soldier found",
    mbIncreaseStaffSaluteReactions="Add more salute reactions",
  },
  help={
    eng={
      addPlayerStaff="Add the last sortie selected DD member to the Mother Base priority staff list to have them appear on MB",
      removePlayerStaff="Removes the last sortie selected DD member to the Mother Base priority staff list",
      addMarkerStaff="Adds the most recently marked staff member to the MB priority list",
      removeMarkerStaff="Removes the most recently marked staff member from the MB priority list",
      clearPriorityStaff="Clears MB staff priority list entirely",
      mbIncreaseStaffSaluteReactions="Adds additional reactions from MB staff when they salute you.",
    },
  },
}--langStrings

return this
