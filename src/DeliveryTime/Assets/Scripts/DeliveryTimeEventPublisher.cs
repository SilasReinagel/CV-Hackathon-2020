using UnityEngine;

[CreateAssetMenu]
public sealed class DeliveryTimeEventPublisher : ScriptableObject
{
    public void ShowLevelSelect() => Message.Publish(new ShowLevelSelect());
}

