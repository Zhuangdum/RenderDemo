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
				fixed3 worldNormal:TEXCOORD0;
				fixed3 viewDir:TEXCOORD1;
			};

			v2f vert (a2v i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				// get ambient
				o.worldNormal = normalize(UnityObjectToWorldNormal(i.normal));
				// get view dir
				o.viewDir = normalize(WorldSpaceViewDir(i.vertex));
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				// diffuse color
				fixed3 diffuse = _LightColor0.rgb*_Diffuse*max(0, dot(i.worldNormal, worldLight));
				// get reflect // attention: worldLight is point to light, not vertex
				fixed3 reflectDir = normalize(reflect(-worldLight, i.worldNormal));
				// calc specular
				fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(saturate(dot(reflectDir, i.viewDir)), _Gloss);
				
				return fixed4(ambient+diffuse+specular, 1.0);
			}
			ENDCG
		}
	}
}
