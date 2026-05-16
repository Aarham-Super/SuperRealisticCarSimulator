using UnityEngine;

public class UIManager : MonoBehaviour
{
    public VehicleController playerCar;
    public CurrencyManager currencyManager;

    void OnGUI()
    {
        if (playerCar == null || currencyManager == null) return;

        GUIStyle style = new GUIStyle(GUI.skin.label);
        style.fontSize = 24;
        style.normal.textColor = Color.white;

        GUI.Label(new Rect(10, 10, 300, 30), "Speed: " + Mathf.Round(playerCar.currentSpeed) + " km/h", style);
        GUI.Label(new Rect(10, 40, 300, 30), "Gear: " + playerCar.currentGear, style);
        GUI.Label(new Rect(10, 70, 300, 30), "Coins: " + currencyManager.coins, style);
        GUI.Label(new Rect(10, 100, 300, 30), "Cash: " + currencyManager.cash, style);
    }
}