Shader "Custom/OrenNayar"
{
    Properties
    {
        _Albedo("Albedo Color", Color) = (1, 1, 1, 1)
        _Roughness("Roughness", Range(0.1, 2.0)) = 0.5
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
                half roughness = _Roughness;
                half roughnessSqr = pow(roughness, 2);
                half3 o_n_fraction = roughnessSqr / (roughnessSqr + float3(0.33, 0.13, 0.09));
                half3 oren_nayar = float3(1, 0, 0) + float3(-0.5, 0.17, 0.45) * o_n_fraction;
                half cos_ndotl = saturate(dot(s.Normal, lightDir));
                half cos_ndotv = saturate(dot(s.Normal, viewDir));
                half oren_nayar_s = saturate(dot(lightDir, viewDir)) - cos_ndotl * cos_ndotv;
                oren_nayar_s /= lerp(max(cos_ndotl, cos_ndotv), 1, step(oren_nayar_s, 0));
                half4 c;
                c.rgb = s.Albedo * atten * _LightColor0.rgb * cos_ndotl * (oren_nayar.x + s.Albedo * oren_nayar.y + oren_nayar.z * oren_nayar_s);
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