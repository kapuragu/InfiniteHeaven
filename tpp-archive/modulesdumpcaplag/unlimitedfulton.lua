local this = {}

this.registerIvars={
    "noFultonLimit",
}

this.noFultonLimit={
    inMission=true,
    save=IvarProc.CATEGORY_EXTERNAL,
    settings={"OFF","ON"},
    default=0,
    OnChange=function(self,setting)
		this.UnlimitedFultons(setting)
	end
}

this.registerMenus={
    "noFultonLimitMenu",
}
  
this.noFultonLimitMenu={
    parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
    options={
                "Ivars.noFultonLimit",     
    },
}

this.langStrings={
eng={
    noFultonLimitMenu="Fulton Limit menu",
},
help={
    eng={
        noFultonLimit="Enables unlimited fulton.",
       },
    },
}

function this.UnlimitedFultons(variable)
    if variable==0 then
		Player.SetFultonCountInfinity(false)
    elseif variable==1 then   
		Player.SetFultonCountInfinity(true)
    end
end

function this.FadeInOnGameStart()
  if InfMain.IsOnlineMission(vars.missionCode)then
    return
  end
  if not InfMain.IsPastTitle(vars.missionCode) then
    return
  end
  this.UnlimitedFultons(Ivars.noFultonLimit:Get())
end

function this.Messages()
  return Tpp.StrCode32Table{
    UI={
      --{msg="EndFadeIn",sender="FadeInOnGameStart",func=this.FadeInOnGameStart},--fires on: most mission starts, on-foot free and story missions, not mb on-foot, but does mb heli start
      --{msg="EndFadeIn",sender="FadeInOnStartMissionGame",func=this.FadeInOnGameStart},--fires on: returning to heli from mission
      --{msg="EndFadeIn",sender="OnEndGameStartFadeIn",func=this.FadeInOnGameStart},--fires on: on-foot mother base, both initial and continue
    },
  }
end

function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  --Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.OnReload(missionTable)
  --this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.Init(missionTable)
  --this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
  
return this