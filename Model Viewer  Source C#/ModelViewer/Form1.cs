using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
using Microsoft.DirectX.DirectInput;
using D3D = Microsoft.DirectX.Direct3D;
using System.IO;


namespace ModelViewer
{
    public partial class Form1 : Form
    {

        private D3D.Device device;
        private float angle = 5f;
        private Mesh[] pwModel;
        private Microsoft.DirectX.DirectInput.Device keyb;
        private float kX, kY, kZ, kRot,ud,lr;
        private Material pwMaterial;
        private Texture[] pwTexture;

        string FilePath;

        public Form1()
        {
            InitializeComponent();
            this.SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.Opaque, true);
        }


        public void InitializeDevice()
        {
            PresentParameters presentParams = new PresentParameters();
            presentParams.Windowed = true;
            presentParams.SwapEffect = SwapEffect.Discard;
            presentParams.AutoDepthStencilFormat = DepthFormat.D16;
            presentParams.EnableAutoDepthStencil = true;
            
            device = new D3D.Device(0, D3D.DeviceType.Hardware, this, CreateFlags.SoftwareVertexProcessing, presentParams);
            device.RenderState.CullMode = Cull.CounterClockwise;
            device.RenderState.FillMode = FillMode.Solid;

            pwMaterial.Diffuse = Color.White;
            pwMaterial.Specular = Color.LightGray;
            pwMaterial.SpecularSharpness = 15.0F;
            
            device.Material = pwMaterial;
            
        }

        public void InitializeKeyboard()
        {
            keyb = new Microsoft.DirectX.DirectInput.Device(SystemGuid.Keyboard);
            keyb.SetCooperativeLevel(this, CooperativeLevelFlags.Background | CooperativeLevelFlags.NonExclusive);
            keyb.Acquire();
        }

        private void CameraPositioning()
        {
            device.Transform.Projection = Matrix.PerspectiveFovLH((float)Math.PI / 4, this.Width / this.Height, 1f, 450f);
            device.Transform.View = Matrix.LookAtLH(new Vector3(0, 0, -5), new Vector3(0, 0, 0), new Vector3(0, 1, 0));
            
            device.Lights[0].Type = LightType.Directional;
            device.Lights[0].Diffuse = Color.White;
            device.Lights[0].Direction = new Vector3(0.8f, 0, -1);
            device.Lights[0].Enabled = true;
        }


        private void MakePWModel(pwMeshContainer pwMesh)
        {

            pwModel = new Mesh[pwMesh.HeaderInfo.MeshCount];

            for (int p = 0; p < pwMesh.HeaderInfo.MeshCount; p++)
            {

                VertexBuffer pwVertexBuffer;
                IndexBuffer pwIndicesBuffer;
                short[] pwIndices;
                CustomVertex.PositionNormalTextured[] pwVertices;
                List<short> tempIndices = new List<short>();


                pwTexture = new Texture[pwMesh.HeaderInfo.MeshCount];
                pwVertices = new CustomVertex.PositionNormalTextured[(int)pwMesh.Objects[p].VertexCount];
                pwIndices = new short[pwMesh.Objects[p].Faces.Count() * 3];


                
                // Declare indices
                pwIndicesBuffer = new IndexBuffer(typeof(short), pwMesh.Objects[p].Faces.Count() * 3, device, Usage.WriteOnly, Pool.Default);
                
                for (int i = 0; i < pwMesh.Objects[p].Faces.Count(); i++)
                {
                    tempIndices.Add(pwMesh.Objects[p].Faces[i].A);
                    tempIndices.Add(pwMesh.Objects[p].Faces[i].B);
                    tempIndices.Add(pwMesh.Objects[p].Faces[i].C);
                }

                pwIndices = tempIndices.ToArray();
                pwIndicesBuffer.SetData(pwIndices, 0, LockFlags.None);



                // Declare Vertices
                pwVertexBuffer = new VertexBuffer(typeof(CustomVertex.PositionNormalTextured), pwMesh.Objects[p].VertexCount, device, Usage.Dynamic | Usage.WriteOnly, CustomVertex.PositionNormalTextured.Format, Pool.Default);

                for (int i = 0; i < (int)pwMesh.Objects[p].VertexCount; i++)
                {
                    pwVertices[i].Position = new Vector3(pwMesh.Objects[p].Vertices[i].X, pwMesh.Objects[p].Vertices[i].Y, pwMesh.Objects[p].Vertices[i].Z);
                    pwVertices[i].Normal = new Vector3(pwMesh.Objects[p].Normals[i].X, pwMesh.Objects[p].Normals[i].Y, pwMesh.Objects[p].Normals[i].Z);

                    pwVertices[i].Tu = pwMesh.Objects[p].UVs[i].U;
                    pwVertices[i].Tv = pwMesh.Objects[p].UVs[i].V;
                }

                pwVertexBuffer.SetData(pwVertices, 0, LockFlags.None);




                // Build Mesh
                pwModel[p] = new Mesh(pwIndices.Count() / 3, pwVertices.Count(), MeshFlags.Managed, CustomVertex.PositionNormalTextured.Format, device);

                pwModel[p].SetVertexBufferData(pwVertices, LockFlags.None);
                pwModel[p].SetIndexBufferData(pwIndices, LockFlags.None);

                int[] adjac = new int[pwModel[p].NumberFaces];
                pwModel[p].OptimizeInPlace(MeshFlags.OptimizeVertexCache, adjac);
                pwModel[p] = pwModel[p].Clone(pwModel[p].Options.Value, CustomVertex.PositionNormalTextured.Format, device);
                pwModel[p].ComputeNormals();


                // Load Textures
                int TexID = pwMesh.Objects[p].TextureIndex;
                byte[] cTextureFile = pwMesh.Textures[TexID].TexFileName;
                string TextureFile = System.Text.Encoding.GetEncoding(936).GetString(cTextureFile);
                string texDir = Path.GetDirectoryName(FilePath) + "\\textures\\" + TextureFile;

                if (File.Exists(texDir))
                    pwTexture[p] = TextureLoader.FromFile(device, texDir);

            }

        }

