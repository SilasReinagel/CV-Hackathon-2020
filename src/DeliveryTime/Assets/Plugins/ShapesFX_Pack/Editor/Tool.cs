#if UNITY_EDITOR

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class Tool : EditorWindow
{
    //static float Number = 0.0f;
    //static float Z_OffsetValue = 0.0f;
    public Object source;

    [MenuItem("OrangedKeys/Tool_Collectables")]

    public static void ShowWindow()
    {
        EditorWindow.GetWindow<Tool>("Tool_Collectables");
    }

    void OnGUI()
    {
        //Number = EditorGUILayout.Slider("Obstacles Lines : ", Number, 1, 1000);
        //Z_OffsetValue = EditorGUILayout.Slider("Z_OffsetValue : ", Z_OffsetValue, 1, 250);
        source = EditorGUILayout.ObjectField(source, typeof(Object), true);


        if (GUILayout.Button("CREATE !!!"))
        {
            Material Asset_Path = (Material)Selection.activeObject;
            Debug.Log(Asset_Path);
        }
    }
}
#endif
