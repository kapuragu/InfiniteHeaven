--DebugText.lua
--tex manually mocked module
--actual is some kind of dev module thats not in retail
--and while a bunch of the references in lua have been replaced with (nil),
--theres still a few around in init mission scripts
--so we'll mock it up so we can log it

local spamReduction=true

local this={}
local lastMessage=nil
local lastMessage2=nil
local repeatMessageCount=0
local repeatMessageCount2=0
local white={1,1,1}

this.NewContext=function() return{} end

--REF DebugText.Print(NewContext,{.5,.5,1},"LuaMission RES.hitRatio");
--REF DebugText.Print(NewContext,"vars.playerShootCountInMission = "..tostring(vars.playerShootCountInMission));
--tex doesnt seem to be any other variations than above, but we'll varargs anyway
--just assuming the table in param2 is rgb color
--OUT: lastMessage, repeatMessageCount
this.Print=function(context,colorOrMessage,message2,...)
  if not InfCore.debugMode then
    return
  end

  local color=white
  local message=colorOrMessage
  if type(colorOrMessage)=='table'then
    color=colorOrMessage
    message=message2
  end
  --tex spam reduction, kjp liked to put it in update calls, I guess it was an onscreen display rather than log?
  --only handles up to 2 .Prints in an update, but thats the max done in vanilla
  if message==lastMessage and spamReduction then
   repeatMessageCount=repeatMessageCount+1
  elseif message==lastMessage2 and spamReduction then
   repeatMessageCount2=repeatMessageCount2+1
  else
    --tex only logs when message actually changes, so not indictative when last repeated, 
    --and will eat the last repeat message if there's no following change
    --but whatever
    if spamReduction then
      if repeatMessageCount>0 then
        InfCore.Log("DebugText.Print: previous message '"..lastMessage.."' repeated #"..repeatMessageCount.." times")
      end
      if repeatMessageCount2>0 then
        InfCore.Log("DebugText.Print: 2nd previous message '"..lastMessage2.."' repeated #"..repeatMessageCount2.." times")
      end
      repeatMessageCount=0
      repeatMessageCount2=0
      lastMessage2=lastMessage
      lastMessage=message
    end--if spamReduction

    InfCore.Log("DebugText.Print: "..message)
    local varArgs=InfUtil.pack2(...)
    if varArgs.n>0 then
      local argsStr=""
      for i=1,varArgs.n do
        argsStr=argsStr..tostring(varArgs[i])..","
      end
      InfCore.Log("!! DebugText.Print has varArgs: "..argsStr)
    end--if varArgs
  end--if ~= lastMessage
end--Print

return this