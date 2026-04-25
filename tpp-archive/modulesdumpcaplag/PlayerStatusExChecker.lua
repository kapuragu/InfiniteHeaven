local this={}

this.CheckCrawlRolling=function()
	if PlayerInfo.AndCheckStatus{PlayerStatusEx.CRAWL,PlayerStatusEx.RUN,PlayerStatusEx.GUN_READY} then
		return true
	end
	return false
end

this.On=function()
	InfCore.Log"crawlrolling_on"
	this.isCrawlrolling=true
end

this.Off=function()
	InfCore.Log"crawlrolling_off"
	this.isCrawlrolling=false
end

function this.Update()
	if this.CheckCrawlRolling() then
		if not this.isCrawlrolling then
			this.On()
		end
	else
		if this.isCrawlrolling then
			this.Off()
		end
	end
end

return this