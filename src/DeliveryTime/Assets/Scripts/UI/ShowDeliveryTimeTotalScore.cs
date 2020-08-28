using System.Collections;
using TMPro;
using UnityEngine;

public sealed class ShowDeliveryTimeTotalScore : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI score;
    [SerializeField] private DeliveryTimeScoreTracker tracker;

    private void Awake() => StartCoroutine(ShowScore());
    
    private IEnumerator ShowScore()
    {
        for (var i = 0; i < tracker.TotalStars; i++)
        {
            score.text = $"{i + 1}/{tracker.PossibleStars}";
            yield return new WaitForSeconds(0.2f);
        }
    }
}
