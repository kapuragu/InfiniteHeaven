--InfRouteSet.lua
--Implements routeSet randomization

--see afgh_routeSets for a commented routeset
--afgh_routesets (and mafr equivalent) is the base generic routeset that is merged with the mission routeset (if the cp has USE_COMMON_ROUTE_SETS = true)
--via TppEnemy.RegisterRouteSet, UpdateRouteSet which transforms it into the runtime data version mvars.ene_routeSets a bunch of other mvars 
--(mostly for optimization using cpIds str32ing stuff and building up enum/index lookups)

--See TppEnemy.RouteSelector, GetPrioritizedRouteTable for the function that ultimately chooses a routeset
--See ene_shiftChangeTable, TppEnemy.MakeShiftChangeTable

--The basic gist is that a routeset for a CP is number of groups of routes (for a given route type, sneak_day/night, caution etc).
--The actual list for the route type is created by working through the groups in a group priority order untill all routes are listed.

--the shift-change hold-sleep system provides variation on top of this, but doesnt seem to grab all soldiers so some routes will stay in play over multiple shifts

--simply randomising the group priority will allow a few different routes be selected, and randomize the shifts.
--randomizing within groups will give a lot more variation
--and combining both the most

--further analysis using IHDebugVars.DumpSoldierInfo
--for given routesets
--from dumping sneak/non-caution cpRoutes for soldiers of one cp periodically (every 3 hours)
--
--all soldiers switch from day/night routes (basic shifts?)
--some are assigned to sleep or hold (and/or?) shifts
--which soldiers are assigned to those shifts are decided by user mission deploy time (asap seems to just fall to either day or night)
--ex deploying day (aka after 0600) over multiple deploys gives the same routes and shifts assigned to the same soldiers.
--ditto night (aka after 1800)
--
--those with the 'basic shifts' seem run the same shedule over every in game day
--furthermore for some soldiers when deployed get their 'day' route set as a night route, and though they still change to night
--routes they'll change back to the night route during the day shift.
--What seems to be happening there is that deploy time sets their initial routes depending on the time, and their shifts just seem to be between night route and initial route.
--
--Where the proper shifts change as they should, and a subset within those even changing their routes over in-game days (but only on night deploy? ahhhh).
--
--'basic shifts' vs proper shift seems to be biased to the first soldiers in list vs later soldiers
--
--its possible the limiting factor for proper shifts is the number of hold/sleep routes
--see dump-ene_shiftChangeTable.txt (TODO add REF?)
--
--
--session change (quitting and starting game exe again), location change (changing location then returning, both quitting to acc from menu option or exiting via heli) effects no difference on the selection.

--TODO: see if just randomising shift table would

--TODO: a further - who cares how dumb it looks - randomisation mode could be just randomize all routes across all route types

--TODO: a periodic by min/max clock time var (set a clock message on mission start, randomize and recalculate next period when message hits)
--see routeset_randomizePeriodically -v-

--TODO: addAditionalRoutes (see this.routeSets), would need an additional-merge since MergeRouteSets isnt

--TODO: randomising just the (completed) shift table causes even less variation for some reason (from logging just randomizing shifts, each shift),
--still maybe worth a go at actually understanding the shift change table and (but need to figure out how soliders are assigned to both routesets and shifts)

--TODO: randomise hold/sleep times
-- these in game world minutes?
--TppDefine
--.DEFAULT_HOLD_TIME=60--mvars.ene_holdTimes[cpId]--TppEnemy.DefineSoldiers
--.DEFAULT_SLEEP_TIME=300--mvars.ene_sleepTimes[cpId]--TppEnemy.DefineSoldiers
--.DEFAULT_TRAVEL_HOLD_TIME=15--MakeTravelPlanTable cpLinkDefine

--REF shift times
--Static from TppClock lua load, but obviously chosen to have a shift change just after player uses the set deploy times
--TppClock.NIGHT_TO_DAY: 06:04:33
--TppClock.DAY_TO_NIGHT: 18:14:13
--TppClock.NIGHT_TO_MIDNIGHT: 22:00:00

