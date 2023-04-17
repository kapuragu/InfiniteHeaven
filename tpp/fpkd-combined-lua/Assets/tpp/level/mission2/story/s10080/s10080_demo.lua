local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table




this.demoList = {
	Demo_InAfrica 						= "p41_030005_000_final",	
	Demo_ArrivalInAfrica 				= "p41_030010_000_final",	
	Demo_TeachChild						= "p41_030030_000_final",	
	Demo_DeadBody						= "p41_030040_000_final",	
	Demo_Reinforcement					= "p41_030050_000_final",	
}



this.demoBlockList = {
	Demo_ArrivalInAfrica	 		= { "/Assets/tpp/pack/mission2/story/s10080/s10080_d01.fpk" },
	Demo_TeachChild				 	= { "/Assets/tpp/pack/mission2/story/s10080/s10080_d02.fpk" },
	Demo_Reinforcement				= { "/Assets/tpp/pack/mission2/story/s10080/s10080_d03.fpk" },
}




this.InAfrica = function(endfunc,skipfunc)
	local exceptGameStatus = Tpp.GetHelicopterStartExceptGameStatus()
	TppDemo.Play(
		"Demo_InAfrica",
		{
			onEnd 	= function() endfunc() end, 
			onSkip 	= function() skipfunc() end,
		},
		{
			useDemoBlock = true,
			startNoFadeIn = true,
			exceptGameStatus = exceptGameStatus,
			isSnakeOnly = false,
		}
	)
	
end


this.ArrivalInAfrica = function(func)
	TppDemo.Play("Demo_ArrivalInAfrica",{ onEnd = function() func() end,} , {
                        useDemoBlock = true,isSnakeOnly = false,})
end


this.TeachChild = function(func)
	TppDemo.Play("Demo_TeachChild",{ onEnd = function() func() end,} , {
                        useDemoBlock = true,
						isInGame = true,
						isSnakeOnly = false, })
end


this.DeadBody = function(func)
	TppDemo.Play("Demo_DeadBody",
		{ onEnd = function() func() end,},
		{ useDemoBlock = true, waitTextureLoadOnDemoEnd = true, isSnakeOnly = false,}
	)
end


this.Reinforcement = function(func)
	TppDemo.Play("Demo_Reinforcement",{ 
						onStart = function()
							
							TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "DemoPlayendFadeIn", scdDemoID )--RETAILBUG: scdDemoID undefined
						end,
						onEnd = function() func() end,
						} ,
						{
						useDemoBlock = true,
						startNoFadeIn = true,
						isSnakeOnly = false,
						})
end




return this
