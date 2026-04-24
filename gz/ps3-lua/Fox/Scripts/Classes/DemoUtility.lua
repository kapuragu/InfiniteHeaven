--------------------------------------------------------------------------------
--! @file	DemoUtility.lua
--! @brief	Demo 関連のユーティリティ Lua 関数群
--------------------------------------------------------------------------------

DemoUtility = {


--------------------------------------------------------------------------------
-- public
--------------------------------------------------------------------------------
----------------------------------------
--! @brief エディタから DataBody を取得
--! @param className
--! @return
----------------------------------------
GetDataBodyFromEditor = function( className )

	return DemoUtility.SearchDataBodies( className, false )

end, -- GetDataBodyFromEditor = function()

----------------------------------------
--! @brief エディタから DataBody リストを取得
--! @param className
--! @return
----------------------------------------
GetDataBodiesFromEditor = function( className )

	return DemoUtility.SearchDataBodies( className, true )

end, -- GetDataBodiesFromEditor = function()

--------------------------------------------------------------------------------
-- private
--------------------------------------------------------------------------------
----------------------------------------
--! @brief DataBody を検索
--! @param className
--! @param all
--! @return
----------------------------------------
SearchDataBodies = function( className, all )

	local app = Application.GetInstance()
	local game = app:GetMainGame()

	if not game:IsKindOf( Editor ) then
		return nil
	end
	local editor = game

	local bodies = {}

	local buckets = editor:GetEditableBucketList()
	for bucketName, bucket in pairs( buckets ) do

		local bodySet = bucket:GetEditableDataBodySet()
		local bodyList = bodySet:GetDataBodyList()
		for dataName, body in pairs( bodyList ) do

			if className == body:GetClassName() then
				if not all then
					return body
				end
				table.insert( bodies, body )
			end
		end
	end

	return all and bodies or nil

end, -- SearchDataBodies = function()


} -- DemoUtility