--GOTCHA: randomisation is currently done on the active routeSets (mvars.ene_routeSetsDefine),
--so there's no current resetting to default, or even seed based randomisation
--(since the underlying routeSets are randomised depending on the amount of times it's been randomised, if that makes sense)
--so mission reloads will give a different randomisation



local this={}

this.registerMenus={
  "routeSetMenu",
}

this.routeSetMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.routeset_randomizeRouteSetsMISSION",
    "Ivars.routeset_randomizeRouteSetsFREE",
    "Ivars.routeset_randomizeOnShiftChange",
    "Ivars.routeset_randomizeOnPhaseChange",
    "Ivars.routeset_randomizePriority",
    "Ivars.routeset_randomizeGroups",
    "InfRouteSet.RandomizeCurrentRouteSetCmd",
  },
}--routeSetMenu

this.registerIvars={
  "routeset_randomizeOnShiftChange",
  "routeset_randomizeOnPhaseChange",
  "routeset_randomizePriority",
  "routeset_randomizeGroups",
}

IvarProc.MissionModeIvars(
  this,
  "routeset_randomizeRouteSets",
  {
    save=IvarProc.CATEGORY_EXTERNAL,
    range=Ivars.switchRange,
    settingNames="set_switch",
  },
  {"MISSION","FREE"}
)--routeset_randomizeRouteSets

