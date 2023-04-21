-- InfNPCPaz.lua --
local this={}



this.packages={

"/Assets/tpp/pack/mission2/common/mis_com_fob_hostage.fpk",

--
  -- "/Assets/tpp/pack/mission2/free/f30050/f30050_d8010.fpk",
--  "/Assets/tpp/pack/mission2/free/f30050/f30050_paz.fpk",
--  "/Assets/tpp/pack/mission2/ih/ih_paz.fpk"
}

local pazLocator="TppPazLocator000"--"mtbs_uq0040_plnt0000|uq_00400000|uq_0040_asset|TppPazLocator"

function this.TestPaz()
  local SendCommand=GameObject.SendCommand
  local GetGameObjectId=GameObject.GetGameObjectId
  local NULL_ID=GameObject.NULL_ID
  
  function this.Warp(position,rotationY)
    local paz=GetGameObjectId(pazLocator)
    GameObject.SendCommand(paz,{id="Warp",position=position,rotationY=rotationY})
  end
    local command = { id="SetEnabled", enabled=true }
    GameObject.SendCommand( paz, command )

  local playerPos=Vector3(vars.playerPosX,vars.playerPosY,vars.playerPosZ)
  local rotationY=0
  this.Warp(playerPos,rotationY)
end

function this.AddMissionPacks(missionCode,packPaths)
  if not Ivars.mbEnablePaz:EnabledForMission(missionCode) then
    return
  end

  if InfMain.IsMbEvent() then
    return
  end

  for i,packPath in ipairs(this.packages) do
    packPaths[#packPaths+1]=packPath
  end
  
  --
        local settings={
        {type="hostage",name="hos_o50050_event5_0000",faceId=621,bodyId=143},
        {type="hostage",name="hos_o50050_event5_0001",faceId=640,bodyId=143},
        {type="hostage",name="hos_o50050_event5_0002",faceId=641,bodyId=143},
        {type="hostage",name="hos_o50050_event5_0003",faceId=646,bodyId=143}
      }
      TppEneFova.AddUniqueSettingPackage(settings)
end

return this
