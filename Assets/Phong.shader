Shader "Custom/Phong"
{
    Properties
    {
        _Albedo("Albedo color", Color) = (1, 1, 1, 1)
        _SpecularColor("Specular color", Color) = (1, 1, 1, 1)
        _SpecularPower("Specular power", Range(0.0, 5.0)) = 1.0
        _SpecularGloss("Gloss", Range(0.0, 5.0)) = 1.0
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM

            #pragma surface surf Phong

            half4 _SpecularColor;
            half _SpecularPower;
            half _SpecularGloss;

            half4 LightingPhong(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
            {
                half NdotL = max(0, dot(s.Normal, lightDir));
                half3 lightReflectDir = reflect(-lightDir, s.Normal);
                half RdotV = max(0, dot(lightReflectDir, viewDir));
                half3 specularity = pow(RdotV, _SpecularGloss/4)*_SpecularPower *_SpecularColor.rgb ;
                half4 c;
                half3 lightingModel = NdotL * s.Albedo + specularity;
                half3 attenColor = _LightColor0.rgb * atten;
                half4 finalDiffuse = float4(lightingModel * attenColor, 1);
                c.rgb = finalDiffuse.rgb;
                c.a = s.Alpha;
                return c;
            }

            half4 _Albedo;

            struct Input
            {
                float a;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                o.Albedo = _Albedo;
            }
            
        ENDCG
    }
}