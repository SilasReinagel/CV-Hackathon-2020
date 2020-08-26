using UnityEngine;

public sealed class PieceJumped
{
    public GameObject Piece { get; }
    
    public PieceJumped(GameObject o) => Piece = o;
}
