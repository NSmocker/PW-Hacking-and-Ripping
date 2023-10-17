
#include "quad.fxh"

string ParamID = "0x003";

DECLARE_QUAD_TEX(SceneMap,SceneSampler,"X8R8G8B8")

struct VertexOutput
{
	float4 Position	: POSITION;
	float3 UV	: TEXCOORD0;
};

VertexOutput OutputVS(
	float3 Position : POSITION, 
	float3 Tex : TEXCOORD0 ) 
{
	VertexOutput OUT;
	OUT.Position = float4(Position.xyz, 1);
	OUT.UV = Tex;
	return OUT;
}



float4 OutputPS(VertexOutput IN) : COLOR
{   
	float4 texCol = float4(tex2D(SceneSampler, IN.UV).xyz,1);
	return texCol;
} 
///////////////////////////////////

technique Default 
{
	pass p0 
	{
		VertexShader = compile vs_1_1 OutputVS();
		cullmode = none;
		ZEnable = false;
		PixelShader  = compile ps_1_1 OutputPS();
	}
}

/***************************** eof ***/
