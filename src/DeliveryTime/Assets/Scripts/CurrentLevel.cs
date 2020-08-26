using UnityEngine;

public class CurrentLevel : ScriptableObject
{
    [DTValidator.Optional, SerializeField] private GameLevel selectedLevel;
    [DTValidator.Optional, SerializeField] private GameObject activeLevelPrefab;
    [SerializeField] private int currentZoneNum;
    [SerializeField] private int currentLevelNum;
    [SerializeField] private bool enableDebugLogging;
    
    public GameLevel ActiveLevel => selectedLevel;
    public int ZoneNumber => currentZoneNum;
    public int LevelNumber => currentLevelNum;

    public void SelectLevel(GameLevel level, int zoneNum, int levelNum)
    {
        if (enableDebugLogging)
            Debug.Log($"Selected Z{zoneNum}-{levelNum} level {level.Name}");
        selectedLevel = level;
        currentZoneNum = zoneNum;
        currentLevelNum = levelNum;
    }

    public void Init()
    {
        if (enableDebugLogging)
            Debug.Log($"Initialized Level {selectedLevel.Name}");
        DestroyImmediate(activeLevelPrefab);
        activeLevelPrefab = Instantiate(selectedLevel.Prefab);
    }

    public void Clear()
    {
        DestroyImmediate(activeLevelPrefab);
    }
}
