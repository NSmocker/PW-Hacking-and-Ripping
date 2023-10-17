#!BPY

# Copyright (c) 2008 Peter S. Stevens
#    - 2010.02: multiple enhancements and added functionality for newer mesh format by Rainer Kesselschlaeger
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# ***** END MIT LICENSE BLOCK *****


"""
Name: 'Perfect World IMPORT (*.ski)...'
Blender: 248
Group: 'Import'
Tooltip: 'Import Perfect World *.ski game files.'
"""

__author__ = ['Peter S. Stevens', 'Rainer Kesselschlaeger']
__email__ = ['pstevens:cryptomail*org', 'katzeklick:gmx*de']
__url__ = ('blender', 'elysiun', 'Project homepage, http://www.ragezone.com/, http://www.gamevixenzone.com')
__version__ = 'v0.5, 2010.feb.10'
__bpydoc__ = """ \
This script imports Perfect World *.ski game files
"""

import Blender
import struct
from Blender import Window
from Blender import Armature
import bpy
import os


# GLOBAL VARS
gMaterialsAssignedList = []

# User defined behavior (may be customized)
gReadHumanFemaleAsDemon = False			# EXPERIMENTAL; leave to False


# Behaviour (don't change)
gFlipLeftToRight = True					# ATTN: MUST BE THE SAME AS IN pw_export

gAppendBoneNameTo_grp_Weights = True
gCopyDuplicateMats = True				# If Meshes share a mat, assign a copy of it


# HUMAN FEMALE BONE NAMES (41; maybe we better get these from the .bon file?)
# -----------------------------------------------------------------------------
gSki_HumanFBoneNames = ['Bip01',				# index 0	+
                        'Bip01 Pelvis',			# 01		+
                        'Bip01 Spine',			# 02		+
                        'Bip01 Spine1',			# 03		+
                        'Bip01 Spine2',			# 04		+
                        'Bip01 Neck',			# 05		+
                        'Bip01 Head',			# 06		+
                        'Bip01 Ponytail1',		# 07		+
                        'Bip01 Ponytail11',		# 08		+
                        'Bip01 Ponytail12',		# 09		+

                        'Bip01 L Clavicle',		# 0x0A 10	+
                        'Bip01 L UpperArm',		# 0x0B 11
                        'Bip01 L Forearm',		# 0x0C 12
                        'Bip01 L Hand',			# 0x0D 13
                        'Bip01 L Finger0',		# 0x0E 14
                        'Bip01 L Finger01',		# 0x0F 15
                        'Bip01 L Finger1',		# 0x10 16
                        'Bip01 L Finger11',		# 0x11 17
                        
                        'Bip01 R Clavicle',		# 0x12 18
                        'Bip01 R UpperArm',		# 0x13 19
                        'Bip01 R Forearm',		# 0x14 20
                        'Bip01 R Hand',			# 0x15 21
                        'Bip01 R Finger0',		# 0x16 22
                        'Bip01 R Finger01',		# 0x17 23
                        'Bip01 R Finger1',		# 0x18 24
                        'Bip01 R Finger11',		# 0x19 25
                        
                        'Bone01',				# 0x1A 26
                        
                        'Bip01 L Thigh',		# 0x1B 27
                        'Bip01 L Calf',			# 0x1C 28
                        'Bip01 L Foot',			# 0x1D 29
                        'Bip01 L Toe0',			# 0x1E 30
                        
                        'Bip01 R Thigh',		# 0x1F 31
                        'Bip01 R Calf',			# 0x20 32
                        'Bip01 R Foot',			# 0x21 33
                        'Bip01 R Toe0',			# 0x22 34
                        
                        # Those are rarely used for avatar: (?)
                        'Bone08',				# 0x23 35
                        'Bone09',				# 0x24 36
                        'Bone10',				# 0x25 37
                        'Bone02',				# 0x26 38
                        'Bone03',				# 0x27 39
                        'Bone04']				# 0x28 40
                        

