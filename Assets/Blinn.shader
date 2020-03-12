Shader "Custom/Blinn"
{
    Properties
    {
        _Albedo("Albedo Color", Color) = (1, 1, 1, 1)
        _SpecularColor("Specular Color", Color) = (1, 1, 1, 1)
        _SpecPower("Specular Power", Range(0.0, 5.0)) = 1.0
        _SpecGloss("Specular Gloss", Range(0.0, 5.0)) = 1.0
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surf Blinn

            half4 _Albedo;
            half4 _SpecularColor;
            half _SpecPower;
            half _SpecGloss;

            half4 LightingBlinn(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
            {
                half3 halfDirection = normalize(viewDir + lightDir); 
                half NdotL = max(0, dot( s.Normal, lightDir ));
                half NdotV = max(0, dot( s.Normal, halfDirection ));
                half3 specularity = pow(NdotV , _SpecGloss) * _SpecPower * _SpecularColor.rgb ;
                half4 c;
                c.rgb = (NdotL * s.Albedo + specularity) * _LightColor0.rgb * atten;
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