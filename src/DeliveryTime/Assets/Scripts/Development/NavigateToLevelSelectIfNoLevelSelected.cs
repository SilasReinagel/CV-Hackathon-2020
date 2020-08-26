using UnityEngine;

public sealed class NavigateToLevelSelectIfNoLevelSelected : MonoBehaviour
{
    [SerializeField] private CurrentLevel current;
    [SerializeField] private Navigator navigator;
    
    void Awake()
    {
        if (current.ActiveLevel == null)
            navigator.NavigateToLevelSelect();
    }
}
