-- DOBUILD: 0
--InfSplash.lua

local this={}

--splash stuff>
this.oneOffSplashes={
  "startstart",
  "startend",
  "knm",
}
function this.AddOneOffSplash(splashName)
-- this.oneOffSplashes[#this.oneOffSplashes+1]=splashName
end
function this.DeleteOneOffSplashes()
  for n,splashName in pairs(this.oneOffSplashes) do
    this.DeleteSplash(splashName)
  end
  this.oneOffSplashes={}
end

function this.DeleteStartSplashes()
  this.DeleteSplash(this.currentRandomSplash)
  this.DeleteOneOffSplashes()
end


function this.DeleteSplash(splashName)
  if splashName~=nil then
    local splash=SplashScreen.GetSplashScreenWithName(splashName)
    if splash~=nil then
      SplashScreen.Delete(splash)
    end
  end
end

local emblemTypes={
  --{"base",{01,50}},--tex OFF mostly boring
  {"front",{01,85}},
  {"front",{5001,5027}},
  --{"front",{7008,7063}},--tex bunch missing (see DOC), boring emblems anyhoo
  {"front",{
    100,
    110,
    120,
    200,
    210,
    220,
    300,
    400,
    410,
    500,
    510,
    600,
    610,
    700,
    720,
    730,
    800,
    810,
    900,
    1000,
    1100,
    1200,
    1210,
    1220,
    1300,
    1310,
    1410,
    1420,
    1430,
    1500,
    1700,
    1710,
    1800,
    1900,
    1920,
    1940,
    1960,
    2000,
    2010,
    2100,
    2200,
    2210,
    2240,
    2241,
  }},
}

this.currentRandomSplash=nil
--IN: emblemTypes
--OUT: this.oneOffSplashes, this.currentRandomSplash, SplashScreen - a splashscreen
--ASSUMPTION: heavy on emblemTypes data layout assumptions, so if you change it, this do break
function this.CreateRandomEmblemSplash()
  --  if this.currentRandomSplash~=nil then
  --    if SplashScreen.GetSplashScreenWithName(this.currentRandomSplash) then
  --      return
  --    end
  --  end

  local groupNumber=math.random(#emblemTypes)
  local group=emblemTypes[groupNumber]
  local emblemType=group[1]
  local emblemRanges=group[2]
  local emblemNumber
  if #emblemRanges>2 then--tex collection of numbers rather than range
    local randomIndex=math.random(#emblemRanges)
    emblemNumber=emblemRanges[randomIndex]
  else
    emblemNumber=math.random(emblemRanges[1],emblemRanges[2])
  end

  local lowOrHi="h"--tex low is full opaque, i guess for being in background thus 'low' display order, hi is more detailed stencil
  --  if math.random()<0.5 then
  --    lowOrHi="l"
  --  else
  --    lowOrHi="h"
  --  end

  local name=emblemType..emblemNumber

  local path="/Assets/tpp/ui/texture/Emblem/"..emblemType.."/ui_emb_"..emblemType.."_"..emblemNumber.."_"..lowOrHi.."_alp.ftex"
  local randomSplash=SplashScreen.Create(name,path,640,640)

  this.currentRandomSplash=name
  --this.AddOneOffSplash(name)

  --SplashScreen.Show(randomSplash,.2,0.5,.2)
  return randomSplash
end

function this.SplashStateCallback_r(screenId, state)
  if mvars.startHasTitileSeqeunce then
    return
  end

  if state==SplashScreen.STATE_DELETE then
    local newSplash=this.CreateRandomEmblemSplash()
    SplashScreen.SetStateCallback(newSplash, this.SplashStateCallback_r)
    SplashScreen.Show( newSplash, .5, 3, .5)--.5,3,.5)-- 1.0, 4.0, 1.0)
  end
end
--<splash stuff


return this