//----------------------------------
// Constants expected
//
//	c0-c3	= WorldViewProj Xform
//	c4-c7	= World Xform
//	c8-c11	= Inverse World Xform
//	c12-c15	= WorldViewProj and Texture Bias Xform combination
//	c16-c19 = Texture Stage 0 Xform
//
//	c91		= Object Specular Power
//	c92		= Object Diffuse Material Color
//	c93		= Object Ambient Material Color
//	c94		= Light Direction
//	c95		= Eye Direction
//
// Vertex components
//
//	v0	= position
//	v1	= normal
//	v2	= texture coords
//

//----------------------------------
// Vertex Shader Version

vs.1.1

//----------------------------------
// Transform Geometry

// Transform Normal to World Space
m3x3 r0, v1, c8

// Normalize Normal
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0, r0, r0.w

// Transform Position to World Space
m3x3 r1, v0, c4

//----------------------------------
// Half Vector

// Compute Vector to Camera
add r2.xyz, c95.xyz, -r1.xyz

// Normalize Vector to Camera
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2, r2, r2.w

// Compute H
add r3.xyz, r2.xyz, -c94

// Normalize H
dp3 r3.w, r3.xyz, r3.xyz
rsq r3.w, r3.w
mul r3.xyz, r3.xyz, r3.w

//----------------------------------
// Lighting

// N dot L
dp3 r4.x, r0, -c94

// N dot H
dp3 r4.y, r3.xyz, r0.xyz

// Specular Power
mov r4.w, c91.w

// Lighting Coefficients
lit r5, r4

// Specular Highlights
mul r6.xyz, r5.z, c91.xyz

// Multiply with Material Diffuse Color
mad oD0, r5.y, c92.xyz, r6.xyz

// Store Transparency
mov oD0.w, c92.w

//----------------------------------
// Output Texture Coords

// Pass Tex Coords
m3x2 oT0, v2, c16

// Transformed Position
m4x4 oT1, v0, c12

//----------------------------------
// Output Position

// Transform Position
m4x4 oPos, v0, c0
