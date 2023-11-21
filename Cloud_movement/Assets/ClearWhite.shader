Shader "Custom/WhiteToTransparent"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
        LOD 200

        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);

                // Calculate the grayscale value of the pixel
                float grayscale = dot(color.rgb, float3(0.299, 0.587, 0.114));

                // Set alpha to 0 if the pixel is close to white
                float threshold = 0.6;
                color.a = (grayscale > threshold) ? 0.0 : color.a;

                return color;
            }

            ENDCG
        }
    }
}