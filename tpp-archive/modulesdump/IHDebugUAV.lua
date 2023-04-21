-- InfUAV.lua
--DEBUGWIP --DEBUGNOW
local this={}

local SendCommand=GameObject.SendCommand

this.packages={
  "/Assets/tpp/pack/mission2/ih/ih_uav.fpk",--DEBUGWIP
  "/Assets/tpp/pack/mission2/ih/ih_uav_ly013_set.fpk",--DEBUGWIP
  "/Assets/tpp/pack/mission2/ih/ih_uav_testroute.fpk",
-- "/Assets/tpp/pack/mission2/ih/o50050_area.fpk",--DEBUGWIP
-- "/Assets/tpp/pack/mission2/ih/o50050_area_ly013_cl00.fpk",--DEBUGWIP
}

function this.AddMissionPacks(missionCode,packPaths)
  local missions={
    [30010]=true,
    [30020]=true,
    [30050]=true,
    [30150]=true,
    [12040]=true,
  }

  if not missions[missionCode] then--DEBUGWIP
    --  if not Ivars.enableUAVMB:EnabledForMission() then
    return
  end

  for i,packPath in ipairs(this.packages) do
    packPaths[#packPaths+1]=packPath
  end
end

--WIP
function this.SetupUAV()
  local objectName="ih_uav_0000"
  --objectName="ly013_cl00_uav0000|cl00pl0_uq_0000_uav|uav_0000"
  --objectName="ly013_cl00_uav0000|cl00pl0_mb_fndt_plnt_uav|uav_0000"
  local gameId=GameObject.GetGameObjectId(objectName)

  if gameId==GameObject.NULL_ID then
    InfCore.Log"gameId==GameObject.NULL_ID"
  else
    InfCore.Log"found uav gameobject"
    local route="rt_quest_uav_0000"
    local developLevel=0
    developLevel=TppUav.DEVELOP_LEVEL_LMG_2

    SendCommand( gameId, {id = "SetEnabled", enabled = true } )
    SendCommand( gameId, {id = "SetPatrolRoute", route=route } )
    SendCommand( gameId, {id = "SetCombatRoute", route=route } )
    --local cp=mtbs_enemy.cpNameDefine
    --local cp="mafr_pfCamp_cp"
    local cpName="quest_cp"
    local cpId=GameObject.GetGameObjectId("TppCommandPost2",cpName)
    if cpId==GameObject.NULL_ID then
      InfCore.Log(cpName.."==GameObject.NULL_ID",true)
    else
      InfCore.Log("found "..cpName,true)
    end

    SendCommand( gameId, {id = "SetCommandPost", cp=cpName } )--tex wont init without valid set
    SendCommand( gameId, {id = "WarpToNearestPatrolRouteNode"} )
    SendCommand( gameId, {id = "SetDevelopLevel", developLevel = developLevel } )
  end

end

return this
