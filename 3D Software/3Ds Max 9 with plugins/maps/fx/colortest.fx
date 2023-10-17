// 3ds max effect file
// Simple Lighting Model

//tell max to transpose the matrix
bool RowMajor = true;


// light direction (view space)
float3 lightDir : Direction <  
	string UIName = "Light Direction"; 
	string Object = "TargetLight";
	int RefID = 0;
	> = {-0.577, -0.577, 0.577};

// light intensity
float4 I_a = { 0.1f, 0.1f, 0.1f, 1.0f };    // ambient
float4 I_d = { 1.0f, 1.0f, 1.0f, 1.0f };    // diffuse
float4 I_s = { 1.0f, 1.0f, 1.0f, 1.0f };    // specular

// material reflectivity
float4 k_a  <
	string UIName = "Ambient";
	> = float4( 0.0f, 0.0f, 0.0f, 1.0f );    // ambient

//diffuse setting controlled by the light if available	
float4 k_d : LightColor <
	string UIName = "Diffuse";
	int LightRef = 0;
	> = float4( 1.0f, 1.0f, 1.0f, 1.0f );    // diffuse
	
float4 k_s  <
	string UIName = "Specular";
	> = float4( 1.0f, 1.0f, 1.0f, 1.0f );    // diffuse    // specular

int n<
	string UIName = "Specular Power";
	string UIType = "IntSpinner";
	float UIMin = 0.0f;
	float UIMax = 50.0f;	
	>  = 15;

// texture
texture Tex0 : DiffuseMap < 
	string name = "tiger.bmp"; 
	string UIName = "Base Texture";
	>;
	

// transformations
float4x4 World      : 		WORLD;
float4x4 View       : 		VIEW;
float4x4 Projection : 		PROJECTION;
float4x4 WorldViewProj : 	WORLDVIEWPROJ;
float4x4 WorldView : 		WORLDVIEW;


struct VS_OUTPUT
{
    float4 Pos  : POSITION;
    float4 Diff : COLOR0;
    float4 Spec : COLOR1;
    float2 Tex  : TEXCOORD0;
};

VS_OUTPUT VS(
    float3 Pos  : POSITION, 
    float3 Norm : NORMAL, 
    float3 Tex  : TEXCOORD0
    )
{
    VS_OUTPUT Out = (VS_OUTPUT)0;

    float3 L = -lightDir;
       

//    float4x4 WorldView = mul(World, View);

    float3 P = mul((float4x4)WorldView,float4(Pos, 1));  // position (view space)
    float3 N = normalize(mul((float3x3)WorldView,Norm)); // normal (view space)

//  float3 N = normalize(Norm); // normal (view space)
    float3 R = normalize(2 * dot(N, L) * N - L);          // reflection vector (view space)
    float3 V = -normalize(P);                             // view direction (view space)

    Out.Pos  = mul(Projection,float4(P,1));    // position (projected)
//  Out.Pos  = mul(WorldViewProj,float4(Pos,1));    // position (projected)
//  Out.Pos  = mul(float4(Pos,1),WorldViewProj));    // position (projected)
    
    Out.Diff = I_a * k_a + I_d * k_d * max(0, dot(N, L)); // diffuse + ambient
    Out.Spec = I_s * k_s * pow(max(0, dot(R, V)), n/4);   // specular
    Out.Tex  = Tex;   

    return Out;
}

sampler Sampler = sampler_state
{
    Texture   = (Tex0);
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};


float4 PS(
    float4 Diff : COLOR0,
    float4 Spec : COLOR1,
    float3 Tex  : TEXCOORD0
    ) : COLOR
{
    float4 color = tex2D(Sampler, Tex) * Diff + Spec;
    return  color ;
}


technique DefaultTechnique
{
    pass P0
    {
        // shaders
        CullMode = None;
       	VertexShader = compile vs_1_1 VS();
        PixelShader  = compile ps_1_1 PS();
    }  
}

technique NoPixelShader
{
    pass P0
    {
        // lighting
        CullMode = None;
        Lighting       = FALSE;
        SpecularEnable = TRUE;

        // samplers
        Sampler[0] = (Sampler);

        // texture stages
        ColorOp[0]   = MODULATE;
        ColorArg1[0] = TEXTURE;
        ColorArg2[0] = DIFFUSE;
        AlphaOp[0]   = MODULATE;
        AlphaArg1[0] = TEXTURE;
        AlphaArg2[0] = DIFFUSE;

        ColorOp[1]   = DISABLE;
        AlphaOp[1]   = DISABLE;

        // shaders
        VertexShader = compile vs_1_1 VS();
        PixelShader  = NULL;
    }
}
