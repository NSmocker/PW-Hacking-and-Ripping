
// This is used by 3dsmax to load the correct parser
string ParamID = "0x0";

//DxMaterial specific 

// light direction (view space)
float3 g_LightDir : Direction <  
	string UIName = "Light"; 
	string Object = "TargetLight";
	int refID = 0;
> = {-0.577, -0.577, 0.577};

float4 g_LightCol : LIGHTCOLOR
<
	int LightRef = 0;
> = float4(0.0f, 0.0f, 0.0f, 0.0f);

// material reflectivity
float4 k_a  <
	string UIName = "Ambient";
> = float4( 0.47f, 0.47f, 0.47f, 1.0f );    // ambient
	
float4 k_d  <
	string UIName = "Diffuse";
> = float4( 0.47f, 0.47f, 0.47f, 1.0f );    // diffuse
	
float4 k_s  <
	string UIName = "Specular";
> = float4( 1.0f, 1.0f, 1.0f, 1.0f );    // diffuse    // specular

int n<
	string UIName = "Specular Power";
	string UIType = "IntSpinner";
	float UIMin = 0.0f;
	float UIMax = 50.0f;	
>  = 15;

bool g_AlphaVertex <
	string UIName = "Vertex Alpha";
> = true;

bool g_AddVertexColor <
	string UIName = "Add Vertex Color";
> =false;

bool g_UseParallax <
	string UIName = "Normal Map Parallax";
> =false;

float g_BumpScale <
	string UIName = "Bump Amount";
	float UIMin = 0.0f;
	float UIMax = 5.0f;
	float UIStep = 0.01f;
>   = 1.0f;


float g_ParallaxScale <
	string UIName = "Parallax Scale";
	float UIMin = -0.50f;
	float UIMax = 0.5f;
	float UIStep = 0.01f;
>   = 0.02f;
									
float g_ParallaxBias <
	string UIName = "Parallax Bias";
	float UIMin = -0.5f;
	float UIMax = 0.5f;
	float UIStep = 0.01f;
>   = 0.0f;

bool g_AmbientOccEnable <
	string UIName = "Ambient Occlusion Enable";
> = false;

texture g_AmbientOccTexture < 
	string UIName = "Ambient Occlusion";
	int Texcoord = 4;
	int MapChannel = 1;
>;

bool g_TopDiffuseEnable <
	string UIName = "Top Diffuse Color Enable";
> = false;

texture g_TopTexture : DiffuseMap< 
	string UIName = "Top Diffuse Map ";
	int Texcoord = 0;
	int MapChannel = 1;
>;

bool g_BottomDiffuseEnable <
	string UIName = "Bottom Diffuse Color Enable";
> = false;

texture g_BottomTexture < 
	string UIName = "Bottom Diffuse";
	int Texcoord = 5;
	int MapChannel = 1;
>;

bool g_SpecularEnable <
	string UIName = "Specular  Enable";
> = false;

texture g_SpecularTexture < 
	string UIName = "Specular";
	int Texcoord = 6;
	int MapChannel = 1;
>;

bool g_NormalEnable <
	string UIName = "Normal Enable";
> = false;

texture g_NormalTexture < 
	string UIName = "Normal";
	int Texcoord = 7;
	int MapChannel = 1;
>;

bool g_ReflectionEnable <
	string UIName = "Reflection Enable";
> = false;

texture g_ReflectionTexture < 
	string UIName = "Reflection";
	string Type = "CUBE";
>;


sampler2D g_AmbientOccSampler = sampler_state
{
	Texture = <g_AmbientOccTexture>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};


sampler2D g_TopSampler = sampler_state
{
	Texture = <g_TopTexture>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};
	
