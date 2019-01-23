Shader "Demo/BaseVert"
{
	Properties
	{
		_mainTex("RGB", 2D) = "white"{}
		_speed("speed", float) = 0.5
	}

	SubShader
	{
		Tags{"RenderType" = "Transparent"}
		Pass
		{
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _mainTex;
			float _speed;
			struct a2v
			{
				float4 vertex:POSITION;
				half2 texcoord:TEXCOORD0;
			};

			struct v2f
			{
				float4 pos:SV_POSITION;
				half2 uv:TEXCOORD0;
			};

			v2f vert(a2v v)
			{
				v2f o;
				// transform in model space
				//v.vertex.x += v.vertex.x*sin(_Time.y*_speed);
				o.pos = UnityObjectToClipPos(v.vertex);
				// transform in clip space
				// o.pos.x += o.pos.x*sin(_Time.y*_speed);
				o.uv = v.texcoord;
				return o;
			}

			fixed4 frag(v2f i):SV_Target
			{
				float4 c;
				c = tex2D(_mainTex, i.uv);
				return c;
			}
			ENDCG
		}
	}
}