# DEMON FEMALE BONE NAMES (43; maybe we better get these from the .bon file?)
# -----------------------------------------------------------------------------
gSki_DemonFBoneNames = ['Bip01',				# index 0	+
                        'Bip01 Pelvis',			# 01		+
                        'Bip01 Spine',			# 02		+
                        'Bip01 Spine1',			# 03		+
                        'Bip01 Spine2',			# 04		+
                        'Bip01 Neck',			# 05		+
                        'Bip01 Head',			# 06		+
                        
                        'Bip01 L Clavicle',		# 07
                        'Bip01 L UpperArm',		# 08
                        'Bip01 L Forearm',		# 09
                        'Bip01 L Hand',			# 10
                        'Bip01 L Finger0',		# 11
                        'Bip01 L Finger01',		# 12
                        'Bip01 L Finger1',		# 13
                        'Bip01 L Finger11',		# 14
                        
                        'Bip01 R Clavicle',		# 15
                        'Bip01 R UpperArm',		# 16
                        'Bip01 R Forearm',		# 17
                        'Bip01 R Hand',			# 18
                        'Bip01 R Finger0',		# 19
                        'Bip01 R Finger01',		# 20
                        'Bip01 R Finger1',		# 21
                        'Bip01 R Finger11',		# 22
                        
                        'Bone01',				# 23
                        
                        'Bip01 L Thigh',		# 24
                        'Bip01 L Calf',			# 25
                        'Bip01 L Foot',			# 26
                        'Bip01 L Toe0',			# 27
                        
                        'Bip01 R Thigh',		# 28
                        'Bip01 R Calf',			# 29
                        'Bip01 R Foot',			# 30
                        'Bip01 R Toe0',			# 31
                        
                        'Bip01 Tail',		# 32		+
                        'Bip01 Tail1',		# 33		+
                        'Bip01 Tail2',		# 34		+
                        'Bip01 Tail3',		# 35		+
                        'Bip01 Tail4',		# 36		+

                        # Those are rarely used for avatar: (?)
                        'Bone08',				# 37
                        'Bone09',				# 38
                        'Bone10',				# 39
                        'Bone02',				# 40
                        'Bone03',				# 41
                        'Bone04']				# 43
                        

# EXPERIMENTAL
# -----------------------------------------------------------------------------
def TranslateHumanBoneIndexToDemon(boneID):
    # a) get the name of the bone in Human table
    # ------------------------------------------
    humanBoneName = gSki_HumanFBoneNames[boneID] 
    
    # b) search for the name in Demon table; if not found, use "Bip01"
    # ----------------------------------------------------------------
    for boneIndex, demonBoneName in enumerate(gSki_DemonFBoneNames):
        if humanBoneName == demonBoneName:
            return boneIndex
    return 0
    
    
# -----------------------------------------------------------------------------
def pwSki_createBoneGroups(bone_names):
    bone_groups = []
    for cnt, bone in enumerate(bone_names):
        bone_groups.extend([cnt])
        bone_groups[cnt] = []
        
    return bone_groups
    

# Read the bone names
# -----------------------------------------------------------------------------
def pwSki_ReadBips(file_object, ski_type, num_bips):
    bone_names = []
    if ski_type == 9:
        print "num_bips:",num_bips
        for x in xrange(num_bips):
            c_count = struct.unpack('<I', file_object.read(4))[0]
            Bip_name = file_object.read(c_count)
            
            # Store names of Bips into bone names list
            bone_names.extend([Bip_name])
    
    return bone_names
    

