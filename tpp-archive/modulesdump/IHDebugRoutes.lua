--InfDebugRoutes.lua --DEBUGNOW
--tex route testing guff for sai.
--adds 'Route test menu' to acc and in-mission
--acc Route test menu adds debugEnableRouteTest which will clear routes and only assign one soldier to mb quarantine platform.
--in-mission route test menu adds setRouteName and setRoutePoint which allows selection of route 
--and assigns it to the sole soldier when pressing <Action> while option selected

local this={}

local GetGameObjectId = GameObject.GetGameObjectId
local SendCommand = GameObject.SendCommand
local NULL_ID = GameObject.NULL_ID

--tex let system know there's ivars in the module (otherwise would have to check every k/v and do an IsIvar check)
this.registerIvars={
  'debugEnableRouteTest',
  'setRouteName',
  'setRoutePoint',
}

--tex ivar definitions
this.debugEnableRouteTest={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  nonConfig=true,
  noDoc=true,
}

local testSoldierName="sol_mtbs_0000"--TODO use select object

this.setRouteName={
  nonConfig=true,
  noDoc=true,
  range={max=7,min=0,increment=1},
  settings={
    --quarantine routes
    "rts_30250_d_0000",
    "rts_30250_d_0001",
    "rts_30250_d_0002",
    "rts_30250_d_0003",
    "rts_30250_d_0004",
    "rts_30250_d_0005",
    "none",--tex could just be "", any non existant route is basically cancel route
  },
  OnActivate=function(self,setting)
    local soldierId=GetGameObjectId(testSoldierName)
    if soldierId==NULL_ID then
      InfCore.Log(testSoldierName.."==NULL_ID",true,true)
      return
    end

    local selectedRoute=self:GetSettingName()
    local selectedPoint=Ivars.setRoutePoint:Get()
    InfCore.Log("SetSneakRoute route="..selectedRoute.." point="..selectedPoint,true,true)
    SendCommand(soldierId,{id="SetSneakRoute",route=selectedRoute,point=selectedPoint})
  end,
}

--tex set point on setroute for selected route 
--TODO: test to see if point change works on an already set route or if you have to change route too
--or that it works at all lol
this.setRoutePoint={
  nonConfig=true,
  noDoc=true,
  default=0,
  range={max=10,min=0,increment=1},
  OnActivate=function(self,setting)
    local soldierId=GetGameObjectId(testSoldierName)
    if soldierId==NULL_ID then
      InfCore.Log(testSoldierName.."==NULL_ID",true,true)
      return
    end

    local selectedRoute=Ivars.setRouteName:GetSettingName()
    local selectedPoint=setting
    InfCore.Log("SetCautionRoute route="..selectedRoute.." point="..selectedPoint,true,true)
    SendCommand(soldierId,{id="SetCautionRoute",route=selectedRoute,point=selectedPoint})
  end,
}

this.routeTestHeliMenu={
  description="Route test menu",
  context="HELISPACE",
  options={
    "Ivars.debugEnableRouteTest",
  }
}
--<ivar defs

--tex menu definitions
this.routeTestMissionMenu={
  description="Route test menu",
  context="MISSION",
  options={
    "Ivars.setRouteName",
    "Ivars.setRoutePoint",
  }
}

this.menuDefs={
  routeTestHeliMenu=this.routeTestHeliMenu,
  routeTestMissionMenu=this.routeTestMissionMenu,
}

function this.Init(missionTable)
  this.messageExecTable=nil
  if ivars.debugEnableRouteTest==0 then
    return
  end
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnReload(missionTable)
  this.messageExecTable=nil
  if ivars.debugEnableRouteTest==0 then
    return
  end
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.Messages()
  return Tpp.StrCode32Table{
    GameObject={
      {msg="RoutePoint2",func=this.OnRoutePointMessage},
    },
   }
end
      
--tex on msg RoutePoint2. debugMessages option will already catch message, but in case you want to run your own code on message
function this.OnRoutePointMessage(gameId,routeStr32,param,messageStr32)

end

return this