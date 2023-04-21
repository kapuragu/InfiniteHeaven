
--local blockName="quest_block"--tex 
local blockName="reinforce_block"--tex 
local questName="pfCamp_q10200"--tex 
local packPath="/Assets/tpp/pack/mission2/quest/mafr/pfCamp/pfCamp_q10200.fpk"--
--local packPath="/Assets/tpp/pack/soldier/reinforce/reinforce_veh_west_wav_a.fpk"
--local packPath="/Assets/tpp/pack/soldier/reinforce/reinforce_veh_west_wav_b.fpk"
--local packPath="/Assets/tpp/pack/soldier/reinforce/reinforce_veh_west_wav_c.fpk"
--local packPath="/Assets/tpp/pack/soldier/reinforce/reinforce_veh_west_wav_can_a.fpk"
 --   local packPath="/Assets/tpp/pack/soldier/reinforce/reinforce_veh_west_wav_can_b.fpk"
--local packPath="/Assets/tpp/pack/soldier/reinforce/reinforce_veh_west_wav_can_c.fpk"
function this.GetQuestBlockState()
  local blockId=ScriptBlock.GetScriptBlockId(blockName)
  if blockId==ScriptBlock.SCRIPT_BLOCK_ID_INVALID then
    return
  end
  return ScriptBlock.GetScriptBlockState(blockId)
end
function this.OnMissionCanStart()




  local blockState=this.GetQuestBlockState()
  if blockState==nil then
    InfCore.DebugPrint"no blockstate"--DEBUG
    return
  end
  
  
  local blockId=ScriptBlock.GetScriptBlockId(blockName)
  if blockId==ScriptBlock.SCRIPT_BLOCK_ID_INVALID then
    return
  end
  
  --local loaded=TppScriptBlock.Load(blockName,questName)
  ScriptBlock.Load(blockId,packPath)
end

function this.OnMissionGameStart(n)

--TppScriptBlock.Load(blockName,"pfCamp_q10200")
  local blockId=ScriptBlock.GetScriptBlockId(blockName)
  TppScriptBlock.ActivateScriptBlockState(blockId)
end
