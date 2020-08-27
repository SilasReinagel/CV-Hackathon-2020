using System;
using System.Collections;
using UnityEngine;

public sealed class SceneBackgroundMusic : MonoBehaviour
{
    [SerializeField] private AudioClip music;
    [SerializeField] private GameMusicPlayer musicPlayer;
    [SerializeField] private FloatReference delayDuration = new FloatReference(0);

    private void Start()
    {
        StartCoroutine(ExectueAfterDelay(delayDuration, () => musicPlayer.PlaySelectedMusicLooping(music)));
    }
    
    private IEnumerator ExectueAfterDelay(float duration, Action action)
    {
        yield return new WaitForSeconds(duration);
        action();
    }
}
