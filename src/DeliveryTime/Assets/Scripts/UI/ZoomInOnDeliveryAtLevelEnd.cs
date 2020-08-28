using DG.Tweening;
using UnityEngine;

public sealed class ZoomInOnDeliveryAtLevelEnd : OnMessage<LevelCompleted>
{
    [SerializeField] private CurrentLevelMap map;
    [SerializeField] private FloatReference zoomDuration = new FloatReference(1);

    private Camera _camera;
    
    private void Awake() => _camera = Camera.main;
    
    protected override void Execute(LevelCompleted msg)
    {
        _camera.transform.DOMove(map.FinalCameraAngle.position, zoomDuration);
        _camera.transform.DORotateQuaternion(map.FinalCameraAngle.rotation, zoomDuration);
    }
}
