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
    public class RotToFoxQuat : MonoBehaviour
    {
        public string posString;
        public string quatString;
        public string sclString;
        public string routeParam1;
        public string row1;
        public string row2;
        public string row3;
        public string row4;
		//public bool copyFromQuat = false;
		//public FoxLib.Core.Quaternion quatToUnity;
        void OnEnable()
        {
            posString = GetPosString();
            quatString = GetQuatString();
            sclString = GetSclString();
            routeParam1 = GetShortRotation();
            row1 = GetRow1String();
            row2 = GetRow2String();
            row3 = GetRow3String();
            row4 = GetRow4String();
        }
		// Update is called once per frame
		/*void Update()
		{
			if (transform.hasChanged)
			{
				transform.hasChanged = false;
				if (copyFromQuat)
				{
					copyFromQuat=false;
					if (quatToUnity==null)
					{
						
					}
					else
					{
						transform.rotation=FoxUtils.FoxToUnity(quatToUnity);
					}
				}
			}
		}*/

        private string GetPosString()
        {
            FoxLib.Core.Vector3 foxPos = FoxUtils.UnityToFox(transform.position);
            return $"x=\"{foxPos.X.ToString(CultureInfo.InvariantCulture)}\" y=\"{foxPos.Y.ToString(CultureInfo.InvariantCulture)}\" z=\"{foxPos.Z.ToString(CultureInfo.InvariantCulture)}\"";
        }//CalcQuatString

        private string GetQuatString()
        {
            FoxLib.Core.Quaternion foxQuat = FoxUtils.UnityToFox(transform.rotation);
            return $"x=\"{foxQuat.X.ToString(CultureInfo.InvariantCulture)}\" y=\"{foxQuat.Y.ToString(CultureInfo.InvariantCulture)}\" z=\"{foxQuat.Z.ToString(CultureInfo.InvariantCulture)}\" w=\"{foxQuat.W.ToString(CultureInfo.InvariantCulture)}\"";
        }//

        private string GetSclString()
        {
            FoxLib.Core.Vector3 foxScl = FoxUtils.UnityToFox(transform.lossyScale);
            return $"x=\"{(-foxScl.X).ToString(CultureInfo.InvariantCulture)}\" y=\"{foxScl.Y.ToString(CultureInfo.InvariantCulture)}\" z=\"{foxScl.Z.ToString(CultureInfo.InvariantCulture)}\"";
        }//

        private string GetShortRotation()
        {
            //tex: from caplag
            //https://discord.com/channels/364177293133873153/364177978315374592/819967138550251530
            float yaw = transform.rotation.eulerAngles.y;
            yaw -= 360;
            yaw = Mathf.Abs(yaw);
            yaw *= 182;
            int yawInt = (int)yaw;
            return yawInt.ToString("X");
        }//GetShortRotation

        private string GetRow1String()
        {
            FoxLib.Core.Matrix4 foxMatrix = FoxUtils.UnityToFox(transform.localToWorldMatrix);
            FoxLib.Core.Vector4 foxRow1 = new FoxLib.Core.Vector4(foxMatrix.Col0[0], foxMatrix.Col0[1], foxMatrix.Col0[2], foxMatrix.Col0[3]);
            return $"Column1=\"{foxRow1.X.ToString(CultureInfo.InvariantCulture)}\" Column2=\"{foxRow1.Y.ToString(CultureInfo.InvariantCulture)}\" Column3=\"{foxRow1.Z.ToString(CultureInfo.InvariantCulture)}\" Column4=\"{foxRow1.W.ToString(CultureInfo.InvariantCulture)}\"";
        }//

        private string GetRow2String()
        {
            FoxLib.Core.Matrix4 foxMatrix = FoxUtils.UnityToFox(transform.localToWorldMatrix);
            FoxLib.Core.Vector4 foxRow2 = new FoxLib.Core.Vector4(foxMatrix.Col1[0], foxMatrix.Col1[1], foxMatrix.Col1[2], foxMatrix.Col1[3]);
            return $"Column1=\"{foxRow2.X.ToString(CultureInfo.InvariantCulture)}\" Column2=\"{foxRow2.Y.ToString(CultureInfo.InvariantCulture)}\" Column3=\"{foxRow2.Z.ToString(CultureInfo.InvariantCulture)}\" Column4=\"{foxRow2.W.ToString(CultureInfo.InvariantCulture)}\"";
        }//

        private string GetRow3String()
        {
            FoxLib.Core.Matrix4 foxMatrix = FoxUtils.UnityToFox(transform.localToWorldMatrix);
            FoxLib.Core.Vector4 foxRow3 = new FoxLib.Core.Vector4(foxMatrix.Col2[0], foxMatrix.Col2[1], foxMatrix.Col2[2], foxMatrix.Col2[3]);
            return $"Column1=\"{foxRow3.X.ToString(CultureInfo.InvariantCulture)}\" Column2=\"{foxRow3.Y.ToString(CultureInfo.InvariantCulture)}\" Column3=\"{foxRow3.Z.ToString(CultureInfo.InvariantCulture)}\" Column4=\"{foxRow3.W.ToString(CultureInfo.InvariantCulture)}\"";
        }//

        private string GetRow4String()
        {
            FoxLib.Core.Vector3 foxPos = FoxUtils.UnityToFox(transform.position);
            return $"Column1=\"{foxPos.X.ToString(CultureInfo.InvariantCulture)}\" Column2=\"{foxPos.Y.ToString(CultureInfo.InvariantCulture)}\" Column3=\"{foxPos.Z.ToString(CultureInfo.InvariantCulture)}\" Column4=\"{(1).ToString(CultureInfo.InvariantCulture)}\"";
        }//
    }//class RotToFoxQuat
}//namespace FoxKit.IH
