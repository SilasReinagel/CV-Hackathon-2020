using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
using System.Collections;

namespace XFrameEffect {
    [CustomEditor(typeof(XFrameManager))]
    public class XFrameEffectInspector : Editor {

        XFrameManager _effect;
        Texture2D _headerTexture;
        GUIStyle titleLabelStyle;
        Color titleColor;

        void OnEnable() {
            titleColor = EditorGUIUtility.isProSkin ? new Color(0.52f, 0.66f, 0.9f) : new Color(0.12f, 0.16f, 0.4f);
            _headerTexture = Resources.Load<Texture2D>("xFrameHeader");
            _effect = (XFrameManager)target;
            _effect.repaintInspectorAction = RefreshInspector;
        }

        void OnDisable() {
            if (_effect != null)
                _effect.repaintInspectorAction = null;
        }

        void RefreshInspector() {
            Repaint();
        }

        public override void OnInspectorGUI() {
            if (_effect == null)
                return;
            _effect.isDirty = false;

            EditorGUILayout.Separator();
            GUI.skin.label.alignment = TextAnchor.MiddleCenter;
            GUILayout.Label(_headerTexture, GUILayout.ExpandWidth(true));
            GUI.skin.label.alignment = TextAnchor.MiddleLeft;

            if (Application.isPlaying && _effect.method != XFRAME_DOWNSAMPLING_METHOD.Disabled && _effect.isActiveAndEnabled) {
                EditorGUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();
                if (_effect.niceFPSisActive) {
                    GUILayout.Label("Current quality: 100% (fps > niceFPS)");
                } else {
                    GUILayout.Label("Current quality: " + (int)(_effect.appliedDownsampling * 100f) + "%");
                }
                GUILayout.FlexibleSpace();
                EditorGUILayout.EndHorizontal();
            }

            EditorGUILayout.BeginHorizontal();
            DrawLabel("General Settings");
            if (GUILayout.Button("Help", GUILayout.Width(50))) {
                EditorUtility.DisplayDialog("Help", "XFrame reduces lag and contributes to a higher FPS for your game in exchange for image quality. As screens of mobile devices pack more and more pixels per inch, you can afford losing some pixels to get those extra FPS when needed.\n\nX-Frame includes several methods from static downsamplers which apply the specified image quality regardless of current fps to an adaptative method which varies the image quality depending on current fps.\n\nX-Frame is very customizable so you can set the minimum acceptable quality to a high value, like 0.7 or 0.8 to get extra FPS without loosing too much quality, or choose a lower minimum quality to get the best FPS at any moment.\n\nMove the mouse over a setting for a short description.\nVisit kronnect.com for support and questions.\n\nPlease rate X-Frame on the Asset Store! Thanks.", "Ok");
            }
            EditorGUILayout.EndHorizontal();

            if (_effect.compositingMethod != XFRAME_COMPOSITING_METHOD.LightweightRenderingPipeline) {
                _effect.method = (XFRAME_DOWNSAMPLING_METHOD)EditorGUILayout.EnumPopup(new GUIContent("Method", "Select the operation method."), _effect.method);

                switch (_effect.method) {
                    case XFRAME_DOWNSAMPLING_METHOD.HorizontalDownsampling:
                        EditorGUILayout.HelpBox("Reduces the width of the render target, perform the rendering and scales back the image to full window width. The amount of reduction is specified with the quality parameter.", MessageType.Info);
                        break;
                    case XFRAME_DOWNSAMPLING_METHOD.QuadDownsampling:
                        EditorGUILayout.HelpBox("Reduces both the width and height of the render target, perform the rendering and scales back the image to full window size. The amount of reduction is specified with the quality parameter.", MessageType.Info);
                        break;
                    case XFRAME_DOWNSAMPLING_METHOD.AdaptativeDownsampling:
                        EditorGUILayout.HelpBox("Reduces the size of the render target depending on real and desired FPS, perform the rendering and scales back the image to full window size. The amount of reduction is dynamically adjusted based on parameters below.", MessageType.Info);
                        break;
                }
            }

            if (_effect.method != XFRAME_DOWNSAMPLING_METHOD.Disabled) {

                if (_effect.compositingMethod != XFRAME_COMPOSITING_METHOD.LightweightRenderingPipeline) {
                    // Check for antialias in the main camera
                    MonoBehaviour[] components = _effect.GetComponents<MonoBehaviour>();
                    if (components != null) {
                        for (int k = 0; k < components.Length; k++) {
                            if (components[k] == null || !components[k].enabled)
                                continue;
                            string name = components[k].GetType().Name.ToUpper();
                            if (name.IndexOf("ANTIALIAS") >= 0) {
                                EditorGUILayout.HelpBox("An antialias component was found on this camera. Disable it and use integrated MSAA instead (antialias slider below).", MessageType.Warning);
                            } else if (name.IndexOf("NOISE") >= 0) {
                                EditorGUILayout.HelpBox("A noise component was found on this camera. Please disable it or add it XFrameCamera instead (only available with render methods that use a second camera - see below).", MessageType.Warning);
                            } else if (name.IndexOf("BEAUTIFY") >= 0) {
                                EditorGUILayout.HelpBox("Beautify component was found on this camera. Please disable it or add it to XFrameCamera instead (only available with render methods that use a second camera - see below).", MessageType.Warning);
                            }
                        }
                    }
                }

                if (_effect.method == XFRAME_DOWNSAMPLING_METHOD.AdaptativeDownsampling) {
                    _effect.targetFPS = EditorGUILayout.IntSlider(new GUIContent("Minimum FPS", "Minimum desired FPS during playmode."), _effect.targetFPS, 10, 120);
                }
                if (_effect.compositingMethod != XFRAME_COMPOSITING_METHOD.LightweightRenderingPipeline) {
                    EditorGUILayout.BeginHorizontal();
                    _effect.niceFPSEnabled = EditorGUILayout.Toggle(new GUIContent("Preserve Nice FPS", "Enables or disabled Nice FPS feature. If FPS exceeds this value, XFrame will be disabled. If FPS goes down, XFrame will be enabled again."), _effect.niceFPSEnabled, GUILayout.Width(20));
                    if (_effect.niceFPSEnabled) {
                        _effect.niceFPS = EditorGUILayout.IntSlider(_effect.niceFPS, 15, 120);
                    }
                    EditorGUILayout.EndHorizontal();
                }

                bool prev = _effect.showFPS;
                _effect.showFPS = EditorGUILayout.Toggle(new GUIContent("Show FPS", "Show current FPS on the screen."), _effect.showFPS);
                if (prev != _effect.showFPS) {
                    GUIUtility.ExitGUI();
                }

                if (_effect.showFPS) {
                    EditorGUI.indentLevel++;
                    _effect.fpsLocation = (XFRAME_FPS_LOCATION)EditorGUILayout.EnumPopup("Location", _effect.fpsLocation);
                    _effect.fpsFontSize = EditorGUILayout.IntField("Font Size", _effect.fpsFontSize);
                    _effect.fpsColor = EditorGUILayout.ColorField("Color", _effect.fpsColor);
                    EditorGUI.indentLevel--;
                }

                EditorGUILayout.Separator();
                EditorGUILayout.BeginHorizontal();
                DrawLabel("Quality Management Settings");
                EditorGUILayout.EndHorizontal();

                if (_effect.method == XFRAME_DOWNSAMPLING_METHOD.AdaptativeDownsampling) {

                    _effect.fpsChangeSpeedUp = EditorGUILayout.Slider(new GUIContent("Adapt Speed Up", "A value that defines how fast FPS will be incremented or decremented to keep up with target FPS."), _effect.fpsChangeSpeedUp, 0.01f, 0.1f);

                    _effect.fpsChangeSpeedDown = EditorGUILayout.Slider(new GUIContent("Adapt Speed Down", "A value that defines how fast FPS will be decremented to keep up with target FPS."), _effect.fpsChangeSpeedDown, 0.01f, 0.1f);

                    _effect.downsampling = EditorGUILayout.Slider(new GUIContent("Minimum Quality", "Minimum acceptable quality level to enforce FPS rate."), _effect.downsampling, 0.1f, 1f);

                    _effect.staticCameraDownsampling = EditorGUILayout.Slider(new GUIContent("Static Camera Quality", "Quality level used when camera is static to enforce FPS rate. You may want to have a higher quality value when camera is not moving or rotating. When camera moves or rotates the minimum quality is used instead."), _effect.staticCameraDownsampling, 0.1f, 1f);

                } else {
                    _effect.downsampling = EditorGUILayout.Slider(new GUIContent("Quality", "This value determines the amount of detail loss or downsampling applied (1=no loss/no effect, 0.5=half reduction, ...)"), _effect.downsampling, 0.1f, 1f);
                    _effect.staticCameraDownsampling = EditorGUILayout.Slider(new GUIContent("Static Camera Quality", "Quality level used when camera is static. You may want to have a higher quality value when camera is not moving or rotating. When camera moves or rotates the normal quality is used instead."), _effect.staticCameraDownsampling, 0.1f, 1f);
                }

                _effect.reducePixelLights = EditorGUILayout.Toggle(new GUIContent("Reduce Pixel Lights", "Reduce pixel light count as FPS decrease."), _effect.reducePixelLights);

                _effect.manageShadows = EditorGUILayout.Toggle(new GUIContent("Manage Shadows", "Automatically switches shadow quality or disable them to improve frame rate."), _effect.manageShadows);
                if (_effect.manageShadows) {
                    _effect.manageShadowsMinInterval = EditorGUILayout.FloatField(new GUIContent("  Min Interval", "Minimum interval until shadows are restored to original settings."), _effect.manageShadowsMinInterval);
                }
                EditorGUILayout.Separator();
                EditorGUILayout.BeginHorizontal();
                DrawLabel("Rendering Settings");
                EditorGUILayout.EndHorizontal();

                if (_effect.compositingMethod == XFRAME_COMPOSITING_METHOD.LightweightRenderingPipeline) {
                    GUI.enabled = false;
                }
                _effect.compositingMethod = (XFRAME_COMPOSITING_METHOD)EditorGUILayout.EnumPopup(new GUIContent("Render Method", "Compositing mode. Simple uses OnGUI event to draw the upscaled frame. SecondCameraBlit uses a second camera and a post-image effect to upscale the frame. SecondCameraBillboard uses a second camera and a simple billboard to draw the frame."), _effect.compositingMethod);
                GUI.enabled = true;

                if (_effect.compositingMethod != XFRAME_COMPOSITING_METHOD.LightweightRenderingPipeline) {
                    _effect.filtering = (XFRAME_FILTERING_MODE)EditorGUILayout.EnumPopup(new GUIContent("Filtering", "Use nearest neighbour to produce a pixelate effect."), _effect.filtering);

                    EditorGUILayout.BeginHorizontal();
                    _effect.antialias = EditorGUILayout.IntSlider(new GUIContent("Antialiasing", "Enable antialias on demand. Level of antialias depends on FPS."), _effect.antialias, 1, 4);
                    if (_effect.antialias == 1) {
                        EditorGUILayout.LabelField("(Off)", GUILayout.Width(30));
                    } else if (_effect.rt != null) {
                        EditorGUILayout.LabelField(string.Format("x{0}", _effect.rt.antiAliasing), GUILayout.Width(30));
                    }
                    EditorGUILayout.EndHorizontal();


                    if (_effect.compositingMethod == XFRAME_COMPOSITING_METHOD.SecondCameraBlit) {
                        _effect.sharpen = EditorGUILayout.Toggle(new GUIContent("Sharpen Image", "Apply a sharpen filter to enhance details of the upscaled image and reduce blur. You may deactivate this option to slightly improve the performance on mobile."), _effect.sharpen);
                        _effect.cameraClearFlags = (CameraClearFlags)EditorGUILayout.EnumPopup(new GUIContent("Clear Flags", "X-Frame's camera clear flags. Set this to Color or Solid Color if you experience ghosting artifacts."), _effect.cameraClearFlags);
                    } else {
                        _effect.blendWithBackground = EditorGUILayout.Toggle(new GUIContent("Blend With Background", "Use only to blend X-Frame camera content on top of other background camera."), _effect.blendWithBackground);
                        if (_effect.blendWithBackground && _effect.mainCamera != null && _effect.mainCamera.clearFlags == CameraClearFlags.Depth) {
                            EditorGUILayout.HelpBox("Main camera clear flags should not be set to depth.", MessageType.Warning);
                        }
                        if (!_effect.blendWithBackground) {
                            _effect.cameraClearFlags = (CameraClearFlags)EditorGUILayout.EnumPopup(new GUIContent("Clear Flags", "X-Frame's camera clear flags. Set this to Color or Solid Color if you experience ghosting artifacts."), _effect.cameraClearFlags);
                        }
                    }

                    _effect.prewarm = EditorGUILayout.Toggle(new GUIContent("Prewarm", "Generates target buffers during initialization. If this value is false, target buffers are created on demand. Most of the cases you can leave this option unchecked."), _effect.prewarm);
                }

                _effect.enableClickEvents = EditorGUILayout.Toggle(new GUIContent("GameObject Clicks", "Uses Raycasting to send mouse events on scene gameobjects that require them."), _effect.enableClickEvents);
            }

            _effect.boostFrameRate = EditorGUILayout.Toggle(new GUIContent("Boost Frame Rate", "When enabled, V-Sync will be disabled and Application target frame rate is set very high. Disable this option and enable V-Sync in Quality Settings if you experience tearing artifacts."), _effect.boostFrameRate);

            if (_effect.isDirty && !Application.isPlaying) {
                EditorUtility.SetDirty(target);
                EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
            }

        }

        void DrawLabel(string s) {
            if (titleLabelStyle == null) {
                titleLabelStyle = new GUIStyle(GUI.skin.label);
            }
            titleLabelStyle.normal.textColor = titleColor;
            GUILayout.Label(s, titleLabelStyle);
        }

    }

}
