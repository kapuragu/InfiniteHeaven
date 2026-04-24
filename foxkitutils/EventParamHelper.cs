using FoxKit.Modules.RouteBuilder;
using FoxKit.Utils;
using System;
using System.Collections.Generic;
using UnityEngine;

//tex for an idea of what this script is trying to help with:
//https://metalgearmodding.fandom.com/wiki/Route_findings#Relaxed_Idle_Act_and_Caution_Idle_Act_.5Bevent_node.5D

//copy script into unity foxkit project somewhere
//add it to a unity game object
//or edit both foxkits CreateRouteSetEditor CreateNewNode and RouteNodeEvent CreateNewNodeEvent and add
//go.AddComponent<EventParamHelper>();//tex
//before the function return

//Script will calculate p1 short which is the soldier facing angle for most events (when aim target type isn't a specific point or route) 
//from the yaw angle of the gameobject its attached to, however it will only update when another field in the inspector is updated
//I usually just click the IsEdge checkbox a couple of time (if script is it will automatically set it to the correct setting so you can just click it once)

//tex Only really deals with  AimTargetType / params 0 - 4,
//and only aimTargetType > param0 not visa versa

//copyFromRouteParams copies as uint, so will be trampled on when input type switched (as normal values are too)
//also doesnt copy param0 as aimTargetType code does trample it

[ExecuteInEditMode]
public class EventParamHelper : MonoBehaviour
{
    public enum RouteAimTargetType
    {
        NoTarget = 0,
        StaticPoint = 0x100,
        Character = 0x200,
        RouteAsSightMovePath = 0x300,
        RouteAsObject = 0x400,
    };

    public enum ParamValueTypes 
    {
        UIntValue,//tex to simplify things and just convert DEBUGNOW could hide/private Param0Uint to lessen confusion
        FloatValue,
        StringToStr32,
    }

    public bool IsNode = false;
    public bool isLoop = false;
    public RouteAimTargetType AimTargetType;
    
    //TODO: not actually sure what the 0x1000000 flag indicates, is only on nodes not edges
    uint aimTargetUnkIsNodeLowFlag = 0x1;
    uint aimTargetUnkHiFlag = 0x1000000;


    private uint Param0Uint = 0;
    //tex only allowing aimTargetType which writes Param0Uint
    //public string Param0 = "0";
    //public ParamValueTypes Param0InputType = ParamValueTypes.UIntValue;

    private uint Param1Uint = 0;
    //tex only allowing P1Shorts (actually only P1Short1WaitTime since P1Short0FromYaw gets set from parent yaw)
    //public string Param1 = "0";
    //public ParamValueTypes Param1InputType = ParamValueTypes.UIntValue;

    public ushort P1Short0FromYaw = 0;
    public ushort P1Short1WaitTime = 479;

    private uint Param2Uint = 0;
    public string Param2 = "0";
    public ParamValueTypes Param2InputType = ParamValueTypes.UIntValue;

    private uint Param3Uint = 0;
    public string Param3 = "0";
    public ParamValueTypes Param3InputType = ParamValueTypes.UIntValue;

    private uint Param4Uint = 0;
    public string Param4 = "0";
    public ParamValueTypes Param4InputType = ParamValueTypes.UIntValue;

    private uint Param5Uint = 0;
    public string Param5 = "0";
    public ParamValueTypes Param5InputType = ParamValueTypes.UIntValue;

    private uint Param6Uint = 0;
    public string Param6 = "0";
    public ParamValueTypes Param6InputType = ParamValueTypes.UIntValue;

    private uint Param7Uint = 0;
    public string Param7 = "0";
    public ParamValueTypes Param7InputType = ParamValueTypes.UIntValue;

    private uint Param8Uint = 0;
    public string Param8 = "0";
    public ParamValueTypes Param8InputType = ParamValueTypes.UIntValue;

    private uint Param9Uint = 0;
    public string Param9 = "0";
    public ParamValueTypes Param9InputType = ParamValueTypes.UIntValue;


    //public uint Param1Combined = 0;

