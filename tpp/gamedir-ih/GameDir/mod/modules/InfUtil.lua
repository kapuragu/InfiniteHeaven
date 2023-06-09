-- InfUtil.lua
-- utility function dumping ground
-- should not have any dependancies to Tpp, put that in InfTppUtil
local this={}

function this.ClearTable(_table)
  for k,v in pairs(_table)do
    _table[k]=nil
  end
end
function this.ClearArray(_table)
  for i=0, #_table do
    _table[i]=nil
  end
end

function this.MergeArray(array1,array2)
  for i=0,#array2 do
    array1[#array1+1]=array2[i]
  end
end

function this.TableKeysToArray(inputTable,outputTable)
  outputTable=outputTable or {}
  for k,v in pairs(inputTable)do
    outputTable[#outputTable+1]=k
  end--for inputTable
  return outputTable
end--TableKeysToArray

--https://stackoverflow.com/questions/12394841/safely-remove-items-from-an-array-table-while-iterating
--array to iterate and remove from
--fnKeep: Return true to keep the value, or false to discard it
function this.ArrayRemove(array, fnKeep)
  local j, n = 1, #array;
  for i=1,n do
    if (fnKeep(array, i, j)) then
      -- Move i's kept value to j's position, if it's not already there.
      if (i ~= j) then
        array[j] = array[i];
        array[i] = nil;
      end
      j = j + 1; -- Increment position of where we'll place the next kept value.
    else
      array[i] = nil;
    end
  end
  return array;
end--ArrayRemove

function this.IsTableEmpty(checkTable)
  return next(checkTable)==nil
end

--tex removes fillCount number of items from sourceList and adds to fillList
function this.FillList(fillCount,sourceList,fillList)
  local addedItems={}
  while fillCount>0 and #sourceList>0 do
    local item=sourceList[#sourceList]
    if item then
      sourceList[#sourceList]=nil--pop
      fillList[#fillList+1]=item
      addedItems[#addedItems+1]=item
      fillCount=fillCount-1
    end
  end
  return addedItems
end

function this.CopyList(sourceList)
  if #sourceList==0 then
    return {}
  end

  local newList={}
  for i=1,#sourceList do
    newList[i]=sourceList[i]
  end
  return newList
end
function this.CopyTable(orig)
  local CopyTable=this.CopyTable
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[CopyTable(orig_key)] = CopyTable(orig_value)
    end
    setmetatable(copy, CopyTable(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end--CopyTable

-- https://stackoverflow.com/a/1283608
function this.MergeTable(t1, t2)
  local MergeTable=this.MergeTable
  for k,v in pairs(t2) do
      if type(v) == "table" then
          if type(t1[k] or false) == "table" then
            MergeTable(t1[k] or {}, t2[k] or {})
          else
              t1[k] = v
          end
      else
          t1[k] = v
      end
  end
  return t1
end

-- adpted from lume.find here: https://github.com/rxi/lume/blob/master/lume.lua
function this.FindInTable(t, value)
  local iter = nil
  if type(t) == "table" and t[1] ~= nil then
    iter = ipairs
  elseif type(t) == "table" then
    iter = pairs
  end

  for k, v in iter(t) do
    if v == value then return k end
  end
  return nil
end

function this.SwapEntry(sourceTable,sourceKey,destKey)
  local currentEntry=sourceTable[sourceKey]
  sourceTable[sourceKey]=sourceTable[destKey]
  sourceTable[destKey]=currentEntry
end--SwapEntry

-- Fisher-Yates shuffle, produces new table
-- via: https://stackoverflow.com/a/68486276
function this.ShuffleArray(array)
  local s = {}
  for i = 1, #array do s[i] = array[i] end
  for i = #array, 2, -1 do
      local j = math.random(i)
      s[i], s[j] = s[j], s[i]
  end
  return s
end

--DEBUGNOW is destructive to input table TODO better
function this.RandomizeArray(array)
  if array==nil then
    InfCore.Log("WARNING: RandomizeArray array==nil")
    return nil
  end

  if #array==0 then
    return array
  end

  local randomizedArray={}
  local size=#array
  for i=1,size do
    local index=math.random(#array)
    table.insert(randomizedArray,array[index])
    table.remove(array,index)
  end
  return randomizedArray
end--RandomizeArray

function this.GetRandomPool(pool)
  --DEBUGNOW
  --  if pool==nil or #pool==0 then
  --    return
  --  end
  local rndIndex=math.random(#pool)
  local name=pool[rndIndex]
  table.remove(pool,rndIndex)
  return name
end

function this.GetRandomInList(list)
  if #list==0 then
    return nil
  end
  return list[math.random(#list)]
end

function this.FindInList(list,findValue)
  for i,value in ipairs(list)do
    if value==findValue then
      return i
    end
  end
  return false
end

function this.InsertUniqueInList(list,insertValue)
  local hasValue=false
  for i,value in ipairs(list)do
    if value==insertValue then
      hasValue=true
      break
    end
  end
  if not hasValue then
    table.insert(list,insertValue)
  end
end

function this.WriteLuaList(fileName,lineFormat,list)
  local header='local this={'
  local lineFormat=lineFormat or '"%s",'
  local footer='}\nreturn this'

  local writeStrings={}
  writeStrings[#writeStrings+1]=header
  for i,entry in ipairs(list)do
    writeStrings[#writeStrings+1]=string.format(lineFormat,entry)
  end
  writeStrings[#writeStrings+1]=footer

  local filePath=InfCore.paths.mod..fileName..".lua"
  InfCore.Log("InfUtil.WriteList: "..filePath)
  InfCore.WriteStringTable(filePath,writeStrings)
end

--tex object for returning a random item with no repeats till it's returned all items
this.ShuffleBag={
  currentItem=nil,
  currentPosition=-1,
  data={},
  New=function(self,table)
    local newBag={}
    newBag.currentItem=nil
    newBag.currentPosition=-1
    newBag.data={}

    setmetatable(newBag,self)
    self.__index=self

    if table then
      newBag:Fill(table)
    end

    return newBag
  end,
  Fill=function(self,table,amount)
    local tableTypeStr="table"
    for i=1,#table do
      local item=table[i]
      if type(item)==tableTypeStr then
        self:Add(item[1],item[2])
      else
        self:Add(item,amount)
      end
    end
  end,
  Add=function(self,item,amount)
    local amount=amount or 1
    for i=1,amount do
      self.data[#self.data+1]=item

      self.currentPosition=#self.data
    end
  end,
  Next=function(self)
    --run out, start again
    if self.currentPosition<2 then
      self.currentPosition=#self.data
      self.currentItem=self.data[1]
      return self.currentItem
    end
    --picks between start of array and currentposition, which decreases from end of array
    local pos=math.random(self.currentPosition)

    self.currentItem=self.data[pos]
    self.data[pos]=self.data[self.currentPosition]
    self.data[self.currentPosition]=self.currentItem
    self.currentPosition=self.currentPosition-1

    return self.currentItem
  end,
  Count=function(self)
    return #self.data
  end,
}

--string
--tex NMC from lua wiki
function this.Split(self,sep)
  local sep = sep or " "
  local fields = {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

--tex NMC from lua wiki
--MoonSharp doesn't like gmatch with long strings
function this.SplitAlt(str,delim,maxNb)
  -- Eliminate bad cases...
  if string.find(str,delim)==nil then
    return{str}
  end
  if maxNb==nil or maxNb<1 then
    maxNb=0--No limit
  end
  local result={}
  local pat="(.-)"..delim.."()"
  local nb=0
  local lastPos
  for part,pos in string.gmatch(str,pat) do
    nb=nb+1
    result[nb]=part
    lastPos=pos
    if nb==maxNb then break end
  end
  -- Handle the last field
  if nb~=maxNb then
    result[nb+1]=string.sub(str,lastPos)
  end
  return result
end


function this.FindLast(searchString,findString)
  --Set the third arg to false to allow pattern matching
  local found=searchString:reverse():find(findString:reverse(),nil,true)
  if found then
    return searchString:len()-findString:len()-found+2
  else
    return found
  end
end

--tex ex returns "cm_f0_h2_v000_eye1.fv2" from "/Assets/tpp/fova/common_source/chara/cm_head/face/cm_f0_h2_v000_eye1.fv2"
function this.GetFileName(path,stripExt)
  local lastPos=this.FindLast(path,"/")
  local fileName=string.sub(path,lastPos+1,#path)
  if stripExt then
    local lastPos=this.FindLast(fileName,[[.]])
    fileName=string.sub(fileName,1,lastPos-1)
  end
  return fileName
end

function this.GetFileExtension(path)
  local lastPos=this.FindLast(path,[[.]])
  if lastPos then
    return string.sub(path,lastPos,string.len(path))
  else
    return ""
  end
end

function this.StripExt(fileName)
  local lastPos=this.FindLast(fileName,[[.]])
  return string.sub(fileName,1,lastPos-1)
end

--enumNames: array of enum names in enum order
--enumTable: optional. will add enums to enumTable instead of returning new table. (so you can pass in same table as enumNames to add to that)
function this.EnumFrom0(enumNames,enumTable)
  if type(enumNames)~="table"then
    return
  end
  enumTable=enumTable or {}
  for i=1,#enumNames do
    enumTable[enumNames[i]]=i-1--NMC: lua tables indexed from 1, enums indexed from 0
  end
  return enumTable
end--EnumFrom0
--as above but enums start at 1
function this.EnumFrom1(enumNames,enumTable)
  if type(enumNames)~="table"then
    return
  end  
  enumTable=enumTable or {}
  local enumTable={}
  for i=1,#enumNames do
    enumTable[enumNames[i]]=i
  end
  return enumTable
end--EnumFrom1

function this.GenerateNameList(fmt,num,list)
  local list=list or {}
  for i=0,num-1 do
    local name=string.format(fmt,i)
    table.insert(list,name)
  end
  return list
end

--tex index 0 based
function this.From3Dto1D(x,y,z,xMax,yMax)
  return (z*xMax*yMax)+(y*xMax)+x
end--From3Dto1D
--tex index 0 based
function this.From1Dto3D(idx,xMax,yMax)
  local z=math.floor(idx/(xMax*yMax))
  idx=idx-(z*xMax*yMax)
  local y=math.floor(idx/xMax)
  local x=math.floor(idx%xMax)
  return x,y,z
end--From1Dto3D
--tex index 0 based
function this.From2Dto1D(x,y,xMax)
  return (y*xMax)+x
end--From3Dto1D
--{x,y,z} vectors
function this.YawTowardsLookPos(pos,lookPos)
  local dirVec=Vector3(lookPos[1]-pos[1],0,lookPos[3]-pos[3])
  dirVec=dirVec:Normalize()
  return TppMath.RadianToDegree(foxmath.Atan2(dirVec:GetX(),dirVec:GetZ()))
end

--lua 5.2s pack, could add to table.pack I guess
--http://lua-users.org/wiki/VarargTheSecondClassCitizen
--basically using {...} with any nil args means you cant iterate it
--using this you have the number of args in .n
--so you can iterate with: for 1,args.n : args[i]
function this.pack2(...)
  return {n=select("#",...),...}--tex sure would be nice if you could reuse table mr lua.
end
--t = a .pack2'ed varargs
--better to inline unpack where you can instead of using this, 
--since you can play with the range for stuff like pcall returns
function this.unpack2(t)
  return unpack(t,1,t.n)
end

--tex kind InfLookup stuff
local concat=table.concat
--stringArgs: table to use for stringArgs (opt to avoid creating new)
--though it still creates a table to capture args, not sure how select is at working with varargs
function this.GetArgsString(stringArgs,...)
  local args={...}
  local argsN=select("#",...)--tex gets actual size including nils

  for i=1,(argsN) do
    stringArgs[i]=tostring(args[i])--tex concat doesnt like nil, so need to pack into another table, but at least we can reuse that one
  end
  return concat(stringArgs,",",1,argsN)
end--GetArgsString

--packedReturns: pack2'ed pcall returns - so [1]==pcall success,[2+]==actual returns
function this.GetPCallReturnsStrings(returnStrings,packedReturns)
  for i=1,packedReturns.n do
    returnStrings[i]=tostring(packedReturns[i])
  end
  return concat(returnStrings,",",2,packedReturns.n)--tex 2 skip success in returns[1]
end--GetPCallReturnsStrings

function this.GetIndexFrom1(array)
  if array[0]~=nil then
    return -1
  end
  return 0
end--GetIndexFrom1

--tex only lua from 1 arrays
function this.SetArrayPos(toArray,xOrPos,Y,Z)
  if type(xOrPos)=='table'then
    Z=xOrPos[3]
    Y=xOrPos[2]
    xOrPos=xOrPos[1]
  end
  toArray[1]=xOrPos
  toArray[2]=Y
  toArray[3]=Z
end--SetArrayPos

--tex handles 0 or 1 based vec arrays
--works on scriptvars since its using indexing
--OUT:toArray
function this.SetAnyArrayPos(toArray,xOrPos,Y,Z)
  local x,y,z=xOrPos,Y,Z--tex avoid unnessesary new table
  if type(xOrPos)=='table'then
    local fromIndexShift=this.GetIndexFrom1(xOrPos)
    x=xOrPos[1+fromIndexShift]
    y=xOrPos[2+fromIndexShift]
    z=xOrPos[3+fromIndexShift]
  end

  local toIndexShift=this.GetIndexFrom1(toArray)
  toArray[1+toIndexShift]=x
  toArray[2+toIndexShift]=y
  toArray[3+toIndexShift]=z
end--SetArrayPos

function this.PointOnCircle(origin,radius,angle)
  local x=origin[1]+radius*math.cos(math.rad(angle))
  local y=origin[3]+radius*math.sin(math.rad(angle))
  return {x,origin[2],y}
end

return this
