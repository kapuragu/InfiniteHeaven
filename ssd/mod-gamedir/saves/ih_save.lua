-- ih_save.lua
-- Save file for IH options
-- While this file is editable, editing an inMission save is likely to cause issues, and it's preferable that you use InfProfiles.lua instead.
-- See Readme for more info
local this={}
this.ihVer=7
this.saveTime=1534804670
this.inMission=false
this.loadToACC=false
this.evars={
	avatar_enableGenderSelect=1,
	speedCamPlayerTimeScale=1.3,
	disableGameOver=1,
	debugFlow=1,
	disableCommonRadio=1,
	disableOutOfBoundsChecks=1,
	dust_requireOxygenMask=0,
	debugMode=1,
	gear_Inner=8,
	gear_Helmet=29,
	enableHelp=1,
	dust_wallVisible=0,
	demo_playList=6,
	enableQuickMenu=1,
	gear_Arm=11,
	speedCamContinueTime=1000,
	dust_forceWeather=3,
	debugMessages=1,
	debugOnUpdate=1,
	enableIHExt=1,
	speedCamWorldTimeScale=0.2,
}
this.igvars={
	mis_isGroundStart=false,
	inf_event=false,
	name=IvarsPersist,
	inf_levelSeed=1,
}
return this