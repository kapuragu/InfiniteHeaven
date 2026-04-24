local this = {}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Get message argument
this.GetArgument = function( argNum )
	TppCommon.DeprecatedFunction( "TppEventSequenceManagerCollector.GetMessageArg( argNum - 1 )" )
	if( argNum < 1 or argNum > 4 ) then
		Fox.Error( "Cannot execute! Argument does not exist!" )
		return nil
	end
	return TppEventSequenceManagerCollector.GetMessageArg( argNum - 1 )
end

-- Get a piece of data
this.GetData = function( dataName, type )
	TppCommon.DeprecatedFunction( "manager:GetDataBodyFromEntityLink( dataName )" )
	type = type or "mission"
	return TppSequence.GetData( dataName, type )
end

-- Get data's position
this.GetPosition = function( dataName )
	TppCommon.DeprecatedFunction( "data:GetWorldTransform().translation" )
	local data = this.GetData( dataName )
	if( data == nil ) then return end

	if( data.data:IsKindOf( "TransformData" ) == false ) then
		Fox.Error( "Cannot execute! [" .. tostring( dataName ) .. "] is not a transform data!" )
		return nil
	end
	return data:GetWorldTransform().translation
end

-- Get data's rotation
this.GetRotation = function( dataName )
	TppCommon.DeprecatedFunction( "data:GetWorldTransform().rotQuat" )
	local data = this.GetData( dataName )
	if( data == nil ) then return end

	if( data.data:IsKindOf( "TransformData" ) == false ) then
		Fox.Error( "Cannot execute! [" .. tostring( dataName ) .. "] is not a transform data!" )
		return nil
	end
	return data:GetWorldTransform().rotQuat
end

-- Enable character
this.Enable = function( characterID )
	TppCommon.DeprecatedFunction( "TppCharacterUtility.SetEnableCharacterId( characterID, true )" )
	TppCharacterUtility.SetEnableCharacterId( characterID, true )
end

-- Disable character
this.Disable = function( characterID )
	TppCommon.DeprecatedFunction( "TppCharacterUtility.SetEnableCharacterId( characterID, false )" )
	TppCharacterUtility.SetEnableCharacterId( characterID, false )
end

-- Show static model
this.ShowModel = function( dataName )
	TppCommon.DeprecatedFunction( "TppStaticModel.Show( staticModelData )" )
	this._DoModel( dataName, true )
end

-- Hide static model
this.HideModel = function( dataName )
	TppCommon.DeprecatedFunction( "TppStaticModel.Hide( staticModelData )" )
	this._DoModel( dataName, false )
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

this._DoModel = function( dataName, isDo )
	local data = this.GetData( dataName )
	if( data == nil ) then return end

	if( data.data:IsKindOf( "StaticModel" ) == false ) then
		Fox.Error( "Cannot execute! [" .. dataName .. "] is not a StaticModel!" )
		return
	end

	data.isVisible = isDo
	data.isGeomActive = isDo
end

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this