using UnityEngine;

public class MovingPiece : MonoBehaviour
{
    [SerializeField] private LockBoolVariable gameInputActive;
    [SerializeField] private FloatReference secondsToTravel;
    [SerializeField] private CurrentLevelMap map;
    [SerializeField] private GameObject rotateTarget;
    [SerializeField] private bool shouldRotate;

    private bool _moving = false;
    private PieceMoved _msg;
    private Vector3 _start;
    private Vector3 _end;
    private float _t;

    private void Execute(UndoPieceMoved msg)
    {
        if (msg.Piece == gameObject)
        {
            transform.localPosition = new Vector3(msg.From.X, msg.From.Y, transform.localPosition.z);
            Message.Publish(new PieceDeselected());
            Message.Publish(new PieceSelected(gameObject));
        }
    }

    private void Execute(PieceMoved msg)
    {
        if (msg.Piece == gameObject)
        {
            _moving = true;
            _msg = msg;
            gameInputActive.Lock(gameObject);
            _start = new Vector3(msg.From.X, msg.From.Y, transform.localPosition.z);
            _end = new Vector3(msg.To.X, msg.To.Y, transform.localPosition.z);
            _t = 0;
        }
    }

    private void Update()
    {
        if (_moving)
        {
            _t += Time.deltaTime / secondsToTravel;
            transform.localPosition = Vector3.Lerp(_start, _end, _t);
            if (Vector3.Distance(transform.localPosition, _end) < 0.01)
            {
                transform.localPosition = _end;
                map.Move(_msg.Piece, _msg.From, _msg.To);
                gameInputActive.Unlock(gameObject);
                _moving = false;
            }
        }
    }

    private void OnEnable()
    {
        _moving = false;
        Message.Subscribe<PieceMoved>(Execute, this);
        Message.Subscribe<UndoPieceMoved>(Execute, this);
    }

    private void OnDisable()
    {
        gameInputActive.Unlock(gameObject);
        Message.Unsubscribe(this);
    }
}
