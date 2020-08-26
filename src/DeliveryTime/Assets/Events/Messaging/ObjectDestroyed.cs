using UnityEngine;

public class ObjectDestroyed
{
    public GameObject Object { get; }
    public TilePoint Location { get; }
    public bool IsGameObjectDestructionHandled { get; }

    public ObjectDestroyed(GameObject o, bool isGameObjectDestructionHandled = false)
    {
        Object = o;
        Location = new TilePoint(o);
        IsGameObjectDestructionHandled = isGameObjectDestructionHandled;
    }
}
