-- DOBUILD: 0
-- tex patch functions
local this={}

function this.QuietReturn()--tex
  if TppStory.IsMissionCleard(10260) then
    -- if gvars.str_didLostQuiet then
    --if TppBuddyService.CheckBuddyCommonFlag(BuddyCommonFlag.BUDDY_QUIET_LOST)then
      local staffId=TppMotherBaseManagement.GenerateStaffParameter{staffType="Unique",uniqueTypeId=TppMotherBaseManagementConst.STAFF_UNIQUE_TYPE_ID_QUIET}
      --if not TppMotherBaseManagement.IsExistStaff{staffId=q}then
        TppMotherBaseManagement.DirectAddStaff{staffId=staffId}
        -- ,section="Wait",isNew=true,specialContract="fromExtra"} --tex nothing seems to work, some kind of internal check in directaddstaff i guess
        -- specialContract="fromGZ"
      --end
      
      gvars.str_didLostQuiet=false
      TppBuddyService.SetObtainedBuddyType(BuddyType.QUIET)
      TppBuddy2BlockController.SetObtainedBuddyType(BuddyType.QUIET)
      TppBuddyService.UnsetBuddyCommonFlag(BuddyCommonFlag.BUDDY_QUIET_DYING)
      TppBuddyService.UnsetBuddyCommonFlag(BuddyCommonFlag.BUDDY_QUIET_LOST)
      TppBuddyService.UnsetBuddyCommonFlag(BuddyCommonFlag.BUDDY_QUIET_HOSPITALIZE)
      TppBuddyService.UnsetDeadBuddyType(BuddyType.QUIET)
      TppBuddyService.SetSortieBuddyType(BuddyType.QUIET)
      TppBuddyService.SetFriendlyPoint(BuddyFriendlyType.QUIET,100)
      TppMotherBaseManagement.RefreshQuietStatus()
    --end
  end
end
function this.Seq_Demo_RecoverVolgin_OnEnter_Patch()--tex patchup shit
--tex ORIG: /Assets/tpp/level/mission2/free/f3020_sequence.lua - sequences.Seq_Demo_RecoverVolgin.OnEnter
  --tex NMC: looks like kjp had attempted some fallback for if sequence was repeated after completed, just no playing demo, trouble is the previous sequence that sets up the player in an unplayble state
  --if this.isRecoverVolginDemoPlay() then
    --Fox.Log("######## Seq_Demo_RecoverVolgin.OnEnter ########")
    TppUiCommand.AnnounceLogView"DBG:Seq_Demo_RecoverVolgin_OnEnter_Patch"
    
    mvars.isPlayVolginDemo = true
    local startFunc = function()
    end
    local endFunc = function()
      TppSequence.SetNextSequence("Seq_Game_MainGame")
    end
    
    TppDemo.SpecifyIgnoreNpcDisable( {"hos_volgin_0000",} )--(VOLGIN_DEMO_GROUP) 
    
    f30250_demo.PlayRecoverVolgin( startFunc, endFunc )
  ---else
    --TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "FadeInOnGameStart")
    --TppMain.EnableGameStatus()  
    --TppSequence.SetNextSequence("Seq_Game_MainGame")
  --end
end
function this.PatchSequenceTable()
--tex OFF: no luck so far
--  if vars.missionCode==30250 then
--    if mvars.seq_sequenceTable["Seq_Demo_RecoverVolgin"] ~= nil then
--      mvars.seq_sequenceTable["Seq_Demo_RecoverVolgin"].OnEnter=this.Seq_Demo_RecoverVolgin_OnEnter_Patch
--    end
--  end
end

return this