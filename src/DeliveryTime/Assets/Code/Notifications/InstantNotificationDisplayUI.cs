using DG.Tweening;
using DTValidator.Internal;
using TMPro;
using UnityEngine;

public sealed class InstantNotificationDisplayUI : OnMessage<ShowNotification, DismissNotification>
{
    [SerializeField] private TextMeshProUGUI display;

    private void Awake() => display.text = "";

    protected override void Execute(ShowNotification msg)
    {
        display.text = msg.Text;
        display.DOKill();
        display.color = display.color.WithAlpha(0);
        display.DOFade(1f, 1.5f);
    }

    protected override void Execute(DismissNotification msg)
    {
        display.DOKill();
        display.DOFade(0, 1.5f);
    }
}
