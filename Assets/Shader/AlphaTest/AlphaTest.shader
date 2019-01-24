Shader "Custom/AlphaTest"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white"{}
		_Color("TansparentColor", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Tags{"RenderType"="Transparent" 
		 "Queue"="Transparent" }
		Pass
		{
			// ----------------------------blend mode----------------------------
			// Blend OFF
			// final = source * source alpha + texture *（1 - texture alpha）
			Blend SrcAlpha OneMinusSrcAlpha
			// ------------------without alpha-------------------------------
			// Blend One One
			// Blend One Zero
			// --------------------------------
			// Blend SrcAlpha  zero
			// Blend OneMinusDstColor One
			// Blend DstColor SrcColor
			CULL BACK
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv:TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv:TEXCOORD0;
			};

			sampler2D _MainTex;
			// float4 _MainTex_ST;
			fixed4 _Color;
			
			v2f vert (a2v i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				// o.uv = TRANSFORM_TEX(i.uv, _MainTex);
				o.uv = i.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 color = tex2D(_MainTex, i.uv);
				return color;
			}
			ENDCG	
		}
	}
}
