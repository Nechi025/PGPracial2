// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "OldVideoPP"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_REd("REd", Vector) = (0.2,0,0,0)
		_Blue("Blue", Vector) = (0,0.2,0,0)
		_Green("Green", Vector) = (-0.2,-0.2,0,0)
		_intensity("intensity", Range( 0.3 , 2)) = 1
		_Float("Float", Float) = 0.5
		_Potencia("Potencia", Float) = 0.01
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float2 _REd;
			uniform float _intensity;
			uniform float2 _Blue;
			uniform float2 _Green;
			uniform float _Float;
			uniform float _Potencia;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult43 = (float4(tex2D( _MainTex, uv_MainTex )));
				float3 temp_output_68_0 = ( _intensity * float3(3,0,0) );
				float4 appendResult47 = (float4(tex2D( _MainTex, ( float3( i.uv.xy ,  0.0 ) + ( float3( _REd ,  0.0 ) * temp_output_68_0 ) ).xy ).r , tex2D( _MainTex, ( float3( i.uv.xy ,  0.0 ) + ( float3( _Blue ,  0.0 ) * temp_output_68_0 ) ).xy ).g , tex2D( _MainTex, ( float3( i.uv.xy ,  0.0 ) + ( float3( _Green ,  0.0 ) * temp_output_68_0 ) ).xy ).b , 0.0));
				float2 temp_cast_10 = (_Float).xx;
				float4 lerpResult44 = lerp( appendResult43 , appendResult47 , pow( length( ( i.uv.xy - temp_cast_10 ) ) , _Potencia ));
				float4 appendResult45 = (float4(lerpResult44));
				

				finalColor = appendResult45;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17200
0;595;1465;396;1479.091;-420.099;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;48;-886.6655,442.111;Inherit;False;Property;_intensity;intensity;3;0;Create;True;0;0;False;0;1;0;0.3;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;69;-922.3485,524.2907;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;3,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;49;-507.0136,120.7507;Inherit;False;Property;_Blue;Blue;1;0;Create;True;0;0;False;0;0,0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;58;-661.0135,247.2253;Inherit;False;Property;_Green;Green;2;0;Create;True;0;0;False;0;-0.2,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-564.3485,510.2907;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;50;-506.0136,-63.48952;Inherit;False;Property;_REd;REd;0;0;Create;True;0;0;False;0;0.2,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-324.6812,335.9841;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-326.8712,150.9343;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;54;-371.2458,-188.7742;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-324.6814,-35.21226;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-354.2499,-436.3544;Inherit;False;Property;_Float;Float;4;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-145.112,143.105;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;41;-54.62098,-278.3666;Inherit;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;67;-153.0238,47.62053;Inherit;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-144.5892,286.8303;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-139.4943,-84.07442;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;60;-168.0308,-465.8629;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-62.07507,-380.3657;Inherit;False;Property;_Potencia;Potencia;5;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;63.67233,332.4107;Inherit;True;Property;_TextureSample2;Texture Sample 2;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;61;-0.03076172,-503.8629;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;64;65.69915,125.6972;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;75.01821,-283.6034;Inherit;True;Property;_TextureSample4;Texture Sample 4;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;81.91194,-70.88326;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;46;314.8074,-545.5269;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;474.8759,-213.7348;Inherit;False;FLOAT4;4;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;515.2074,-36.20444;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;44;731.9851,-205.4328;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;955.3852,-205.4269;Inherit;True;FLOAT4;4;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;40;1190.415,-223.5294;Float;False;True;2;ASEMaterialInspector;0;7;OldVideoPP;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;0
WireConnection;68;0;48;0
WireConnection;68;1;69;0
WireConnection;52;0;58;0
WireConnection;52;1;68;0
WireConnection;53;0;49;0
WireConnection;53;1;68;0
WireConnection;51;0;50;0
WireConnection;51;1;68;0
WireConnection;55;0;54;0
WireConnection;55;1;53;0
WireConnection;56;0;54;0
WireConnection;56;1;52;0
WireConnection;57;0;54;0
WireConnection;57;1;51;0
WireConnection;60;0;54;0
WireConnection;60;1;59;0
WireConnection;65;0;67;0
WireConnection;65;1;56;0
WireConnection;61;0;60;0
WireConnection;64;0;67;0
WireConnection;64;1;55;0
WireConnection;42;0;41;0
WireConnection;63;0;67;0
WireConnection;63;1;57;0
WireConnection;46;0;61;0
WireConnection;46;1;62;0
WireConnection;43;0;42;0
WireConnection;47;0;63;1
WireConnection;47;1;64;2
WireConnection;47;2;65;3
WireConnection;44;0;43;0
WireConnection;44;1;47;0
WireConnection;44;2;46;0
WireConnection;45;0;44;0
WireConnection;40;0;45;0
ASEEND*/
//CHKSM=BD40C14022C891368B6C14E39C8474B05BE153C2