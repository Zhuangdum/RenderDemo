Shader "Unlit/DepthTest"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		// if less than depth buffer, draw this pixel
		// ZWRITE ON
		// ZTEST ALWAYS
		Pass
		{
			Color(1, 0, 0, 1)
		}
	}
}
