using UnityEngine;

public sealed class UndoPieceMoved
{
    public GameObject Piece { get; }
    public TilePoint From { get; }
    public TilePoint To { get; }
    public TilePoint Delta => To - From;

    public UndoPieceMoved(GameObject obj, TilePoint from, TilePoint to)
    {
        Piece = obj;
        From = from;
        To = to;
    }

    public bool HadJumpedOver(GameObject other) => From.IsAdjacentTo(new TilePoint(other)) && To.IsAdjacentTo(new TilePoint(other))
                                                                                           && (To.X == From.X || To.Y == From.Y);
}
