using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class SC_EffectControl : MonoBehaviour
{
    private Renderer rend;
    public Material mat;
    public GameObject Target;
    private Vector3 TargetPosition;

    void Start()
    {
        rend = GetComponent<Renderer>();
        mat = rend.material;

    }

    void Update()
    {
        TargetPosition = Target.transform.position;
        mat.SetVector("_target", TargetPosition);

    }
}
