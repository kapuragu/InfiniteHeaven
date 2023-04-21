-- InfUAV.lua
--DEBUGWIP --DEBUGNOW
local this={}

local SendCommand=GameObject.SendCommand

this.packages={
 -- "/Assets/tpp/pack/mission2/ih/ih_uav.fpk",--DEBUGWIP
 -- "/Assets/tpp/pack/mission2/ih/ih_uav_ly013_set.fpk",--DEBUGWIP

 -- "/Assets/tpp/pack/mission2/ih/o50050_area.fpk",--DEBUGWIP
 -- "/Assets/tpp/pack/mission2/ih/o50050_area_ly013_cl00.fpk",--DEBUGWIP
}

function this.AddMissionPacks(missionCode,packPaths)
  local missions={
    [30010]=true,
    [30020]=true,
    [30050]=true,
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
    local route=""
    --route="rt_heli_quest_0000"--"rt_hltx_ly003_cl00"
    --route="ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_d_0000"
    --route="ly003_cl00_route0000|cl00pl0_mb_fndt_plnt_free|rt_free_h_0000"
    --route="ly013_cl00_uav0000|cl00pl0_uq_0000_uav|rt_ptl_0000"
    --route="rt_hltx_ly003_cl00"
    --route="lz_pfCamp_S0000|lz_pfCamp_S_0000_hover"
    --route="rt_hover_1"
    --route="rt_uav_0a"
    --route="rt_uav_0b"
    route="aaa_someroute"
    --route="rt_uav_0b"
    --route="zzz_someroute"
    --route="rt_quest_d_0000"
    --route="rt_uav_1"
    route="rt_quest_uav_0000"
    local developLevel=0
    developLevel=TppUav.DEVELOP_LEVEL_LMG_2

    SendCommand( gameId, {id = "SetEnabled", enabled = true } )
    SendCommand( gameId, {id = "SetPatrolRoute", route=route } )
    SendCommand( gameId, {id = "SetCombatRoute", route=route } )
    --local cp=mtbs_enemy.cpNameDefine
    --local cp="mafr_pfCamp_cp"
    local cp="quest_cp"
    SendCommand( gameId, {id = "SetCommandPost", cp=cp } )--tex wont init without valid set
    SendCommand( gameId, {id = "WarpToNearestPatrolRouteNode"} )
    SendCommand( gameId, {id = "SetDevelopLevel", developLevel = developLevel } )
  end

end

return this
