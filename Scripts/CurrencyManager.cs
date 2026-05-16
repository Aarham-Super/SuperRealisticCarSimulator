using UnityEngine;

public class CurrencyManager : MonoBehaviour
{
    [Header("Currency Balances")]
    public int coins = 0; // regular coins
    public int cash = 0;  // premium cash

    [Header("Conversion Settings")]
    public int coinsPerCash = 100; // 100 coins = 1 cash

    // Add coins to player balance
    public void AddCoins(int amount)
    {
        coins += amount;
        CheckConvertToCash();
    }

    // Add cash directly
    public void AddCash(int amount)
    {
        cash += amount;
    }

    // Spend coins, returns true if successful
    public bool SpendCoins(int amount)
    {
        if (coins >= amount)
        {
            coins -= amount;
            return true;
        }
        return false;
    }

    // Spend cash, returns true if successful
    public bool SpendCash(int amount)
    {
        if (cash >= amount)
        {
            cash -= amount;
            return true;
        }
        return false;
    }

    // Convert coins to cash automatically if enough coins
    private void CheckConvertToCash()
    {
        if (coins >= coinsPerCash)
        {
            int cashToAdd = coins / coinsPerCash;
            coins -= cashToAdd * coinsPerCash;
            cash += cashToAdd;
        }
    }

    // Get total value in coins including converted cash
    public int GetTotalValueInCoins()
    {
        return coins + (cash * coinsPerCash);
    }

    // Debug method to test adding and spending currency
    public void TestCurrency()
    {
        Debug.Log($"Coins: {coins}, Cash: {cash}, Total Value in Coins: {GetTotalValueInCoins()}");
    }
}