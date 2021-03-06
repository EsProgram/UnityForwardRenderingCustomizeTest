﻿Shader "ForwardRendering/CustomLightingForwardBase"
{
	SubShader
	{

		Pass
		{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float4 diffuse : COLOR0;
			};

			//ライトの色
			fixed4 _LightColor0;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				//球面調和
				o.diffuse.rgb = ShadeSH9(half4(v.normal,1));
				o.diffuse.a = 1;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = float4(0.5, 0.5, 0.5, 1);
				//Diffuseカラー計算
				i.diffuse += max(0, dot(i.normal, _WorldSpaceLightPos0.xyz)) * _LightColor0;
				col *= i.diffuse;
				return col;
			}
			ENDCG
		}
	}
}
