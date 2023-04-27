--TppException.lua
local this={}
this.MGO_INVITATION_CANCEL_POPUP_ID=5010
this.CLOSE_INIVITATION_CANCEL_POPUP_INTERVAL=1.5
this.PROCESS_STATE=Tpp.Enum{"EMPTY","START","SHOW_DIALOG","SUSPEND","FINISH"}
this.TYPE=Tpp.Enum{
  "INVITATION_ACCEPT",
  "DISCONNECT_FROM_PSN",
  "DISCONNECT_FROM_KONAMI",
  "DISCONNECT_FROM_NETWORK",
  "SESSION_DISCONNECT_FROM_HOST",
  "SIGNIN_USER_CHANGED",
  "INVITATION_PATCH_DLC_CHECKING",
  "INVITATION_PATCH_DLC_ERROR",
  "INVITATION_ACCEPT_BY_OTHER",
  "INVITATION_ACCEPT_WITHOUT_SIGNIN",
  "WAIT_MGO_CHUNK_INSTALLATION"
}
this.GAME_MODE=Tpp.Enum{"TPP","TPP_FOB","MGO"}
this.OnEndExceptionDialog={}
this.mgoInvitationUpdateCount=0
function this.IsDisabledMgoInChinaKorea()
  if(TppGameSequence.GetShortTargetArea()=="ck")then
    if(not TppGameSequence.IsMgoEnabled())then
      return true
    end
  end
  return false
end
this.SHOW_EXECPTION_DIALOG={
  [this.TYPE.INVITATION_ACCEPT]=function()
    this.mgoInvitationUpdateCount=0
    this.mgoInvitationPopupId=nil
    if this.IsDisabledMgoInChinaKorea()then
      return 5013
    elseif TppStory.CanPlayMgo()then
      if this.GetCurrentGameMode()==this.GAME_MODE.TPP_FOB then
        this.mgoInvitationPopupId=this.MGO_INVITATION_CANCEL_POPUP_ID
        return this.MGO_INVITATION_CANCEL_POPUP_ID
      else
        return 5001,Popup.TYPE_TWO_BUTTON,nil,true
      end
    else
      return 5004
    end
  end,
  [this.TYPE.DISCONNECT_FROM_PSN]=function()
    return TppDefine.ERROR_ID.DISCONNECT_FROM_PSN
  end,
  [this.TYPE.DISCONNECT_FROM_KONAMI]=function()
    return TppDefine.ERROR_ID.DISCONNECT_FROM_KONAMI
  end,
  [this.TYPE.DISCONNECT_FROM_NETWORK]=function()
    return TppDefine.ERROR_ID.DISCONNECT_FROM_NETWORK
  end,
  [this.TYPE.SESSION_DISCONNECT_FROM_HOST]=function()
    if this.GetCurrentGameMode()=="TPP"then
      return
    end
    return TppDefine.ERROR_ID.SESSION_DISCONNECT_FROM_HOST
  end,
  [this.TYPE.SIGNIN_USER_CHANGED]=function()
    return TppDefine.ERROR_ID.SIGNIN_USER_CHANGED
  end,
  [this.TYPE.INVITATION_PATCH_DLC_CHECKING]=function()
    return 5100,false,"POPUP_TYPE_NO_BUTTON_NO_EFFECT",nil
  end,
  [this.TYPE.INVITATION_PATCH_DLC_ERROR]=function()
    return 5103
  end,
  [this.TYPE.INVITATION_ACCEPT_BY_OTHER]=function()
    return 5005
  end,
  [this.TYPE.INVITATION_ACCEPT_WITHOUT_SIGNIN]=function()
    return 5012
  end,
  [this.TYPE.WAIT_MGO_CHUNK_INSTALLATION]=function()
    return TppDefine.ERROR_ID.NOW_INSTALLING,Popup.TYPE_ONE_CANCEL_BUTTON
  end}
function this.NoProcessOnEndExceptionDialog()
  if not gvars.canExceptionHandling then
    return this.PROCESS_STATE.SUSPEND
  end
  return this.PROCESS_STATE.FINISH
