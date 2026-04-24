Command.StartGroup()
local editor = Editor.GetInstance()
local blendFunction = Command.CreateData( editor,'CustomBlendFunctionData' )
Command.SetProperty{ entity=blendFunction, property="name", value="9x3Function" }

Command.AddPropertyElement{ entity=blendFunction, property="controls" }
local control = blendFunction.controls[1]
Command.SetProperty{ entity=control, property="portName", value="x" }
Command.AddPropertyElement{ entity=blendFunction, property="controls" }
control = blendFunction.controls[2]
Command.SetProperty{ entity=control, property="portName", value="y" }

Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[1]
Command.SetProperty{ entity=item, property="portName", value="X0_Y0" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[2]
Command.SetProperty{ entity=item, property="portName", value="X0_Y1" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[3]
Command.SetProperty{ entity=item, property="portName", value="X0_Y2" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[4]
Command.SetProperty{ entity=item, property="portName", value="X1_Y0" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[5]
Command.SetProperty{ entity=item, property="portName", value="X1_Y1" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[6]
Command.SetProperty{ entity=item, property="portName", value="X1_Y2" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[7]
Command.SetProperty{ entity=item, property="portName", value="X2_Y0" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[8]
Command.SetProperty{ entity=item, property="portName", value="X2_Y1" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[9]
Command.SetProperty{ entity=item, property="portName", value="X2_Y2" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[10]
Command.SetProperty{ entity=item, property="portName", value="X3_Y0" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[11]
Command.SetProperty{ entity=item, property="portName", value="X3_Y1" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[12]
Command.SetProperty{ entity=item, property="portName", value="X3_Y2" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[13]
Command.SetProperty{ entity=item, property="portName", value="X4_Y0" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[14]
Command.SetProperty{ entity=item, property="portName", value="X4_Y1" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[15]
Command.SetProperty{ entity=item, property="portName", value="X4_Y2" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[16]
Command.SetProperty{ entity=item, property="portName", value="X5_Y0" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[17]
Command.SetProperty{ entity=item, property="portName", value="X5_Y1" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[18]
Command.SetProperty{ entity=item, property="portName", value="X5_Y2" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[19]
Command.SetProperty{ entity=item, property="portName", value="X6_Y0" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[20]
Command.SetProperty{ entity=item, property="portName", value="X6_Y1" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[21]
Command.SetProperty{ entity=item, property="portName", value="X6_Y2" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[22]
Command.SetProperty{ entity=item, property="portName", value="X7_Y0" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[23]
Command.SetProperty{ entity=item, property="portName", value="X7_Y1" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[24]
Command.SetProperty{ entity=item, property="portName", value="X7_Y2" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[25]
Command.SetProperty{ entity=item, property="portName", value="X8_Y0" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[26]
Command.SetProperty{ entity=item, property="portName", value="X8_Y1" }
Command.AddPropertyElement{ entity=blendFunction, property="items" }
local item = blendFunction.items[27]
Command.SetProperty{ entity=item, property="portName", value="X8_Y2" }
local param = Command.CreateData( editor,'TppCustomBlendFunctionPlugin_9x3Param' )
Command.SetProperty{ entity=blendFunction, property="pluginParam", value=param }
Command.EndGroup()
