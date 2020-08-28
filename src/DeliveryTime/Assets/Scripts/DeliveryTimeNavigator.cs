using UnityEngine;
using UnityEngine.SceneManagement;

[CreateAssetMenu]
public sealed class DeliveryTimeNavigator : ScriptableObject
{
    public void NavigateToGameScene() => SceneManager.LoadScene("DeliveryTimeGameScene");
    public void NavigateToMainMenu() => SceneManager.LoadScene("DeliveryTimeMainMenuScene");
    public void NavigateToSummaryScene() => SceneManager.LoadScene("DeliveryTimeSummaryScene");
}
