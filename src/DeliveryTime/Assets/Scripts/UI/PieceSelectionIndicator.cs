using UnityEngine;

public sealed class PieceSelectionIndicator : OnMessage<PieceSelected, PieceDeselected>
{
    [SerializeField] private GameObject indicator;

    private void Start() => indicator.SetActive(false);
    
    protected override void Execute(PieceSelected msg) 
        => indicator.SetActive(msg.Piece.Equals(transform.gameObject));

    protected override void Execute(PieceDeselected msg) 
        => indicator.SetActive(false);
}
