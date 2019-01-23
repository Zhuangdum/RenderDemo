// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/diffuse_tex_frag"
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
				// 这边绑定的语义在于告诉GPU属性用于存储什么样的信息(颜色， 纹理等)
				float4 pos : SV_POSITION;
				// float3 normal:TEXCOORD0;
				float3 normal:NORMAL;
				float2 uv:TEXCOORD1;
			};

			fixed4 _DiffuseColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (a2v i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.normal = mul(i.normal, (float3x3)unity_WorldToObject);
				// 取uv值
				o.uv = TRANSFORM_TEX(i.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 lambert = max(0.0, dot(-normalize(i.normal), normalize(_WorldSpaceLightPos0.xyz)));
				fixed3 diffuse = 0.5*lambert*_DiffuseColor.xyz*_LightColor0.xyz+0.5;
				fixed4 color = tex2D(_MainTex, i.uv);
				// 漫反射强度 乘 颜色值
				return fixed4(diffuse*color.xyz, 1.0);
			}
			ENDCG
		}
	}
}