        protected override void OnPaint(System.Windows.Forms.PaintEventArgs e)
        {
            
            device.Clear(ClearFlags.Target|ClearFlags.ZBuffer, Color.DarkSlateBlue, 1.0f, 0);

            device.BeginScene();


            device.Transform.World = Matrix.RotationYawPitchRoll(kX, kY, kZ);
            device.Transform.View = Matrix.LookAtLH(new Vector3(0, 0, angle), new Vector3(lr, ud, 0), new Vector3(0, 1, 0));
            
   
            for (int k = 0; k < pwModel.Count(); k++)
            {

                if (pwTexture[k] != null)
                    device.SetTexture(0, pwTexture[k]);

                int numSubSets = pwModel[k].GetAttributeTable().Length;
                for (int i = 0; i < numSubSets; ++i)
                    pwModel[k].DrawSubset(i);

            }

            device.EndScene();
            device.Present();

            this.Invalidate();
            ReadKeyboard();

        }

        private void ReadKeyboard()
        {
            KeyboardState keys = keyb.GetCurrentKeyboardState();

            if (keys[Key.UpArrow] && keys[Key.LeftShift])
                angle -= 0.8f;
            else if (keys[Key.UpArrow])
                angle -= 0.1f;

            if (keys[Key.DownArrow] && keys[Key.LeftShift])
                angle += 0.8f;
            else if (keys[Key.DownArrow])
                angle += 0.1f;


            if (keys[Key.LeftArrow])
                kX += 0.05f;
            if (keys[Key.RightArrow])
                kX -= 0.05f;

            if (keys[Key.W])
                kY += 0.05f;
            if (keys[Key.S])
                kY -= 0.05f;

            if (keys[Key.A])
                kZ += 0.05f;
            if (keys[Key.D])
                kZ -= 0.05f;

            if (keys[Key.F])
                kRot += 0.05f;
            if (keys[Key.V])
                kRot -= 0.05f;

            if (keys[Key.I])
                ud -= 0.05f;
            if (keys[Key.K])
                ud += 0.05f;
            if (keys[Key.J])
                lr -= 0.05f;
            if (keys[Key.L])
                lr += 0.05f;


       }



        static void Main(string[] args)
        {

            using (Form1 dxForm = new Form1())
            {

                dxForm.InitializeDevice();
                dxForm.InitializeKeyboard();
                dxForm.CameraPositioning();

                if (args.Count() == 1)
                {

                    string mFile = args[0];
                    if (File.Exists(mFile))
                    {
                        if (mFile.Contains(".ski"))
                        {
                            dxForm.FilePath = mFile;
                            if (PWMeshReader.ReadFile(mFile))
                                dxForm.MakePWModel(PWMeshReader.pwMesh);
                            else
                                MessageBox.Show("Cannot read .Ski file");
                        }
                        else
                            MessageBox.Show("File is not .Ski file");

                    }
                    else
                        MessageBox.Show("Cannot find " + mFile);
                }

                Application.Run(dxForm);

            }
        }

    }
}















