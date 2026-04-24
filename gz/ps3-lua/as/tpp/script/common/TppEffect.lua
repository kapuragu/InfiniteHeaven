local this = {}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Create effect
this.CreateEffect = function( effectInstanceName, options )
	Fox.Log( "TppEffect : [CreateEffect] function called!" )
	options = options or {}

	if ( options.useGroup == true ) then
		TppDataUtility.CreateEffectFromGroupId( effectInstanceName )
	else
		TppDataUtility.CreateEffectFromId( effectInstanceName )
	end
end

-- Show effect
this.ShowEffect = function( effectInstanceName, options )
	Fox.Log( "TppEffect : [ShowEffect] function called!" )
	options = options or {}

	this._SetVisible( effectInstanceName, options.useGroup, true )
end

-- Hide effect
this.HideEffect = function( effectInstanceName, options )
	Fox.Log( "TppEffect : [HideEffect] function called!" )
	options = options or {}

	this._SetVisible( effectInstanceName, options.useGroup, false )
end

-- Enable area fog
this.EnableAreaFog = function( dataName )
	Fox.Log( "TppEffect : [EnableAreaFog] function called!" )
	
	this._SetEnableAreaFog( dataName, true )
end

-- Disable area fog
this.DisableAreaFog = function( dataName )
	Fox.Log( "TppEffect : [DisableAreaFog] function called!" )
	
	this._SetEnableAreaFog( dataName, false )
end

---------------------------------------------------------------------------------
-- Internal Functions
---------------------------------------------------------------------------------

-- Enable damage filter
this.EnableDamageFilter = function()
	TppEffectUtility.SetDamageBurnFilterVisibility( true )
end

-- Disable damage filter
this.DisableDamageFilter = function()
	TppEffectUtility.SetDamageBurnFilterVisibility( false )
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

this._SetVisible = function( effectInstanceName, useGroup, visible )
	if ( useGroup == true ) then
		TppDataUtility.SetVisibleEffectFromGroupId( effectInstanceName, visible )
	else
		TppDataUtility.SetVisibleEffectFromId( effectInstanceName, visible )
	end
end

this._SetEnableAreaFog = function( dataName, enable )
	TppVolumetricFogManager:SetEnableAreaFog( dataName, enable )
end

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this