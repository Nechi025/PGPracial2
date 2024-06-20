// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TVNoisePP"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_linesScale("linesScale", Range( 0 , 1)) = 0.5
		_smallNoiseScale("smallNoiseScale", Range( 0 , 1)) = 0.5
		_maskScale("maskScale", Range( 0 , 1)) = 0.5
		_smallNoiseAmmount("smallNoiseAmmount", Range( 0 , 0.6)) = 0.6
		_linesAmmount("linesAmmount", Range( 0 , 1)) = 0.282353
		_maskAmmount("maskAmmount", Range( 0.5 , 1)) = 1
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
			#include "UnityShaderVariables.cginc"


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
			
			uniform float _maskScale;
			uniform float _maskAmmount;
			uniform float _linesScale;
			uniform float _linesAmmount;
			uniform float _smallNoiseScale;
			uniform float _smallNoiseAmmount;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			


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
				float4 tex2DNode41 = tex2D( _MainTex, uv_MainTex );
				float2 uv0102 = i.uv.xy * float2( 16,9 ) + float2( 0,0 );
				float2 temp_cast_0 = (uv0102.y).xx;
				float2 panner127 = ( _Time.y * float2( 2,2 ) + temp_cast_0);
				float simplePerlin2D101 = snoise( panner127*_maskScale );
				simplePerlin2D101 = simplePerlin2D101*0.5 + 0.5;
				float simplePerlin2D104 = snoise( panner127*_linesScale );
				simplePerlin2D104 = simplePerlin2D104*0.5 + 0.5;
				float2 panner126 = ( _Time.y * float2( -2,0 ) + uv0102);
				float simplePerlin2D106 = snoise( panner126*_smallNoiseScale );
				simplePerlin2D106 = simplePerlin2D106*0.5 + 0.5;
				float temp_output_150_0 = ( ( 1.0 - ceil( ( simplePerlin2D101 - _maskAmmount ) ) ) * ( ceil( ( simplePerlin2D104 - ( 1.0 - _linesAmmount ) ) ) * ceil( ( simplePerlin2D106 - ( 1.0 - _smallNoiseAmmount ) ) ) ) );
				float4 temp_cast_1 = (temp_output_150_0).xxxx;
				float4 lerpResult109 = lerp( tex2DNode41 , temp_cast_1 , temp_output_150_0);
				

				finalColor = lerpResult109;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17200
0;584;1647;407;646.0632;37.39622;2.248458;True;False
Node;AmplifyShaderEditor.Vector2Node;72;-495.4661,140.4265;Inherit;False;Constant;_Ratio;Ratio;1;0;Create;True;0;0;False;0;16,9;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;131;-302.6162,270.4144;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;102;-327.6644,135.8163;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;120;-74.45477,555.8611;Inherit;False;Property;_smallNoiseScale;smallNoiseScale;1;0;Create;True;0;0;False;0;0.5;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-61.91833,-48.17977;Inherit;False;Property;_maskScale;maskScale;2;0;Create;True;0;0;False;0;0.5;1.697483;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-62.78748,253.4618;Inherit;False;Property;_linesScale;linesScale;0;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;126;-57.11863,375.0535;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-2,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;127;-34.70379,107.4885;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;2,2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;157;265.7085,327.5933;Inherit;False;Property;_linesAmmount;linesAmmount;4;0;Create;True;0;0;False;0;0.282353;0.3531406;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;251.3689,667.6487;Inherit;False;Property;_smallNoiseAmmount;smallNoiseAmmount;3;0;Create;True;0;0;False;0;0.6;0.1058824;0;0.6;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;101;224.3304,-30.56435;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;164;557.5911,299.1235;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;104;260.8663,224.1917;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;162;567.2651,630.0938;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;106;225.039,415.9373;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;457.6039,59.35785;Inherit;False;Property;_maskAmmount;maskAmmount;5;0;Create;True;0;0;False;0;1;0.3531406;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;163;737.6729,456.9837;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;158;752.7494,-38.94775;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;156;729.6134,178.3304;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;146;962.1672,394.2779;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;147;963.5046,-27.0451;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;148;976.9654,164.5376;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;1178.878,244.4172;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;42;780.1013,-220.4774;Inherit;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;160;1199.874,104.3912;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;1406.167,131.7305;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;913.7502,-248.2863;Inherit;True;Property;_TextureSample4;Texture Sample 4;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;137;1947.114,-184.0691;Inherit;True;FLOAT4;4;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;1250.083,-199.4489;Inherit;True;FLOAT4;4;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;109;1606.466,-9.702646;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;40;1989.972,-20.6016;Float;False;True;2;ASEMaterialInspector;0;7;TVNoisePP;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;0
WireConnection;102;0;72;0
WireConnection;126;0;102;0
WireConnection;126;1;131;0
WireConnection;127;0;102;2
WireConnection;127;1;131;0
WireConnection;101;0;127;0
WireConnection;101;1;119;0
WireConnection;164;0;157;0
WireConnection;104;0;127;0
WireConnection;104;1;118;0
WireConnection;162;0;155;0
WireConnection;106;0;126;0
WireConnection;106;1;120;0
WireConnection;163;0;106;0
WireConnection;163;1;162;0
WireConnection;158;0;101;0
WireConnection;158;1;159;0
WireConnection;156;0;104;0
WireConnection;156;1;164;0
WireConnection;146;0;163;0
WireConnection;147;0;158;0
WireConnection;148;0;156;0
WireConnection;149;0;148;0
WireConnection;149;1;146;0
WireConnection;160;0;147;0
WireConnection;150;0;160;0
WireConnection;150;1;149;0
WireConnection;41;0;42;0
WireConnection;137;0;109;0
WireConnection;110;0;41;0
WireConnection;109;0;41;0
WireConnection;109;1;150;0
WireConnection;109;2;150;0
WireConnection;40;0;109;0
ASEEND*/
//CHKSM=4C9A2A2F07D2360F24EBCC16E8231F104E929012