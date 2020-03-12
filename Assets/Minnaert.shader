Shader "Custom/Minnaert"
{
    Properties
    {
        _Albedo("Albedo Color", Color) = (1, 1, 1, 1)
        _Roughness("Roughness", Range(0.1, 1.0)) = 0.5
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM

            half4 _Albedo;
            half _Roughness;

            #pragma surface surf Minnaert

            half4 LightingMinnaert(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
            {
                float NdotL = max(0, dot(s.Normal, lightDir ));
                float NdotV = max(0, dot(s.Normal, viewDir));
                float3 minnaert = saturate(NdotL * pow(NdotL * NdotV, _Roughness));
                half4 c;
                c.rgb = minnaert * s.Albedo * atten * _LightColor0.rgb;
                c.a = s.Alpha;
                return c;
            }

            struct Input 
            {
                fixed a;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                o.Albedo = _Albedo.rgb;
            }
        ENDCG
    }
}