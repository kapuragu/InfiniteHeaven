--InfHero.lua
--Ivars and commands in this module are in playerSettingsMenu
--TODO: there's a couple of calls to SetHeroicPoint directly (for mission clear and abort), and SetOgrePoint that I'm missing by only modding SetAndAnnounceHeroicOgrePoint
local this={}

this.pointTableMod={}--tex OPT

function this.PostModuleReload(prevModule)
  this.pointTableMod=prevModule.pointTableMod
end--PostModuleReload

--CALLER: TppHero.SetAndAnnounceHeroicOgrePoint

function this.ModHeroicPoint(pointTable)
  if InfMain.IsOnlineMission(vars.missionCode) then
    return pointTable
  end
  --tex should only happen in fob, but log anyway to see if I'm missing anything
  if type(pointTable.heroicPoint)=="string" then
    InfCore.Log("WARNING InfHero.ModHeroicPoint heroicPoint==string")
    return pointTable
  end
  if type(pointTable.ogrePoint)=="string" then
    InfCore.Log("WARNING InfHero.ModHeroicPoint ogrePoint==string")
    return pointTable
  end

  if this.debugModule then
    InfCore.PrintInspect(pointTable,"SetAndAnnounceHeroicOgrePoint pointTable")
  end
  --tex> dont want to change any actual table passed by ref
  this.pointTableMod.heroicPoint=pointTable.heroicPoint or 0
  this.pointTableMod.ogrePoint=pointTable.ogrePoint or 0
  if this.pointTableMod.heroicPoint<0 and Ivars.hero_dontSubtractHeroPoints:Is(1)then
    this.pointTableMod.heroicPoint=0
  end
  if this.pointTableMod.ogrePoint>0 and Ivars.hero_dontAddOgrePoints:Is(1)then
    this.pointTableMod.ogrePoint=0
  end
  if this.pointTableMod.heroicPoint>0 and Ivars.hero_heroPointsSubstractOgrePoints:Is(1)then
    this.pointTableMod.ogrePoint=-this.pointTableMod.heroicPoint
  end

  if this.debugModule then
    InfCore.PrintInspect(this.pointTableMod,"SetAndAnnounceHeroicOgrePoint pointTableMod")
  end
  return this.pointTableMod
end--ModHeroicPoint

this.registerIvars={
  "hero_dontSubtractHeroPoints",  
  "hero_dontAddOgrePoints",
  "hero_heroPointsSubstractOgrePoints",
}--registerIvars

this.hero_dontSubtractHeroPoints={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.hero_dontAddOgrePoints={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.hero_heroPointsSubstractOgrePoints={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.ogrePointChange=90000
--tex see https://www.gamefaqs.com/boards/718564-metal-gear-solid-v-the-phantom-pain/72466130 for breakdown of the demon points levels.
this.SetDemon=function()
  --tex why aren't I using this again? not usable in tpp release build?
  --TppMotherBaseManagement.SetOgrePoint{ogrePoint=99999999}

  TppHero.SetOgrePoint(this.ogrePointChange)
  InfMenu.Print("-"..this.ogrePointChange .. InfLangProc.LangString"set_demon")
end
this.RemoveDemon=function()
  --TppMotherBaseManagement.SetOgrePoint{ogrePoint=1}
  --TppMotherBaseManagement.SubOgrePoint{ogrePoint=-999999999}
  TppHero.SetOgrePoint(-this.ogrePointChange)
  InfMenu.Print(this.ogrePointChange .. InfLangProc.LangString"removed_demon")
end

this.langStrings={
  eng={
    ogrePointChange="Set demon snake",
    ogrePointChangeSettings={"Default","Normal","Demon"},
    setDemon="Add demon points",
    set_demon=" demon points subtracted, visual will refresh on mission start or retry command.",
    removeDemon="Subtract demon points",
    removed_demon=" demon points subtracted, visual should refresh on mission start or retry command.",
    hero_dontSubtractHeroPoints="Don't subtract hero points",  
    hero_dontAddOgrePoints="Don't add demon points",
    hero_heroPointsSubstractOgrePoints="Hero points subtract demon points",
  },
  help={
    eng={
      setDemon="Adds 999999 points to demon score",--SYNC
      removeDemon="Subtracts 999999 points from demon score",--SYNC
      hero_dontSubtractHeroPoints="Actions that usually subtract hero points don't.",  
      hero_dontAddOgrePoints="Actions that usually add demon points don't.",
      hero_heroPointsSubstractOgrePoints="Actions that add hero points subtract the same amount of demon points",
    },
  },
}--langStrings

return this