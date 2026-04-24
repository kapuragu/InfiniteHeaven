--[[
	@file
		ストーリーフラグ
]]
gzStoryFlag = {

InitStoryFlag = function()

-- ******************************************************************************************* --
--　エクストラミッション用フラグ
-- ******************************************************************************************* --

	StoryFlags.RegisterFlag("gzProgress","start")
	StoryFlags.RegisterFlag("gzProgress","e20010Cleared")
	StoryFlags.RegisterFlag("gzProgress","e20015Cleared")

	StoryFlags.RegisterFlag("e20020Progress","notCleared")
	StoryFlags.RegisterFlag("e20020Progress","cleared")

	StoryFlags.RegisterFlag("e20030Progress","notCleared")
	StoryFlags.RegisterFlag("e20030Progress","cleared")

	StoryFlags.RegisterFlag("e20040Progress","notCleared")
	StoryFlags.RegisterFlag("e20040Progress","cleared")

	StoryFlags.RegisterFlag("e20050Progress","notCleared")
	StoryFlags.RegisterFlag("e20050Progress","cleared")

	StoryFlags.RegisterFlag("e20060Progress","notCleared")
	StoryFlags.RegisterFlag("e20060Progress","cleared")

	StoryFlags.RegisterFlag("e20070Progress","notCleared")
	StoryFlags.RegisterFlag("e20070Progress","cleared")

	StoryFlags.RegisterFlag("gzXofWappen","notCleared")
	StoryFlags.RegisterFlag("gzXofWappen","cleared")

end,


}