end
function this.OnEndExceptionDialogForSignInUserChange()
  if not TppSequence.CanHandleSignInUserChangedException()then
    return this.PROCESS_STATE.FINISH
  end
  TppUiStatusManager.SetStatus("All","ABORT")
  TppUI.FinishLoadingTips()
  TppRadio.playingBlackTelInfo=nil
  if not gvars.canExceptionHandling then
    return this.PROCESS_STATE.SUSPEND
  end
  if TppSave.IsSaving()then
    return this.PROCESS_STATE.SUSPEND
  end
  if TppUiCommand.IsShowPopup()then
    TppUiCommand.ErasePopup()
  end
  gvars.isLoadedInitMissionOnSignInUserChanged=true
  this.isLoadedInitMissionOnSignInUserChanged=true
  TppUI.FadeOut(TppUI.FADE_SPEED.FADE_MOMENT,"FadeOutOnEndExceptionDialogForSignInUserChange",nil,{setMute=true})
  FadeFunction.SetFadeCallEnable(false)
  SignIn.SetStartupProcessCompleted(false)
  TppUI.SetFadeColorToBlack()
  StageBlockCurrentPositionSetter.SetEnable(false)
  TppUiCommand.SetLoadIndicatorVisible(true)
  SubtitlesCommand.SetIsEnabledUiPrioStrong(false)
  TppRadio.Stop()
  TppMusicManager.StopMusicPlayer(1)
  TppMusicManager.EndSceneMode()
  TppRadioCommand.SetEnableIgnoreGamePause(false)
  GkEventTimerManager.StopAll()
  Mission.AddFinalizer(function()
    this.waitPatchDlcCheckCoroutine=nil
    TppSave.missionStartSaveFilePool=nil
    TppMission.DisablePauseForShowResult()
    TppVarInit.ClearAllVarsAndSlot()
    TppUiStatusManager.UnsetStatus("All","ABORT")
    FadeFunction.SetFadeCallEnable(true)
  end)
  TppVarInit.StartInitMission()
  return this.PROCESS_STATE.FINISH
end
function this.UpdateMgoInvitationAccept()
  if(this.currentErrorPopupLangId==this.MGO_INVITATION_CANCEL_POPUP_ID)then
    this.mgoInvitationUpdateCount=this.mgoInvitationUpdateCount+Time.GetFrameTime()
    if this.mgoInvitationUpdateCount>this.CLOSE_INIVITATION_CANCEL_POPUP_INTERVAL then
      TppUiCommand.ErasePopup()
    end
  end
end
function this.OnEndExceptionDialogForMgoInvitationAccept()
  if not gvars.canExceptionHandling then
    return this.PROCESS_STATE.SUSPEND
  end
  if this.IsDisabledMgoInChinaKorea()then
    this.CancelMgoInvitation()
    return this.PROCESS_STATE.FINISH
  end
  if not TppStory.CanPlayMgo()then
    this.CancelMgoInvitation()
    return this.PROCESS_STATE.FINISH
  end
  if(this.mgoInvitationPopupId==this.MGO_INVITATION_CANCEL_POPUP_ID)then
    this.CancelMgoInvitation()
    return this.PROCESS_STATE.FINISH
  end
  if TppSave.IsSaving()then
    return this.PROCESS_STATE.SUSPEND
  end
  local select=TppUiCommand.GetPopupSelect()
  if select==Popup.SELECT_OK then
    PatchDlc.StartCheckingPatchDlc()
    if PatchDlc.IsCheckingPatchDlc()then
      local currentGameMod=this.GetCurrentGameMode()
      this.Enqueue(this.TYPE.INVITATION_PATCH_DLC_CHECKING,currentGameMod)
    else
      if PatchDlc.DoesExistPatchDlc()then
        this.CheckMgoChunkInstallation()
      else
        local currentGameMod=this.GetCurrentGameMode()
        this.Enqueue(this.TYPE.INVITATION_PATCH_DLC_ERROR,currentGameMod)
      end
    end
  else
    this.CancelMgoInvitation()
  end
  return this.PROCESS_STATE.FINISH
