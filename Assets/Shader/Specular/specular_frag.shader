Shader "Custom/SpecularFrag"
{
	Properties
	{
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss",Range(8.0,256)) = 20
	}
	SubShader
	{
		Tags { "LightMode"="ForwardBase"}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"
			#include "UnityCG.cginc"

			float4 _Diffuse;
			float4 _Specular;
			float _Gloss;

			struct a2v
			{
				float4 vertex:POSITION;
				fixed3 normal:NORMAL;
			};

			struct v2f
			{
				float4 pos:SV_POSITION;
				fixed3 color:COLOR;
			};

			v2f vert (a2v i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				// get ambient
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldnormal = normalize(UnityObjectToWorldNormal(i.normal));
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				// diffuse color
				fixed3 diffuse = _LightColor0.rgb*_Diffuse*max(0, dot(worldnormal, worldLight));
				// get reflect // attention: worldLight is point to light, not vertex
				fixed3 reflectDir = normalize(reflect(-worldLight, worldnormal));
				// get view dir
				fixed3 viewDir = normalize(WorldSpaceViewDir(i.vertex));
				// calc specular
				fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(saturate(dot(reflectDir, viewDir)), _Gloss);
				// return color
				o.color = ambient+diffuse+specular;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return fixed4(i.color, 1.0);
			}
			ENDCG
		}
	}
}
