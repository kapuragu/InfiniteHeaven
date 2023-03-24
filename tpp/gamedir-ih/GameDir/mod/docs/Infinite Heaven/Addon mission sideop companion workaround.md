Building Sideops Companion sidops for freeroam addon missions that support quests:
Set up a sideop, giving proper positions in the map, ditto the icon pos.
Set:
Quest Map to Afgh
Quest Area to whatever the top one is.
Quest CP: to anything but NONE
Do all the rest normaly, hit build.
Open SOC folder \Sideop_Build\GameDir\mod\quests\ <questInfo> lua

Change locationId to whatever matches the location:
	look in mgs_tpp\mod\locations at the locationInfo luas (of location addons you have installed) for the locationId
	or use the more friendlier TppDefine.LOCATION_ID.<locationName> ex. TppDefine.LOCATION_ID.GNTN
Change areaName to an area defined in the locationInfo questAreas for the same location
in this case areaName = "gntn",

GOTCHA: you will have to repeat this if you use SOC Build again as it will overwrite the questInfo.

Example sideop so you can see the questInfo directly (after installing it, see in mod\quests), or just unzip the .mgsv)
 and the updated example quest https://mega.nz/file/XI1GXBiY#7SWyMurdNXIXTJgoZvLYhFnPQKgr3Ef6WvMCTuIHtsQ