# Read texture, assure its name fits into Blender, create it, load image
# -----------------------------------------------------------------------------
def pwSki_ReadTexture(file_object, xcount):
    # a) Read texture name from file
    tex_len = struct.unpack('<I', file_object.read(4))[0]
    tex_filename = file_object.read(tex_len)
    
    print ""
    print "Texture",xcount,"file:",tex_filename,"  len:(",tex_len,")"
    
    # NOTE: Names of textures in Blender can be max. 21 chars long
    # So if it is longer, try if it fits when we remove the extension ".dds" at the end
    # (on export, we have to add ".dds" again if the name does not have this extension)
    # ---------------------------------------------------------------------------------
    tex_title = tex_filename
    if len(tex_filename) > 21:
        (title,ext) = os.path.splitext(tex_filename)
        # remove extention only if it IS ".dds"
        if ext == ".dds":
            tex_title = title
            print "Texture title:",tex_title
    # if the texture name is still longer than 21 chars, rename it to "RENAME_IN_EXPORT.dds"
    # to easier find it in the export file for manual replacement
    if len(tex_title) > 21:
        tex_title = "RENAME_IN_EXPORT.dds"
        print "Name was too long; remember to rename",tex_title,"back to",tex_filename,"in export."
    
    # TODO: Better try to create a property for the mesh with the original filename and place a reference (like "Prop_File_01") here - if possible
    
    
    # b) try to get a texture with this name from Blender, or generate a new
    texture = None
    try:
        texture = Blender.Texture.Get(tex_title)
        print "Got the texture:",tex_title
    except:
        print "except1"
        texture = Blender.Texture.New(tex_title)
        print "Created new texture:",tex_title
        
        # Check if name fitted
        if texture.name != tex_title:
            Blender.Draw.PupMenu("Warning%%t|Texture name '%s' did not fit into Blender. It was renamed to '%s'. You have to rename after export with a Hex editor.|Okay..." % (tex_title,texture.name))
        
        texture.setType('Image')
        
        # b2) try to get or load the image
        image = None
        try:
            image = Blender.Image.Get(tex_filename)
            print "Got the image; Success."
        except:
            print "except2"
            search_path = Blender.sys.join (Blender.sys.dirname(file_object.name) , "textures")
            img_file_path = Blender.sys.join(search_path, tex_filename)
            
            print "img file path:",img_file_path
            
            if Blender.sys.exists(img_file_path):
                try:
                    image = Blender.Image.Load(img_file_path)
                    print "Image loaded; Success."
                except:
                    print "except3"
                    #Blender.Draw.PupMenu("Warning%%t|Could not load '%s.'" % img_file_path)
                    print "Image",img_file_path,"not found!"
            else:
                print "Image",img_file_path,"not found!"
        finally:
            if image is not None:
                texture.setImage(image)
    
    return texture
    

# Read in the "MATERIAL: " parameters
# -----------------------------------------------------------------------------
def pwSki_ReadMaterial(file_object, xcount):
    mat_header = file_object.read(11)	# "MATERIAL: "/0 (string)
    # check if string is what we expected
    if mat_header[0:10] != "MATERIAL: ":
        print "ERROR: Wrong Material signature!"
        # TODO: do something to warn or abort
    
    # Read a block with 17 float values
    data_chunk = file_object.read(68)	# 16+1 FLOATs
    
    # assign floats to what we think they mean
    diffuse_color = struct.unpack_from('<4f', data_chunk)		# Diffuse Color, R,G,B +?
    specular_color = struct.unpack_from('<4f', data_chunk, 16)	# Specular Color, R,G,B, +?
    emissive_color = struct.unpack_from('<4f', data_chunk, 32)	# 
    unknown_block = struct.unpack_from('<4f', data_chunk, 48)	# 
    
    scale_parameter = struct.unpack_from('<f', data_chunk, 64)	# scale? or distance? (0.0, 9.9999 or 19.9999 spotted)
    
    mat_name = "Mat_%02d" % xcount
    material = Blender.Material.New(mat_name)
    
    # Assign values to material we do understand and have checked in function:
    material.setRGBCol(diffuse_color[0:3])		# OK, matches Diffuse Color RGB triple
    material.setSpecCol(specular_color[0:3])	# OK, matches Specular Color RGB triple
    
    # Assign RGB triple values to material we need to store although they don't reflect the function:
    material.setMirCol(emissive_color[0:3])		# this is more like "illumination" than mirror color
    
    # Assign single values that need storage although function does not match:
    # ...
    
    # Remaining values that we don't know the function of currently:
    # ...
    
    # Currently just IGNORE these parameters:
    # ---------------------------------------
    # diffuse_color[3]; 	seems to have no effect - expect 1.0, and just export always 1.0
    # specular_color[3]; 	makes avatar INVISIBLE if below (0.5 ?) - expect 1.0, and just export always 1.0
    # emissive_color[3]; 	seems to have no effect - expect 1.0, and just export always 1.0
    # unknown_block[0:4]	currently totally unknown. Export as 0.0, 0.0, 0.0, 1.0 for now.
    
    
    # And read the last byte, which may mean "clothing":
    bIsClothing = struct.unpack('<B', file_object.read(1))[0]		# One BYTE
    
    
    # TODO: Where could we store this value?
    ########################################
    # Okay: just store them into the mesh instead of material;
    # this could work if we always have only one material per mesh (!)
    # =====================================================================
    scaling = scale_parameter[0]	# strange Python... *think*
    clothing = bIsClothing
    
    return (material, scaling, clothing)
    