this.routeset_randomizeOnShiftChange={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.routeset_randomizeOnPhaseChange={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--tex in minutes
--DEBUGNOW
--IvarProc.MinMaxIvar(
--  this,
--  "routeset_randomizePeriodically",
--  {
--    default=60,
--    OnChange=function(self,setting,prevSetting)
--      IvarProc.PushMax(self,setting,prevSetting)
--      --...
--    end,
--  },
--  {
--    default=120,
--    OnChange=function(self,setting,prevSetting)
--      IvarProc.PushMin(self,setting,prevSetting)
--      --...
--    end,
--  },
--  {
--    inMission=true,
--    range={min=1,max=1440,increment=10},
--  }
--)--MinMaxIvar routeset_randomizePeriodically

this.routeset_randomizePriority={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.routeset_randomizeGroups={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

function this.RandomizeCurrentRouteSetCmd()
  if TppMission.IsHelicopterSpace(vars.missionCode) then
    InfMenu.PrintLangId"command_for_in_mission"
    return
  end
  
  if Ivars.routeset_randomizePriority:Is(0) and Ivars.routeset_randomizeGroups:Is(0) then
    InfMenu.PrintLangId"requires_prio_or_routes"
    return
  end

  InfMenu.PrintLangId"randomizing_routeset"

  InfCore.Log("RandomizeCurrentRouteSetCmd")
  this.RandomizeCurrentRouteSet()
end--RandomizeCurrentRouteSetCmd

this.langStrings={
  eng={
    routeSetMenu="RouteSet menu",
    routeset_randomizeRouteSetsFREE="Randomize RouteSets in free roam",
    routeset_randomizeRouteSetsMISSION="Randomize RouteSets in missions",
    routeset_randomizeOnShiftChange="Randomize on shift change",
    routeset_randomizeOnPhaseChange="Randomize on phase change",
    routeset_randomizePriority="Randomize group priority",
    routeset_randomizeGroups="Randomize group routes",
    randomizeCurrentRouteSetCmd="Randomize RouteSet now",
    requires_prio_or_routes="Requires rnd group priority or rnd group routes to be enabled",
    randomizing_routeset="Randomizing Routeset",
  },
  help={
    eng={
      routeSetMenu="Options to randomize what routes soldiers use in a Command Post.",
      routeset_randomizeRouteSetsFREE="Enables all following options. Also randomizes current routeSet on mission load/reload. Requires randomize group priority or group routes to be on.",
      routeset_randomizeRouteSetsMISSION="Enables all following options. Also randomizes current routeSet on mission load/reload. WARNING: may mess up scripted mission routes.",
      routeset_randomizeOnShiftChange="Randomize current routeSet on morning and night shift changes.",
      routeset_randomizeOnPhaseChange="Randomize current routeSet when enemy phase changes in any way, Sneak, Caution, Alert, Evasion. Up or down.",
      routeset_randomizePriority="Each routeSet for a CP has a number of groups of routes, this will change the order the groups are picked from.",
      routeset_randomizeGroups="Each routeSet for a CP has a number of groups of routes, this will change the order within the group.",
      randomizeCurrentRouteSetCmd="Randomize current routeset right now. (Use the command in-mission).",
    },
  }--help
}--langStrings


--unused routes? added in a brutegen of <routeprefix>_<routeword2>_<00nn><routeword4>
--came up with routes not previously in dict (which was mostly based off lua routesets names)
--a lot of them were _sub or _searchlight variations of exising routes
--(still dont know what _sub routes are, or why routesets use a few even though a lot of routes have them)
--ane many of the routes are SwitchRouted to from other routes (might be good to be able to visualise that easier)
--but these ones are not only not referenced in routesets, dont seem to be referenced in switchroute?
this.routeSets={
  afgh={--free
    afgh_citadel_cp={
      type="additional",--ih - vs "replace" ?
      sneak_day={
        stage1st={
          "rt_citadel_d_0001",
        },
      },
      sneak_night={
        stage2nd={
          "rt_citadel_n_0004",
        },
        stage3rd={
          "rt_citadel_n_0015",
        },
        stage4th={
          "rt_citadel_n_0019",
        },
      },
      caution={
        stage1st={
          "rt_citadel_c_0006",
        },
      },
      hold={
        stage1st={
          "rt_citadel_h_0000",
          "rt_citadel_h_0001",
        },
        stage2nd={
          "rt_citadel_h_0002",
          "rt_citadel_h_0003",
          "rt_citadel_h_0004",
          "rt_citadel_h_0005",
        },
        stage3rd={
          "rt_citadel_h_0006",
          "rt_citadel_h_0007",
        },
        stage4th={
          "rt_citadel_h_0008",
          "rt_citadel_h_0009",
        },
      },
    },--afgh_citadel_cp
    afgh_cliffEast_ob={
      sneak_night={
        groupB={
          "rt_cliffEast_n_0004",
        },
      },
    },--afgh_cliffEast_ob
    afgh_cliffSouth_ob={
      priority={
        "groupC",
      },
      sneak_day={
        groupC={
          "rt_cliffSouth_d_0004",
          "rt_cliffSouth_d_0005",
        },
      },
      sneak_night={
        groupC={
          "rt_cliffSouth_n_0004",
          "rt_cliffSouth_n_0004",
        },
      },
    },--afgh_cliffSouth_ob
    afgh_enemyBase_cp={
      sleep={
        default={
          "rt_enemyBase_s_0004",
        },
      },
    },--afgh_enemyBase_cp

    afgh_fort_cp={
      caution={
        groupA={
          "rt_fort_c_0009",
        },
      },
    },--afgh_fort_cp
    afgh_plantWest_ob={
      caution={
        groupA={
          "rt_plantWest_c_0004",
          "rt_plantWest_c_0005",
        },
      },
    },--afgh_plantWest_ob
    afgh_powerPlant_cp={
      caution={
        groupA={
          "rt_powerPlant_c_0010",
        },
      },
    },--afgh_powerPlant_cp
    afgh_remnants_cp={
      caution={
        groupA={
          "rt_remnants_d_0012",
        },
      },
    },--afgh_remnants_cp
    afgh_sovietBase_cp={
      sneak_day={
        groupD={
          "rt_sovietBase_d_0017",
          "rt_sovietBase_d_0018",
        },
      },
      sneak_night={
        groupD={
          "rt_sovietBase_n_0017",
          "rt_sovietBase_d_0018",
        },
      },
    },--afgh_sovietBase_cp
  },--afgh free

  --DEBUGNOW
  mafr={--free
  --rt_bananaSouth_d_0006
  --
  --rt_bananaSouth_n_0006
  --rt_bananaSouth_n_0007
  --
  --
  --rt_diamondNorth_d_0006
  --rt_diamondNorth_d_0007
  --rt_diamondNorth_n_0006
  --rt_diamondNorth_n_0007
  --
  --rt_diamondWest_d_0006
  --rt_diamondWest_n_0007
  --
  --
  --rt_hillSouth_c_0005
  --rt_hillSouth_c_0006
  --rt_hillSouth_c_0007
  --
  --rt_hillSouth_n_0005
  --
  --rt_hillWestNear_c_0006
  --rt_hillWestNear_c_0007
  --
  --rt_hillWestNear_n_0004
  --rt_hillWestNear_n_0005
  --
  --rt_lab_d_0010
  --rt_lab_d_0011
  --
  --rt_outlandNorth_c_0007
  --
  --rt_pfCampNorth_c_0004
  --rt_pfCampNorth_c_0005

  --rt_pfCampNorth_c_0006--tex only one ive seen that doesnt have route nor _sub used in routeset
  --rt_pfCampNorth_c_0006_sub

  --rt_pfCampNorth_c_0007
  --
  --rt_savannahNorth_d_0006
  --rt_savannahNorth_d_0007
  --
  --rt_savannahNorth_n_0006
  --rt_savannahNorth_n_0007
  --
  --rt_savannahWest_d_0006
  --rt_savannahWest_d_0007
  --
  --rt_savannahWest_n_0006
  --rt_savannahWest_n_0007
  --
  --rt_swampEast_c_0005
  --rt_swampEast_c_0006
  --rt_swampEast_c_0007
  --
  --rt_swampEast_n_0009
  --
  --rt_swampEast_r_0006
  --rt_swampEast_r_0007
  --
  --rt_swampSouth_c_0005
  --
  --rt_swampSouth_n_0005
  },--mafr free
}--routeSets

function this.Init(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
--tex called after RegisterRouteSet in TppMain.OnReload
function this.OnReload(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  if IvarProc.EnabledForMission"routeset_randomizeRouteSets" then
    this.RandomizeCurrentRouteSet()
  end
end--OnReload
--tex called a little ways after RegisterRouteSet is called in TppMain.OnInitialize
function this.SetUpEnemy(missionTable)
  if IvarProc.EnabledForMission"routeset_randomizeRouteSets" then
    this.RandomizeCurrentRouteSet()
  end
end--SetupEnemy

function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.Messages()
  return Tpp.StrCode32Table{
    GameObject={
      {msg="ChangePhase",func=this.OnPhaseChange},
    },
    Weather={
      {msg="Clock",sender="ShiftChangeAtNight",func=this.ShiftChangeAtNight},
      {msg="Clock",sender="ShiftChangeAtMorning",func=this.ShiftChangeAtMorning},
      {msg="Clock",sender="ShiftChangeAtMidNight",func=this.ShiftChangeAtMidNight},
    },--Weather
  }--StrCode32Table message table
end--Messages

function this.OnPhaseChange(cpGameObjectId,phase,oldPhase)
  if ivars.routeset_randomizeOnPhaseChange==0 then
    return
  end  
  
  if not IvarProc.EnabledForMission"routeset_randomizeRouteSets" then
    return
  end

  --tex this is called for every OnPhaseChange, so will be brutal for something like InfEnemyPhase or events that trigger a bunch of phasechange
  --DEBUGNOW TODO
  local cpName=InfLookup.CpNameForCpId(cpGameObjectId)
  InfCore.Log("InfRouteSet.OnPhaseChange "..tostring(cpName))--DEBUGNOW
  local cpRouteSet={}
  if mvars.ene_routeSetsDefine[cpName] then
    cpRouteSet[cpName]=InfUtil.CopyTable(mvars.ene_routeSetsDefine[cpName])
    InfCore.PrintInspect(cpRouteSet,"cpRouteSet")--DEBUGNOW
    this.RandomizeRouteSet(cpRouteSet)
  end
end--OnPhaseChange

function this.ShiftChangeAtMorning(sender,time)
  if ivars.routeset_randomizeOnShiftChange==0 then
    return
  end

  if not IvarProc.EnabledForMission"routeset_randomizeRouteSets" then
    return
  end

  InfCore.Log("InfRouteSet.ShiftChangeAtMorning")
  this.RandomizeCurrentRouteSet()
end--ShiftChangeAtMorning

function this.ShiftChangeAtNight(sender,time)
  if ivars.routeset_randomizeOnShiftChange==0 then
    return
  end

  if not IvarProc.EnabledForMission"routeset_randomizeRouteSets" then
    return
  end

  InfCore.Log("InfRouteSet.ShiftChangeAtNight")
  this.RandomizeCurrentRouteSet()
end--ShiftChangeAtNight

--tex actually at 22:00:00 (TppClock.NIGHT_TO_MIDNIGHT) rather than actual midnight
--tex GOTCHA: while there's no midgnight routes ("sneak_midnight etc") they take the night routeType and create a shift anyway?
--see TppEnemy._MakeShiftChangeUnit, search 'midnight'
function this.ShiftChangeAtMidNight(sender,time)
  if ivars.routeset_randomizeOnShiftChange==0 then
    return
  end

  if not IvarProc.EnabledForMission"routeset_randomizeRouteSets" then
    return
  end

  InfCore.Log("InfRouteSet.ShiftChangeAtMidNight")
  --this.RandomizeCurrentRouteSet()--tex DEBUGNOW don't know if I want to given that night shift is at ~18:00
end--ShiftChangeAtMidNight

function this.RandomizeCurrentRouteSet()
  InfCore.LogFlow("InfRouteSet.RandomizeCurrentRouteSet")
  if this.debugModule then
    InfCore.PrintInspect(mvars.ene_routeSetsDefine,"ene_routeSetsDefine before")
  end
  local routeSets=InfUtil.CopyTable(mvars.ene_routeSetsDefine)--tex ChangeRouteSets>MergeRouteSets isn't a pure merge, so you'd break things feeding ene_routeSetsDefine back into it directly
  this.RandomizeRouteSet(routeSets)
  if this.debugModule then
    InfCore.PrintInspect(mvars.ene_routeSetsDefine,"ene_routeSetsDefine after")
  end
end--RandomizeCurrentRouteSet

--tex DEBUGNOW Clean up
function this.RandomizeRouteSet(routeSets)
  InfCore.LogFlow("RandomizeRouteSet")
  --DEBUGNOW TODO setrandomtolevelseed, or is there a mission elapsed time var that can be used since this is being called in-mission too?
  --would only work if not doing RandomizeCurrentRouteSet/repeatedly randomising the same routeset

  --tex randomizing priority but keeping same sets just makes soldiers reassign
  --I assume its a case of there being more routes than soldiers thus the distrubution of soldier over them changes
  --tex could have an random-all-but-first, but the first tends to be sniper/vip tables which are added seperate anyway
  local randomizePriority=Ivars.routeset_randomizePriority:Get()==1
  if randomizePriority then
    for cpOrLrrp,routeSet in pairs(routeSets)do
      routeSet.priority=InfUtil.RandomizeArray(routeSet.priority)

      if routeSet.fixedShiftChangeGroup then
        routeSet.fixedShiftChangeGroup=InfUtil.RandomizeArray(routeSet.fixedShiftChangeGroup)
      end
    end
  end--if routeset_randomizePriority

  if Ivars.routeset_randomizeGroups:Get()==1 then
    --tex ok, so it's not technically a group
    --    for cpOrLrrp,routeSet in pairs(routeSets)do
    --      if routeSet.outofrain then
    --        routeSet.outofrain=this.RandomizeArray(routeSet.outofrain)
    --      end
    --    end
    --
    --    --tex randomize each group
    --    --kind of the same as randomizing only priority,
    --    --but more change in distribution as routes that normally wouldnt get assigned get assigned
    --    --and randomizing just this instead of priority still gives a prioritized route set, just one thats different than vanilla
    for cpOrLrrp,routeSet in pairs(routeSets)do
      --tex DEBUGNOW see if I want to handle 'travel' differently
      for i,routeSetType in pairs(TppEnemy.ROUTE_SET_TYPES)do
        --InfCore.Log(tostring(i)..":"..tostring(routeSetType))--DEBUGNOW
        local routeSetForType=routeSet[routeSetType]
        if not routeSetForType then
        --InfCore.Log("routeSet "..cpOrLrrp.." has no routeSetType "..routeSetType)--DEBUG
        else
          for groupName,routes in pairs(routeSetForType)do
            --InfCore.PrintInspect(routeSetForType[groupName],groupName.." before")--DEBUG
            routeSetForType[groupName]=InfUtil.RandomizeArray(routes)
            --InfCore.PrintInspect(routeSetForType[groupName],groupName.." after")--DEBUG
          end--for routeSetForType
        end--if routeSetForType
      end--for ROUTE_SET_TYPES
    end--for routeSets
  end--if routeset_randomizeGroups

  --tex could further ransomize routes across types,
  --that is if you're fine with soliders manning lights at night (actually not sure they actually would if theres further checks on whether the gimmick should be used based on world time)
  --or some rushing around like theyre in caution when its sneak

  TppEnemy.ChangeRouteSets(routeSets)
  if randomizePriority then--tex only cares about the group prios
    TppEnemy.MakeShiftChangeTable()
  end
  --if Ivars.routeset_randomizeShiftChangeTable
  this.RandomizeShiftChangeTable()--DEBUGNOW
end--RandomizeRouteSet

--REF --groups are actually StrCode32 in live table
--afgh_enemyBase_cp
--mvars.ene_shiftChangeTable[cpId]={
--  shiftAtNight={
--    [1]={--insertPos*2-1
--      [1]={"day","groupE"},-- shiftChangeUnit .start -- {shiftName, groupName}
--      [2]={"hold","default"},-- shiftChangeUnit .goal
--      holdTime=60,
--    },
--    [2]={--insertPos*2
--      [1]={"hold","default"},-- shiftChangeUnit .start
--      [2]={"night","groupA"},-- shiftChangeUnit .goal
--    },
--    ...
--tex DEBUGNOW one downside of ChangeRouteSets is that all soldier will change routes when its called
--so lets see what changing shifts gets us since its only pulled each shift
--tex just randomizing ene_shiftChangeTable itself since I havent got my mind around MakeShiftChangeTable
--IN/OUT/SIDE: mvars.ene_shiftChangeTable
--DEBUGNOW doesnt seem to do much, possibly assigned by group name and order doesn mean a thing
--if anything it seems to cause even less variation??
function this.RandomizeShiftChangeTable()
  InfCore.LogFlow"InfRouteSet.RandomizeShiftChangeTable"
  if this.debugModule then
  --InfCore.PrintInspect(mvars.ene_shiftChangeTable,"mvars.ene_shiftChangeTable before")
  end
  for cpId,shiftTypes in pairs(mvars.ene_shiftChangeTable)do
    InfCore.Log("cpId:"..cpId)--DEBUGNOW
    for shiftType,shifts in pairs(shiftTypes)do
      InfCore.Log("shiftType:"..shiftType.." #shifts:"..#shifts)--DEBUGNOW
      if #shifts>2 then
        for i=1,#shifts,2 do--shifts are added in pairs

          InfCore.Log("i:"..tostring(i).." #shifts:"..tostring(#shifts))--DEBUGNOW

          local rndIndex=math.random(#shifts-1)
          --tex odd only
          if (rndIndex % 2 == 0) then
            rndIndex=rndIndex+(math.random(0,1)and 1 or -1)
          end
          InfCore.Log("rndIndex:"..tostring(rndIndex))--DEBUGNOW
          --InfCore.PrintInspect(shifts[i],"shifts[i]")--DEBUGNOW
          --InfCore.PrintInspect(shifts[i+1],"shifts[i+1]")--DEBUGNOW
          --InfCore.PrintInspect(shifts[rndIndex],"shifts[rndIndex]")--DEBUGNOW
          --InfCore.PrintInspect(shifts[rndIndex+1],"shifts[rndIndex+1]")--DEBUGNOW
          InfUtil.SwapEntry(shifts,i,rndIndex)
          InfUtil.SwapEntry(shifts,i+1,rndIndex+1)
        end--for shifts,2
      end--if #shifts>2
    end
  end--for ene_shiftChangeTable
  if this.debugModule then
  --InfCore.PrintInspect(mvars.ene_shiftChangeTable,"mvars.ene_shiftChangeTable after")
  end
end--RandomizeShiftChangeTable

return this