end
function this.OnEndExceptionDialogForPatchDlcCheck()
  if not gvars.canExceptionHandling then
    return this.PROCESS_STATE.SUSPEND
  end
  if TppSave.IsSaving()then
    return this.PROCESS_STATE.SUSPEND
  end
  if PatchDlc.DoesExistPatchDlc()then
    this.CheckMgoChunkInstallation()
  else
    local n=this.GetCurrentGameMode()
    this.Enqueue(this.TYPE.INVITATION_PATCH_DLC_ERROR,n)
  end
  return this.PROCESS_STATE.FINISH
end
function this.CheckMgoChunkInstallation()
  if Chunk.GetChunkState(Chunk.INDEX_MGO)==Chunk.STATE_INSTALLED then
    this.GoToMgoByInivitaion()
  else
    Tpp.StartWaitChunkInstallation(Chunk.INDEX_MGO)
    local n=this.GetCurrentGameMode()
    this.Enqueue(this.TYPE.WAIT_MGO_CHUNK_INSTALLATION,n)
  end
end
function this.GoToMgoByInivitaion()
  TppPause.RegisterPause"GoToMGO"
  TppGameStatus.Set("GoToMGO","S_DISABLE_PLAYER_PAD")
  this.isNowGoingToMgo=true
  this.fadeOutRemainTimeForGoToMgo=TppUI.FADE_SPEED.FADE_HIGHSPEED
  TppUI.FadeOut(TppUI.FADE_SPEED.FADE_HIGHSPEED,"GoToMgoByInivitaion",nil,{setMute=true})
  FadeFunction.SetFadeCallEnable(false)
end
function this.UpdateMgoChunkInstallingPopup()
  Tpp.ShowChunkInstallingPopup(Chunk.INDEX_MGO,true)
  if Chunk.GetChunkState(Chunk.INDEX_MGO)==Chunk.STATE_INSTALLED then
    TppUiCommand.ErasePopup()
  end
end
function this.OnEndExceptionDialogForPatchDlcError()
  if not gvars.canExceptionHandling then
    return this.PROCESS_STATE.SUSPEND
  end
  Tpp.ClearDidCancelPatchDlcDownloadRequest()
  this.CancelMgoInvitation()
  return this.PROCESS_STATE.FINISH
end
function this.UpdateMgoPatchDlcCheckingPopup()
  if PatchDlc.IsCheckingPatchDlc()then
    TppUI.ShowAccessIconContinue()
    return
  end
  TppUiCommand.ErasePopup()
end
function this.OnEndExceptionDialogForInvitationAcceptFromOther()
  if not gvars.canExceptionHandling then
    return this.PROCESS_STATE.SUSPEND
  end
  this.CancelMgoInvitation()
  return this.PROCESS_STATE.FINISH
end
function this.OnEndExceptionDialogForInvitationAcceptWithoutSignIn()
  if not gvars.canExceptionHandling then
    return this.PROCESS_STATE.SUSPEND
  end
  this.CancelMgoInvitation()
  return this.PROCESS_STATE.FINISH
end
function this.OnEndExceptionDialogForCheckMgoChunkInstallation()
  if not gvars.canExceptionHandling then
    return this.PROCESS_STATE.SUSPEND
  end
  if Chunk.GetChunkState(Chunk.INDEX_MGO)==Chunk.STATE_INSTALLED then
    this.GoToMgoByInivitaion()
  else
    this.CancelMgoInvitation()
  end
  return this.PROCESS_STATE.FINISH
end
function this.CancelMgoInvitation()
  InvitationManager.ResetAccept()
  InvitationManager.EnableMessage(true)
  if Chunk.GetChunkState(Chunk.INDEX_MGO)~=Chunk.STATE_INSTALLED then
    Chunk.SetChunkInstallSpeed(Chunk.INSTALL_SPEED_NORMAL)
  end
end
function this.ForbidFobExceptionHandling()
  mvars.exc_permitFobExceptionHandling=nil
end
function this.PermitFobExceptionHandling()
  mvars.exc_permitFobExceptionHandling=true
end
function this.SuspendFobExceptionHandling()
  mvars.exc_suspendFobExceptionHandling=true
  mvars.exc_permitFobExceptionHandling=nil
