--InfGimmick.lua
--DEBUGWIP
--Stuff related to gimmick objects (currently just AA radar reset)
local this={}

this.dataSetPath32ToAacr={}

-->
this.ivarsPersist={
  --aacradar countdowns
  cliffTown_aacr001=8,
  commFacility_aacr001=8,
  enemyBase_aacr001=8,
  field_aacr001=8,
  fort_aacr001=8,
  powerPlant_aacr001=8,
  remnants_aacr001=8,
  slopedTown_aacr001=8,
  sovietBase_aacr001=8,
  tent_aacr001=8,
  banana_aacr001=8,
  diamond_aacr001=8,
  flowStation_aacr001=8,
  hill_aacr001=8,
  pfCamp_aacr001=8,
  savannah_aacr001=8,
  swamp_aacr001=8,
}

this.registerIvars={
  'resetAACRCount',
}

this.resetAACRCount={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={max=30,min=0,increment=1}
}
--<

function this.Init(missionTable)
  if not Ivars.resetAACRCount:Is(0) then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnReload(missionTable)
  if not Ivars.resetAACRCount:Is(0) then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  if not Ivars.resetAACRCount:Is(0) then
    return
  end

  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.Messages()
  return Tpp.StrCode32Table{
    GameObject={
      {msg="BreakGimmick",func=this.OnBreakGimmick},
    },
  }
end

function this.OnBreakGimmick(gimmickId,locatorNameS32,dataSetPath32,attackerId)
  --tex start reset countdown
  local aacrName=this.dataSetPath32ToAacr[dataSetPath32]
  if aacrName then
    local info=TppLandingZone.aacrGimmickInfo[aacrName]
    if Fox.StrCode32(info.locatorName) == locatorNameS32 then
      InfCore.Log("InfGimmick: Starting AACR reset countdown")--DEBUGWIP
      igvars[aacrName]=IvarsPersist[aacrName]--tex reset to default countdown
    end
  end
end

--DEBUGNOW TODO: where do I want to decrement this, only once per mission. on mission complete? (and abort to acc??)
function this.DecrementAACRCountdown()
  if not Ivars.resetAACRCount:Is(0) then
    return
  end

  InfCore.Log("InfGimmick.DecrementAACRCountdown:")

  for name,info in TppLandingZone.aacrGimmickInfo do
    --tex dont want it too OP
    local defaultValue=IvarsPersist[name]
    local value=igvars[name] or defaultValue--tex DEBUGWIP TODO: query broken state (if possible) and only kick off if has igvars or is broken
    value=value-1
    if value<=0 then
      value=defaultValue
      InfCore.Log("aacr "..name.." decrement/reset")--DEBUGWIP
    end
    if this.debugModule then
      InfCore.Log("aacr "..name.." decrement from "..igvars[name].." to "..value)--DEBUG
    end
    igvars[name]=value
  end
end

--EXEC
--fast lookup from OnBreakGimmick message pathcode32
for name,info in pairs(TppLandingZone.aacrGimmickInfo) do
  this.dataSetPath32ToAacr[Fox.PathFileNameCode32(info.dataSetName)]=name
end

--tex usefull for testing sideops with gimmicks
function this.DEBUG_ResetGimmicks()
  local resetTypes={
    [TppGimmick.GIMMICK_TYPE.MCHN]=true,
    [TppGimmick.GIMMICK_TYPE.GUN]=true,
    [TppGimmick.GIMMICK_TYPE.MORTAR]=true,
    [TppGimmick.GIMMICK_TYPE.ANTIAIR]=true,
  }

  local gimmickTables={}
  if afgh_gimmick then
    table.insert(gimmickTables,afgh_gimmick.gimmickIdentifierParamTable)
  end
  if mafr_gimmick then
    table.insert(gimmickTables,mafr_gimmick.gimmickIdentifierParamTable)
  end

  for i,gimmickTable in ipairs(gimmickTables)do
    for gimmickName, gimmickInfo in pairs(gimmickTable)do
      if resetTypes[gimmickInfo.gimmickType] then
        Gimmick.ResetGimmick(gimmickInfo.type,gimmickInfo.locatorName,gimmickInfo.dataSetName)
      end
    end
  end
end

function this.DEBUG_ResetAACRs()
  InfCore.PrintInspect(TppLandingZone.aacrGimmickInfo,"TppLandingZone.aacrGimmickInfo ----------")
  for gimmickName,gimmickInfo in pairs(TppLandingZone.aacrGimmickInfo)do
    local isBroken=TppLandingZone.IsBrokenGimmick(gimmickName)
    InfCore.Log(gimmickName.." isBroken bef:"..tostring(isBroken))

    Gimmick.ResetGimmick(gimmickInfo.type,gimmickInfo.locatorName,gimmickInfo.dataSetName)--tex resets in game gimmick
    Gimmick.ResetGimmickData(gimmickInfo.locatorName,gimmickInfo.dataSetName)--tex *shrug*

    local isBroken=TppLandingZone.IsBrokenGimmick(gimmickName)
    InfCore.Log(gimmickName.." isBroken aft:"..tostring(isBroken))--DEBUGWIP still says broken, and fixed state doesnt seem to save/broken on return it
  end
end

return this
