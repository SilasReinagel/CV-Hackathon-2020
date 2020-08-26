using System.Linq;
using UnityEngine;

public sealed class MoveProcessor : OnMessage<MoveToRequested>
{
    [SerializeField] private CurrentLevelMap map;
    
    protected override void Execute(MoveToRequested m)
    {        
        if (m.Piece.GetComponent<MovementEnabled>() == null)
            return;

        var movementProposals = map.MovementOptionRules
            .Where(r => m.Piece.GetComponent<MovementEnabled>().Types.Any(t => r.Type == t))
            .Where(x => x.IsPossible(m))
            .Select(x => new MovementProposed(x.Type, m.Piece, m.From, m.To)).ToList();

        foreach (var proposal in movementProposals)
        {
            if (map.MovementRestrictionRules.All(x => x.IsValid(proposal)))
            {
                Message.Publish(new PieceMoved(proposal.Piece, m.From, m.To));
                return;
            }
        }
    }
}
