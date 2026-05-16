using UnityEngine;

public class PlayerController : MonoBehaviour
{
    public VehicleController vehicle;
    public Camera playerCamera;
    public Vector3 cameraOffset = new Vector3(0, 3, -6);
    public float cameraSmooth = 5f;

    void LateUpdate()
    {
        if (playerCamera != null && vehicle != null)
        {
            Vector3 desiredPos = vehicle.transform.position + vehicle.transform.TransformDirection(cameraOffset);
            playerCamera.transform.position = Vector3.Lerp(playerCamera.transform.position, desiredPos, cameraSmooth * Time.deltaTime);
            playerCamera.transform.LookAt(vehicle.transform.position + Vector3.up * 1f);
        }
    }
}