end
function this.FobMissionEndOnException()
  if not gvars.canExceptionHandling then
    return this.PROCESS_STATE.SUSPEND
  end
  local n=this.GetCurrentGameMode()
  if n~=this.GAME_MODE.TPP_FOB then
    return this.PROCESS_STATE.FINISH
  end
  if TppSave.IsSaving()then
    return this.PROCESS_STATE.SUSPEND
  end
  if TppMission.IsHelicopterSpace(vars.missionCode)then
    if mvars.exc_permitFobExceptionHandling then
      TppUiCommand.AbortFobMissionPreparation()
    else
      if mvars.exc_suspendFobExceptionHandling then
        return this.PROCESS_STATE.SUSPEND
      else
        return this.PROCESS_STATE.FINISH
      end
    end
  else
    if mvars.exc_permitFobExceptionHandling==nil then
      return this.PROCESS_STATE.SUSPEND
    end
    if TppServerManager.FobIsSneak()then
      TppMission.AbortMissionByMenu()
    else
      TppMission.ReturnToMission{withServerPenalty=true}
    end
  end
  return this.PROCESS_STATE.FINISH
end
this.POPUP_CLOSE_CHECK_FUNC={[this.TYPE.INVITATION_ACCEPT]=this.UpdateMgoInvitationAccept,[this.TYPE.INVITATION_PATCH_DLC_CHECKING]=this.UpdateMgoPatchDlcCheckingPopup,[this.TYPE.WAIT_MGO_CHUNK_INSTALLATION]=this.UpdateMgoChunkInstallingPopup}
this.TPP_ON_END_EXECPTION_DIALOG={[this.TYPE.INVITATION_ACCEPT]=this.OnEndExceptionDialogForMgoInvitationAccept,[this.TYPE.DISCONNECT_FROM_PSN]=this.NoProcessOnEndExceptionDialog,[this.TYPE.DISCONNECT_FROM_KONAMI]=this.NoProcessOnEndExceptionDialog,[this.TYPE.DISCONNECT_FROM_NETWORK]=this.NoProcessOnEndExceptionDialog,[this.TYPE.SESSION_DISCONNECT_FROM_HOST]=this.NoProcessOnEndExceptionDialog,[this.TYPE.SIGNIN_USER_CHANGED]=this.OnEndExceptionDialogForSignInUserChange,[this.TYPE.INVITATION_PATCH_DLC_CHECKING]=this.OnEndExceptionDialogForPatchDlcCheck,[this.TYPE.INVITATION_PATCH_DLC_ERROR]=this.OnEndExceptionDialogForPatchDlcError,[this.TYPE.INVITATION_ACCEPT_BY_OTHER]=this.OnEndExceptionDialogForInvitationAcceptFromOther,[this.TYPE.INVITATION_ACCEPT_WITHOUT_SIGNIN]=this.OnEndExceptionDialogForInvitationAcceptWithoutSignIn,[this.TYPE.WAIT_MGO_CHUNK_INSTALLATION]=this.OnEndExceptionDialogForCheckMgoChunkInstallation}
this.TPP_FOB_ON_END_EXECPTION_DIALOG={[this.TYPE.INVITATION_ACCEPT]=this.OnEndExceptionDialogForMgoInvitationAccept,[this.TYPE.DISCONNECT_FROM_PSN]=this.FobMissionEndOnException,[this.TYPE.DISCONNECT_FROM_KONAMI]=this.FobMissionEndOnException,[this.TYPE.DISCONNECT_FROM_NETWORK]=this.FobMissionEndOnException,[this.TYPE.SESSION_DISCONNECT_FROM_HOST]=this.FobMissionEndOnException,[this.TYPE.SIGNIN_USER_CHANGED]=this.OnEndExceptionDialogForSignInUserChange,[this.TYPE.INVITATION_PATCH_DLC_CHECKING]=this.OnEndExceptionDialogForPatchDlcCheck,[this.TYPE.INVITATION_ACCEPT_BY_OTHER]=this.OnEndExceptionDialogForInvitationAcceptFromOther,[this.TYPE.INVITATION_ACCEPT_WITHOUT_SIGNIN]=this.OnEndExceptionDialogForInvitationAcceptWithoutSignIn,[this.TYPE.WAIT_MGO_CHUNK_INSTALLATION]=this.OnEndExceptionDialogForCheckMgoChunkInstallation}
function this.RegisterOnEndExceptionDialog(gameMode,exceptionDialogTypes)
  this.OnEndExceptionDialog[gameMode]=exceptionDialogTypes
