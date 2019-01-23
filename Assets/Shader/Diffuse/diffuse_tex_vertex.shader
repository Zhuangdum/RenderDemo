// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//#define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)
//Tiling表示纹理的缩放比例，Offset表示了纹理使用时采样的偏移值。
//在采样时，将材质面板上设置的Tiling值通过XXX_ST.xy传递进来，
//用于和采样的坐标相乘，进行采样的缩放，将Offset值通过XXX_ST.zw传递进来，作为纹理采样的偏移。


Shader "Custom/diffuse_tex_vertex"
{
	Properties
	{
		_DiffuseColor("DiffuseColor", Color) = (1, 1, 1, 1)
		_MainTex("MainTex", 2D) = "white"{}
	}
	SubShader
	{
		Pass
		{
			Tags{"RenderType" = "Opaque"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord:TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed4 color:COLOR;
				float2 uv:TEXCOORD1;
			};

			fixed4 _DiffuseColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (a2v i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				fixed3 worldNormal = mul(i.normal, (float3x3)unity_WorldToObject);
				fixed3 lambert = max(0.0, dot(-normalize(worldNormal), normalize(_WorldSpaceLightPos0.xyz)));
				fixed3 diffuse = 0.5*lambert*_DiffuseColor.xyz*_LightColor0.xyz+0.5;
				o.color = fixed4(diffuse, 1.0);
				o.uv = TRANSFORM_TEX(i.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return i.color*tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
}
