--InfNPCOcelot.lua
local this={}

--LOCALOPT
local InfMain=InfMain
local StrCode32=InfCore.StrCode32
local NULL_ID=GameObject.NULL_ID
local GetGameObjectId=GameObject.GetGameObjectId
local GetTypeIndex=GameObject.GetTypeIndex
local SendCommand=GameObject.SendCommand
local Random=math.random
local GetCurrentCluster=MotherBaseStage.GetCurrentCluster

--updateState
this.active="mbEnableOcelot"
this.execCheckTable={inGame=true,inSafeSpace=false}
this.execState={
  nextUpdate=0,
}
this.updateRate=1

--
this.packages={
  "/Assets/tpp/pack/mission2/free/f30050/f30050_ocelot.fpk",
}
this.packages_rail={
  "/Assets/tpp/pack/mission2/ih/ih_ocelot.fpk",--rail routes, spch, etc
}

this.npcPositions={
  [30050]={
    --TODO: expand to multiple clusters, multiple startpos/rots and multiple npc
    onClusterId=TppDefine.CLUSTER_DEFINE.Command,
    startPos=Vector3(10.396,0.8,-16.994),--similar to ddogs mission static pos
    -- OFF: command 1 is in construction during early game
    --startPos=Vector3(5.56,24.83,-5.57)--tex just outside core door
    --startRotY=144,
    --startPos=Vector3(3.89,8.512,-14.535)--tex mid level overlooking lower helipad
    startRotY=170.482,
    --command plat only

    --rlc rail pos
    startPosRailing=Vector3(6.813,24.8,-6.075),
    startRotYRailing=90.0,

    npcRoutes={
      --"rt_oc_rail_0000",--he won't reach the node, just circles
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_d_0000",
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_d_0001",
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_d_0002",
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_d_0003",
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_d_0004",
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_d_0005",

      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_n_0000",
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_n_0001",
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_n_0002",
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_n_0003",
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_n_0004",
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_n_0005",

      "ly003_cl00_route0000|cl00pl0_mb_fndt_plnt_free|rt_free_h_0000",
      "ly003_cl00_route0000|cl00pl0_mb_fndt_plnt_free|rt_free_h_0001",
      "ly003_cl00_route0000|cl00pl0_mb_fndt_plnt_free|rt_free_h_0002",
      "ly003_cl00_route0000|cl00pl0_mb_fndt_plnt_free|rt_free_h_0003",

      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_h_0000",
      "ly003_cl00_route0000|cl00pl0_uq_0000_free|rt_free_h_0001",
    },--npcRoutes
  },--30050
  --DEBUGNOW
  [34001]={
    startPos=Vector3(-14,-7.2,3.85),
    startRotY=340,
  },--34001
}--npcPositions

local onClusterId=TppDefine.CLUSTER_DEFINE.Command--DEBUGNOW use npcPositions instead

local npcList={
  --WARNING TODO: not multiple npc aware
  "ly003_cl00_npc0000|cl00pl0_uq_0000_npc2|TppOcelot2GameObjectLocator",
}
--tex indexed by npcList
local npcBodies={
  {
    TppEnemyBodyId.oce0_main0_v00,
    TppEnemyBodyId.oce0_main0_v01,--glasses
  --TppEnemyBodyId.oce0_main0_v02,--looks normal but may be defaulting/need a pack, no references but may be used in a demo
  },
}

local npcTimes={}
for n=1,#npcList do
  npcTimes[n]=0
end

local routeTimeMin=3*60
local routeTimeMax=6*60

this.mbDemoWasPlay=false
this.setupNpc=false

this.registerIvars={
  "mbEnableOcelot",
  "mbOcelotRailMode",
  "mbOcelotRailVoice",
}

this.mbEnableOcelot={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  MissionCheck=IvarProc.MissionCheckMb,
  --DEBUGNOW
--  MissionCheck=function(self,missionCode)
--    local missionCode=missionCode or vars.missionCode
--
--    local firstDigit=math.floor(missionCode/1e4)
--    if firstDigit==3 then
--      InfCore.Log"Ivars.mbEnableOcelot MissionCheck true"--DEBUGNOW
--      return true
--    end
--InfCore.Log"Ivars.mbEnableOcelot MissionCheck false"--DEBUGNOW
--    return false
--  end,
}
--<
this.mbOcelotRailMode={
  save=IvarProc.CATEGORY_EXTERNAL,
  --Off is regular IH style
  --START has him on the railing from the beginning
  --LEAVE has him only appear, and on the railing, when you pull out by heli
  settings={"OFF","START","LEAVE"},
  settingNames="mbOcelotRailModeSettingNames",
  MissionCheck=IvarProc.MissionCheckMb,
}
function this.IsOcelotRailEnable()
  return Ivars.mbOcelotRailMode:Get()>0
