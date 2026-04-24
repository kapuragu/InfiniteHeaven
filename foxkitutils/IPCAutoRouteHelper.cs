using BezierSolution;
using FoxKit.IH;
using FoxKit.Modules.RouteBuilder;
using FoxKit.Utils;
using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using UnityEditor;
using UnityEngine;

[ExecuteInEditMode]
public class IPCAutoRouteHelper : MonoBehaviour
{
    public bool SingleUpdate = false;
    public bool ContinuousUpdate = false;
    public float UpdateDistanceMin = 5.0f;
    public Vector3 LastPosition;
    void OnEnable()
    {
        Start();
    }//OnEnable
    void Start()
    {
        //Debug.Log("IPCFeature.Start");//DEBUG
        //EditorApplication.update += OnEditorUpdate;
        SingleUpdate = false;
        ContinuousUpdate = false;
    }
    void OnDestroy()
    {
        if (Event.current != null && Event.current.commandName == "Delete")
            EditorApplication.update -= OnEditorUpdate;
    }//OnDisable
    void OnDisable()
    {
        if (Event.current != null && Event.current.commandName == "Delete")
            EditorApplication.update -= OnEditorUpdate;
    }//OnDisable
    void OnEditorUpdate()
    {
        if (!IPC.Instance.IsPipeConnected())
        {
            Debug.Log($"Pipe not connected, GO: {gameObject.name}");
            return;
        }
        if (ContinuousUpdate || SingleUpdate)
        {
            SingleUpdate = false;
            var proxyGameObject = GameObject.Find("Player");
            if (proxyGameObject == null)
                return;

            RouteSet routeSet = gameObject.GetComponent<RouteSet>();
            Route route = gameObject.GetComponent<Route>();
            RouteNode routeNode = gameObject.GetComponent<RouteNode>();
            BezierSpline spline = gameObject.GetComponent<BezierSpline>();
            BezierPoint point = gameObject.GetComponent<BezierPoint>();

            if (route==null)
            {
                if (routeSet != null)
                    if (routeSet.Routes.Count>0)
                        route=routeSet.Routes.Last();
                    else
                        routeSet.AddNewRoute();
                else if (routeNode != null)
                    route = routeNode.transform.parent.gameObject.GetComponent<Route>();
            }

            if (spline==null)
            {
                if (point != null)
                {
                    spline = point.transform.parent.gameObject.GetComponent<BezierSpline>();
                }
            }

            if (route==null&&spline==null)
            {
                return;
            }

            if (route != null)
                if (route.Nodes.Count > 0)
                    if (route.Nodes.Last() != null)
                        if (LastPosition == null)
                            LastPosition = route.Nodes.Last().gameObject.transform.position;

            if (spline != null)
                if (spline.Count > 0)
                    if (spline.Last() != null)
                        if (LastPosition == null)
                            LastPosition = spline.Last().gameObject.transform.position;

            if (ContinuousUpdate && !SingleUpdate && LastPosition != null && proxyGameObject != null)
                if (Vector3.Distance(proxyGameObject.transform.position, LastPosition) < UpdateDistanceMin)
                {
                    Debug.Log($"Not far enough from last position:{Vector3.Distance(proxyGameObject.transform.position, LastPosition)}");
                    return;
                }

            if (route != null)
            {

                RouteNode newNode = CreateRouteSetEditor.CreateNewNode(route);
                if (newNode != null && proxyGameObject != null)
                {
                    newNode.transform.position = proxyGameObject.transform.position;
                    newNode.transform.rotation = proxyGameObject.transform.rotation;
                    LastPosition = newNode.transform.position;
                }
                else
                {
                    Debug.Log("Node or proxy doesn't exist");
                }
            }
            else
            {
                Debug.Log("Route doesn't exist");
            }
            if (spline != null)
            {

                BezierPoint newPoint = new GameObject().AddComponent<BezierPoint>();
                if (newPoint != null && proxyGameObject != null)
                {
                    newPoint.gameObject.transform.parent = spline.transform;
                    newPoint.transform.position = proxyGameObject.transform.position;
                    LastPosition = newPoint.transform.position;
                    spline.AutoConstructSpline();
                    spline.First().followingControlPointLocalPosition = Vector3.zero;
                    spline.First().precedingControlPointLocalPosition = Vector3.zero;
                    spline.Last().followingControlPointLocalPosition = Vector3.zero;
                    spline.Last().precedingControlPointLocalPosition = Vector3.zero;
                }
                else
                {
                    Debug.Log("Point or proxy doesn't exist");
                }
            }
            else
            {
                Debug.Log("Spline doesn't exist");
            }
        }
    }
}