# NEW Function to assign textures to materials (depends on indexes in meshes)
# -----------------------------------------------------------------------------
def AssignTextureToMat (material, texture, entry):
    material.setTexture(entry, texture, Blender.Texture.TexCo.UV)
    material.setMode(Blender.Material.Modes.TEXFACE + Blender.Material.Modes.TEXFACE_ALPHA)
    
    return material


# Helpers: Name to Index, and vice versa ("Grp_NameToIndex()" unused here)
# -----------------------------------------------------------------------------
def Grp_NameToIndex (group_name):
    group_index = int(group_name[5:8])	# OLD STYLE groups were named like "_grp_042" (without "_A")
    
    # do we have a NEW STYLE named group?
    if len(group_name) == 10:			# NEW STYLE groups are named like "_grp_010_C"
        main_index = int(group_name[5:8])				# "027"
        byte_offset = ord(group_name[9:10])  - ord('A')	# "B"
        group_index = main_index*4 + byte_offset
    return group_index

def Grp_IndexToName (group_index):
    main_index = int(group_index/4)
    byte_offset = group_index % 4
    sub_group = chr(ord('A')+byte_offset)
    group_name = "_grp_%03d_%s" % (main_index,sub_group)
    return group_name
    

# -----------------------------------------------------------------------------
def ShorterBoneName (bone_name):
    if len(bone_name) > 8 and bone_name[0:6] == "Bip01 ":
        return bone_name[6:]
    else:
        return bone_name


# Helper: Count textures a material has
# -----------------------------------------------------------------------------
def CountTexturesInMat (material):
    tex_count = 0
    textures = material.getTextures()
    for tex in textures:
        if tex is not None:
            tex_count +=1
    return tex_count


# Helper: Check if a mat belongs to a mesh (if it is already assigned)
# -----------------------------------------------------------------------------
def CheckMatAssignments (mat_index):
    global gMaterialsAssignedList
    if len(gMaterialsAssignedList) > mat_index:
        return gMaterialsAssignedList[mat_index]
    return 0
    
# Mark material as used; count how often
def AppendMatAssignments (mat_index):
    global gMaterialsAssignedList
    while len(gMaterialsAssignedList) <= mat_index:
        gMaterialsAssignedList.append(0)
    gMaterialsAssignedList[mat_index] += 1


# Flips a mesh in X-direction, while maintaining the vertex normals
# -----------------------------------------------------------------------------
def FlipMeshLeftRight (mesh_obj):
    
    realMesh = mesh_obj.getData(False,True) # gets a Mesh object instead of an NMesh
    
    # 1. Save the vertex normals
    # --------------------------
    vertex_normals = []
    for vert in realMesh.verts:
        normal = vert.no
        vertex_normals.append(normal)
        
    # 2. Revert x-coordinate of each vertex
    # -------------------------------------
    for vert in realMesh.verts:
        position = vert.co
        position[0] = -position[0]
        vert.co = position
        
    # 3. Flip the vertex normals, because they now point inside
    #    NOTE: This does not work when we call the function 
    #    with a mesh not already linked to an object;
    #    Additionally, it does not work while in Edit Mode.
    # ---------------------------------------------------------
    for face in realMesh.faces:
        face.sel = 1
    realMesh.flipNormals()
    
    # 4. Restore the vertex normals
    # -----------------------------
    for vert in realMesh.verts:
        index = vert.index
        normal = vertex_normals[index]
        normal[0] = -normal[0]
        vert.no = normal
        

