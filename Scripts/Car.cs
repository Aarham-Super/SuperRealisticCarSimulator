using UnityEngine;

[System.Serializable]
public class Car
{
    public string brand = "McLaren";
    public float maxSpeed = 300f;
    public float acceleration = 25f;
    public float brakePower = 50f;
    public float handling = 1.2f;
    public int gears = 6;
    public AudioClip engineSound;
    public AudioClip hornSound;
}