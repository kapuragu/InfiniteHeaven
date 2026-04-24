using FoxKit.Utils;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Globalization;

//tex: converts the transform the component is attached to to a string of fox quat
//toggle the component using its checkmark to update the quat string

//routeParam1 is first part (4bytes) of route param1 (rotation and waittime)

namespace FoxKit.IH
{
    [ExecuteInEditMode]
    public class FoxToUnityRot : MonoBehaviour
    {
		public bool copyFromQuat = false;
		public Quaternion quatToUnity;
		// Update is called once per frame
		void Update()
		{
				if (copyFromQuat==true)
				{
					copyFromQuat=false;
					if (quatToUnity==null)
					{
						
					}
					else
					{
						FoxLib.Core.Quaternion quat = new FoxLib.Core.Quaternion(quatToUnity.x,quatToUnity.y,quatToUnity.z,quatToUnity.w);
						transform.rotation=FoxUtils.FoxToUnity(quat);
					}
				}
		}
    }//class RotToFoxQuat
}//namespace FoxKit.IH
