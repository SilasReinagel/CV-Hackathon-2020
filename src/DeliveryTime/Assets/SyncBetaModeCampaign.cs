using UnityEngine;

public class SyncBetaModeCampaign : MonoBehaviour
{
    [SerializeField] private Campaign normalCampaign;
    [SerializeField] private Campaign betaCampaign;
    [SerializeField] private BoolVariable betaActive;
    [SerializeField] private SaveStorage save;

    void Awake()
    {
        var activeCampaign = betaActive.Value ? betaCampaign : normalCampaign;
        if (activeCampaign.Name != save.GetCampaign().Name)
        {
            save.SetCampaign(activeCampaign);
            save.SaveZone(0);
        }
    }
}
