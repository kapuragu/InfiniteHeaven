--LEGACY GZ
CameraAroundParams = {
Definitions = {
	ActionList = {		
		"ACT_Stand",
		"ACT_Squat",
		"ACT_Crawl",
		"ACT_BehindStand",
		"ACT_BehindSquat",
		"ACT_DashMove",
		"ACT_Elude",
		"ACT_EludePeepingZoom",
		"ACT_HorseDefault",
		"ACT_HorseRideOff",
		"ACT_StrykerDefault",
		"ACT_CombatVehicleRideOn",
		"ACT_CombatVehicleRideOff",
		"ACT_CqcDefault",
		"ACT_CqcSquat",	
		"ACT_CqcToHold",
		"ACT_VehicleDefault",
		"ACT_LightVehicleDefault",
		"ACT_LightVehicleRideOff",

		
		"ACT_TruckDefault",
		
		"ACT_TruckRideOff",

		
		"ACT_HeliDefault",
		
		"ACT_HeliDead",

		
		"ACT_MgmDefault",

		
		"ACT_HorseVolginChase",
		
		
		"ACT_TimeCigarette",

		
		"ACT_TruckDeck",
		"ACT_TruckDeckPeepingZoom",
		"ACT_TruckDeckCrawl",
		"ACT_TruckDeckOff",

		
		"ACT_Picking",
		
		"ACT_PushButton",

		
		"ACT_BehindStandEdgeZoom",
		
		"ACT_BehindSquatEdgeZoom",
		
		"ACT_BehindSquatPeepingUpZoom",
	},
	
},

BasicParams = {
	DefaultParam = {
		distance				= 5.1,
		offset				= Vector3( -0.30, 0.7, 0.0 ),
		rotXMin				= -60,
		rotXMax				= 80,
		rotVelMaxX			= 80,
		rotVelMaxY			= 160,
		rotVelAccelFrame		= 10,
		rotVelFadeFrame		= 10,
		focalLength			= 21,
		offsetInterpTime		= 0.3,
		distanceInterpTime	= 0.3,
		focalLengthInterpTime	= 0.3,
		attachType			= "None",
		focusDistance = 8.75,
		focusDistanceInterpTime = 0.3,
		aperture					= 1.875,
		apertureInterpTime		= 0.3,
		defaultRotXAngle			= 5,
		correctAimOffsetX			= 10,
		correctAimOffsetY			= 15,
		rotationCorrectInvalidTime	= 2,
		correctPosSpeedRate		= 1.0,
		correctRotInterpTimeMin	= 1.5,
		correctRotInterpTimeMax	= 5,
		corectAimOffsetYExcessRate	= 0.1,
		effectiveFocalLengthRatioFromDemo = -2.0,
		focalLengthInterpTimeFromDemo = 0.0,
		PresetDefault = {
			{
				
				presetName	= "Indoor",
			
				
				distance				= 2.9,
			
				
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				
				focalLength			= 18,
			},

			
			{
				presetName	= "watchtower",
				distance	= 3.0,
				offset		= Vector3( -0.3, 0.3, 0 ),
			},
			
			
			{
				
				presetName	= "hospital",
			
				
				distance				= 1.5,
			
				
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				
				focalLength			= 18,
			},
			
			
			{
				
				presetName	= "hospital_poster_constcam",
			
				
				distance				= 1.5,
			
				
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				
				focalLength			= 18,
			},
			
			
			{
				
				presetName	= "hospital_smoke_room",
			
				
				distance				= 2.9,
			
				
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				
				focalLength			= 18,
			},
			
			
			{
				
				presetName	= "hospital_murder_collidor",
			
				
				distance				= 2.9,
			
				
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				
				focalLength			= 18,
			},
			
			
			{
				
				presetName	= "hospital_curtain_room",
			
				
				distance				= 2.9,
			
				
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				
				focalLength			= 18,
			},
			
			
			
			{
				
				presetName	= "hospital_entrance",
			
				
				distance				= 1.5,
			
				
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				
				focalLength			= 18,
			},			
			
			{
				
				presetName	= "homage",
			
				
				distance			= 12,
				
				rotXMin				= 64,
				
				rotXMax				= 65,
			},
			
			{
				
				presetName	= "gntn_000",
				
				
				distance				= 3.55,
				
				offset			= Vector3( -0.15, 0.55, 0.0 ),
			},	
			
			{
				
				presetName	= "gntn_001",
				
				
				distance				= 3.0,
				
				offset			= Vector3( -0.30, 0.30, 0.0 ),
			},	
			
			{
				
				presetName	= "gntn_002",
				
				
				distance				= 3.95,
				
				offset			= Vector3( -0.30, 0.5, 0.0 ),
			},	
		},
	},
	

	
	Params = {

	
	
	
		
		
		{
			actionName	= "ACT_Stand",
		},
		
		
		{
			actionName	= "ACT_Squat",
		
			
			distance				= 3.25,	
			
			offset			= Vector3(-0.30, 0.2, 0.0 ),
		},

		
		{
			actionName	= "ACT_Crawl",
			
			
			distance			= 2.5,
			
			offset			= Vector3(-0.30, 0.2, 0.0 ),
		},

		
		{
			actionName	= "ACT_BehindStand",
			
			offsetInterpTime		= 1.0,
			
			distance			= 4.5,
			
			offset			= Vector3( -0.6, 0.5, 0.0 ),
		},

		
		{
			actionName	= "ACT_BehindSquat",
			
			offsetInterpTime		= 1.0,
			
			distance			= 4.5,
			
			offset			= Vector3( -0.6, 0.45, 0.0 ),
		},

		
		
		{
			actionName	= "ACT_DashMove",
			
			
			distance			= 3.5,
			
			offset			= Vector3( -0.30, 0.325, 0.0 ),
		},
		
		
		{
			actionName	= "ACT_Elude",
			
			
			distance				= 4.0,	
			
			offset			= Vector3(-0.30, 0.3, 0.0 ),
		},
		
		
		{
			actionName	= "ACT_EludePeepingZoom",
			
			
			distance				= 4.0,	
			
			offset			= Vector3(-0.30, 0.7, 0.0 ),
		},
		
		
		{
			actionName	= "ACT_HorseDefault",
			
			
			distance				= 7.0,
			
			offset				= Vector3( -0.5, -0.4, 0.0 ),
			
			offsetInterpTime		= 1.5,
			
			distanceInterpTime	= 1.5,
		},
		
		
		{
			actionName	= "ACT_HorseRideOff",
			
			
			offsetInterpTime		= 1.76,
			
			
			distanceInterpTime	= 1.76,
		},
		
		
		{
			actionName	= "ACT_StrykerDefault",

			attachType = "Manual",
			
			
			distance				= 10.0,
			
			offset				= Vector3( 0.0, 0.0, 0.0 ),
			
			focalLength			= 18,
			
			defaultRotXAngle			= 8,
			
			rotXMin				= -30,
			
			offsetInterpTime		= 1.0,
			
			distanceInterpTime	= 1.0,
			
			focalLengthInterpTime	= 1.0,
			
			correctAimOffsetY			= 16,
			
			correctRotInterpTimeMin	= 0.6,
			
			rotationCorrectInvalidTime	= 0.85,
			
			rotVelMaxX			= 40,
			
			rotVelMaxY			= 80,
		},

		
		{
			actionName	= "ACT_CombatVehicleRideOn",

			attachType = "Manual",
			
			
			distance				= 10.0,
			
			offset				= Vector3( 0.0, 0.0, 0.0 ),
			
			focalLength			= 18,
			
			defaultRotXAngle			= 8,
			
			rotXMin				= -30,
			
			offsetInterpTime		= 1.0,
			
			distanceInterpTime	= 1.0,
			
			focalLengthInterpTime	= 1.0,
			
			correctAimOffsetY			= 16,
			
			correctRotInterpTimeMin	= 0.6,
			
			rotationCorrectInvalidTime	= 0.85,

		},
		
		
		{
			actionName	= "ACT_CombatVehicleRideOff",
			
			distanceInterpTime	= 2.0,
			
			offsetInterpTime		= 3.0,
		},
		
		
		{
			actionName	= "ACT_VehicleDefault",
			
			attachType			= "Manual",
		},

		
		{
			actionName	= "ACT_LightVehicleDefault",
			
			attachType			= "Manual",

			
			offset				= Vector3( 0.0, -0.5, 0.0 ),
			
			distance				= 6.0,
			
			defaultRotXAngle			= 10,
			
			correctAimOffsetY			= 8,
			
			correctRotInterpTimeMin	= 0.6,
			
			rotationCorrectInvalidTime	= 0.85,
		},

		
		{
			actionName	= "ACT_LightVehicleRideOff",
			
			attachType			= "Manual",

			
			offset				= Vector3( 0.0, -0.5, 0.0 ),

			
			distanceInterpTime	= 1.85,
		},

		
		{
			actionName	= "ACT_TruckDefault",
			
			attachType			= "Manual",

			
			distance				= 9.5,
			
			defaultRotXAngle			= 10,
			
			focalLength			= 21,
			
			offset				= Vector3( 0.0, 0.0, 0.0 ),
			
			rotXMin				= -30,
			
			offsetInterpTime		= 1.0,
			
			distanceInterpTime	= 1.0,
			
			focalLengthInterpTime	= 1.0,
			
			correctAimOffsetY			= 12,
			
			correctRotInterpTimeMin	= 0.6,
			
			rotationCorrectInvalidTime	= 0.85,
			
			rotVelMaxX			= 50,
			
			rotVelMaxY			= 100,
		},

		
		{
			actionName	= "ACT_TruckRideOff",
			
			offset				= Vector3( 0.0, 0.5, 0.0 ),
			
			offsetInterpTime		= 1.0,
			
			distanceInterpTime	= 2.0,


			
			rotXMin			= 30,
		},

		
		{
			actionName	= "ACT_HeliDefault",

			
			attachType			= "Manual",

			
			distance				= 1.5,
			
			offset			= Vector3(-0.15, -0.05, 0.0 ),

			
			rotXMin			= -20,
			
			rotXMax			= 50,
			
			rotYMin			= -90,
			
			rotYMax			= 90,
		},

		
		{
			actionName	= "ACT_HeliDead",
		
			
			attachType			= "Manual",

			
			distance				= 2.0,
			
			offset			= Vector3(0.0, -0.25, 0.0 ),

			
			rotXMin			= -20,
			
			rotXMax			= 50,
			
			rotYMin			= -90,
			
			rotYMax			= 90,
		},

		
		{
			actionName	= "ACT_MgmDefault",
			
			distance			= 5.0,
			
			offset				= Vector3( 0.0, -0.5, 0.0 ),
			
			offsetInterpTime	= 1.5,
			
			distanceInterpTime	= 1.5,
			
			focalLengthInterpTime	= 1.5,
		},

		
		{
			actionName	= "ACT_CqcDefault",
			
			offset			= Vector3( 0.0, 0.35, 0.0 ),
			
			focalLength			= 32,
		},

		
		{
			actionName	= "ACT_CqcSquat",

			
			distance				= 3.6,
			
			offset			= Vector3( 0.0, 0.0, 0.0 ),
			
			focalLength			= 32,
		},

		
		{
			actionName	= "ACT_CqcToHold",

			
			distance			= 3.0,
			
			offset				= Vector3( -0.00, 0.65, 0.0 ),
			
			interpTime	= 0.2,
			
			focalLength			= 32,
		},

		
		{
			actionName	= "ACT_TimeCigarette",

			
			distance				= 1.5,

			
			focusDistance			= 1.5,

			
			offset			= Vector3( -0.3, 0.7, 0.0 ),
			
			focalLength			= 32,
			
			
			focusDistanceInterpTime = 0.1,
			
			
			aperture				= 4.0,
		},

		
		{
			actionName = "ACT_TruckDeck",
			
			
			distance			= 1.2,
			
			offset			= Vector3( -0.4, 0.25, 0.0 ),
		},
		
		
		{
			actionName = "ACT_TruckDeckPeepingZoom",
			
			
			distance			= 1.2,
			
			offset			= Vector3( -0.175, 0.36, 0.0 ),
		},
		
		
		{
			actionName = "ACT_TruckDeckCrawl",

			
			distance			= 1.0,
			
			offset			= Vector3( -0.4, 0.20, 0.0 ),

		},
		
		{
			actionName = "ACT_TruckDeckOff",

			
			distance				= 3.25,	
			
			offset			= Vector3(-0.30, 0.2, 0.0 ),
			
			distanceInterpTime	= 1.8,
			
			offsetInterpTime		= 1.8,
		},

		
		{
			actionName = "ACT_Picking",

			
			distance			= 2.25, 
			
			offset			= Vector3( -0.20, 0.27, 0.0 ),
			
			focalLength			= 26,
			
			focusDistance		= 2.75,
		},

		
		{
			actionName = "ACT_PushButton",

			
			distance			= 2.25, 
			
			offset			= Vector3( -0.20, 0.40, 0.0 ),
			
			focalLength			= 26,
			
			focusDistance		= 2.75,
		},

		
		{
			actionName	= "ACT_BehindStandEdgeZoom",
			
			offsetInterpTime		= 0.4,
			
			distance			= 4.5,
			
			offset			= Vector3( -1.1, 0.5, 0.0 ),
		},

		
		{
			actionName	= "ACT_BehindSquatEdgeZoom",
			
			offsetInterpTime		= 0.4,
			
			distance			= 4.5,
			
			offset			= Vector3( -1.1, 0.45, 0.0 ),
		},
		
		
		{
			actionName	= "ACT_BehindSquatPeepingUpZoom",
			
			offsetInterpTime		= 0.4,
			
			distance			= 4.5,
			
			offset			= Vector3( -0.6, 0.8, 0.0 ),
		},

	
	
	
		
		
		{
			actionName	= "ACT_Stand",
			
			
			presetName	= "Indoor",
			
			distance			= 2.9,
			
			offset			= Vector3( 0.0, 0.7, 0.0 ),
		},
		
		
		{
			actionName	= "ACT_Squat",
			
			
			presetName	= "Indoor",
			
			
			distance			= 2.6,
			
			offset			= Vector3( 0.0, 0.05, 0.0 ),
		},
		
		
		{
			actionName	= "ACT_Crawl",
			
			
			presetName	= "Indoor",
			
			
			distance			= 2.3,
			
			offset			= Vector3( 0.0, 0.2, 0.0 ),
		},
		
		
		{
			actionName	= "ACT_DashMove",
			
			
			presetName	= "Indoor",
			
			
			distance			= 2.5,
			
			offset			= Vector3( 0.0, 0.05, 0.0 ),
		},

	
	
	
	{	presetName			= "watchtower",
		actionName			= "ACT_Stand",
		distance			= 3.0,
		offset				= Vector3( -0.3, 0.3, 0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_Squat",
		distance			= 1.7,
		offset				= Vector3( -0.30, 0.2, 0.0 ),
	},		
	{	presetName			= "watchtower",
		actionName			= "ACT_Crawl",
		distance			= 1.6,
		offset				= Vector3(-0.30, 0.2, 0.0 ),
	},		
	{	presetName			= "watchtower",
		actionName			= "ACT_BehindStand",
		offsetInterpTime	= 1.0,
		distance			= 2.0,
		offset				= Vector3( -0.6, 0.5, 0.0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_BehindSquat",
		offsetInterpTime	= 1.0,
		distance			= 1.7,
		offset				= Vector3( -0.6, 0.30, 0.0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_DashMove",
		distance			= 2.5,
		offset				= Vector3( -0.35, 0.325, 0.0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_BehindStandEdgeZoom",
		offsetInterpTime	= 0.4,
		distance			= 2.0,
		offset				= Vector3( -1.1, 0.5, 0.0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_BehindSquatEdgeZoom",
		offsetInterpTime	= 0.4,
		distance			= 1.7,
		offset				= Vector3( -1.1, 0.15, 0.0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_BehindSquatPeepingUpZoom",
		offsetInterpTime	= 0.4,
		distance			= 1.7,
		offset				= Vector3( -0.3, 0.4, 0.0 ),
	},
		
	
	
	
		
		
		{
			actionName	= "ACT_Stand",
			
			
			presetName	= "hospital",

			
			distance			= 2.9,
			
			offset			= Vector3( 0.0, 0.2, 0.0 ),
			
			focalLength			= 18,

			
			focusDistance 		= 5.5,

			
			focusDistanceInterpTime = 0.1,

			
			aperture				= 0.9,

		},
		
		
		{
			actionName	= "ACT_Squat",
			
			
			presetName	= "hospital",
			
			
			distance			= 2.6,
			
			offset			= Vector3( 0.0, 0.05, 0.0 ),
			
			focalLength			= 18,
			
			
			focusDistance 		= 5.5,			

			
			focusDistanceInterpTime = 0.1,

			
			aperture				= 0.9,

		},
		
		
		{
			actionName	= "ACT_Crawl",
			
			
			presetName	= "hospital",
			
			
			distance			= 2.3,
			
			offset			= Vector3( 0.0, 0.2, 0.0 ),
			
			focalLength			= 18,
			

			
			focusDistance 		= 5.5,
			

			
			focusDistanceInterpTime = 0.1,

			
			aperture				= 0.9,
			

		},

		
		
		
		
		
		{
			actionName	= "ACT_Squat",
			
			
			presetName	= "hospital_smoke_room",
			
			
			distance			= 1.5,
			
			offset			= Vector3( 0.0, 0.15, 0.0 ),
			
			focalLength			= 18,
			
			
			focusDistance 		= 3.0,

			
			focusDistanceInterpTime = 0.1,

			
			rotXMin				= -20,
		
			
			rotXMax				= 20,
		},
		
		
		{
			actionName	= "ACT_Crawl",
			
			
			presetName	= "hospital_smoke_room",
			
			
			distance			= 1.0,
			
			offset			= Vector3( 0.0, 0.25, 0.0 ),
			
			focalLength			= 18,

			
			focusDistance 		= 3.0,

			
			focusDistanceInterpTime = 0.1,

			
			rotXMin				= -20,
		
			
			rotXMax				= 20,
		},

		
		
		

		
		{
			actionName	= "ACT_Stand",
			
			
			presetName	= "hospital_curtain_room",

			
			distance			= 2.25,
			
			offset			= Vector3( 0.0, 0.8, 0.0 ),
			
			focalLength			= 18,

			
			focusDistance 		= 3.0,

			
			focusDistanceInterpTime = 0.1,

		},

		
		{
			actionName	= "ACT_Squat",
			
			
			presetName	= "hospital_curtain_room",
			
			
			distance			= 1.5,
			
			offset			= Vector3( 0.0, 0.1, 0.0 ),
			
			focalLength			= 18,
			
			
			focusDistance 		= 3.0,

			
			focusDistanceInterpTime = 0.1,

		},

		
		{
			actionName	= "ACT_Crawl",
			
			
			presetName	= "hospital_curtain_room",
			
			
			distance			= 1.25,
			
			offset			= Vector3( 0.0, 0.2, 0.0 ),
			
			focalLength			= 18,

			
			focusDistance 		= 3.0,

			
			focusDistanceInterpTime = 0.1,
		},

		
		
		

		
		{
			actionName	= "ACT_Stand",
			
			
			presetName	= "hospital_murder_collidor",

			
			distance			= 2.25,
			
			offset			= Vector3( 0.0, 0.8, 0.0 ),
			
			focalLength			= 18,

			
			focusDistance 		= 3.0,

			
			focusDistanceInterpTime = 0.1,

		},

		
		{
			actionName	= "ACT_Squat",
			
			
			presetName	= "hospital_murder_collidor",
			
			
			distance			= 1.5,
			
			offset			= Vector3( 0.0, 0.1, 0.0 ),
			
			focalLength			= 18,
			
			
			focusDistance 		= 3.0,

			
			focusDistanceInterpTime = 0.1,

		},

		
		{
			actionName	= "ACT_Crawl",
			
			
			presetName	= "hospital_murder_collidor",
			
			
			distance			= 0.85,
			
			offset			= Vector3( 0.0, 0.2, 0.2 ),
			
			focalLength			= 18,

			
			focusDistance 		= 1.0,

			
			focusDistanceInterpTime = 0.1,

			
			rotXMin				= -20,
		
			
			rotXMax				= 20,
		},

		
		
		
		
		
		{
			actionName	= "ACT_Stand",
			
			
			presetName	= "hospital_entrance",

			
			distance			= 2.9,
			
			offset			= Vector3( 0.0, 0.2, 0.0 ),
			
			focalLength			= 18,
		},
		
		
		{
			actionName	= "ACT_Squat",
			
			
			presetName	= "hospital_entrance",
			
			
			distance			= 2.6,
			
			offset			= Vector3( 0.0, 0.05, 0.0 ),
			
			focalLength			= 18,
		},
	
		
		{
			actionName	= "ACT_Crawl",
			
			
			presetName	= "hospital_entrance",
			
			
			distance			= 2.3,
			
			offset			= Vector3( 0.0, 0.2, 0.0 ),
			
			focalLength			= 18,
		},		
		
		{
			actionName	= "ACT_HorseVolginChase",

			
			presetName	= "hospital_entrance",
			 
			
			distance				= 4.8,
			
			
			offset				= Vector3( -0.9, -0.9, 0.0 ),
			
			offsetInterpTime		= 1.5,
			
			distanceInterpTime	= 1.5,
			
			focalLengthInterpTime	= 1.5,
		 	
			focalLength			= 18,
			
			focusDistance			= 5.0,
			
			aperture				= 0.8,
			
			shutterSpeed			= 0.04,
		},
		
	
	
	
		
		
		{
			actionName			= "ACT_Stand",
			
			presetName			= "gntn_000",
			
			distance			= 3.55,
			
			offset				= Vector3( -0.15, 0.55, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_Squat",
			
			presetName			= "gntn_000",
			
			distance			= 1.7,
			
			offset				= Vector3( -0.15, 0.1, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_Crawl",
			
			presetName			= "gntn_000",
			
			distance			= 1.6,
			
			offset				= Vector3( -0.15, 0.2, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindStand",
			
			presetName			= "gntn_000",
			
			offsetInterpTime	= 1.0,
			
			distance			= 2.5,
			
			offset				= Vector3( -0.6, 0.5, 0.0 ),
		},
		
		{
			actionName			= "ACT_BehindSquat",
			
			presetName			= "gntn_000",
			
			offsetInterpTime	= 1.0,
			
			distance			= 2.5,
			
			offset				= Vector3( -0.6, 0.15, 0.0 ),
		},
		
		{
			actionName			= "ACT_DashMove",
			
			presetName			= "gntn_000",
			
			distance			= 2.5,
			
			offset				= Vector3( -0.35, 0.325, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindStandEdgeZoom",
			
			presetName			= "gntn_000",
			
			offsetInterpTime	= 0.4,
			
			distance			= 2.0,
			
			offset			= Vector3( -0.9, 0.5, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindSquatEdgeZoom",
			
			presetName			= "gntn_000",
			
			offsetInterpTime	= 0.4,
			
			distance			= 1.7,
			
			offset			= Vector3( -0.85, 0.0, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindSquatPeepingUpZoom",
			
			presetName			= "gntn_000",
			
			offsetInterpTime	= 0.4,
			
			distance			= 1.7,
			
			offset			= Vector3( -0.3, 0.4, 0.0 ),
		},
		
	
	
	
		
		
		{
			actionName			= "ACT_Stand",
			
			presetName			= "gntn_001",
			
			distance			= 3.0,
			
			offset				= Vector3( -0.30, 0.30, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_Squat",
			
			presetName			= "gntn_001",
			
			distance			= 1.7,
			
			offset				= Vector3( -0.30, 0.2, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_Crawl",
			
			presetName			= "gntn_001",
			
			
			distance			= 1.6,
			
			offset				= Vector3(-0.30, 0.2, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindStand",
			
			presetName			= "gntn_001",
			
			offsetInterpTime	= 1.0,
			
			distance			= 1.8,
			
			offset				= Vector3( -0.6, 0.5, 0.0 ),
		},
		
		{
			actionName			= "ACT_BehindSquat",
			
			presetName			= "gntn_001",
			
			offsetInterpTime	= 1.0,
			
			distance			= 1.7,
			
			offset				= Vector3( -0.6, 0.30, 0.0 ),
		},
		
		{
			actionName			= "ACT_DashMove",
			
			presetName			= "gntn_001",
			
			distance			= 2.5,
			
			offset				= Vector3( -0.35, 0.325, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindStandEdgeZoom",
			
			presetName			= "gntn_001",
			
			offsetInterpTime	= 0.4,
			
			distance			= 1.8,
			
			offset			= Vector3( -1.0, 0.5, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindSquatEdgeZoom",
			
			presetName			= "gntn_001",
			
			offsetInterpTime	= 0.4,
			
			distance			= 1.7,
			
			offset			= Vector3( -0.9, 0.1, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindSquatPeepingUpZoom",
			
			presetName			= "gntn_001",
			
			offsetInterpTime	= 0.4,
			
			distance			= 1.7,
			
			offset			= Vector3( -0.3, 0.4, 0.0 ),
		},
		
	
	
	
		
		
		{
			actionName			= "ACT_Stand",
			
			presetName			= "gntn_002",
			
			distance			= 3.95,
			
			offset				= Vector3( -0.30, 0.5, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_Squat",
			
			presetName			= "gntn_002",
			
			distance			= 2.75,
			
			offset				= Vector3( -0.30, 0.2, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_Crawl",
			
			presetName			= "gntn_002",
			
			distance			= 2.0,
			
			offset				= Vector3(-0.30, 0.2, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindStand",
			
			presetName			= "gntn_002",
			
			offsetInterpTime	= 1.0,
			
			distance			= 2.25,
			
			offset				= Vector3( -0.6, 0.5, 0.0 ),
		},
		
		{
			actionName			= "ACT_BehindSquat",
			
			presetName			= "gntn_002",
			
			offsetInterpTime	= 1.0,
			
			distance			= 2.25,
			
			offset				= Vector3( -0.6, 0.30, 0.0 ),
		},
		
		{
			actionName			= "ACT_DashMove",
			
			presetName			= "gntn_002",
			
			distance			= 3.0,
			
			offset				= Vector3( -0.35, 0.325, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindStandEdgeZoom",
			
			presetName			= "gntn_002",
			
			offsetInterpTime	= 0.4,
			
			distance			= 2.25,
			
			offset			= Vector3( -1.1, 0.5, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindSquatEdgeZoom",
			
			presetName			= "gntn_002",
			
			offsetInterpTime	= 0.4,
			
			distance			= 2.25,
			
			offset			= Vector3( -0.9, 0.15, 0.0 ),
		},
		
		
		{
			actionName			= "ACT_BehindSquatPeepingUpZoom",
			
			presetName			= "gntn_002",
			
			offsetInterpTime	= 0.4,
			
			distance			= 2.25,
			
			offset			= Vector3( -0.3, 0.4, 0.0 ),
		},
		
	},



}, 



FixedParams = {
	
	
	DefaultParam = {
		
		
		stickMargin				= ( 24 / 255 ),
		
		
		stickMarginByAnotherAxis	= 0.15,
		
		
		distanceInterpTimeAtStart	= 0.4,
		
		
		offsetInterpTimeAtStart	= 0.3,
		
		
		basePosInterpTime			= 0.3,
		
		
		collisionInterpTime		= 0.3,
		
		
		bezierControlTime			= 0.4,
		
		
		bezierControlRate			= 0.8,
		
	},

}, 



ShakeParams = {
	
	
	DefaultParam = {
		
		
		rangePosX	= 0,
		
		
		rangePosY	= 0,

		
		rangePosZ	= 0,
		
		
		rangeRotX	= 0.5,
		
		
		rangeRotY	= 0.05,
		
		
		rangeRotZ	= 0,

		
		cyclePos		= 6,
		
		
		cycleRot		= 14,
		
		
		interpTime	= 0.5,
		
		
		speedMode	= true,

		
		speedRateMin = 0.15,
			
		
		speedRateBaseValue = 3.5,

		
		cyclePosRateWhenSpeedRateIsMin = 0.333333,
		
		cycleRotRateWhenSpeedRateIsMin = 0.333333,
	},

	Params = {

		
		{
			name		= "ACT_Stand",
			
			
			rangePosX	= 0.0005,
			rangePosY	= 0.0005,
			rangePosZ	= 0.07,
			
			
			rangeRotX	= 0.12,
			rangeRotY	= 0.03,
			rangeRotZ	= 0.1,

			
			cyclePos		= 4.5,
			cycleRot		= 18,
			
			speedRateBaseValue = 4.19,
			
			
			speedRateMin = 0.01,
		},
		
		{
			name		= "ACT_DashMove",
			
			
			rangePosX	= 0.005,
			rangePosY	= 0.005,
			rangePosZ	= 0.175,
			
			
			rangeRotX	= 0.35,
			rangeRotY	= 0.07,
			rangeRotZ	= 0.2,

			
			cyclePos		= 9,
			cycleRot		= 36,
			
			speedRateBaseValue = 8.39,
			
			
			speedRateMin = 0.01,
		},
		
		{
			name		= "ACT_Squat",

			
			rangePosX	= 0.0005,
			
			
			rangePosY	= 0.0005,

			
			rangeRotX	= 0.10,
			
			
			rangeRotY	= 0.10,

			
			cyclePos		= 6,
			
			
			cycleRot		= 14,
			
			
			speedRateBaseValue = 2.5,

			
			cyclePosRateWhenSpeedRateIsMin = 0.5,
			
			--DUPLICATE: cyclePosRateWhenSpeedRateIsMin = 0.5,
		},

		
		{
			name		= "ACT_CarryStand",	

			
			rangePosX	= 0.005,
			rangePosY	= 0.005,
			rangePosZ	= 0.175,
			
			
			rangeRotX	= 0.35,
			rangeRotY	= 0.07,
			rangeRotZ	= 0.2,

			
			cyclePos		= 9,
			cycleRot		= 36,
			
			speedRateBaseValue = 8.39,
			
			
			speedRateMin = 0.01,
		},

		
		{
			name		= "ACT_CarrySquat",

			
			rangePosX	= 0.0005,
			
			
			rangePosY	= 0.0005,

			
			rangeRotX	= 0.10,
			
			
			rangeRotY	= 0.10,

			
			cyclePos		= 6,
			
			
			cycleRot		= 14,
			
			
			speedRateBaseValue = 2.0,

			
			cyclePosRateWhenSpeedRateIsMin = 0.5,
			
			--DUPLICATE: cyclePosRateWhenSpeedRateIsMin = 0.5,
		},

		
		{
			name		= "ACT_Crawl",

			
			rangePosX	= 0.0,
			
			
			rangePosY	= 0.0,

			
			rangeRotX	= 0.05,
			
			
			rangeRotY	= 0.05,

			
			cyclePos		= 6,
			
			
			cycleRot		= 14,

			
			speedRateMin = 0.5,
			
			
			speedRateBaseValue = 1.0,

			
			cyclePosRateWhenSpeedRateIsMin = 0.5,
			
			--DUPLICATE: cyclePosRateWhenSpeedRateIsMin = 0.5,
		},
		
		
		{
			name	= "ACT_HorseDefault",
			
			
			rangePosX	= 0.01,
			
			
			rangePosY	= 0.02,

			
			rangeRotX	= 0.30,
			
			
			rangeRotY	= 0.45,
			
			
			cyclePos		= 9,
		
			
			cycleRot		= 21,
		
			
			speedRateMin = 0.01,
				
			
			speedRateBaseValue = 11,

			
			cyclePosRateWhenSpeedRateIsMin = 0.333333,
			
			cycleRotRateWhenSpeedRateIsMin = 0.333333,
		},

		
		{
			name	= "ACT_LightVehicleDefault",

			
			rangePosX	= 0.0,
			rangePosY	= 0.0,
			rangePosZ	= 0.25,
			
			
			rangeRotX	= 0.2,
			rangeRotY	= 0.2,

			
			cyclePos		= 24,
		
			
			cycleRot		= 56,
		
			
			speedRateMin = 0.01,
				
			
			speedRateBaseValue = 11,

			
			cyclePosRateWhenSpeedRateIsMin = 0.333333,
			
			cycleRotRateWhenSpeedRateIsMin = 0.333333,
		},

		
		{
			name	= "ACT_TruckDefault",

			
			rangePosX	= 0.0,
			rangePosY	= 0.0,
			rangePosZ	= 0.35,
			
			
			rangeRotX	= 0.2,
			rangeRotY	= 0.2,

			
			cyclePos		= 24,
		
			
			cycleRot		= 56,
		
			
			speedRateMin = 0.01,
				
			
			speedRateBaseValue = 11,

			
			cyclePosRateWhenSpeedRateIsMin = 0.333333,
			
			cycleRotRateWhenSpeedRateIsMin = 0.333333,
		},
		
		
		{
			name	= "ACT_StrykerDefault",

			
			rangePosX	= 0.0,
			rangePosY	= 0.0,
			rangePosZ	= 0.45,
			
			
			rangeRotX	= 0.2,
			rangeRotY	= 0.2,

			
			cyclePos		= 24,
		
			
			cycleRot		= 56,
		
			
			speedRateMin = 0.1,
				
			
			speedRateBaseValue = 5,

			
			cyclePosRateWhenSpeedRateIsMin = 0.333333,
			
			cycleRotRateWhenSpeedRateIsMin = 0.333333,
		},

		
		{
			name	= "ACT_TruckDeck",
			
			
			rangePosX	= 0.01,
			
			
			rangePosY	= 0.02,

			
			rangeRotX	= 0.30,
			
			
			rangeRotY	= 0.45,
			
			
			cyclePos		= 24,
		
			
			cycleRot		= 56,
		
			
			speedRateMin = 0.05,
				
			
			speedRateBaseValue = 9,

			
			cyclePosRateWhenSpeedRateIsMin = 0.15,
			
			cycleRotRateWhenSpeedRateIsMin = 0.15,
		},

		
		{
			name	= "ACT_TruckDeckCrawl",
			
			
			rangePosX	= 0.0075,
			
			
			rangePosY	= 0.015,

			
			rangeRotX	= 0.20,
			
			
			rangeRotY	= 0.3,
			
			
			cyclePos		= 24,
		
			
			cycleRot		= 56,
		
			
			speedRateMin = 0.05,
				
			
			speedRateBaseValue = 9,
			
			
			cyclePosRateWhenSpeedRateIsMin = 0.15,
			
			cycleRotRateWhenSpeedRateIsMin = 0.15,
		},

		
		{
			name	= "ACT_Picking",
			
			
			rangePosX	= 0.01,
			
			
			rangePosY	= 0.02,

			
			rangeRotX	= 0.30,
			
			
			rangeRotY	= 0.45,
			
			
			cyclePos		= 24,
		
			
			cycleRot		= 56,
		},

		
		{
			name		= "ACT_HeliDefault",

			
			rangePosX	= 0.000,
			
			
			rangePosY	= 0.000,

			
			rangeRotX	= 0.14,
			
			
			rangeRotY	= 0.14,
			
			
			cyclePos		= 18,
		
			
			cycleRot		= 36,
		
			
			speedRateMin = 1.0,
				
			
			speedRateBaseValue = 1.0,

			
			cyclePosRateWhenSpeedRateIsMin = 1.0,
			
			cycleRotRateWhenSpeedRateIsMin = 1.0,
		},

		
		{
			name		= "ACT_RailIdle",

			
			rangePosX	= 0,
		
			
			rangePosY	= 0,

			
			rangePosZ	= 0,
		
			
			rangeRotX	= 0,
		
			
			rangeRotY	= 0,
		
			
			rangeRotZ	= 0,

			
			cyclePos		= 0,
		
			
			cycleRot		= 0,
		
			
			interpTime	= 1.0,
		
			
			speedMode	= false,
		
		},

		
		{
			name		= "ACT_RailCrawlMove",

			
			rangePosX	= 0.0001,
		
			
			rangePosY	= 0.0001,

			
			rangePosZ	= 0,
		
			
			rangeRotX	= 0.15,
		
			
			rangeRotY	= 0.15,
		
			
			rangeRotZ	= 0,

			
			cyclePos		= 3,
		
			
			cycleRot		= 7,
		
			
			interpTime	= 0.5,
		
			
			speedMode	= false,
		
		},

		
		{
			name		= "ACT_RailSquatMove",

			
			rangePosX	= 0.0005,
		
			
			rangePosY	= 0.0005,

			
			rangePosZ	= 0,
		
			
			rangeRotX	= 0.25,
		
			
			rangeRotY	= 0.25,
		
			
			rangeRotZ	= 0,

			
			cyclePos		= 7,
		
			
			cycleRot		= 15,
		
			
			interpTime	= 0.5,
		
			
			speedMode	= false,
		
		},
	},

}, 


VehicleNoiseParam = {

	DefaultParam = {

		
		enableDistanceMax = 15.0,
	
		
		enableSpeedMin = 1.39,
	
		
		enableSpeedMax = 16.7,
	
		
		levelXMax = 0.25,
	
		
		levelYMax = 0.15,
	
		
		time = 0.0,
	
		
		decayRate = 0.75,

	},

	Params = {

		
		{
			vehicleType = 0,	
			enableDistanceMax = 30.0,
		},

		
		{
			vehicleType = 1,	
		},

		
		{
			vehicleType = 2,	
		},

		
		{
			vehicleType = 3,	
		},

	},
	
}, 


} 
