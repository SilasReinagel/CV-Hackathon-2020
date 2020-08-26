using UnityEngine;

public sealed class CollectStarOnEntered : OnMessage<PieceMoved>
{
    [SerializeField] private CurrentLevelMap map;

    private void Start()
    {
        map.RegisterAsCollectible(gameObject);
    }

    protected override void Execute(PieceMoved msg)
    {
        if (!new TilePoint(gameObject).Equals(msg.To)) return;
        
        Message.Publish(StarCollected.OnMapDataCube(gameObject));
        Message.Publish(new ObjectDestroyed(gameObject));
    }

    public void Revert() => gameObject.SetActive(true);
}
