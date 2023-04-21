-- InfDemoPlay.lua --DEBUGNOW
local this={}

this.registerIvars={
  "demo_playList",
}

this.demo_playList={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=1},--DYNAMIC--DEBUGNOW
  settings={},--DYNAMIC
  GetSettingText=function(self,setting)
    if mvars.dem_demoList==nil then
      return "dem_demoList empty"--DEBUGNOW
    end
    if #self.settings==0 then
      return "demo list empty"--DEBUGNOW
    end
    local demoName=self.settings[setting+1]
    local demoId=mvars.dem_demoList[demoName]
    return demoName.." - "..demoId
  end,
  OnSelect=function(self)
    InfUtil.ClearArray(self.settings)
    self.range.max=0
    --InfCore.PrintInspect(self.settings,"self.settings")--DEBUG
    --InfCore.PrintInspect(mvars.dem_demoList,"mvars.dem_demoList")--DEBUG

    if mvars.dem_demoList==nil then
      return
    end
    for demoName,demoId in pairs(mvars.dem_demoList)do
      self.settings[#self.settings+1]=demoName
    end

    table.sort(self.settings)
    --InfCore.PrintInspect(self.settings,"self.settings post")--DEBUG
    self.range.max=#self.settings-1
  end,
  OnActivate=function(self,setting)
    if mvars.dem_demoList==nil then
      return
    end
    
    local demoName=self.settings[setting+1]
    if not mvars.dem_demoList then
      return
    end
    
    
    local useDemoBlock=false
    if mvars.sbl_scriptBlockPackList and mvars.sbl_scriptBlockPackList.demo_block then
       useDemoBlock=mvars.sbl_scriptBlockPackList.demo_block[demoName]~=nil
    end
    InfCore.PrintInspect(useDemoBlock,"useDemoBlock")--DEBUGNOW

    TppDemo.Play(demoName,{
      onStart=function()
        InfCore.Log("!!!!------Demo onStart")--DEBUGNOW
        TppSoundDaemon.ResetMute"Loading"
      end,
      onEnd=function()
        InfCore.Log("!!!!------Demo onEnd")--DEBUGNOW
        TppPlayer.ResetAroundCameraRotation()
        --TppSequence.SetNextSequence"Seq_Demo_SwitchSequence"--DEBUGNOW
        TppSequence.SetNextSequence"Seq_Demo_WaitMainGame"--DEBUGNOW
      end},
    {isSnakeOnly=false,useDemoBlock=useDemoBlock,finishFadeOut=true})
  end,
}

this.registerMenus={
  "demoPlayMenu",
}

this.demoPlayMenu={--DEBUGNOW
  parentRefs={"InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.demo_playList",
  }
}

--REF DEBUGNOW
--mvars.dem_demoList = _sequence.demoList
--mvars.sbl_scriptBlockPackList[blockName][packName]=packPath --"demo_block", demoName  _sequence.demoBlockList

return this
