--RlcHeliInfiniteAmmo
local this={}

this.messageTable={
    Player={
        {
            msg="RideHelicopter",
            func=function()
                this.UpdateInfiniteAmmo(true)
            end,
        },
        {
            msg="OnPlayerHeliHatchOpen",
            func=function()
                this.UpdateInfiniteAmmo(true)
            end,
        },
        {
            msg="PlayerHeliGetOff",
            func=function()
                this.UpdateInfiniteAmmo(false)
            end,
        },
    },
}

function this.OnMissionCanStart(currentChecks)
    if not InfMain.IsPastTitle(vars.missionCode) then
        return
    end
    if InfMain.IsOnlineMission(vars.missionCode) then
        return
    end
    this.UpdateInfiniteAmmo()
end

function this.UpdateInfiniteAmmo(enable)
    if enable==nil then
        enable=TppTutorial.IsRideHelicopter()
    end
    --Player.SetInfiniteAmmoFromScript(enable)
    --Player.SetFultonCountInfinity(enable)
end

function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
    if vars.missionCode <= 5 or vars.missionCode >= 50000 then
        return
    end
    Tpp.DoMessage(Tpp.MakeMessageExecTable(Tpp.StrCode32Table(this.messageTable)),TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

return this