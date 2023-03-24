
IH feature quest support for location addons

Bug: No sideop location tab for anything but the vanilla locs + All
Bug: Cannot select sideop from idroid list to travel to that sideop location.
Bug: the sideop started message stuff not showing

Needs quest_enemy.fox2 in mission fpkd
Can copy vanilla file, for example. No need to edit it.
\Assets\tpp\pack\mission2\free\f30010\f30010_fpkd
	\Assets\tpp\level\mission2\quest\common\quest_enemy.fox2

Needs a quest_block ScriptBlockData 
Example in:
\Assets\tpp\pack\mission2\free\f30020\f30020_fpkd
	\Assets\tpp\level\mission2\free\f30020\f30020_sequence.fox2


<mission script>_enemy.lua soldierdefine needs the quest_cp enemies (caplag has already done this for gntn)
this.soldierDefine = {
	...
	quest_cp = {
		"sol_quest_0000",
		"sol_quest_0001",
		"sol_quest_0002",
		"sol_quest_0003",
		"sol_quest_0004",
		"sol_quest_0005",
		"sol_quest_0006",
		"sol_quest_0007",
	},
}

locationInfo needs questAreas entry
Just a single area I centered on the playable area
Example in the GNTN locationInfo:
  --tex defines quest areas for location, see TppQuestList.questList
  questAreas={
    {
      areaName="prison",--tex small location so just one area. good enough name? (if you change it then update your gntn example sideop) 
      --xMin,yMin,xMax,yMax, in smallblock coords. see Tpp.CheckBlockArea      
      loadArea={106,104,110,107},
      activeArea={107,105,109,106},
      invokeArea={107,105,109,106},
    },
  },--questAreas
  