end
this.RegisterOnEndExceptionDialog(this.GAME_MODE.TPP,this.TPP_ON_END_EXECPTION_DIALOG)
this.RegisterOnEndExceptionDialog(this.GAME_MODE.TPP_FOB,this.TPP_FOB_ON_END_EXECPTION_DIALOG)
function this.GetCurrentGameMode()
  if TppSystemUtility.GetCurrentGameMode()=="MGO"then
    return this.GAME_MODE.MGO
  else
    if TppMission.IsFOBMission(vars.missionCode)then
      if TppMission.CheckMissionState(false,false,false,true)then
        return this.GAME_MODE.TPP_FOB
      else
        return this.GAME_MODE.TPP
      end
    else
      if TppServerManager.FobIsSneak()then
        return this.GAME_MODE.TPP_FOB
      end
      if(TppMission.GetNextMissionCodeForEmergency()==50050)then
        return this.GAME_MODE.TPP_FOB
      else
        return this.GAME_MODE.TPP
      end
    end
  end
end
function this.Enqueue(exceptionType,gameMode)
  if not this.TYPE[exceptionType]then
    return
  end
  local currentQueueDepth=gvars.exc_exceptionQueueDepth
  local nextQueueDepth=gvars.exc_exceptionQueueDepth+1
  if nextQueueDepth>=TppDefine.EXCEPTION_QUEUE_MAX then
    return
  end
  if(gvars.exc_processingExecptionType==exceptionType)then
    return
  end
  if this.HasQueue(exceptionType,gameMode)then
    return
  end
  gvars.exc_exceptionQueueDepth=nextQueueDepth
  gvars.exc_exceptionQueue[currentQueueDepth]=exceptionType
  gvars.exc_queueGameMode[currentQueueDepth]=gameMode
end
function this.Dequeue(startDepth)
  local startQueueDepth=startDepth or 0
  if startQueueDepth>gvars.exc_exceptionQueueDepth then
    return
  end
  local exceptionType=gvars.exc_exceptionQueue[startQueueDepth]
  local gameMode=gvars.exc_queueGameMode[startQueueDepth]
  local exceptionQueueDepth=gvars.exc_exceptionQueueDepth
  for i=startQueueDepth,(exceptionQueueDepth-1)do
    gvars.exc_exceptionQueue[i]=gvars.exc_exceptionQueue[i+1]
    gvars.exc_queueGameMode[i]=gvars.exc_queueGameMode[i+1]
  end
  gvars.exc_exceptionQueue[exceptionQueueDepth]=0
  gvars.exc_queueGameMode[exceptionQueueDepth]=0
  gvars.exc_exceptionQueueDepth=exceptionQueueDepth-1
  return exceptionType,gameMode
end
function this.HasQueue(exceptionType,gameMode)
  for i=0,gvars.exc_exceptionQueueDepth do
    if(gvars.exc_exceptionQueue[i]==exceptionType)and((gameMode==nil)or(gvars.exc_queueGameMode[i]==gameMode))then
      return true
    end
  end
  return false
end
function this.StartProcess(exceptionDialogType,gameMode)
  gvars.exc_processState=this.PROCESS_STATE.START
  gvars.exc_processingExecptionType=exceptionDialogType
  gvars.exc_processingExecptionGameMode=gameMode
  local disablePadTypes={
    [this.TYPE.INVITATION_PATCH_DLC_CHECKING]=true,
    [this.TYPE.INVITATION_PATCH_DLC_ERROR]=true,
    [this.TYPE.INVITATION_ACCEPT_BY_OTHER]=true,
    [this.TYPE.INVITATION_ACCEPT_WITHOUT_SIGNIN]=true,
    [this.TYPE.INVITATION_ACCEPT]=true,
    [this.TYPE.WAIT_MGO_CHUNK_INSTALLATION]=true
  }
  if(gameMode==this.GAME_MODE.TPP_FOB)and(disablePadTypes[exceptionDialogType])then
    TppGameStatus.Set("TppException","S_DISABLE_PLAYER_PAD")
  else
    this.EnablePause()
  end
