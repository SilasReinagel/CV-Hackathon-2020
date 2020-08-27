using System;
using System.Collections;
using UnityEngine;

public sealed class SceneBackgroundMusic : MonoBehaviour
{
    [SerializeField] private AudioClip music;
    [SerializeField] private AudioClip[] altMusic = new AudioClip[0]; 
    [SerializeField] private GameMusicPlayer musicPlayer;
    [SerializeField] private FloatReference delayDuration = new FloatReference(0);

    private void Start()
    {
        StartCoroutine(ExecuteAfterDelay(delayDuration, 
            () => musicPlayer.PlaySelectedMusicLooping(altMusic.Concat(music).Random())));
    }
    
    private IEnumerator ExecuteAfterDelay(float duration, Action action)
    {
        yield return new WaitForSeconds(duration);
        action();
    }
}
