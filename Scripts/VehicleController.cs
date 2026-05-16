using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class VehicleController : MonoBehaviour
{
    public Car carData;
    public Transform frontLeftWheel, frontRightWheel, rearLeftWheel, rearRightWheel;

    private Rigidbody rb;
    public float currentSpeed;
    public int currentGear = 1;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        rb.centerOfMass = new Vector3(0, -0.5f, 0);
    }

    void FixedUpdate()
    {
        HandleMovement();
        UpdateWheels();
        UpdateGear();
    }

    void HandleMovement()
    {
        float v = Input.GetAxis("Vertical");
        float h = Input.GetAxis("Horizontal");

        if (v > 0) currentSpeed += v * carData.acceleration * Time.fixedDeltaTime;
        else currentSpeed += v * carData.braking * Time.fixedDeltaTime;

        currentSpeed = Mathf.Clamp(currentSpeed, 0, carData.maxSpeed);

        Vector3 forwardMove = transform.forward * currentSpeed * Time.fixedDeltaTime;
        rb.MovePosition(rb.position + forwardMove);

        float turnAmount = h * carData.handling * Time.fixedDeltaTime * (currentSpeed / carData.maxSpeed);
        rb.MoveRotation(rb.rotation * Quaternion.Euler(0f, turnAmount * 50f, 0f));
    }

    void UpdateGear()
    {
        float speedPerGear = carData.maxSpeed / carData.gears;
        currentGear = Mathf.Clamp(Mathf.CeilToInt(currentSpeed / speedPerGear), 1, carData.gears);
    }

    void UpdateWheels()
    {
        float rotation = currentSpeed * 360f / (2f * Mathf.PI * 0.3f) * Time.fixedDeltaTime;
        frontLeftWheel.Rotate(rotation, 0, 0);
        frontRightWheel.Rotate(rotation, 0, 0);
        rearLeftWheel.Rotate(rotation, 0, 0);
        rearRightWheel.Rotate(rotation, 0, 0);
    }
}