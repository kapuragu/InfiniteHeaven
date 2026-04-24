Command.StartGroup()
local editor = Editor.GetInstance()
local blendFunction = Command.CreateData( editor,'CustomBlendFunctionData' )
Command.SetProperty{ entity=blendFunction, property="name", value="5x1Function" }

Command.AddPropertyElement{ entity=blendFunction, property="controls" }
local control = blendFunction.controls[1]
Command.SetProperty{ entity=control, property="portName", value="x" }

Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[1]
Command.SetProperty{ entity=item, property="portName", value="X0" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[2]
Command.SetProperty{ entity=item, property="portName", value="X1" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[3]
Command.SetProperty{ entity=item, property="portName", value="X2" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[4]
Command.SetProperty{ entity=item, property="portName", value="X3" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[5]
Command.SetProperty{ entity=item, property="portName", value="X4" }
local param = Command.CreateData( editor,'TppCustomBlendFunctionPlugin_5x1Param' )
Command.SetProperty{ entity=blendFunction, property="pluginParam", value=param }
Command.EndGroup()
