// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/half_lambert"
{
	Properties
	{
		_DiffuseColor("DiffuseColor", Color) = (1, 1, 1, 1)
		_LamberValue("LamberValue", Range(0, 1)) = 0.5
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
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
			};

			fixed4 _DiffuseColor;
			float _LamberValue;
			
			v2f vert (a2v i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.worldNormal = mul(i.normal, (float3x3)unity_WorldToObject);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// half lambert parameters
				fixed3 lambert = _LamberValue*max(0.0, dot(-normalize(i.worldNormal), normalize(_WorldSpaceLightPos0.xyz)))+_LamberValue;
				fixed3 diffuse = lambert*_DiffuseColor.xyz*_LightColor0.xyz;
				return fixed4(diffuse, 1.0);
			}
			ENDCG
		}
	}
}