    //public bool P1ShortsToParam1 = false;
    public bool copyToRouteParams = false;
    public bool copyFromRouteParams = false;

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (transform.hasChanged)
        {
            transform.hasChanged = false;
            //Debug.Log("transform.hasChanged");
            OnValidate();
        }
    }

    private uint StrCode32(string inputString)
    {
        return (uint)Hashing.HashFileNameLegacy(inputString);
    }

    private uint ParamToUint(string inputParam, ParamValueTypes valueType)
    {
        switch (valueType)
        {
            case ParamValueTypes.UIntValue:
                if (inputParam == "") return 0;
                uint paramUint = uint.Parse(inputParam);
                return paramUint;
                break;
            case ParamValueTypes.FloatValue:
                if (inputParam == "") return 0;
                float paramFloat = float.Parse(inputParam);
                return BitConverter.ToUInt32(BitConverter.GetBytes(paramFloat), 0);
                break;
            case ParamValueTypes.StringToStr32:
                uint paramStr32 = StrCode32(inputParam);
                return paramStr32;
                break;
        }//valueType
        return 0;
    }//UpdateParam

    // Called when value is changed in inspector
    private void OnValidate()
    {
        RouteNode routeNode = GetComponent<RouteNode>();
        RouteEdgeEvent routeEdgeEvent = null;
        if (routeNode != null)
        {
            routeEdgeEvent = routeNode.EdgeEvent;
            //Debug.Log("EventParamHelper.OnValidate: routeNode != null");
        }
        RouteNodeEvent routeNodeEvent = GetComponent<RouteNodeEvent>();

        List<uint> Params = null;
        if (routeEdgeEvent != null)
        {
            Params = routeEdgeEvent.Params;
        }
        if (routeNodeEvent != null)
        {
            Params = routeNodeEvent.Params;
        }
        if (Params == null)
        {
            //Debug.Log("EventParamHelper.OnValidate: Params == null");
        }

        if (routeEdgeEvent != null)
        {
            IsNode = false;
        }
        if (routeNodeEvent != null)
        {
            IsNode = true;
        }
        //
        if (copyFromRouteParams)
        {
            copyFromRouteParams = false;

            if (Params == null)
            {
                Debug.Log("EventParamHelper: Component isn't attached to a route Edge or Node");
            }
            else
            {
                //Param0 = Params[0].ToString();//
                //Param1 = Params[1].ToString();
                Param2 = Params[2].ToString();
                Param3 = Params[3].ToString();
                Param4 = Params[4].ToString();
                Param5 = Params[5].ToString();
                Param6 = Params[6].ToString();
                Param7 = Params[7].ToString();
                Param8 = Params[8].ToString();
                Param9 = Params[9].ToString();

                //Param0InputType = ParamValueTypes.UIntValue;
                //Param1InputType = ParamValueTypes.UIntValue;
                Param2InputType = ParamValueTypes.UIntValue;
                Param3InputType = ParamValueTypes.UIntValue;
                Param4InputType = ParamValueTypes.UIntValue;
                Param5InputType = ParamValueTypes.UIntValue;
                Param6InputType = ParamValueTypes.UIntValue;
                Param7InputType = ParamValueTypes.UIntValue;
                Param8InputType = ParamValueTypes.UIntValue;
                Param9InputType = ParamValueTypes.UIntValue;
            }
        }
        //

        switch (AimTargetType)
        {
            case RouteAimTargetType.NoTarget:
                //param1 = aim and wait time //TODO: shift param1shorts stuff here?
                Param2 = "0";//allways 0
                Param3 = "0";//allways 0
                Param4 = "0";//allways 0
                break;
            case RouteAimTargetType.StaticPoint:
                Param2InputType = ParamValueTypes.FloatValue;//aimPointX
                Param3InputType = ParamValueTypes.FloatValue;//aimPointY
                Param4InputType = ParamValueTypes.FloatValue;//aimPointZ
                break;
            case RouteAimTargetType.Character:
                Param2InputType = ParamValueTypes.StringToStr32;//aimCharacterNameS32 - ex S32"Player" or S32"sol_vip_village"
                //Param3 = "0";//unknown - never 0 - maybe bodySection/bone to aim at? TODO: look at values again
                Param4 = "0";//always 0
                break;
            case RouteAimTargetType.RouteAsSightMovePath:
                Param2InputType = ParamValueTypes.StringToStr32;//aimRouteS32 - S32"some_aim_route_name" (aim route names haven't been found since they are soley referenced within routes TODO is this still true) (or S32 empty string, never 0)
                Param3InputType = ParamValueTypes.StringToStr32;//unknown - never 0, S32 empty string or sometimes == to Param3
                Param4InputType = ParamValueTypes.StringToStr32;//unknown - never 0, S32 empty string or sometimes == to Param4
                Param5InputType = ParamValueTypes.StringToStr32;//unknown - never 0, S32 empty string or sometimes == to Param4
                break;
            case RouteAimTargetType.RouteAsObject:
                Param2InputType = ParamValueTypes.StringToStr32;//aimRouteS32 - see above
                Param3InputType = ParamValueTypes.StringToStr32;//unknown
                Param4InputType = ParamValueTypes.StringToStr32;//unknown
                Param5InputType = ParamValueTypes.StringToStr32;//unknown
                break;
            default:
                break;
        }

        // No edge events in vanilla frts use unk 0x100000 high flag TODO: but conversely do all nodes use high? if not then which ones?
        if (!IsNode)
        {
            if (isLoop)
            {
                Debug.Log("EventParamHelper this flag only appears on RouteNodes");
            }
            isLoop = false;
        }

        uint aimTargetValue = (uint)AimTargetType;
        if (IsNode)
        {
            aimTargetValue += aimTargetUnkIsNodeLowFlag;
        }
        if (isLoop)
        {
            aimTargetValue += aimTargetUnkHiFlag;
        }

        Param0Uint = aimTargetValue;//TODO: verify that param0 is allways aim target type

        //
        P1Short0FromYaw = GetShortRotation();

        uint RIGHT = 0xFFFF;
        if (IsNode)
		{
        Param1Uint = (uint)((P1Short0FromYaw << 16) | (P1Short1WaitTime & RIGHT));
		}
		else
		{
			Param1Uint = 0;
		}

        //if (P1ShortsToParam1)
        //{
        //    P1ShortsToParam1 = false;
        //    Param1InputType = ParamValueTypes.UIntValue;
        //    Param1 = Param1Combined.ToString();
        //}




        //Param0Uint = ParamToUint(Param0, Param0InputType);
        //Param1Uint = ParamToUint(Param1, Param1InputType);
        Param2Uint = ParamToUint(Param2, Param2InputType);
        Param3Uint = ParamToUint(Param3, Param3InputType);
        Param4Uint = ParamToUint(Param4, Param4InputType);
        Param5Uint = ParamToUint(Param5, Param5InputType);
        Param6Uint = ParamToUint(Param6, Param6InputType);
        Param7Uint = ParamToUint(Param7, Param7InputType);
        Param8Uint = ParamToUint(Param8, Param8InputType);
        Param9Uint = ParamToUint(Param9, Param9InputType);




        if (copyToRouteParams)
        {
            copyToRouteParams = false;

            if (Params == null)
            {
                Debug.Log("EventParamHelper: Component isn't attached to a route Edge or Node");
            }
            else 
            {
                Params[0] = Param0Uint;
                Params[1] = Param1Uint;
                Params[2] = Param2Uint;
                Params[3] = Param3Uint;
                Params[4] = Param4Uint;
                Params[5] = Param5Uint;
                Params[6] = Param6Uint;
                Params[7] = Param7Uint;
                Params[8] = Param8Uint;
                Params[9] = Param9Uint;
            }
        }
    }//OnValidate

    private ushort GetShortRotation()
    {
        //tex: from caplag
        //https://discord.com/channels/364177293133873153/364177978315374592/819967138550251530
        float yaw = transform.rotation.eulerAngles.y;
        yaw -= 360;
        yaw = Mathf.Abs(yaw);
        yaw *= 182;
        return (ushort)yaw;
    }//GetShortRotation
}//EventParamHelper