# -----------------------------------------------------------------------------
def pwSki_ReadMesh(file_object, vertex_type, material_objects, extra_mat_params, texture_objects, bone_names, xcount):
    name_len = struct.unpack('<I', file_object.read(4))[0]
    ob_name = file_object.read(name_len)
    
    texture_index = struct.unpack('<i', file_object.read(4))[0]		# "signed" long (32 bit)
    material_index = struct.unpack('<i', file_object.read(4))[0]	# "signed" long (32 bit)
    
    # (assignments later below)
    
    if vertex_type == 1:
        file_object.seek(4, 1)
        print "vertex_type=1, skipping 4 bytes"
    
    vertex_count = struct.unpack('<I', file_object.read(4))[0]
    print "vertex_count:",vertex_count
    
    index_count = struct.unpack('<I', file_object.read(4))[0]
    print "index_count(num_faces*3):",index_count
    
    mesh_object = Blender.Object.New('Mesh', ob_name)
    
    mesh = mesh_object.getData(mesh = True)
    
    if mesh is None:
        mesh = Blender.Mesh.New(mesh_name)
        mesh_object.link(mesh)
    
    # Set Property: MeshType
    # ++++++++++++++++++++++
    mesh_object.addProperty("MeshType", vertex_type, 'INT')		#0: Mesh with vertex weight info; 1: without
    
    # And add properties for Extra Material Parameters:
    # +++++++++++++++++++++++++++++++++++++++++++++++++
    mesh_object.addProperty("Scaling", extra_mat_params[material_index][0], 'FLOAT')
    mesh_object.addProperty("Clothing", extra_mat_params[material_index][1], 'INT')
    
    
    mesh.vertexUV = True
    
    mesh.mode |= Blender.Mesh.Modes.TWOSIDED;	# TEST: Geht das? HIERHIER
    
    vertex_colors = []		# this
    artic_weights = []		# or that
    
    vertex_groups = []
    num_vgroups = 0
    
    bone_groups = pwSki_createBoneGroups(bone_names)
    
    
    # VERTICES 
    # ******** 
    for x in xrange(vertex_count):
        
        # 1. VERTICES (position)
        # ----------------------
        # Read in order x,z,y
        pos_x, pos_z, pos_y = struct.unpack('<3f', file_object.read(12))
        position = Blender.Mathutils.Vector(pos_x, -pos_y, pos_z)
        
        # Use vertex color to store the 3 float values
        # --------------------------------------------
        if vertex_type == 0:
            # 2. THREE FLOAT VALUES
            # ---------------------
            vertex_color = struct.unpack('<3f', file_object.read(12))
            vertex_colors.append([int((y * 255.0)+0.5) for y in vertex_color])		# this
            artic_weights.append([y for y in vertex_color])							# or that
            
            # 3. FOUR BYTE VALUES
            # -------------------
            # Read the next 4 bytes and treat them as 4 groups the vertex belongs to
            # then assign the vertex to each of those groups, if > 0
            vgroups = struct.unpack('<4B', file_object.read(4))		# e.g. [13,12,0,0] or [15,16,17,12] or [26,0,4,2]
            
            # EXPERIMENTAL
            # ~~~~~~~~~~~~
            if gReadHumanFemaleAsDemon:
                g1 = TranslateHumanBoneIndexToDemon(vgroups[0])
                g2 = TranslateHumanBoneIndexToDemon(vgroups[1])
                g3 = TranslateHumanBoneIndexToDemon(vgroups[2])
                g4 = TranslateHumanBoneIndexToDemon(vgroups[3])
                vgroups = (g1,g2,g3,g4)
            # ~~~~~~~~~~~~
            
            # install group if not present
            for group in vgroups:
                while num_vgroups <= group*4:
                    for i in xrange(4):
                        vertex_groups.extend([num_vgroups])
                        vertex_groups[num_vgroups] = []
                        num_vgroups +=1
                
        # 4. NORMALS
        # ----------
        # Read in order x,z,y
        nX,nZ,nY = struct.unpack('<3f', file_object.read(12))
        normal = Blender.Mathutils.Vector(nX,-nY,nZ)
        normal[0] = nX
        normal[1] = -nY
        normal[2] = nZ
        
        
        # 5. uv-coords
        # ------------
        uv_coordinates = Blender.Mathutils.Vector(struct.unpack('<2f', file_object.read(8)))
        
        
        # Now append the new vertex
        # -------------------------
        mesh.verts.extend(position)
        
        vertex = mesh.verts[-1]
        
        vertex.no = normal
        
        uv_coordinates.y = float(1.0 - uv_coordinates.y)
        vertex.uvco = uv_coordinates
        
        
        # Add vertex to a list in the appropriate group
        # (only available for vertex_type 0)
        if vertex_type == 0:
            i=0
            for group in vgroups:		# (vgroups always contains 4 members at this point)
                vertex_groups[group*4+i].extend([vertex.index])
                i += 1
            
                # Additionally, (currently only used for convenience), add the vertex to the BoneGroups:
                # Note: Bone identifiers only refer to the local bone names given in the file itself, 
                #       not to the global FemalBoneNames list.
                #       So it's correct that len(bone_names) == len(bone_groups).
                # --------------------------------------------------------------------------------------
                if group < len(bone_groups):
                    bone_groups[group].extend([vertex.index])
                else:
                    print "Warning: BoneGroup",group,"not found in Bones!"
        
    
    # FACES 
    # ******** 
    num_faces = int((index_count / 3)+0.5)
    for x in xrange(num_faces):
        vert_indices = struct.unpack('<3H', file_object.read(6))
        face_vertices = [mesh.verts[y] for y in vert_indices]
        
        mesh.faces.extend(face_vertices)
        
        face = mesh.faces[-1]
        
        face.uv = [vertex.uvco for vertex in face_vertices]
    
    
    # Assignment of material to mesh, IF material given
    # =================================================
    if material_index >= 0 and material_index < len(material_objects):
        material = material_objects[material_index]
        
        # If we want to avoid that different meshes share the same material, make a copy of it:
        # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if gCopyDuplicateMats:
            # find out if this material is already assigned to a mesh
            num_assigns = CheckMatAssignments(material_index)
            if num_assigns > 0:
                src_mat = material
                material = src_mat.__copy__()
                
                # rename the mat from "Mat_00" to "Mat_00b" or "Mat_00.001" to "Mat_00b.001"
                mat_name = material.getName()
                dotpos = mat_name.find('.')
                autonum = ""
                if dotpos > 0:
                    autonum = mat_name[dotpos:]
                    if len(autonum)==4 and mat_name.endswith(autonum):	# e.g. '.005'
                        mat_name = mat_name[0:dotpos]
                mat_name = mat_name + chr(ord('a')+num_assigns) + autonum
                material.setName(mat_name)
                
                # remove textures in the copy
                for tchan in xrange(10):	# TODO: make a define for MAX_BLENDER_TEX_CHANNELS (10)
                    material.clearTexture(tchan)
                
            # Remember for later:
            AppendMatAssignments(material_index)
            
        
        # Assignment of texture to material
        # ---------------------------------
        # Now, as we know which texture belongs to us, we can assign this texture to our belonging material:
        if texture_index >= 0 and texture_index < len(texture_objects):
            # first count no. of textures the material already has
            entry = CountTexturesInMat (material)
            # assign to the next texture channel
            AssignTextureToMat (material, texture_objects[texture_index], entry)
        
        
        # Assignment of material to mesh
        # ------------------------------
        mesh.materials = [material]
            
    
    # Assignment of texture to faces
    # ------------------------------
    if texture_index >= 0 and texture_index < len(texture_objects):
        texture = texture_objects[texture_index]
        
        image = texture.getImage()
        
        for face in mesh.faces:
            face.mode = Blender.Mesh.FaceModes.TEX + Blender.Mesh.FaceModes.TWOSIDE
            face.image = image
    
    
    # insert the vertex colors into faces
    # -----------------------------------
    # (only available for vertex_type 0)
    if vertex_type == 0:
        mesh.vertexColors = True
        for face in mesh.faces:
            for i, vertex in enumerate(face):
                vertex_color = vertex_colors[vertex.index]
                
                face_color = face.col[i]
                face_color.r = vertex_color[0]
                face_color.g = vertex_color[1]
                face_color.b = vertex_color[2]
            
    
    # then setup groups of vertices
    # (only available for vertex_type 0)
    if vertex_type == 0:
        for group, vert_list in enumerate(vertex_groups):
            if len(vert_list) > 0:
                grp_name = Grp_IndexToName(group)
                
                if gAppendBoneNameTo_grp_Weights:
                    bone_index = int(group/4)
                    grp_name += " ("+ShorterBoneName(bone_names[bone_index])+")"
                    
                mesh.addVertGroup(grp_name)
                mesh.assignVertsToGroup(grp_name, vert_list, 1.0, Blender.Mesh.AssignModes.ADD)
        
        # Additionally, add a Blender group for each bone group (even if it has no vertices attached):
        # --------------------------------------------------------------------------------------------
        for group, vert_list in enumerate(bone_groups):
            grp_name = bone_names[group]
            mesh.addVertGroup(grp_name)
            mesh.assignVertsToGroup(grp_name, vert_list, 1.0, Blender.Mesh.AssignModes.ADD)
    
    
    # AND - because assigning these 3 float values (which may be weight as well) to vertex colors
    # is not really handy (impedes handling of textures) we store those three values in groups too
    # --------------------------------------------------------------------------------------------
    # (only available for vertex_type 0)
    if vertex_type == 0:
        arti_grp1_name = "Articular_W1"
        arti_grp2_name = "Articular_W2"
        arti_grp3_name = "Articular_W3"
        mesh.addVertGroup(arti_grp1_name)
        mesh.addVertGroup(arti_grp2_name)
        mesh.addVertGroup(arti_grp3_name)
        for vert in mesh.verts:
            arti_weight = artic_weights[vert.index]
            vert_list = [vert.index]
            mesh.assignVertsToGroup(arti_grp1_name, vert_list, arti_weight[0], Blender.Mesh.AssignModes.ADD)
            mesh.assignVertsToGroup(arti_grp2_name, vert_list, arti_weight[1], Blender.Mesh.AssignModes.ADD)
            mesh.assignVertsToGroup(arti_grp3_name, vert_list, arti_weight[2], Blender.Mesh.AssignModes.ADD)
    
    
    return mesh_object


