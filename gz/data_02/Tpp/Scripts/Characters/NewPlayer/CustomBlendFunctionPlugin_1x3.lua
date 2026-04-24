Command.StartGroup()
local editor = Editor.GetInstance()
local blendFunction = Command.CreateData( editor,'CustomBlendFunctionData' )
Command.SetProperty{ entity=blendFunction, property="name", value="1x3Function" }

Command.AddPropertyElement{ entity=blendFunction, property="controls" }
local control = blendFunction.controls[1]
Command.SetProperty{ entity=control, property="portName", value="y" }

Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[1]
Command.SetProperty{ entity=item, property="portName", value="Y0" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[2]
Command.SetProperty{ entity=item, property="portName", value="Y1" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[3]
Command.SetProperty{ entity=item, property="portName", value="Y2" }
local param = Command.CreateData( editor,'TppCustomBlendFunctionPlugin_1x3Param' )
Command.SetProperty{ entity=blendFunction, property="pluginParam", value=param }
Command.EndGroup()
