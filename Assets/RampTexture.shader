Shader "Custom/RampTexture"
{
    Properties
    {
        _Albedo("Albedo color", Color) = (1, 1, 1, 1)
        _RampTex("Ramp texture", 2D) = "white"{}
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surf Ramp

            half4 _Albedo;
            sampler2D _RampTex;

            half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten)
            {
                half NdotL = dot(s.Normal, lightDir);
                half diff = NdotL * 0.5 + 5.0;            
                float2 uv_RampTex = float2(diff, diff);
                half3 ramp = tex2D(_RampTex, uv_RampTex).rgb;
                half4 c;
                c.rgb = s.Albedo * _LightColor0.rgb * ramp * atten;
                c.a = s.Alpha;
                return c;
            }

            struct Input
            {
                float a;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                o.Albedo = _Albedo.rgb;
            }
        ENDCG
    }
}