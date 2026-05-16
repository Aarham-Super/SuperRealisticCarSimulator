using UnityEngine;

public class TrafficAI : MonoBehaviour
{
    public Transform[] waypoints;
    public float speed = 12f;
    private int currentWaypoint = 0;
    private Rigidbody rb;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        rb.centerOfMass = new Vector3(0, -0.5f, 0);
    }

    void FixedUpdate()
    {
        if (waypoints.Length == 0) return;

        Transform target = waypoints[currentWaypoint];
        Vector3 direction = (target.position - transform.position).normalized;

        rb.MovePosition(rb.position + direction * speed * Time.fixedDeltaTime);
        rb.MoveRotation(Quaternion.Slerp(rb.rotation, Quaternion.LookRotation(direction), 2f * Time.fixedDeltaTime));

        if (Vector3.Distance(transform.position, target.position) < 1f)
            currentWaypoint = (currentWaypoint + 1) % waypoints.Length;
    }
}