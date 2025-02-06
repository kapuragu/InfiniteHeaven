local reinforce_block = {}





function reinforce_block.OnAllocate()
end

function reinforce_block.OnInitialize()
	TppReinforceBlock.ReinforceBlockOnInitialize()
end

function reinforce_block.OnUpdate()
	TppReinforceBlock.ReinforceBlockOnUpdate()
end

function reinforce_block.OnTerminate()
	TppReinforceBlock.ReinforceBlockOnTerminate()
end

return reinforce_block
