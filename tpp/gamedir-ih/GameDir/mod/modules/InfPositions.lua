--InfPositions.lua
--Commands to manage positions list used for other commands as well as saving and loading from file.
--Search for this.positions in this file or InfPositions.positions in others for uses of the positions list

local this={}

--STATE
this.positions={
--REF {x,y,z,yaw}--yaw currently unused
}
function this.PostModuleReload(prevModule)
  this.positions=prevModule.positions
end--

local fileName="positions_list.txt"

this.registerMenus={
  'positionsMenu',
}

this.positionsMenu={
  parentRefs={"InfMenuDefs.objectListsMenu"},
  options={
    "InfPositions.AddPosition",
    "InfPositions.AddMarkerPositions",    
    "InfPositions.ClearPositions",
    "InfPositions.WritePositions",
    "InfPositions.LoadPositions",
    "Ivars.selectListPosition",
  },
}
--< menu defs
this.langStrings={
  eng={
    positionsMenu="Positions menu",
    addPosition="Add current position to Positions List",
    addMarkerPositions="Add markers to Positions List",
    writePositions="Write Positions List",
    clearPositions="Clear Positions List",
    loadPositions="Load positions from file",
    selectListPosition="Select position",
  },
  help={
    eng={
      positionsMenu="For adding positions in the game to a Positions List, and writing/loading them to files.",
      addPosition="Add current player or freecam position to Positions List, positions list can be written to file with Write Positons List command.",
      addMarkerPositions="Adds current user markers to positions list, positions list can be written to file with Write Positons List command.",
      writePositions="Writes Positions List to files in MGS_TPP\\mod\\",
      clearPositions="Clears Positions List",
      loadPositions="Loads positions from MGS_TPP\\mod\\positions.txt",
      selectListPosition="Selects a position from positions list, mostly just used to browse positions at the moment.",--DEBUGNOW
    },
  },
}
--<

this.registerIvars={
  "selectListPosition",
}

this.selectListPosition={
  inMission=true,
  settings={},--DYNAMIC
  GetSettingText=function(self,setting)
    if #self.settings==0 then
      return InfLangProc.LangString"list_empty"
    end
    local position=self.settings[setting+1]

    return string.format("x=%.3f,y=%.3f,z=%.3f",position[1],position[2],position[3])
  end,
  OnSelect=function(self)
    IvarProc.SetSettings(self,this.positions)
  end,
}

--Commands
--tex adds player or camera position (if freecam) to this.positions
function this.AddPosition()
  local offsetY=0
  if Ivars.adjustCameraUpdate:Is(0) then--tex freecam not on
    offsetY=-0.783
    if PlayerInfo.OrCheckStatus{PlayerStatus.CRAWL} then
      offsetY = offsetY + 0.45
    end
  end

  local position={vars.playerPosX, vars.playerPosY+offsetY, vars.playerPosZ, vars.playerCameraRotation[1]}
  table.insert(this.positions,position)
  InfCore.Log(#this.positions..[[ positions in list]],true,true)
end

--tex adds current user marker positions to InfPositions.positions
function this.AddMarkerPositions()
  if vars.userMarkerSaveCount==0 then
    InfMenu.PrintLangId"no_marker_found"
    return
  end

  local addedCount=0
  for index=0,vars.userMarkerSaveCount-1 do
    local markerPos=InfUserMarker.GetMarkerPosition(index)
    addedCount=addedCount+1
    table.insert(this.positions,markerPos)
  end

  local addedString = addedCount.." positions added to list"
  local sizeString = "list now has "..#this.positions.." positions"
  InfCore.Log("InfPositions:AddPositions: "..addedString)
  InfCore.DebugPrint(addedString)
  InfCore.Log("InfPositions:AddPositions: "..sizeString)
  InfCore.DebugPrint(sizeString)
end

function this.ClearPositions()
  --tex clear rather than new since othe ivars operate on this and dont want to break their references
  InfUtil.ClearArray(this.positions)
end

function this.WritePositions()
  InfCore.Log("InfPositions.WritePositions:")

  local writeTypes={
    positions_plain={fmt='%.3f,%.3f,%.3f,%3f,'},
    positions_lua={
      header='local positions={',
      fmt='{pos={%.3f,%.3f,%.3f},rotY=%.3f,},',
      footer='} return positions',
    },
    positions_xml={fmt='<value x="%.3f" y="%.3f" z="%.3f" w="0" />'},
    positions_json={
      header='{"Positions" : [{',
      fmt='"Position": {"X": %.3f,"Y": %.3f,"Z": %.3f},',
      footer='}]}',
    },
  }

  for writeType,writeInfo in pairs(writeTypes)do
    local writeStrings={}
    writeStrings[#writeStrings+1]=writeInfo.header
    for i,position in ipairs(this.positions)do
      writeStrings[#writeStrings+1]=string.format(writeInfo.fmt,position[1],position[2],position[3],position[4] or 0)
    end
    writeStrings[#writeStrings+1]=writeInfo.footer

    local filePath=InfCore.paths.mod..writeType..".txt"
    InfCore.Log(filePath)
    InfCore.WriteStringTable(filePath,writeStrings)
  end

  InfCore.Log(#this.positions..[[ positions written to MGS_TPP\mod\]],true,true)
end

function this.LoadPositions()
  InfCore.Log("InfPositions.LoadPositions:")
--DEBUGNOW
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

  --GOTCHA: different save format (see writepositions) than positions list TODO: choose one or other
  --Currently just x,y,z,yaw, per line, yaw currently unused
  InfUtil.ClearArray(this.positions)
  for i,coords in ipairs(lines)do
    local split=InfUtil.Split(coords,",")
    this.positions[#this.positions+1]=split
  end

  InfCore.Log(#this.positions.." positions loaded from "..fileName,true,true)--ADDLANG
end

function this.AddAndWrite()
  this.AddPosition()
  this.WritePositions()
end

return this
