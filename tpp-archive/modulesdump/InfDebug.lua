-- DOBUILD: 0 -- CULL
-- InfDebug.lua
local this={}

function this.PrintGlobals()
  local globals=""
  for k,v in pairs(_G) do
    globals=globals..tostring(k)..":"..tostring(v).."\n"
  end
  InfCore.DebugPrint(globals)
end

function this.locals()
  local variables = {}
  local idx = 1
  while true do
    local ln, lv = debug.getlocal(2, idx)
    if ln ~= nil then
      variables[ln] = lv
    else
      break
    end
    idx = 1 + idx
  end
  return variables
end

function this.upvalues()
  local variables = {}
  local idx = 1
  local func = debug.getinfo(2, "f").func
  while true do
    local ln, lv = debug.getupvalue(func, idx)
    if ln ~= nil then
      variables[ln] = lv
    else
      break
    end
    idx = 1 + idx
  end
  return variables
end

--


local function ErrorCallBack(err)
  --return debug.traceback(err)
  InfCore.DebugPrint(err)
end
--TODO
--
--do
--  local real_xpcall = xpcall
--  function xpcall(func, err, ...)
--  
--    return real_xpcall(function() return func(...) end, err)
--  end
--end
--
-- xpcall(function () func(...) end, err)

--function this.TryFuncDebug(Func,...)
--  if ivars.debugMode==0 then
--    return Func(...)
--  end
--
--  if Func==nil then
--    InfCore.DebugPrint("TryFunc func == nil")
--    return
--  elseif type(Func)~="function" then
--    InfCore.DebugPrint("TryFunc func~=function")
--    return
--  end
--
--  local success, ret
--  if arg then
--    success,ret=xpcall(function() return Func(unpack(arg)) end,ErrorCallBack)
--  else
--    success,ret=xpcall(function() return Func() end,ErrorCallBack)
--  end
--
--  if success then
--    return ret
--  else
--
--  end
--end

--usage print(GetArgs(func))
function this.GetArgs(func)
  local args = {}
  local hook = debug.gethook()

  local argHook = function( ... )
    local info = debug.getinfo(3)
    if 'pcall' ~= info.name then return end

    for i = 1, math.huge do
      local name, value = debug.getlocal(2, i)
      if '(*temporary)' == name then
        debug.sethook(hook)
        error('')
        return
      end
      table.insert(args,name)
    end
  end

  debug.sethook(argHook, "c")
  pcall(func)

  return args
end



return this