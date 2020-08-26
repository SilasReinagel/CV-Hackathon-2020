// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SciFi_Shader_Pack"
{
	Properties
	{
		[NoScaleOffset]_DisplacementMask("Mask Map", 2D) = "white" {}
		_Animation_speed("Animation Speed", Range( 0 , 4)) = 1
		_NormalPush("Normal Push", Range( -1 , 4)) = 0
		_Shrink_Faces_Amplitude("Shrink Factor", Range( -2 , 3)) = 0
		[NoScaleOffset]_FrontFace_Diffuse_map("FrontFace_Diffuse_map", 2D) = "white" {}
		_OutlineTex("Outline Map", 2D) = "white" {}
		_Outline_Opacity("Outline Opacity", Range( 0 , 200)) = 1
		[HDR]_Outline_Color("Outline Color", Color) = (1,1,1,0)
		_FrontFace_Intensity("Intensity Mult", Range( 0 , 4)) = 1
		[HDR]_FrontFace_Color("FrontFace Color", Color) = (1,1,1,0)
		_PannerY("PannerY", Range( -1 , 1)) = 0
		_PannerX("PannerX", Range( -1 , 1)) = 1
		_TileX("TileX", Range( 0.05 , 10)) = 1
		_TileY("TileY", Range( 0.05 , 10)) = 1
		[Toggle]_Stretching("Stretching", Float) = 0
		_DefaultShrink("DefaultShrink", Range( 0 , 0.5)) = 0
		_DefaultOutlineOpacity("DefaultOutlineOpacity", Range( 0 , 25)) = 0
		[Toggle]_Debug_Mask("Debug_Mask", Float) = 0
		[Toggle]_ExtrudeUpFaces("ExtrudeUpFaces", Float) = 0
		[Toggle]_TargetMode("TargetMode", Float) = 0
		[Toggle]_DirectionChange("~Direction Change", Float) = 0
		_target("target", Vector) = (0,0,0,0)
		_InfluenceRadius("InfluenceRadius", Float) = 0.5
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord2 : TEXCOORD2;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
			};

			uniform float _ExtrudeUpFaces;
			uniform sampler2D _DisplacementMask;
			uniform float _Animation_speed;
			uniform float _PannerX;
			uniform float _PannerY;
			uniform float _DirectionChange;
			uniform float _Stretching;
			uniform float _TileX;
			uniform float _TileY;
			uniform float _TargetMode;
			uniform float3 _target;
			uniform float _InfluenceRadius;
			uniform float _NormalPush;
			uniform float _DefaultShrink;
			uniform float _Shrink_Faces_Amplitude;
			uniform float _Debug_Mask;
			uniform sampler2D _FrontFace_Diffuse_map;
			uniform float _FrontFace_Intensity;
			uniform float4 _FrontFace_Color;
			uniform sampler2D _OutlineTex;
			uniform float4 _OutlineTex_ST;
			uniform float4 _Outline_Color;
			uniform float _DefaultOutlineOpacity;
			uniform float _Outline_Opacity;
			float2 MyCustomExpression146( float3 normal )
			{
				float3 normalVS = mul(UNITY_MATRIX_MV,normal);
				normalVS = normalize(normalVS);
				float2 uv_matcap = normalVS *0.5 + float2(0.5,0.5); float2(0.5,0.5);
				return uv_matcap;
			}
			
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float mulTime7 = _Time.y * _Animation_speed;
				float2 appendResult77 = (float2(_PannerX , _PannerY));
				float2 uv163 = v.ase_texcoord1 * float2( 1,1 ) + float2( 0,0 );
				float2 uv03 = v.ase_texcoord * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult81 = (float2(_TileX , _TileY));
				float2 temp_output_78_0 = ( lerp(uv163,uv03,_Stretching) * appendResult81 );
				float2 panner4 = ( mulTime7 * appendResult77 + lerp(temp_output_78_0,mul( float3( temp_output_78_0 ,  0.0 ), float3x3(0,1,0,1,0,0,0,0,0) ).xy,_DirectionChange));
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float3 temp_output_5_0_g1 = ( ( ase_worldPos - _target ) / _InfluenceRadius );
				float dotResult8_g1 = dot( temp_output_5_0_g1 , temp_output_5_0_g1 );
				float clampResult10_g1 = clamp( dotResult8_g1 , 0.0 , 1.0 );
				float mask124 = ( tex2Dlod( _DisplacementMask, float4( panner4, 0, 0.0) ).r * lerp(1.0,( 1.0 - pow( clampResult10_g1 , 0.5 ) ),_TargetMode) );
				float temp_output_67_0 = step( 0.0 , 1.0 );
				float2 uv314 = v.ase_texcoord3 * float2( 1,1 ) + float2( 0,0 );
				float2 uv415 = v.ase_texcoord4 * float2( 1,1 ) + float2( 0,0 );
				float4 appendResult17 = (float4(( uv314.x * -1.0 ) , uv314.y , uv415.x , 0.0));
				float4 temp_output_22_0 = ( float4( ( mask124 * v.ase_normal * ( _NormalPush * 0.01 ) * temp_output_67_0 ) , 0.0 ) + ( ( _DefaultShrink * appendResult17 * 0.01 ) + ( appendResult17 * _Shrink_Faces_Amplitude * mask124 * temp_output_67_0 * 0.01 ) ) );
				float2 uv4139 = v.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				
				o.ase_texcoord2.xyz = ase_worldPos;
				
				o.ase_normal = v.ase_normal;
				o.ase_texcoord.xy = v.ase_texcoord2.xy;
				o.ase_texcoord.zw = v.ase_texcoord1.xy;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = lerp(temp_output_22_0,( temp_output_22_0 * uv4139.y ),_ExtrudeUpFaces).xyz;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float3 normal146 = i.ase_normal;
				float2 localMyCustomExpression146 = MyCustomExpression146( normal146 );
				float4 tex2DNode27 = tex2D( _FrontFace_Diffuse_map, localMyCustomExpression146 );
				float4 break57 = ( tex2DNode27 * _FrontFace_Intensity * _FrontFace_Color );
				float4 appendResult56 = (float4(break57.r , break57.g , break57.b , _FrontFace_Color.a));
				float2 uv3_OutlineTex = i.ase_texcoord.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
				float temp_output_67_0 = step( 0.0 , 1.0 );
				float4 temp_output_37_0 = ( tex2D( _OutlineTex, uv3_OutlineTex ) * float4( 1,1,1,0 ) * _Outline_Color * temp_output_67_0 * float4( float3(0.3,0.3,0.3) , 0.0 ) );
				float mulTime7 = _Time.y * _Animation_speed;
				float2 appendResult77 = (float2(_PannerX , _PannerY));
				float2 uv163 = i.ase_texcoord.zw * float2( 1,1 ) + float2( 0,0 );
				float2 uv03 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult81 = (float2(_TileX , _TileY));
				float2 temp_output_78_0 = ( lerp(uv163,uv03,_Stretching) * appendResult81 );
				float2 panner4 = ( mulTime7 * appendResult77 + lerp(temp_output_78_0,mul( float3( temp_output_78_0 ,  0.0 ), float3x3(0,1,0,1,0,0,0,0,0) ).xy,_DirectionChange));
				float3 ase_worldPos = i.ase_texcoord2.xyz;
				float3 temp_output_5_0_g1 = ( ( ase_worldPos - _target ) / _InfluenceRadius );
				float dotResult8_g1 = dot( temp_output_5_0_g1 , temp_output_5_0_g1 );
				float clampResult10_g1 = clamp( dotResult8_g1 , 0.0 , 1.0 );
				float mask124 = ( tex2D( _DisplacementMask, panner4 ).r * lerp(1.0,( 1.0 - pow( clampResult10_g1 , 0.5 ) ),_TargetMode) );
				float dotResult42 = dot( tex2DNode27 , float4(0.5,0.5,0.5,0.5) );
				float4 temp_output_58_0 = ( appendResult56 + ( ( ( temp_output_37_0 * _DefaultOutlineOpacity ) + ( temp_output_37_0 * mask124 * _Outline_Opacity ) ) * dotResult42 ) );
				float4 temp_cast_6 = (mask124).xxxx;
				
				
				finalColor = lerp(temp_output_58_0,temp_cast_6,_Debug_Mask);
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ShapeFxPackUI"
	
	
}
/*ASEBEGIN
Version=17000
0;0;1920;1019;2975.166;-77.84464;1.612743;True;True
Node;AmplifyShaderEditor.CommentaryNode;26;-2203.424,-54.66446;Float;False;5180.465;991.6393;Comment;40;22;9;88;128;12;87;10;19;73;17;86;127;11;90;20;15;18;14;124;67;130;68;2;69;4;102;77;7;76;101;75;8;78;100;83;81;63;80;3;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2170.005,4.801289;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;79;-2151.865,317.4777;Float;False;Property;_TileX;TileX;15;0;Create;True;0;0;False;0;1;0;0.05;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-2146.865,413.4777;Float;False;Property;_TileY;TileY;16;0;Create;True;0;0;False;0;1;0;0.05;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-2163.262,145.7285;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;83;-1890.584,55.87494;Float;False;Property;_Stretching;Stretching;17;0;Create;True;0;0;False;0;0;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;81;-1847.863,264.4777;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Matrix3X3Node;100;-1481.106,275.6328;Float;False;Constant;_Matrix0;Matrix 0;22;0;Create;True;0;0;False;0;0,1,0,1,0,0,0,0,0;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-1586.033,62.03605;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-1022.028,278.4201;Float;False;Property;_PannerX;PannerX;14;0;Create;True;0;0;False;0;1;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1170.936,148.7365;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1020.09,493.8668;Float;False;Property;_Animation_speed;Animation Speed;1;0;Create;False;0;0;False;0;1;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;113;-1355.166,1145.323;Float;False;Property;_target;target;24;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;148;-1147.066,1631.047;Float;False;Property;_InfluenceRadius;InfluenceRadius;25;0;Create;True;0;0;False;0;0.5;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1023.028,371.4201;Float;False;Property;_PannerY;PannerY;13;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;102;-892.6642,58.56129;Float;False;Property;_DirectionChange;~Direction Change;23;0;Create;False;0;0;False;0;0;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;153;-1058.64,981.3115;Float;False;SphereMask;-1;;1;988803ee12caf5f4690caee3c8c4a5bb;0;3;15;FLOAT3;0,0,0;False;14;FLOAT;5;False;12;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;77;-742.0276,269.4201;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;-712.0626,504.0772;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;4;-571.3143,61.92897;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;154;-509.0463,985.9174;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;34;-2717.419,-1272.494;Float;False;828.1869;614.2216;MatcapUv;2;28;146;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;138;-39.41788,1286.486;Float;False;Property;_TargetMode;TargetMode;22;0;Create;True;0;0;False;0;0;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;68;-1553.441,787.1879;Float;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;2;-315.0696,40.8592;Float;True;Property;_DisplacementMask;Mask Map;0;1;[NoScaleOffset];Create;False;0;0;False;0;0fc8bf4d13e7b2c44872d87a42008190;0fc8bf4d13e7b2c44872d87a42008190;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-1558.588,857.5736;Float;False;Constant;_deformation_type_Factor;Transition Factor;13;0;Create;False;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;67;-550.1345,810.4012;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;1115.004,214.2874;Float;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;28;-2667.419,-1057.449;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;230.0174,55.88341;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;146;-2180.284,-1052.073;Float;False;float3 normalVS = mul(UNITY_MATRIX_MV,normal)@$$normalVS = normalize(normalVS)@$$float2 uv_matcap = normalVS *0.5 + float2(0.5,0.5)@ float2(0.5,0.5)@$$return uv_matcap@;2;False;1;True;normal;FLOAT3;0,0,0;In;;Float;False;My Custom Expression;True;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;1230.815,59.0615;Float;False;mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-603.7484,-2494.584;Float;False;Property;_Outline_Color;Outline Color;8;1;[HDR];Create;False;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;1506.059,238.3456;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;1131.64,592.7656;Float;False;4;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;40;-592.7091,-2314.927;Float;False;Constant;_HDR_Factor;HDR_Factor;9;0;Create;True;0;0;False;0;0.3,0.3,0.3;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;36;-1075.152,-2722.139;Float;True;Property;_OutlineTex;Outline Map;6;0;Create;False;0;0;False;0;b23676ff9cac20a4c9c7b9333f055f1b;b23676ff9cac20a4c9c7b9333f055f1b;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;92;-324.5876,-2282.434;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;1709.121,389.137;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-257.5504,-2446.647;Float;False;Property;_Outline_Opacity;Outline Opacity;7;0;Create;False;0;0;False;0;1;0;0;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;1647.042,702.643;Float;False;124;mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;1948.268,855.4913;Float;False;Constant;_Float1;Float 1;20;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;1851.036,668.8928;Float;False;Property;_Shrink_Faces_Amplitude;Shrink Factor;3;0;Create;False;0;0;False;0;0;0;-2;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;2015.664,14.41169;Float;False;Property;_DefaultShrink;DefaultShrink;18;0;Create;True;0;0;False;0;0;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-430.4011,-1469.032;Float;False;Property;_FrontFace_Intensity;Intensity Mult;9;0;Create;False;0;0;False;0;1;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-257.3275,-2534.387;Float;False;124;mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;73;1170.767,848.0627;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;-1657.885,-1563.108;Float;True;Property;_FrontFace_Diffuse_map;FrontFace_Diffuse_map;4;1;[NoScaleOffset];Create;True;0;0;False;0;d8cfe409d2fb65842a7151f63c8307c5;d8cfe409d2fb65842a7151f63c8307c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-267.07,-2709.459;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;298.8099,600.4836;Float;False;Property;_NormalPush;Normal Push;2;0;Create;False;0;0;False;0;0;0;-1;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-457.7407,-2933.661;Float;False;Property;_DefaultOutlineOpacity;DefaultOutlineOpacity;19;0;Create;True;0;0;False;0;0;0;0;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;47;-398.1266,-1373.554;Float;False;Property;_FrontFace_Color;FrontFace Color;11;1;[HDR];Create;False;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-60.74072,-2830.661;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;595.5834,236.8195;Float;False;124;mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;10;452.9073,352.5459;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;48.49939,-2708.229;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;695.8816,606.0494;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-126.4893,-1577.787;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;2371.971,640.7537;Float;False;5;5;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;2356.918,95.08242;Float;False;3;3;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector4Node;43;-561.5037,-1866.576;Float;False;Constant;_Vector1;Vector 1;9;0;Create;True;0;0;False;0;0.5,0.5,0.5,0.5;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;57;124.3944,-1579.249;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;93;324.2593,-2832.661;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;860.2293,336.7623;Float;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;42;-293.6394,-2012.16;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;2546.147,363.6688;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;2779.594,324.3912;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;703.6519,-1581.069;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;139;2802.2,655.3958;Float;False;4;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;717.688,-2310.317;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;3051.768,497.6676;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;1062.358,-1580.74;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;2900.163,-277.2464;Float;False;124;mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;120;-655.6412,1290.344;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-1678.485,-894.098;Float;True;Property;_BackFace_Diffuse_map;BackFace Map;5;1;[NoScaleOffset];Create;False;0;0;False;0;e6042d60a743b1145b5ea4a614f4aa98;e6042d60a743b1145b5ea4a614f4aa98;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-983.5407,1129.694;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;141;3294.109,323.7791;Float;False;Property;_ExtrudeUpFaces;ExtrudeUpFaces;21;0;Create;True;0;0;False;0;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-810.2424,1283.675;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.125;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-302.5623,1289.045;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;50;-354.3729,-676.5362;Float;False;Property;_BackFace_Color;BackFace Color;12;1;[HDR];Create;False;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;114;-1368.542,1465.305;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;49;-363.6474,-774.0141;Float;False;Property;_BackFace_Intensity;Intensity Mult;10;0;Create;False;0;0;False;0;1;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-59.73576,-881.7688;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;62;1563.623,-1223.438;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;149;-744.6842,1491.877;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;96;3316.306,-294.7485;Float;False;Property;_Debug_Mask;Debug_Mask;20;0;Create;True;0;0;False;0;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DistanceOpNode;112;-1126.243,1281.959;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;129;-492.0239,1318.29;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;736.6283,-885.4119;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;147;-904.0233,1504.987;Float;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;121;-288.7247,1408.236;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;51;153.3765,-881.1363;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FaceVariableNode;61;1396.652,-974.2081;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;111;3730.548,302.0112;Float;False;True;2;Float;ShapeFxPackUI;0;1;SciFi_Shader_Pack;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;83;0;63;0
WireConnection;83;1;3;0
WireConnection;81;0;79;0
WireConnection;81;1;80;0
WireConnection;78;0;83;0
WireConnection;78;1;81;0
WireConnection;101;0;78;0
WireConnection;101;1;100;0
WireConnection;102;0;78;0
WireConnection;102;1;101;0
WireConnection;153;15;113;0
WireConnection;153;14;148;0
WireConnection;77;0;75;0
WireConnection;77;1;76;0
WireConnection;7;0;8;0
WireConnection;4;0;102;0
WireConnection;4;2;77;0
WireConnection;4;1;7;0
WireConnection;154;0;153;0
WireConnection;138;1;154;0
WireConnection;2;1;4;0
WireConnection;67;0;68;0
WireConnection;67;1;69;0
WireConnection;130;0;2;1
WireConnection;130;1;138;0
WireConnection;146;0;28;0
WireConnection;124;0;130;0
WireConnection;18;0;14;1
WireConnection;92;0;67;0
WireConnection;17;0;18;0
WireConnection;17;1;14;2
WireConnection;17;2;15;1
WireConnection;73;0;67;0
WireConnection;27;1;146;0
WireConnection;37;0;36;0
WireConnection;37;2;39;0
WireConnection;37;3;92;0
WireConnection;37;4;40;0
WireConnection;94;0;37;0
WireConnection;94;1;95;0
WireConnection;91;0;37;0
WireConnection;91;1;126;0
WireConnection;91;2;38;0
WireConnection;12;0;11;0
WireConnection;45;0;27;0
WireConnection;45;1;46;0
WireConnection;45;2;47;0
WireConnection;19;0;17;0
WireConnection;19;1;20;0
WireConnection;19;2;127;0
WireConnection;19;3;73;0
WireConnection;19;4;90;0
WireConnection;87;0;86;0
WireConnection;87;1;17;0
WireConnection;87;2;90;0
WireConnection;57;0;45;0
WireConnection;93;0;94;0
WireConnection;93;1;91;0
WireConnection;9;0;128;0
WireConnection;9;1;10;0
WireConnection;9;2;12;0
WireConnection;9;3;67;0
WireConnection;42;0;27;0
WireConnection;42;1;43;0
WireConnection;88;0;87;0
WireConnection;88;1;19;0
WireConnection;22;0;9;0
WireConnection;22;1;88;0
WireConnection;56;0;57;0
WireConnection;56;1;57;1
WireConnection;56;2;57;2
WireConnection;56;3;47;4
WireConnection;44;0;93;0
WireConnection;44;1;42;0
WireConnection;140;0;22;0
WireConnection;140;1;139;2
WireConnection;58;0;56;0
WireConnection;58;1;44;0
WireConnection;120;0;118;0
WireConnection;35;1;146;0
WireConnection;123;0;112;0
WireConnection;141;0;22;0
WireConnection;141;1;140;0
WireConnection;118;0;123;0
WireConnection;118;1;149;0
WireConnection;152;0;129;0
WireConnection;48;0;35;0
WireConnection;48;1;49;0
WireConnection;48;2;50;0
WireConnection;62;0;52;0
WireConnection;62;1;58;0
WireConnection;62;2;61;0
WireConnection;149;0;147;0
WireConnection;96;0;58;0
WireConnection;96;1;125;0
WireConnection;112;0;113;0
WireConnection;112;1;114;0
WireConnection;129;0;120;0
WireConnection;52;0;51;0
WireConnection;52;1;51;1
WireConnection;52;2;51;2
WireConnection;52;3;50;4
WireConnection;147;1;148;0
WireConnection;121;0;152;0
WireConnection;51;0;48;0
WireConnection;111;0;96;0
WireConnection;111;1;141;0
ASEEND*/
//CHKSM=4ADF622681C5B21E643EBB011D4C627726DF03C7