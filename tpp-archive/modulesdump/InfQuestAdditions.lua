--DEBUGWIP
function this.PostAllModulesLoad()
  --tex since we're outright replacing it dont have to faff around with keeping the original like we wood with a hook
  --DEBUGWIP TppQuest.CheckQuestAllTarget=this.CheckQuestAllTarget
end

--tex replacement for TppEnemy.CheckQuestAllTarget, replaced in postallmodulesload
--NMC Called from quest script on various elimination msgs, or on quest deactivate
--cant see any calls using param5
function this.CheckQuestAllTarget(questType,messageId,gameId,questDeactivate,param5)
  InfCore.LogFlow("CheckQuestAllTarget")
  return InfCore.PCallDebug(function(questType,messageId,gameId,questDeactivate,param5)--DEBUG
    local clearType=TppDefine.QUEST_CLEAR_TYPE.NONE
    local deactivating=questDeactivate or false
    local _param5=param5 or false
    local inTargetList=false
    local totalTargets=0
    local countIncreased=true
    local RENAMEsomeBool=false
    local currentQuestName=TppQuest.GetCurrentQuestName()
    if TppQuest.IsEnd(currentQuestName)then
      return clearType
    end
    if mvars.ene_questTargetList[gameId]then
      local targetInfo=mvars.ene_questTargetList[gameId]
      if targetInfo.messageId~="None"and targetInfo.isTarget==true then
        RENAMEsomeBool=true
      elseif targetInfo.isTarget==false then
        RENAMEsomeBool=true
      end
      targetInfo.messageId=messageId or"None"
      inTargetList=true
    end
    if(deactivating==false and _param5==false)and inTargetList==false then
      return clearType
    end

    local targetStatusTypes={
      "Fulton",
      "InHelicopter",
      "FultonFailed",
      "Dead",
      "VehicleBroken",
      "LostControl",
      "Vanished",
    }

    local statusCounts={}
    for i,statusType in ipairs(targetStatusTypes)do
      statusCounts[statusType]=0
    end

    for targetGameId,targetInfo in pairs(mvars.ene_questTargetList)do
      local RENAMEsomebool2=false--NMC: this is never set true?
      local isTarget=targetInfo.isTarget or false

      if deactivating==true then
        if Tpp.IsSoldier(targetGameId)or Tpp.IsHostage(targetGameId)then
          if this.CheckQuestDistance(targetGameId)then
            targetInfo.messageId="Fulton"
            fultonedCount=fultonedCount+1--DEBUGNOW account for this
            RENAMEsomebool2=false
            countIncreased=true
          end
        end
      end

      if isTarget==true then
        if RENAMEsomebool2==false then
          local targetMessageId=targetInfo.messageId
          if targetMessageId~="None"then
            for i,countType in ipairs(targetStatusTypes)do
              if targetMessageId==countType then
                targetStatusTypes[countType]=targetStatusTypes[countType]+1
                countIncreased=true
              end
            end
          end
          if deactivating==true then
            countIncreased=false
          end
        end
        totalTargets=totalTargets+1
      end
    end
    if RENAMEsomeBool==true then
      countIncreased=false
    end

    local clearTypes={
      "CLEAR",--tex UPDATE is just a case of CLEAR
      "FAILURE",
    }

    local questTypeRules={
      [TppDefine.QUEST_TYPE.RECOVERED]={
        --sum > totaltargets - Clear, else sum > 0 Update
        CLEAR={
          "Fulton",
          "InHelicopter",
        },
        --any > 0
        FAILURE={
          "FultonFailed",
          "Dead",
          "VehicleBroken",
          "LostControl",
        },
      },

      [TppDefine.QUEST_TYPE.ELIMINATE]={
        CLEAR={
          "Fulton",
          "InHelicopter",
          "FultonFailed",
          "Dead",
          "VehicleBroken",
          "LostControl",
        },
      },

      [TppDefine.QUEST_TYPE.MSF_RECOVERED]={
        --sum > totaltargets - Clear
        CLEAR={
          "Fulton",
          "InHelicopter",
        },
        --any > 0
        FAILURE={
          "FultonFailed",
          "Dead",
          "VehicleBroken",
          "LostControl",
          "Vanished",
        },
      },

      --DEBUGNOW TODO
      --      [TppDefine.QUEST_TYPE.ANIMAL_RECOVERED]={
      --        CLEAR={
      --          "Fulton",
      --        },
      --        FAILURE={
      --          "FultonFailed",
      --          "Dead",
      --        },
      --      },

--      [TppDefine.QUEST_TYPE.GIMMICK_RECOVERED]={
--        CLEAR={
--          "Recovered",
--        },
--        FAILURE={
--        },
--      },
--      [TppDefine.QUEST_TYPE.DEVELOP_RECOVERED]={
--        CLEAR={
--          "Recovered",
--        },
--        FAILURE={
--        },
--      },
--      [TppDefine.QUEST_TYPE.SHOOTING_PRACTIVE]={
--        CLEAR={
--          "Break",
--        },
--        FAILURE={
--        },
--      },
    }

    local clearCounts={}
    for i,clearType in ipairs(clearTypes)do
      clearCounts[clearType]=0
    end

    if totalTargets>0 then
      local clearRules=questTypeRules[questType]
      if not clearRules then
        InfCore.Log("TppQuest.CheckQuestAllTarget: WARNING: could not find questType "..tostring(questType).." in clearRules")
      else
        for clearType,statusTypes in pairs(clearRules)do
          for i,statusType in ipairs(statusTypes)do
            clearCounts[clearType]=clearCounts[clearType]+1
          end
        end

        if clearCounts.CLEAR>=totalTargets then
          clearType=TppDefine.QUEST_CLEAR_TYPE.CLEAR
        elseif clearRules.FAILURE and clearCounts.FAILURE>0 then
          clearType=TppDefine.QUEST_CLEAR_TYPE.FAILURE
        elseif clearCounts.CLEAR>0 and countIncreased then
          clearType=TppDefine.QUEST_CLEAR_TYPE.UPDATE
        end
      end
    end
    if _param5==true then
      if clearType==TppDefine.QUEST_CLEAR_TYPE.NONE or clearType==TppDefine.QUEST_CLEAR_TYPE.UPDATE then
        clearType=TppDefine.QUEST_CLEAR_TYPE.NONE
      end
    end
    return clearType
  end,questType,messageId,gameId,questDeactivate,param5)--DEBUG
end