sampler2D g_BottomSampler = sampler_state
{
	Texture = <g_BottomTexture>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler2D g_SpecularSampler = sampler_state
{
	Texture = <g_SpecularTexture>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler2D g_NormalSampler = sampler_state
{
	Texture = <g_NormalTexture>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

samplerCUBE g_ReflectionSampler = sampler_state
{
	Texture = <g_ReflectionTexture>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};



// transformations
float4x4 World      : 		WORLD;
float4x4 View       : 		VIEW;
float4x4 Projection : 		PROJECTION;
float4x4 WorldViewProj : 	WORLDVIEWPROJ;
float4x4 WorldView : 		WORLDVIEW;
float3	g_CamPos	:	WORLDCAMERAPOSITION;

int texcoord1 : Texcoord
<
	int Texcoord = 1;
	int MapChannel = 0;
>;

int texcoord2 : Texcoord
<
	int Texcoord = 2;
	int MapChannel = -2;
>;

int texcoord3 : Texcoord
<
	int Texcoord = 3;
	int MapChannel = -1;
>;


float3 NormalCalc(float3 mapNorm, float BumpScale)
{
	float3 v = {0.5f,0.5f,1.0f};
	mapNorm = lerp(v, mapNorm, BumpScale );
	mapNorm = ( mapNorm * 2.0f ) - 1.0f;
	return mapNorm;
}


struct VSIn
{
	float3 Position		: POSITION;
	float3 Normal		: NORMAL;
	float3 Tangent		: TANGENT;
	float3 BiNormal		: BINORMAL;
	float2 UV0		: TEXCOORD0;	
	float3 Colour		: TEXCOORD1;
	float3 Alpha		: TEXCOORD2;
	float3 Illum		: TEXCOORD3;
	float3 UV1		: TEXCOORD4;
	float3 UV2		: TEXCOORD5;
	float3 UV3		: TEXCOORD6;
	float3 UV4		: TEXCOORD7;

};


struct VSOut
{
	float4 Position		: POSITION;
	float4 Colour		: COLOR0;
   	float2 UV0		: TEXCOORD0;
   	float3 LightDir		: TEXCOORD1;
   	float3 Normal		: TEXCOORD2;
   	float3 ViewDir		: TEXCOORD3;
	float2 UV1		: TEXCOORD4;
	float2 UV2		: TEXCOORD5;
	float2 UV3		: TEXCOORD6;
	float2 UV4		: TEXCOORD7;
   	
};

struct PSIn
{
	float4 Colour		: COLOR0;
   	float2 UV0		: TEXCOORD0;
   	float3 LightDir		: TEXCOORD1;
   	float3 Normal		: TEXCOORD2;
   	float3 ViewDir		: TEXCOORD3;
	float2 UV1		: TEXCOORD4;
	float2 UV2		: TEXCOORD5;
	float2 UV3		: TEXCOORD6;
	float2 UV4		: TEXCOORD7;

};

struct PSOut
{
	float4 Colour		: COLOR0;
};


VSOut VS(VSIn vsIn) 
{
	VSOut vsOut;                                                                                                                                                                                                                                                                                                                                   
   	vsOut.Position = mul(float4(vsIn.Position, 1.0f), WorldViewProj);
      	vsOut.Colour.rgb = vsIn.Colour * vsIn.Illum;
	vsOut.Colour.a	= vsIn.Alpha.x;
	vsOut.Normal = vsIn.Normal;

	float4 WorldPos = mul(float4(vsIn.Position, 1.0f),World);
	float3 ViewDir = g_CamPos - WorldPos.xyz;

	if(g_NormalEnable)
	{
		float3x3 objToTangent;

		objToTangent[0] = vsIn.BiNormal;
		objToTangent[1] = vsIn.Tangent;
		objToTangent[2] = vsIn.Normal;
		
		vsOut.LightDir = mul(objToTangent, g_LightDir);
		vsOut.ViewDir = mul(objToTangent, ViewDir);
		
	}
	else
	{
		vsOut.LightDir = g_LightDir;
		vsOut.ViewDir = ViewDir;
	}
	
   	vsOut.UV0 = vsIn.UV0;
   	vsOut.UV1 = vsIn.UV1;
   	vsOut.UV2 = vsIn.UV2;
   	vsOut.UV3 = vsIn.UV3;
   	vsOut.UV4 = vsIn.UV4;
	return vsOut;
}

PSOut PS( PSIn psIn )
{
	PSOut psOut;
	float3 BottomCol = k_d.rgb; 
	float4 TopCol = k_d; 
	float3 LightCol = float3(1.0,1.0,1.0);
	float3 Normal = normalize(psIn.Normal);
	float3 LightDir = normalize(psIn.LightDir); 
	float3 ViewDir = normalize(psIn.ViewDir);
	float3 Ambient = k_a.rgb;
	float3 SpecLevel = float3(1.0,1.0,1.0);
	float Alpha; 
	
	float2 normalUV = psIn.UV4;
	
	float4 newCol;
	
	if(g_AmbientOccEnable)
		Ambient *= tex2D(g_AmbientOccSampler, psIn.UV1);


	if(g_TopDiffuseEnable)
		TopCol = tex2D(g_TopSampler, psIn.UV0 );
	
	if(g_BottomDiffuseEnable)
		BottomCol = tex2D(g_BottomSampler, psIn.UV2);
	

	if(g_AlphaVertex)
		Alpha = psIn.Colour.a;
	else
		Alpha = TopCol.a;
		
	if(g_UseParallax)
	{
		float height = tex2D(g_NormalSampler, psIn.UV4 ).a;
		float Altitude = height + g_ParallaxBias; 
		normalUV  = Altitude * g_ParallaxScale*ViewDir;
		normalUV +=  psIn.UV4;		
	}
		
	if(g_NormalEnable)
		Normal = NormalCalc(tex2D(g_NormalSampler, normalUV).xyz, g_BumpScale);
		
	if(g_SpecularEnable)
		SpecLevel = tex2D(g_SpecularSampler, psIn.UV3).xyz;


	newCol.rgb = TopCol * Alpha;
	newCol.rgb += BottomCol * (1.0f - Alpha);
	if(g_AddVertexColor)
		newCol.rgb *= psIn.Colour.rgb;
		
	psOut.Colour.rgb = (Ambient + (g_LightCol * saturate(dot(Normal, LightDir)))) * newCol.rgb;		

	if(g_ReflectionEnable)
	{
		float3 CUV = normalize( reflect( ViewDir, Normal));
		float4 env = texCUBE(g_ReflectionSampler, CUV);
		psOut.Colour.rgb += env.rgb; 
	}
	

	float3 H = normalize(LightDir + ViewDir);
	float Specular = pow(saturate(dot(Normal, H)), n);
	psOut.Colour.rgb += (k_s.rgb * Specular) * SpecLevel.rgb;

	psOut.Colour.a = 1.0f;
	return psOut;
}


technique Default
{
    pass P0 
    {		
		AlphaBlendEnable	= TRUE;
		DestBlend		= InvSrcAlpha;  
		SrcBlend		= SrcAlpha;
		VertexShader		= compile vs_1_1 VS();
		PixelShader		= compile ps_2_0 PS();
    }
}
