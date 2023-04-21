-- IHDebugFova.lua
-- tex for testing fv2s applied to player
local this={}

this.fv2Table={
  "/Assets/tpp/fova/chara/sna/sna0_main1_v00.fv2",
  "/Assets/tpp/fova/chara/sna/sna0_main1_v01.fv2",
  "/Assets/tpp/fova/chara/sna/sna0_main1_v02.fv2",
}

this.packages={
  "/Assets/tpp/pack/player/parts/plparts_normal_scarf_test.fpk",
}

this.registerIvars={
  "fova_selectFromTable",
}

this.fova_selectFromTable={
  inMission=true,
  settings=this.fv2Table,
  OnActivate=function(self,setting)
    local fv2Path=self.settings[setting+1]
    InfCore.Log("fova_selectFromTable: Applying "..fv2Path,false,true)
    Player.ApplyFormVariationWithFile(fv2Path)
  end,
}

this.registerMenus={
  "debugFovaMenu",
}

this.debugFovaMenu={
  parentRefs={"InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.fova_selectFromTable",
  }
}

function this.AddMissionPacks(missionCode,packPaths)
  if missionCode < 5 then
     return
  end

  for i,packPath in ipairs(this.packages) do
    packPaths[#packPaths+1]=packPath
  end
end

return this
