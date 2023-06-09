--InfShootingPractice.lua
--tex ivars and implementation of Shooting Practice quest features
local this={}

--LOCALOPT
local floor=math.floor
local format=string.format

--this.saveDirty=false--tex OFF saves via InfQuest/ih_quest_states

function this.Init()
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.OnReload(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.Messages()
  local shootingPracticeTrapNames={
    --tex vanilla traps
    "ly003_cl00_npc0000|cl00pl0_uq_0000_npc2|trap_shootingPractice_start",--Command
    "ly003_cl01_npc0000|cl01pl0_uq_0010_npc2|trap_shootingPractice_start",--Combat
    "ly003_cl02_npc0000|cl02pl0_uq_0020_npc2|trap_shootingPractice_start",--Develop
    "ly003_cl03_npc0000|cl03pl0_uq_0030_npc2|trap_shootingPractice_start",--Support
    "ly003_cl04_npc0000|cl04pl0_uq_0040_npc2|trap_shootingPractice_start",--Medical
    "ly003_cl05_npc0000|cl05pl0_uq_0050_npc2|trap_shootingPractice_start",--Spy
    "ly003_cl06_npc0000|cl06pl0_uq_0060_npc2|trap_shootingPractice_start",--BaseDev
  }
  for questName,questAddon in pairs(InfQuest.ihQuestsInfo)do
    if questAddon.startTrapName then
      table.insert(shootingPracticeTrapNames,questAddon.startTrapName)
    end
  end

  return Tpp.StrCode32Table{
    Player={
      {
        --tex sent by ActionIcon of start trap
        --Overriding the quest scripts message callback via this.QuestBlockOnInitializeBottom
        msg="QuestStarted",
        sender="ShootingPractice",
        func=function(questNameHash)
          if Ivars.quest_enableShootingPracticeRetry:Is(0) then
            return
          end

          InfCore.Log("InfQuest msg QuestStarted")
          if mvars.qst_isShootingPracticeStarted then
            InfCore.Log("ShootingPractice manual cancel")
            local isClearType=TppGimmick.CheckQuestAllTarget(TppDefine.QUEST_TYPE.SHOOTING_PRACTIVE,nil,true)
            TppQuest.ClearWithSave(isClearType)--tex will have to think this through (and all calls to ClearWithSave) if you chand ClearWithSave to actually save (it currently doesnt for shooting practice)
          else
            InfCore.Log("InfQuest QuestStarted")
            --TppPlayer.QuestStarted(questNameHash)--tex hides action icon and stops sfx when entering start trap
            TppQuest.SetQuestShootingPractice()

            if MotherBaseStage.GetCurrentCluster()==4 then--Medical
              f30050_sequence.StopMusicFromQuietRoom()
              mvars.isShootingPracticeInMedicalStopMusicFromQuietRoom = true
            end

            --KLUDGE, don't know why these aren't just a single var anyway
            mvars.needToUpdateRankingInCommand = false
            mvars.needToUpdateRankingInCombat = false
            mvars.needToUpdateRankingInDevelop = false
            mvars.needToUpdateRankingInSupport = false
            mvars.needToUpdateRankingInMedical = false
            mvars.needToUpdateRankingInSpy = false
            mvars.needToUpdateRankingInBaseDev = false
          end
        end--func
      }--msg QuestStarted
    },--Player
    Trap = {
      {
        msg="Enter",sender=shootingPracticeTrapNames,
        func=function(trap,player)
          if mvars.qst_isShootingPracticeStarted then
            --InfCore.Log( "Shooting Quest Trap Enter: ShootingPractice is Deactivated. Return" )
            return
          end
          local questName=TppQuest.GetCurrentQuestName()
          this.PrintShootingPracticeBestTime(questName)
        end
      },--msg Enter
      {
        msg="Exit",sender=shootingPracticeTrapNames,
        func=function(trap,player)
          if mvars.qst_isShootingPracticeStarted then
            --InfCore.Log( "Shooting Quest Trap Exit: ShootingPractice is Deactivated. Return" )
            return
          end
          local questName=TppQuest.GetCurrentQuestName()
        end
      },--msg Exit
    },--Trap
  }--StrCode32Table
end--Messages
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.QuestBlockOnInitializeBottom(questScript)
  InfCore.LogFlow("InfShootingQuest.QuestBlockOnInitializeBottom")
  --REF
  --mvars.qst_questScriptBlockMessageExecTable={
  --  [738746875] = {
  --    [669800987] = {
  --      func = <function 1>
  --    }
  --  },
  --  [2524903270] = {
  --    [166925615] = {
  --      sender = {
  --        [814656445] = <function 2>
  --      },
  --      senderOption = {}
  --    },
  --    [246347329] = {
  --      sender = {
  --        [814656445] = <function 3>
  --      },
  --      senderOption = {}
  --    }
  --  },
  --  [3087473413] = {
  --    [845558693] = {
  --      func = <function 4>
  --    },
  --    [3220759189] = {
  --      sender = {
  --        [2294579761] = <function 5>
  --      },
  --      senderOption = {}
  --    },
  --    [4187264311] = {
  --      func = <function 6>
  --    }
  --  }
  --}
  if mvars.qst_questScriptBlockMessageExecTable then
    if Ivars.quest_enableShootingPracticeRetry:Is(1) then
      --tex kill quests message subscriber so it doesn't interfere with our override (in this.Messages)
      --TODO: generalize this to KillMessage or something
      local PlayerS32=Fox.StrCode32("Player")
      local QuestStartedS32=Fox.StrCode32("QuestStarted")
      local ShootingPracticeS32=Fox.StrCode32("ShootingPractice")
      --REF Tpp.MakeMessageExecTable, mvars.qst_questScriptBlockMessageExecTable
      for messageClassS32,messageNames in pairs(mvars.qst_questScriptBlockMessageExecTable)do
        if messageClassS32==PlayerS32 then
          InfCore.LogFlow("found PlayerS32")--
          for messageNameS32,messageInfo in pairs(messageNames)do
            if messageNameS32==QuestStartedS32 then
              InfCore.LogFlow("found QuestStartedS32")--
              mvars.qst_questScriptBlockMessageExecTable[PlayerS32][QuestStartedS32]=nil
              --            for senderS32,senderInfo in pairs(messageInfo)do
              --              if senderS32==ShootingPracticeS32 then
              --                --DEBUGNOW not finding it
              --                InfCore.LogFlow("found ShootingPracticeS32")
              --                --tex TODO: should really check there is only one sender listed
              --
              --                break
              --              end
              --            end--for messageInfo
            end--if QuestStartedS32
          end--for messageNames
        end--if PlayerS32
      end--for qst_questScriptBlockMessageExecTable
    end--if quest_enableShootingPracticeRetry
  end--if qst_questScriptBlockMessageExecTable
end--QuestBlockOnInitializeBottom

--TODO move to util
function this.BreakDownMs(timeInMs)
  local minutes=math.floor(timeInMs/6e4)
  local seconds=math.floor((timeInMs-minutes*6e4)/1e3)
  local milliseconds=(timeInMs-minutes*6e4)-seconds*1e3
  return minutes,seconds,milliseconds
end
local timeFmt="%d:%02d:%d"
function this.PrintShootingPracticeBestTime(questName)
  local scoreTime=this.GetShootingPracticeTime(questName)

  if not scoreTime then
    InfMenu.PrintLangId("quest_no_best_time")
  else
    --TODO: mvars.gim_questDisplayTimeSec
    -- local parTime=mvars.gim_questDisplayTimeSec*1000
    -- local minutes,seconds,milliseconds=this.BreakDownMs(parTime)
    -- local parTimeStr=format(timeFmt,minutes,seconds,milliseconds)
    --TppUiCommand.AnnounceLogView(InfLangProc.LangString("quest_best_time").."["..bestTimeStr.."/"..parTimeStr.."]")--tex announcelog not up long enough for this to be readable
  
    local minutes,seconds,milliseconds=this.BreakDownMs(scoreTime)
    local bestTimeStr=format(timeFmt,minutes,seconds,milliseconds)

    TppUiCommand.AnnounceLogView(InfLangProc.LangString("quest_best_time").." "..bestTimeStr)
  end
end--PrintShootingPracticeBestTime
--tex Hook of TppRanking.UpdateShootingPracticeClearTime (See InfHooks)
--CALLER: quest script on quest clear
--leftTime in ms
--'best times' are actually time-left in respect to the starting time limit
function this.UpdateShootingPracticeClearTime(questName,leftTime)
  local questAddon=InfQuest.ihQuestsInfo[questName]
  if not questAddon then
    --tex vanilla shootingpractice, since those are backed up by the whole ui and leaderboards don't really want to poke at that at the moment
    TppRanking.UpdateScore(questName,leftTime)
  else

  --  local limitIsBestTime=Ivars.quest_setShootingPracticeTimeLimitToBestTime:Is(1)
  --
  --
  --  local fullTimeLimit=mvars.gim_questDefaultTimeSec or mvars.gim_questDisplayTimeSec
  --  local fullTimeLimit=fullTimeLimit*1000
  --  local currentTimeLimit=mvars.gim_questDisplayTimeSec*1000
  --
  --  local bestTimeLeft=this.GetShootingPracticeTime(questName)
  --  local bestTimeTaken=fullTimeLimit-bestTimeLeft
  --
  --  local currentTimeLeft=leftTime
  --  local currentTimeTaken=currentTimeLimit-currentTimeLeft
  --
  --  --tex leftTime is time left in respect to the 'best time', which is time left of default/full time limit. fun
  --  if limitIsBestTime then
  --    leftTime=fullTimeLimit-(bestTimeTaken+currentTimeTaken)
  --  end

  local questState=ih_quest_states[questName] or {}
  local bestTime=questState.scoreTime or 0--tex
  InfCore.Log("UpdateShootingPracticeClearTime currentBestTime:"..tostring(bestTime).." leftTime:"..tostring(leftTime))--DEBUGNOW
  if leftTime>bestTime then--tex since it's timeleft
    --tex replicate TppRanking.UpdateScore>ShowUpdateScoreAnnounceLog
    TppUI.ShowAnnounceLog"trial_update"
    --tex uhh, I don't see anything print in vanilla between trial_update - announce_trial_update 'New trial record:' and the time?
    --local rankingLangId=this.GetRankingLangId(rankingCategoryEnum)
    --TppUiCommand.AnnounceLogViewLangId(rankingLangId)
    --tex DEBUGNOW TODOif Ivars.quest_showShootingPracticeBestTimeAsTimeTaken -- show as time taken on quest clear message and on announcelog when entering start trap
    --TppRanking._ShowScoreTimeAnnounceLog(currentTimeTaken)
    --else
    TppRanking._ShowScoreTimeAnnounceLog(leftTime)
    
    InfQuest.saveDirty=true
    questState.scoreTime=leftTime
    ih_quest_states[questName]=questState
  end
  end--if not questAddon
end--UpdateShootingPracticeClearTime

--CALLER: TppQuest.StartShootingPractice
--mvars.gim_questDisplayTimeSec,mvars.gim_questCautionTimeSec
function this.OverrideShootingPracticeTime()
  InfCore.LogFlow"OverrideShootingPracticeTime"
  mvars.gim_questDefaultTimeSec=nil
  local scoreTime=this.GetShootingPracticeTime()
  if scoreTime then
    scoreTime=math.ceil(scoreTime/1000)--tex scoreTime is in ms
    if Ivars.quest_setShootingPracticeTimeLimitToBestTime:Is(1) then
      mvars.gim_questDefaultTimeSec=mvars.gim_questDisplayTimeSec--tex added
      --GOTCHA: mvars must be set directly, can't set it on passed in reference
      mvars.gim_questDisplayTimeSec=scoreTime
      mvars.gim_questCautionTimeSec=math.ceil(scoreTime/5)
    elseif Ivars.quest_setShootingPracticeCautionTimeToBestTime:Is(1) then--DEBUGNOW should really just be a mode of quest_setShootingPracticeTimeLimitToBestTime
      mvars.gim_questCautionTimeSec=scoreTime
    end
  end--if scoreTime
end--OverrideShootingPracticeTime

function this.GetShootingPracticeTime(questName)
  questName=questName or TppQuest.GetCurrentQuestName()
  InfCore.Log("GetShootingPracticeTime "..tostring(questName))
  if questName then
    local questState=ih_quest_states[questName]
    if questState then
      InfCore.Log("has questState, scoreTime:"..tostring(questState.scoreTime))
      return questState.scoreTime
    else
      --tex vanilla shootingpractice quests
      local gvarName="rnk_"..questName
      local scoreTime=gvars[gvarName]
      if scoreTime then
        return scoreTime
      end
    end
  end--if questName
end--GetShootingPracticeTime

this.registerIvars={
  "quest_enableShootingPracticeRetry",
  "quest_setShootingPracticeCautionTimeToBestTime",
  "quest_setShootingPracticeTimeLimitToBestTime",
}

this.quest_enableShootingPracticeRetry={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.quest_setShootingPracticeCautionTimeToBestTime={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.quest_setShootingPracticeTimeLimitToBestTime={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.langStrings={
  eng={
    quest_no_best_time="No best time set",
    quest_best_time="Best time",
    quest_enableShootingPracticeRetry="Enable Shooting Practice Retry",
    quest_setShootingPracticeTimeLimitToBestTime="Set Shooting Practice time limit to best time",
    quest_setShootingPracticeCautionTimeToBestTime="Set Shooting Practice caution time to best time",
  },--eng
  help={
    eng={
      quest_enableShootingPracticeRetry="Does not hide the starting point when Shooting Practice starts or finishes, and allows you to cancel while in progress and start again.",
      quest_setShootingPracticeCautionTimeToBestTime="Sets the caution time/time when the timer turns red to the current best time (rounded up to the second) so you have a clearer idea when going for best time.",    
    },
  }--help
}--langStrings

return this
