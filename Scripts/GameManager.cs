using UnityEngine;

public class GameManager : MonoBehaviour
{
    public Transform[] trafficWaypoints;
    public GameObject[] trafficPrefabs;
    public int maxTraffic = 10;

    void Start()
    {
        SpawnTraffic();
    }

    void SpawnTraffic()
    {
        for (int i = 0; i < maxTraffic; i++)
        {
            GameObject prefab = trafficPrefabs[Random.Range(0, trafficPrefabs.Length)];
            Transform wp = trafficWaypoints[Random.Range(0, trafficWaypoints.Length)];
            Instantiate(prefab, wp.position, wp.rotation);
        }
    }
}