Shader "Unlit/DepthTest2"
{
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		// if less than depth buffer, draw this pixel
		ZWRITE ON
		// 始终将颜色值写入到深度buffer里面
		ZTEST ALWAYS
		Pass
		{
			Color(1, 1, 0, 1)
		}
	}
}
