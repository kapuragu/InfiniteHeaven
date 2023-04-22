--InfObjects.lua
--Commands to manage gameobject name list used for other commands as well as saving and loading from file.
--TODO: also add browse lookuplist couterpart to addLookuplist with onactive to add to object list
local this={}

--STATE
this.objectNames={
  "Player",
}
function this.PostAllModulesLoad(prevModule)
  this.objectNames=prevModule.objectNames
end--PostAllModulesLoad

local fileName="objects_list.txt"

this.registerMenus={
  'objectsMenu',
}

this.objectsMenu={
  parentRefs={"InfMenuDefs.objectListsMenu"},
  options={
    "InfObjects.AddMarkerObjects",
    "InfObjects.addObjectLookupList",
    "InfObjects.ClearObjects",
    "InfObjects.WriteObjects",
    "InfObjects.LoadObjectNames",
    "Ivars.selectListObject",
  },
}
--< menu defs
this.langStrings={
  eng={
    objectsMenu="Objects menu",
    addMarkerObjects="Add marked objects to list",
    writeObjects="Write Objects List",
    loadObjectNames="Load Objects List",
    clearObjects="Clear Objects List",
    selectListObject="Browse object list",
    addObjectLookupList="Add lookup list",
  },
  help={
    eng={
      objectsMenu="For adding game object names in the game to a Objects List, and writing/loading them to files.",
      addMarkerObjects="Adds current marked game object names to objects list, objects list can be written to file with Write Objects List command.",
      writeObjects="Writes Objects List to file in MGS_TPP\\mod\\",
      loadObjectNames="Loads objects list from file in MGS_TPP\\mod\\",
      clearObjects="Clears Objects List",
      --selectListObject="Select game object name, mostly just used to browse object names list at the moment.",--DEBUGNOW
      addObjectLookupList="Lets you cycle through a number of lookup lists IH uses and add all items from it to the main object list.",
    },
  },
}
--<

this.registerIvars={
  "selectListObject",
  "addObjectLookupList",
}

this.selectListObject={
  settings=this.objectNames,--DYNAMIC
  GetSettingText=function(self,setting)
    if #self.settings==0 then
      return InfLangProc.LangString"list_empty"
    end
    local objectName=this.objectNames[setting+1]

    local gameObjectId=GameObject.GetGameObjectId(objectName)
    if gameObjectId==GameObject.NULL_ID then
      return objectName.."==NULL_ID"
    end

    return objectName
  end,
  OnSelect=function(self)
    IvarProc.SetSettings(self,this.objectNames)
  end,
}

this.addObjectLookupList={
  settings={"empty"},--DYNAMIC
  settingNamesDoc="<lookup list names>",
  GetSettingText=function(self,setting)
    local listName=InfLookup.objectNameListsEnum[setting+1]
    if listName==nil then
      return InfLangProc.LangString"list_empty"
    end

    return listName
  end,
  Init=function(self)
    IvarProc.SetSettings(self,InfLookup.objectNameListsEnum)
  end,
  OnSelect=function(self)
    IvarProc.SetSettings(self,InfLookup.objectNameListsEnum)
  end,
  OnActivate=function(self,setting)
    local listName=InfLookup.objectNameListsEnum[setting+1]
    if listName==nil then
      return
    end

    local list=InfLookup.objectNameLists[listName]
    if list==nil then
      InfMenu.PrintLangId"list_empty"
      return
    end

    if #list==0 then
      InfMenu.PrintLangId"list_empty"
      return
    end

    for i,objectName in ipairs(list)do
      table.insert(this.objectNames,objectName)
    end

    local addedString = #list.." objects added to list"
    local sizeString = "list now has "..#this.objectNames.." positions"
    InfCore.Log("InfObjects addLookupList: "..addedString)
    InfCore.DebugPrint(addedString)
    InfCore.Log("InfObjects addLookupList: "..sizeString)
    InfCore.DebugPrint(sizeString)
  end,
}

--Commands
function this.AddMarkerObjects()
  if vars.userMarkerSaveCount==0 then
    InfMenu.PrintLangId"no_marker_found"
    return
  end

  local addedCount=0
  for index=0,vars.userMarkerSaveCount-1 do
    local gameId=vars.userMarkerGameObjId[index]
    if gameId==GameObject.NULL_ID then
      --DEBUGNOW InfMenu.PrintLangId"soldier_not_marked"
      InfCore.Log("gameId==NULL_ID  "..gameId)--DEBUGNOW
    else

      local gameObjectName=InfLookup.ObjectNameForGameId(gameId)
      if gameObjectName==nil then
        --DEBUGNOW InfMenu.PrintLangId"soldier_not_marked"
        InfCore.Log("No name found for gameobject "..gameId,true)--DEBUGNOW
      else
        --TODO: better
        local add=true
        for i,objectName in ipairs(this.objectNames) do
          if gameObjectName==objectName then
            add=false
            break
          end
        end

        if add then
          addedCount=addedCount+1
          this.objectNames[#this.objectNames+1]=gameObjectName
        end
      end--if name not nil
    end--if not NULL_ID
  end--for markers

  local addedString = addedCount.." objects added to list"
  local sizeString = "list now has "..#this.objectNames.." positions"
  InfCore.Log("InfObjects:AddMarkerObjects: "..addedString)
  InfCore.DebugPrint(addedString)
  InfCore.Log("InfObjects:AddMarkerObjects: "..sizeString)
  InfCore.DebugPrint(sizeString)
end

function this.ClearObjects()
  InfUtil.ClearTable(this.objectNames)--tex used on ivars settings so dont new a table
  table.insert(this.objectNames,"Player")--TODO why always having player?
end

function this.WriteObjects()
  InfCore.Log("InfObjects.WriteObjects:")

  local list=this.objectNames

  local filePath=InfCore.paths.mod..fileName
  InfCore.WriteStringTable(filePath,list)

  InfCore.Log(#list..[[ entries written to MGS_TPP\mod\]]..fileName,true,true)
end
--tex UNUSED
function this.LoadObjectNames()
  InfCore.Log("InfObjects.LoadObjectNames:")

  local filePath=InfCore.paths.mod..fileName
  local lines=InfCore.GetLines(filePath)
  if lines==nil then
    InfCore.DebugPrint("Could not load "..fileName)--DEBUGNOW ADDLANG
    return
  end

  if #lines==0 then
    InfMenu.PrintLangId"list_empty"
    return
  end

  this.objectNames=lines

  InfCore.Log(#lines.." entries loaded from "..fileName,true,true)
end
--<

function this.GetObjectInfoOrPos(index)--DEBUGNOW
  local objectList=this.objectNames

  if objectList==nil then
    return nil,"objectList nil"
  end

  if #objectList==0 then
    return nil,"objectList empty"
  end

  local objectName=objectList[index]
  if objectName==nil then
    return nil,"objectName==nil for index "..index,nil
  end
  local gameId=objectName
  if type(objectName)=="string" then
    gameId=GameObject.GetGameObjectId(objectName)
  end
  if gameId==nil then
    return objectName,objectName.." nil"
  end
  if gameId==GameObject.NULL_ID then
    return objectName,objectName.." NULL_ID"
  end

  local position=GameObject.SendCommand(gameId,{id="GetPosition"})
  if position==nil then
    return objectName,objectName.." nil for GetPosition"
  end

  position={position:GetX(),position:GetY(),position:GetZ()}

  return objectName,"",position
end

function this.PostAllModulesLoad(prevModule)
  --this.ClearObjects()
end

return this