# -----------------------------------------------------------------------------
def pw_ski_read(file_path):
    global gSki_HumanFBoneNames		# formerly "FemaleBoneNames"?
    file_object = None
    
    Window.WaitCursor(1)
    
    # because "flipNormals()" does not work in Edit Mode:
    if gFlipLeftToRight:
        in_emode = Window.EditMode()
        if in_emode: Window.EditMode(0)	# darf das beim Import?
    
    print "========== ========== ========== =========="
    print "Import started..."
    
    try:
        file_object = open(file_path, 'rb')
        
        moxbiksa = file_object.read(8) # a ski bmox
        if moxbiksa != "MOXBIKSA":
            result = Blender.Draw.PupMenu("Error%t|This is not a SKI file.|Okay...")
            raise IndexError, 'Not a SKI file.'
        
        ski_type = struct.unpack('<I', file_object.read(4))[0]		# ski_type
        
        obj_type_count = struct.unpack('<4I', file_object.read(16))
        
        texture_count = struct.unpack('<I', file_object.read(4))[0]
        
        material_count = struct.unpack('<I', file_object.read(4))[0]
        
        num_bips = struct.unpack('<I', file_object.read(4))[0] 	# num_bips (NOT always 4)
        
        unknown_2 = struct.unpack('<I', file_object.read(4))[0]		# (always value 0 found so far)
        
        type_mask = struct.unpack('<I', file_object.read(4))[0] 	# (defines number of bones in *.bon file; expect 0x29 or 0x2B, or 0x32 or...)
        
        file_object.seek(60, 1)		# (expect 60 bytes all 0)
        
        
        # Handle the bones
        if ski_type == 9:	# we got Bips in the file
            bone_names = pwSki_ReadBips (file_object, ski_type, num_bips)
        else:				# seems to be the main avatar body, which uses the global bones (from the .bon file)
            if type_mask == 43:		
                bone_names = gSki_DemonFBoneNames
            else:	# (type_mask 41 assumed)
            	bone_names = gSki_HumanFBoneNames	# currently we don't have any other table
                
                if gReadHumanFemaleAsDemon:
                    bone_names = gSki_DemonFBoneNames
                    
        print bone_names
        
        
        texture_objects = []
        for x in xrange(texture_count):
            texture_objects.append(pwSki_ReadTexture(file_object, x))
        
        
        material_objects = []
        extra_mat_params = []
        for x in xrange(material_count):
            (material, scaling, clothing) = pwSki_ReadMaterial(file_object, x)
            material_objects.append(material)
            extra_mat_params.append((scaling,clothing))
        
        mesh_objects = []
        
        for vertex_type, mobj_count in enumerate(obj_type_count):
            for x in xrange(mobj_count):
                mesh_objects.append(pwSki_ReadMesh(file_object, vertex_type, material_objects, extra_mat_params, texture_objects, bone_names, x))
        
        # Set Properties in each mesh: Ski_Type and TypeMask
        # ++++++++++++++++++++++++++++++++++++++++++++++++++
        for mesh_object in mesh_objects:
            mesh_object.addProperty("Ski_Type", ski_type, 'INT')	#8: Old-style format; 9: new style
            mesh_object.addProperty("TypeMask", type_mask, 'INT')	# (can be 41 or 43 or 50 or ...)
        
        
        
        scene = Blender.Scene.GetCurrent()
        
        for mesh_object in mesh_objects:
            scene.objects.link(mesh_object)
            
            # Finally flip the mesh, because in PW SKI it's mirrored
            # ------------------------------------------------------
            if gFlipLeftToRight:
                FlipMeshLeftRight (mesh_object)
            
            # and store information about the mirrored status (saying if we NOT flipped it)
            # does not tell if we flipped, but if we kept it mirrored as if came from the file
            # --------------------------------------------------------------------------------
            bMirror = not gFlipLeftToRight	
            mesh_object.addProperty("mirrored", bMirror, 'BOOL')
            
        
    except IOError, (errno, strerror):
        Blender.Draw.PupMenu("Error%%t|I/O error(%d): %s." % (errno, strerror))
    except Exception, err:
        Blender.Draw.PupMenu("Error%%t|.%s" % err)
    finally:
        if file_object is not None:
            file_object.close()
            
    # because "flipNormals()" does not work in Edit Mode:
    if gFlipLeftToRight:
        if in_emode: Window.EditMode(1)	# darf das beim Import?
    Blender.Redraw()
    Window.WaitCursor(0)
    
    

# -----------------------------------------------------------------------------
def main():
    def pw_file_selector(file_path):
        if file_path and not Blender.sys.exists(file_path):
            Blender.Draw.PupMenu("Error%%t|The file %s does not exist." % file_path)
        else:
            pw_ski_read(file_path)
    
    Blender.Window.FileSelector(pw_file_selector, 'Import SKI', Blender.sys.makename(ext='.ski'))


if __name__ == "__main__":
    main()

