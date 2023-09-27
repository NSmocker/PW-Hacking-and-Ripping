using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ModelViewer
{


    struct pwVertex
    {
        public float X;
        public float Y;
        public float Z;

        public pwVertex(float X, float Y, float Z)
        {
            this.X = X;
            this.Y = Y;
            this.Z = Z;
        }
    }

    struct pwNormal
    {
        public float X;
        public float Y;
        public float Z;

        public pwNormal(float X, float Y, float Z)
        {
            this.X = X;
            this.Y = Y;
            this.Z = Z;
        }
    }

    struct convWeightMap
    {
        public int VertexID;
        public int JointID;
        public float Weight;

        public convWeightMap(int VertexID, int JointID, float Weight)
        {
            this.VertexID = VertexID;
            this.JointID = JointID;
            this.Weight = Weight;
        }
    }

    struct pwUV
    {
        public float U;
        public float V;

        public pwUV(float U, float V)
        {
            this.U = U;
            this.V = V;
        }
    }

    struct pwFaces
    {
        public short A;
        public short B;
        public short C;

        public pwFaces(short A, short B, short C)
        {
            this.A = A;
            this.B = B;
            this.C = C;
        }

    }

    struct pwVertexWeight
    {
        public float X;
        public float Y;
        public float Z;

        public pwVertexWeight(float X, float Y, float Z)
        {
            this.X = X;
            this.Y = Y;
            this.Z = Z;
        }
    }

    struct pwBoneIndex
    {
        public byte A;
        public byte B;
        public byte C;
        public byte D;

        public pwBoneIndex(byte A, byte B, byte C, byte D)
        {
            this.A = A;
            this.B = B;
            this.C = C;
            this.D = D;
        }


    }

    class pwObject
    {
        public byte[] MeshName { get; set; }
        public int TextureIndex { get; set; }
        public int MaterialIndex { get; set; }
        public byte[] ExtraData { get; set; }
        public int VertexCount { get; set; }
        public int FaceVertsCount { get; set; }

        public pwVertex[] Vertices { get; set; }
        public pwVertexWeight[] VertexWeight { get; set; }
        public pwBoneIndex[] BoneIndex { get; set; }
        public pwNormal[] Normals { get; set; }
        public pwUV[] UVs { get; set; }
        public pwFaces[] Faces { get; set; }
    }

    class pwJoints
    {
        public byte[] Name { get; set; }
    }

    class pwTextures
    {
        public byte[] TexFileName { get; set; }
    }

    class pwHeaderInfo
    {
        public byte[] Format { get; set; }
        public int Version { get; set; }
        public uint MeshCount { get; set; }
        public uint VertexType { get; set; }
        public uint UnknownValue1 { get; set; }
        public uint UnknownValue2 { get; set; }
        public uint TextureCount { get; set; }
        public uint MaterialCount { get; set; }
        public uint JointCount { get; set; }
        public uint UnknownValue3 { get; set; }
        public uint TypeMask { get; set; }
    }

    class pwMaterials
    {
        public byte[] MatHeader { get; set; }
        public float[] Values { get; set; }
        public float Scale { get; set; }
        public byte isClothing { get; set; }
    }

    class pwMeshContainer
    {
        public pwHeaderInfo HeaderInfo { get; set; }
        public pwJoints[] Joints { get; set; }
        public pwTextures[] Textures { get; set; }
        public pwMaterials[] Materials { get; set; }
        public pwObject[] Objects { get; set; }
    }
}
