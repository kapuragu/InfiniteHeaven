local this = {}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Show static model
this.Show = function( staticModelData )
	if( this._IsStaticModel( staticModelData ) == false ) then return end
	staticModelData.isVisible = true
	staticModelData.isGeomActive = true
end

-- Hide static model
this.Hide = function( staticModelData )
	if( this._IsStaticModel( staticModelData ) == false ) then return end
	staticModelData.isVisible = false
	staticModelData.isGeomActive = false
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

this._IsStaticModel = function( staticModelData )
	if( staticModelData == nil or staticModelData == Entity.Null() ) then
		Fox.Error( "Cannot execute! [staticModelData] does not exist!" )
		return false
	elseif( staticModelData:IsKindOf( "StaticModelBody" ) == false ) then
		Fox.Error( "Cannot execute! [" .. tostring( staticModelData ) .. "] is not a StaticModel!" )
		return false
	end
	return true
end

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this