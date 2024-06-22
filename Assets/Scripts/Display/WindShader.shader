Shader"Custom/WindShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _WindStrength ("Wind Strength", Float) = 1.0
        _WindSpeed ("Wind Speed", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

#include "UnityCG.cginc"

sampler2D _MainTex;
float _WindStrength;
float _WindSpeed;
float4 _MainTex_ST;

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

v2f vert(appdata v)
{
    v2f o;
    float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                // Calculate wind effect
    float windEffect = sin(worldPos.x * _WindStrength + _Time.y * _WindSpeed) * 0.1;
    v.vertex.y += windEffect;

    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    fixed4 col = tex2D(_MainTex, i.uv);
    return col;
}
            ENDCG
        }
    }
FallBack"Diffuse"
}
