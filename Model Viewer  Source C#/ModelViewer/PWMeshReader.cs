using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Windows.Forms;

namespace ModelViewer
{


    class PWMeshReader
    {



        public static pwMeshContainer pwMesh;

        public static bool ReadFile(string FileName)
        {

            try
            {

                FileStream fs = new FileStream(FileName, FileMode.Open, FileAccess.Read, FileShare.Read);
                BinaryReader b = new BinaryReader(fs);

                pwMesh = new pwMeshContainer();

                // Get the data from the header
                pwMesh.HeaderInfo = new pwHeaderInfo();
                pwMesh.HeaderInfo.Format = b.ReadBytes(8);
                pwMesh.HeaderInfo.Version = b.ReadInt32();
                pwMesh.HeaderInfo.MeshCount = b.ReadUInt32();
                pwMesh.HeaderInfo.VertexType = b.ReadUInt32();
                pwMesh.HeaderInfo.UnknownValue1 = b.ReadUInt32();
                pwMesh.HeaderInfo.UnknownValue2 = b.ReadUInt32();
                pwMesh.HeaderInfo.TextureCount = b.ReadUInt32();
                pwMesh.HeaderInfo.MaterialCount = b.ReadUInt32();
                pwMesh.HeaderInfo.JointCount = b.ReadUInt32();
                pwMesh.HeaderInfo.UnknownValue3 = b.ReadUInt32();
                pwMesh.HeaderInfo.TypeMask = b.ReadUInt32();

                if (pwMesh.HeaderInfo.MeshCount == 0)
                    pwMesh.HeaderInfo.MeshCount = 1;


                // Advance 60 bytes = 60 x 0x00
                b.BaseStream.Position += 60;


                // Read the Joints
                if (pwMesh.HeaderInfo.Version == 9)
                {
                    pwMesh.Joints = new pwJoints[pwMesh.HeaderInfo.JointCount];
                    for (int i = 0; i < pwMesh.HeaderInfo.JointCount; i++)
                    {
                        pwMesh.Joints[i] = new pwJoints();
                        pwMesh.Joints[i].Name = b.ReadBytes(b.ReadInt32());
                    }
                }


                // Read the list of texture files
                pwMesh.Textures = new pwTextures[pwMesh.HeaderInfo.TextureCount];
                for (int i = 0; i < pwMesh.HeaderInfo.TextureCount; i++)
                {
                    pwMesh.Textures[i] = new pwTextures();
                    int byteCount = b.ReadInt32();
                    pwMesh.Textures[i].TexFileName = b.ReadBytes(byteCount);

                }



                // Read the materials
                pwMesh.Materials = new pwMaterials[pwMesh.HeaderInfo.MaterialCount];
                for (int i = 0; i < pwMesh.HeaderInfo.MaterialCount; i++)
                {
                    pwMesh.Materials[i] = new pwMaterials();

                    pwMesh.Materials[i].MatHeader = b.ReadBytes(11);

                    pwMesh.Materials[i].Values = new float[16];
                    for (int j = 0; j < 16; j++)
                        pwMesh.Materials[i].Values[j] = b.ReadSingle();

                    pwMesh.Materials[i].Scale = b.ReadSingle();
                    pwMesh.Materials[i].isClothing = b.ReadByte();
                }


                // Read the Meshes
                pwMesh.Objects = new pwObject[pwMesh.HeaderInfo.MeshCount];
                for (int i = 0; i < pwMesh.HeaderInfo.MeshCount; i++)
                {
                    pwObject currentobj = new pwObject();


                    currentobj.MeshName = b.ReadBytes(b.ReadInt32());
                    currentobj.TextureIndex = b.ReadInt32();
                    currentobj.MaterialIndex = b.ReadInt32();

                    if (pwMesh.HeaderInfo.VertexType == 1)
                        currentobj.ExtraData = b.ReadBytes(4);

                    currentobj.VertexCount = b.ReadInt32();
                    currentobj.FaceVertsCount = b.ReadInt32();


                    currentobj.Vertices = new pwVertex[currentobj.VertexCount];
                    currentobj.Normals = new pwNormal[currentobj.VertexCount];
                    currentobj.UVs = new pwUV[currentobj.VertexCount];

                    if (pwMesh.HeaderInfo.VertexType == 0)
                    {
                        currentobj.VertexWeight = new pwVertexWeight[currentobj.VertexCount];
                        currentobj.BoneIndex = new pwBoneIndex[currentobj.VertexCount];
                    }

                    for (int j = 0; j < currentobj.VertexCount; j++)
                    {
                        currentobj.Vertices[j] = new pwVertex(b.ReadSingle(), b.ReadSingle(), b.ReadSingle());

                        if (pwMesh.HeaderInfo.VertexType == 0)
                        {
                            currentobj.VertexWeight[j] = new pwVertexWeight(b.ReadSingle(), b.ReadSingle(), b.ReadSingle());
                            currentobj.BoneIndex[j] = new pwBoneIndex(b.ReadByte(), b.ReadByte(), b.ReadByte(), b.ReadByte());
                        }

                        currentobj.Normals[j] = new pwNormal(b.ReadSingle(), b.ReadSingle(), b.ReadSingle());
                        currentobj.UVs[j] = new pwUV(b.ReadSingle(), b.ReadSingle());

                    }


                    currentobj.Faces = new pwFaces[currentobj.FaceVertsCount / 3];
                    for (int j = 0; j < (currentobj.FaceVertsCount / 3); j++)
                        currentobj.Faces[j] = new pwFaces(b.ReadInt16(), b.ReadInt16(), b.ReadInt16());

                    pwMesh.Objects[i] = currentobj;

                }

                return true;

            }
            catch
            {
                return false;
            }

        }
    }
}
