using UnityEngine;
using UnityEngine.SceneManagement;

[CreateAssetMenu]
public sealed class DeliveryTimeNavigator : ScriptableObject
{
    public void NavigateToGameScene() => SceneManager.LoadScene("DeliveryTimeGameScene");
}