end
function this.FinishProcess()
  gvars.exc_processState=this.PROCESS_STATE.EMPTY
  gvars.exc_processingExecptionType=0
  gvars.exc_processingExecptionGameMode=0
  this.DisablePause()
end
function this.EnablePause()
  TppPause.RegisterPause"TppException.lua"TppGameStatus.Set("TppException","S_DISABLE_PLAYER_PAD")
end
function this.DisablePause()
  TppPause.UnregisterPause"TppException.lua"TppGameStatus.Reset("TppException","S_DISABLE_PLAYER_PAD")
end
this.currentErrorPopupLangId=nil
local switchingToMgo=false
function this.Update()
  if not gvars then
    return
  end
  if this.isNowGoingToMgo then
    if this.fadeOutRemainTimeForGoToMgo~=nil then
      if this.fadeOutRemainTimeForGoToMgo>0 then
        this.fadeOutRemainTimeForGoToMgo=this.fadeOutRemainTimeForGoToMgo-Time.GetFrameTime()
      else
        if not switchingToMgo then
          switchingToMgo=true
          Mission.SwitchApplication"mgo"
        end
      end
    end
    return
  end
  if gvars.isLoadedInitMissionOnSignInUserChanged then
    return
  end
  if gvars.exc_exceptionQueueDepth<=0 and(gvars.exc_processState<=this.PROCESS_STATE.EMPTY)then
    return
  end
  if(gvars.exc_processState>this.PROCESS_STATE.EMPTY)then
    local gameMode=this.GetCurrentGameMode()
    if this.currentErrorPopupLangId and TppUiCommand.IsShowPopup(this.currentErrorPopupLangId)then
      gvars.exc_processState=this.PROCESS_STATE.SHOW_DIALOG
      local PopupCloseCheckFunc=this.POPUP_CLOSE_CHECK_FUNC[gvars.exc_processingExecptionType]
      if PopupCloseCheckFunc then
        PopupCloseCheckFunc()
      end
    else
      this.currentErrorPopupLangId=nil
      local onEndExceptionDialogTypes=this.OnEndExceptionDialog[gameMode]
      if not onEndExceptionDialogTypes then
        this.FinishProcess()
        return
      end
      local exceptionType=onEndExceptionDialogTypes[gvars.exc_processingExecptionType]
      if not exceptionType then
        this.FinishProcess()
        return
      end
      gvars.exc_processState=exceptionType()
      local processState=gvars.exc_processState
      if processState>this.PROCESS_STATE.SHOW_DIALOG then
        this.DisablePause()
      end
      if processState==this.PROCESS_STATE.FINISH then
        this.FinishProcess()
      end
    end
  else
    local exceptionDialogType,gameMode=this.Dequeue()
    this.StartProcess(exceptionDialogType,gameMode)
    local hasType=this.ShowPopup(exceptionDialogType)
    if not hasType then
      this.FinishProcess()
    end
  end
end
function this.ShowPopup(exceptionDialogType)
  local ShowExceptionDialog=this.SHOW_EXECPTION_DIALOG[exceptionDialogType]
  if not ShowExceptionDialog then
    return
  end
  local langId,buttonType,popupType,setSelectNegative=ShowExceptionDialog()
  if not langId then
    return
  end
  if buttonType==nil then
    buttonType=Popup.TYPE_ONE_BUTTON
  end
  if popupType then
    TppUiCommand.SetPopupType(popupType)
  end
  if setSelectNegative then
    TppUiCommand.SetPopupSelectNegative()
  end
  TppUiCommand.ShowErrorPopup(langId,buttonType)
  --tex this calls it langId, but most uses are popupId/ERROR_ID (ala TppDefine.ERROR_ID)?
  --theres likely some enum > landId lookup in the exe
  --o50050_sequence does put langIds into a call to IsShowPopup, so I guess it's both
  this.currentErrorPopupLangId=langId
  return true