end
function this.IsOcelotRailLeave()
  return Ivars.mbOcelotRailMode:Is(2)
end
this.mbOcelotRailVoice={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}
function this.IsOcelotRailVoice()
  return Ivars.mbOcelotRailVoice:Is(1)
end
this.langStrings={
  eng={
    mbEnableOcelot="Enable Ocelot",
    mbOcelotRailMode="Ocelot Railing Mode",
    mbOcelotRailModeSettingNames={"Off","Start","Leave"},
    mbOcelotRailVoice="Ocelot Railing Voice",
  },
  help={
    eng={
      mbEnableOcelot="Enables Ocelot to roam the command platform.",
      mbOcelotRailMode="Makes Ocelot observe Mother Base from a railing on the command platform. Start will have him appear there since the start of your visit, and Leave will have him appear when you take off by helicopter.",
      mbOcelotRailVoice="Makes Ocelot greet you when approached while he's on a railing.",
    },
  }
}
--<

function this.PostAllModulesLoad()
  this.Init()
end

function this.AddMissionPacks(missionCode,packPaths)
  --DEBUGNOW
  if this.npcPositions[missionCode]==nil then
    return
  end
  if not this.active:EnabledForMission(missionCode) then
    return
  end

  if InfMainTpp.IsMbEvent(missionCode) then
    return
  end

  for i,packPath in ipairs(this.packages) do
    packPaths[#packPaths+1]=packPath
  end
  
  if this.IsOcelotRailEnable() then
    for i,packPath in ipairs(this.packages_rail) do
      packPaths[#packPaths+1]=packPath
    end
  end
end

function this.Init()
  this.messageExecTable=nil

  if not this.active:EnabledForMission() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  local clusterId=GetCurrentCluster()
  this.InitCluster(clusterId)
end

function this.OnReload(missionTable)
  this.messageExecTable=nil

  if not this.active:EnabledForMission() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

local searchTargetName = "ocelotHi"
local goDelay = "Timer_GoDelay"

function this.Messages()
  return Tpp.StrCode32Table{
    MotherBaseStage={
      --{msg="MotherBaseCurrentClusterLoadStart",func=this.MotherBaseCurrentClusterLoadStart},
      {msg="MotherBaseCurrentClusterActivated",func=function(clusterId)this.MotherBaseCurrentClusterActivated(clusterId)end},
    },
    --rlc rail
    GameObject={
      {
        msg="RoutePoint2",func=function(gameObjectId,routeId,routeNode,messageId)
          if gameObjectId~=this.GetGameObjectId() then
            return
          end
          if messageId==StrCode32"Rail" then
            local TR={
              trs=Vector3(6.813,24.8,-6.075),
              rot=TppMath.DegreeToRadian(90.0),
            }
            this.SetSpecialAction("/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_a.gani",TR,false,"railLoop")
          end
        end
      },
      {
        msg="SpecialActionEnd",func=function(gameObjectId,actionId,commandId)
          if gameObjectId~=this.GetGameObjectId() then
            return
          end
          if this.npcOcelotIsInterrupted then
            this.npcOcelotIsInterrupted=nil
            return
          end
          if actionId==StrCode32"PlayMotion" then
            if commandId==StrCode32"railLoop" then
              local TR={
                trs=Vector3(6.813,24.0,-6.075),
                rot=TppMath.DegreeToRadian(90.0),
              }
              local path="/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_a.gani"
              local autoFinish=true
              if math.random(0,1)==1 then
                path="/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_b.gani"
                autoFinish=true
                if math.random(0,1)==1 then
                  --path="/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_lok_r.gani"
                end
              end
              this.SetSpecialAction(path,TR,autoFinish,"railLoop")
            elseif commandId==StrCode32"railEnd" then
              SendCommand(gameObjectId,{id="SpecialAction",action="",})	

              local placement=this.npcPositions[vars.missionCode]--WARNING: not multiple npc aware
              if placement==nil then
                InfCore.Log("InfNPCOcelot placement==nil")--DEBUGNOW
                return
              end
            
              if placement.onClusterId and GetCurrentCluster()~=placement.onClusterId then
                return
              end

              if placement.npcRoutes then--WARNING: not multiple npc aware
                TppEnemy.SetSneakRoute(gameObjectId,placement.npcRoutes[math.random(1,#placement.npcRoutes)])
              end
            end
          end
        end
      },
      {
        msg="MonologueEnd",func=function(gameObjectId,speechLabel,isSuccess)
          if gameObjectId~=this.GetGameObjectId() then
            return
          end

        end
      },
      {
        msg="Damage",func=function(gameObjectId,attackId,attackerId)
          if gameObjectId~=this.GetGameObjectId() then
            return
          end

          this.npcOcelotIsInterrupted=true
        end,
      }
    },
    Trap={
      {
        msg="Enter",sender="trap_oce_rail_see",func=function()
          local isEnable = this.IsOcelotRailEnable() and not this.IsOcelotRailLeave()
          if not isEnable then
            return
          end
          Player.AddSearchTarget {
            name = searchTargetName,
            targetGameObjectTypeIndex = TppGameObject.GAME_OBJECT_TYPE_OCELOT2,
            targetGameObjectName = npcList[1],
            skeletonName = "SKL_004_HEAD",
            offset = Vector3(0,0.25,0),
            centerRange = 0.9,
            distance = 150,
            doWideCheck = false,
            wideCheckRadius = 0.25,
            wideCheckRange = 0.15,
            doDirectionCheck = false,
            directionCheckRange = 180,
            doCollisionCheck = true,
            --checkImmediately = true,
          }
        end,
      },
      {
        msg="Exit",sender="trap_oce_rail_see",func=function()
          local isEnable = this.IsOcelotRailEnable() and not this.IsOcelotRailLeave()
          if not isEnable then
            return
          end
					Player.RemoveSearchTarget(searchTargetName)
        end,
      },
    },
    Player={
      {
        msg="LookingTarget",func=function(message)
          if not message==StrCode32(searchTargetName) then
            return
          end
          if GkEventTimerManager.IsTimerActive(goDelay) then
            return
          end
          GkEventTimerManager.Start(goDelay,3)
					Player.RemoveSearchTarget(searchTargetName)
        end,
      },
      {
        msg = "RideHelicopter",
        func = function( gameObjectId )
          if not Tpp.IsPlayer( gameObjectId ) then
            return
          end
          this.EnableOcelotForLeave()
        end,
      },
      {
        msg = "OnPlayerHeliHatchOpen",
        func = function()
          this.EnableOcelotForLeave()
        end,
      },
      {
        msg = "PlayerHeliGetOff",
        func = function( gameObjectId )
          if not Tpp.IsPlayer( gameObjectId ) then
            return
          end
          if not this.IsOcelotRailLeave() then
            return
          end
          SendCommand(this.GetGameObjectId(),{id="SetEnabled",enabled=false})
        end,
      },
    },
    Timer={
      {
        msg="Finish",sender=goDelay,func=function()
          if mvars.mbOcelotRailEnd then
            return
          end
          mvars.mbOcelotRailEnd=true
          local isEnable = this.IsOcelotRailEnable() and not this.IsOcelotRailLeave()
          if isEnable then
            this.EndOcelotSpecialAction(true)
          end
          if this.IsOcelotRailVoice() then
            local label="OcelotGreetA"
            if math.random(0,1)==1 then
              label="OcelotGreetB"
            end
            SendCommand(this.GetGameObjectId(),{id="CallMonologue",label=label})
          end
        end,
      }
    }
  }
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.MotherBaseCurrentClusterActivated(clusterId)
  this.InitCluster(clusterId)
end

function this.InitCluster(clusterId)
  if clusterId~=onClusterId then
    return
  end

  this.mbDemoWasPlay=false
  this.setupNpc=false

  for n=1,#npcList do
    npcTimes[n]=0
  end
end

function this.Update(currentChecks,currentTime,execChecks,execState)
  if not currentChecks.inGame then
    return
  end

  if not this.active:EnabledForMission() then
    return
  end

  if InfMainTpp.IsMbEvent() then
    return
  end

  local demoName=TppDemo.GetMBDemoName()
  if demoName then
    this.mbDemoWasPlay=true
    return
  end

  local placement=this.npcPositions[vars.missionCode]--WARNING: not multiple npc aware
  if placement==nil then
    InfCore.Log("InfNPCOcelot placement==nil")--DEBUGNOW
    return
  end

  if placement.onClusterId and GetCurrentCluster()~=placement.onClusterId then
    return
  end

  local isRailStart=this.IsOcelotRailEnable() and not this.IsOcelotRailLeave() and not this.mbDemoWasPlay

  if not this.setupNpc then
    this.setupNpc=true

    for n=1,#npcList do
      local npcName=npcList[n]
      local gameId=GetGameObjectId(npcName)
      if gameId==NULL_ID then
        InfCore.Log("InfNPCOcelot "..npcName.."==NULL_ID")--DEBUGNOW
      else
        InfCore.Log("InfNPCOcelot setupNpc")--DEBUGNOW

        if this.mbDemoWasPlay then
        --InfCore.DebugPrint("mbDemoWasPlay")--DEBUG
        else
          local startPos = placement.startPos
          local startRotY = placement.startRotY
          if this.IsOcelotRailEnable() then
            startPos = placement.startPosRailing
            startRotY = placement.startRotYRailing
          end
          local command={id="Warp",position=startPos,degRotationY=startRotY}
          SendCommand(gameId,command)
        end

        local command={id="SetEnabled",enabled=not this.IsOcelotRailLeave()}
        SendCommand(gameId,command)


        local bodyId=npcBodies[n][Random(#npcBodies[n])]--tex TODO: seed it if it's a big enough change to be jarring

        local command={id="ChangeFova",faceId=EnemyFova.INVALID_FOVA_VALUE,bodyId=bodyId}
        SendCommand(gameId,command)
                
        if isRailStart then
          local TR={
            trs=Vector3(6.813,24.0,-6.075),
            rot=TppMath.DegreeToRadian(90.0),
          }
          this.SetSpecialAction("/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_a.gani",TR,false,"railLoop")
        end
        --if NULL_ID<
      end
      --for npcs
    end
    --if not setup<
  end

  if isRailStart and not mvars.mbOcelotRailEnd then
      for n=1,#npcList do
        local npcName=npcList[n]
        local gameId=GetGameObjectId(npcName)
        if gameId==NULL_ID then
        --InfCore.DebugPrint("gameId==NULL_ID")
        else
          local command={id="SetSneakRoute",route=""}
          SendCommand(gameId,command)
        end
    end
    return
  end

  if placement.npcRoutes then--WARNING: not multiple npc aware
    for n=1,#npcList do
      local npcName=npcList[n]
      local gameId=GetGameObjectId(npcName)
      if gameId==NULL_ID then
      --InfCore.DebugPrint("gameId==NULL_ID")
      else
        if npcTimes[n]< currentTime then
          npcTimes[n]=currentTime+Random(routeTimeMin,routeTimeMax)

          local routeIdx=Random(#placement.npcRoutes)

          --        local routeTime=npcTimes[n]-Time.GetRawElapsedTimeSinceStartUp()--DEBUG
          --        InfCore.DebugPrint(npcName .. " routeIdx ".. routeIdx .. " for "..routeTime)--DEBUG
          local command={id="SetSneakRoute",route=placement.npcRoutes[routeIdx]}
          SendCommand(gameId,command)
        end
      end
      --for npcs<
    end
  end
end

--rlc Rail Ocelot
--OBJECTIVE: E3 2014 Ocelot on railing restoration.
--At least use the one spot at the top heliport so he can wave when you arrive, leave or just see him.
--Note: there is no "from idle into rail" animation, so he has to start on the rail.
--He should, however, be able to leave the spot any time, either facing behind or to the right.

local ocelotRailLocationTR = {
  trs = Vector3(6.813,24.025,-6.075),
  rot = TppMath.DegreeToRadian(90.0)
}
--local command={id="Warp",position=Vector3(6.813,24.025,-6.075),degRotationY=90}
--local gameObjectId=GameObject.GetGameObjectId("ly003_cl00_npc0000|cl00pl0_uq_0000_npc2|TppOcelot2GameObjectLocator")
--GameObject.SendCommand(gameObjectId,command)

--idles:
local railLoop="/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_a.gani"--loop
local railVariation="/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_b.gani"--repositioning animation. on end go to loop
local railLookRight="/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_lok_r.gani"--look right. on end go to loop
--ends:
local railGo="/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_go.gani"--from loop to face right, salute
local railBack="/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_ed.gani"--from loop to face back
local railRight="/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_tn_r.gani"--from loop to face right

local facial={
    "cool",
    "sneer",
    "combat",
    "delight",
    "shout",
    "normal",
    "disgust",
    "damage_h",
    "damage_l",
    "angry",
    "endure",
}

--local gameObjectId=GameObject.GetGameObjectId("ly003_cl00_npc0000|cl00pl0_uq_0000_npc2|TppOcelot2GameObjectLocator")
local command={
  id="SpecialAction",
  action="PlayMotion",
  facial="cool",
  path="/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_st.gani",
  startPosition=Vector3(6.813,24.025,-6.075),
  startAngleY=TppMath.DegreeToRadian( 90.0 ),
	enableMessage=true,
	autoFinish=true,
}
--GameObject.SendCommand(gameObjectId,command)

this.railPoints={
  {
    rt="rt_oc_rail_0000",--E3 2014 point
    loc={
      trs=Vector3(6.813,24.025,-6.075),
      rot=TppMath.DegreeToRadian(90.0)
    },
  }
}

function this.GetGameObjectId()
  return GetGameObjectId("TppOcelot2",npcList[1])
end

function this.SetSpecialAction(path,startTR,autoFinish,commandId)
  local gameObjectId=this.GetGameObjectId()
  local startPosition
  local startAngleY
  if Tpp.IsTypeTable(startTR) then
    startPosition=startTR.trs
    startAngleY=startTR.rot
  end
  if Tpp.IsTypeString(commandId) then
    commandId=StrCode32(commandId)
  end
  local commandSpecialAction={
    id="SpecialAction",
    action="PlayMotion",
    path=path,
    startPosition=startPosition,
    startAngleY=startAngleY,
    override=true,
    autoFinish=autoFinish,
    enableMessage=true,
    commandId=commandId,
    enableGravity=(commandId=="railEnd"),
    enableCollision=(commandId=="railEnd"),
  }
  SendCommand(gameObjectId,commandSpecialAction)
end

function this.EndOcelotSpecialAction(isGo)
  local path=railBack
  if math.random(0,1)==1 then
    path=railRight
  end
  if isGo then
    path=railGo
  end
  this.SetSpecialAction(path,nil,true,"railEnd")
end

function this.EnableOcelotForLeave()
  local isEnable = this.IsOcelotRailLeave()
  if not isEnable then
    return
  end

  local placement=this.npcPositions[vars.missionCode]--WARNING: not multiple npc aware
  if placement==nil then
    InfCore.Log("InfNPCOcelot placement==nil")--DEBUGNOW
    return
  end

  if placement.onClusterId and GetCurrentCluster()~=placement.onClusterId then
    return
  end

  local ocelotGameObjectId = this.GetGameObjectId()
  local startPos = placement.startPosRailing
  local startRotY = placement.startRotYRailing

  SendCommand(ocelotGameObjectId,{id="Warp",position=startPos,degRotationY=startRotY})
  TppEnemy.SetSneakRoute(ocelotGameObjectId,"")
  SendCommand(ocelotGameObjectId,{id="SetEnabled",enabled=true})

  local bodyId=npcBodies[1][Random(#npcBodies[1])]--tex TODO: seed it if it's a big enough change to be jarring

  local command={id="ChangeFova",faceId=EnemyFova.INVALID_FOVA_VALUE,bodyId=bodyId}
  SendCommand(ocelotGameObjectId,command)

  local TR={
    trs=Vector3(6.813,24.0,-6.075),
    rot=TppMath.DegreeToRadian(90.0),
  }
  this.SetSpecialAction("/Assets/tpp/motion/SI_game/fani/bodies/oce0/oce0/oce0_s_idl_rail_a.gani",TR,false,"railLoop")
end

return this
