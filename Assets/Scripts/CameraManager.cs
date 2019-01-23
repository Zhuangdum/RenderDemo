using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraManager : MonoBehaviour {

    [SerializeField]
    private float anglesSpeed = 1f;
    [SerializeField]
    private Transform target;

	void Update () {
        Camera.main.transform.LookAt(target);
		Camera.main.transform.RotateAround(target.position, Vector3.up, anglesSpeed * Time.deltaTime);
	}
}