end
function this.OnAllocate(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.OnReload(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.Messages()
  return Tpp.StrCode32Table{
    Network={
      {msg="InvitationAccept",func=this.OnInvitationAccept},
      {msg="DisconnectFromPsn",func=this.OnDisconnectFromPsn},
      {msg="DisconnectFromKonami",func=this.OnDisconnectFromKonami},
      {msg="DisconnectFromNetwork",func=this.OnDisconnectFromNetwork},
      {msg="SignInUserChanged",func=this.SignInUserChanged},
      {msg="InvitationAcceptByOther",func=this.OnInvitationAcceptByOther},
      {msg="InvitationAcceptWithoutSignIn",func=this.OnInvitationAcceptWithoutSignIn}
    },
    Nt={
      {msg="SessionDisconnectFromHost",func=this.OnSessionDisconnectFromHost},
      {msg="SessionDeleteMember",func=function()
        if TppServerManager.FobIsSneak()then
          local popupId=4181
          TppUiCommand.ShowErrorPopup(popupId)
        end
      end}
    },
    Dlc={{msg="DlcStatusChanged",func=this.OnDlcStatusChanged}}}
end
function this.OnInvitationAccept()
  local n=this.GetCurrentGameMode()
  this.Enqueue(this.TYPE.INVITATION_ACCEPT,n)
  this.Update()
end
function this.OnDisconnectFromPsn()
  local n=this.GetCurrentGameMode()
  this.Enqueue(this.TYPE.DISCONNECT_FROM_PSN,n)
  this.Update()
end
function this.OnDisconnectFromKonami()
  local gameMode=this.GetCurrentGameMode()
  this.Enqueue(this.TYPE.DISCONNECT_FROM_KONAMI,gameMode)
  this.Update()
end
function this.OnDisconnectFromNetwork()
  local n=this.GetCurrentGameMode()
  this.Enqueue(this.TYPE.DISCONNECT_FROM_NETWORK,n)
  this.Update()
end
function this.OnSessionDisconnectFromHost()
  local n=this.GetCurrentGameMode()
  this.Enqueue(this.TYPE.SESSION_DISCONNECT_FROM_HOST,n)
  this.Update()
end
function this.SignInUserChanged()
  if not TppSequence.CanHandleSignInUserChangedException()then
    return
  end
  if this.isNowGoingToMgo then
    return
  end
  TppSave.ForbidSave()
  while TppSave.IsEnqueuedSaveData()do
    TppSave.DequeueSave()
  end
  InvitationManager.EnableMessage(false)
  local n=this.GetCurrentGameMode()
  this.Enqueue(this.TYPE.SIGNIN_USER_CHANGED,n)
  this.Update()
end
function this.OnInvitationAcceptByOther()
  local n=this.GetCurrentGameMode()
  this.Enqueue(this.TYPE.INVITATION_ACCEPT_BY_OTHER,n)
  this.Update()
end
function this.OnInvitationAcceptWithoutSignIn()
  local n=this.GetCurrentGameMode()
  this.Enqueue(this.TYPE.INVITATION_ACCEPT_WITHOUT_SIGNIN,n)
  this.Update()
end
function this.OnDlcStatusChanged()
  if vars.missionCode==TppDefine.SYS_MISSION_ID.INIT then
    return
  end
  local popupId=8014
  if gvars.ini_isTitleMode then
    popupId=8013
  end
  if TppUiCommand.IsShowPopup(popupId)then
  else
    TppUiCommand.ShowErrorPopup(popupId,Popup.TYPE_ONE_BUTTON)
  end
end
local exceptionMessageHandler={}
function exceptionMessageHandler.Update()
  this.Update()
end
function exceptionMessageHandler:OnMessage(sender,messageId,arg0,arg1,arg2,arg3)
  local strLogText
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOptionWhileLoading,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end
ScriptUpdater.Create("exceptionMessageHandler",exceptionMessageHandler,{"Network","Nt","UI","Dlc"})
return this
