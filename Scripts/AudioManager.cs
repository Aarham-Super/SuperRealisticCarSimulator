using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public VehicleController playerCar;
    public AudioSource engineSource;
    public AudioSource hornSource;

    void Update()
    {
        if (playerCar == null || engineSource == null) return;

        engineSource.pitch = 0.5f + (playerCar.currentSpeed / playerCar.carData.maxSpeed) * 2f;

        if (Input.GetKeyDown(KeyCode.Space))
            hornSource.Play();
    }
}