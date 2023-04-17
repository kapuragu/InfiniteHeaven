local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table








this.demoList = {
	test = test--RETAILBUG: test undefined
}














this.PlayOpeningDemo = function(func)
	Fox.Log("#### s10043_demo.PlayOpeningDemo ####")
	TppDemo.PlayOpening(
		{ onEnd = function() func() end,},
		{ useDemoBlock = true }
	)
end





return this
