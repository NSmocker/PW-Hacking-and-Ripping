#!BPY

# Copyright (c) 2010 Rainer Kesselschlaeger
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
Name: 'Perfect World EXPORT (*.ski)...'
Blender: 248
Group: 'Export'
Tip: 'Export to Perfect World *.ski file format.'
"""
__author__ = "Rainer Kesselschlaeger AKA pvpseeker"
__url__ = ["http://gamevixenzone.com/"]
__email__ = ["katzeklick:gmx*de"]
__version__ = "v0.5"


__bpydoc__ = """\
This script exports to the Perfect World *.ski format.

Usage:

Run this script from "File->Export" menu.
"""

# TODO: - export fashion automatically in two files, one for MaskType 41 (named ".._A.ski"), one for 43 (".._B.ski")
# TODO: - do equalization of faces automatically before export

import Blender
import struct
from Blender import Mesh,Window


# GLOBAL VARS
gSki_File_Needs_Bones = False
gSki_Num_Bones = 0


# Behaviour
gFlipLeftToRight = True					# ATTN: MUST BE THE SAME AS IN pw_import

gExportOnlyOneTexPerMesh = True
gExportWeightsOnlyIfOne = True
gNormalizeWeights = True
gVerbose = True


# Helper: Build a list of alternative Property Names - in case we renamed some
# -----------------------------------------------------------------------------
def getPropertyNames (propName):
    propertyNames = [propName]
    
    # list of alternative (older) names stored in blender files, indexed by new name:
    # -------------------------------------------------------------------------------
    if propName == "Clothing":		# formerly lower-case
        propertyNames = ["Clothing", "clothing"]

    elif propName == "Scaling":		# formerly distance
        propertyNames = ["Scaling", "distance"]
    
    return propertyNames


# Helper: Determine a mesh object property; use default if not available
# -----------------------------------------------------------------------------
def pwSki_FetchProperty (mesh_obj, propName, defaultVal = None):
    propItem = None
    propValue = None
    propList = mesh_obj.getAllProperties()
    propertyNames = getPropertyNames (propName)
    for prop in propList:
        if prop.name in propertyNames:
            propItem = prop
            break
    
    if propItem is not None:
        propValue = propItem.getData()
    else:
        propValue = defaultVal
    
    return propValue


# Determine the Ski_Type of one mesh object
# -----------------------------------------------------------------------------
def pwSki_DetermineSkiType(mesh_obj):
    global gSki_File_Needs_Bones
    global gSki_Num_Bones
    gSki_File_Needs_Bones = True
    gSki_Num_Bones = 0
    nSkiType = 9
    
    # First check if we can get this from a property
    Ski_Type = pwSki_FetchProperty(mesh_obj, "Ski_Type")
    if Ski_Type is not None:
        if Ski_Type == 8:
            gSki_File_Needs_Bones = False
            gSki_Num_Bones = 0
        nSkiType = Ski_Type
    
    if nSkiType == 9:	# still 9 because not yet detected, or got it from property
        nMesh = mesh_obj.getData()
        vertex_group_names = nMesh.getVertGroupNames()
        for group_name in vertex_group_names:
            if group_name[0:5] != "_grp_":		# ignore our special groups here
                if group_name[0:11] != "Articular_W":
                    if group_name != "AssignERRORs":
                        gSki_Num_Bones += 1
            
    return nSkiType
    
    
# Check if we have a unique Ski_Type in all meshes to export
# -----------------------------------------------------------------------------
def CheckUniqueSkiType(meshes):
    bUnique = True
    uSkiType = None
    for mesh_obj in meshes:
        nSkiType = pwSki_DetermineSkiType(mesh_obj)
        if uSkiType is not None:
            if nSkiType != uSkiType:
                bUnique = False
        else:
            uSkiType = nSkiType
    return bUnique
    

# Check if we have a unique TypeMask in all meshes to export
# -----------------------------------------------------------------------------
def CheckUniqueTypeMask(meshes):
    bUnique = True
    uTypeMask = None
    for mesh_obj in meshes:
        nTypeMask = pwSki_FetchProperty (mesh_obj, "TypeMask", 41)
        if uTypeMask is not None:
            if nTypeMask != uTypeMask:
                bUnique = False
        else:
            uTypeMask = nTypeMask
    return bUnique


# -----------------------------------------------------------------------------
def pwSki_WriteHeader(file, meshes):
    global gSki_File_Needs_Bones
    global gSki_Num_Bones
    
    file.write("MOXBIKSA")	# 8 bytes
    
    # This Byte depends on ski file having armatures
    if gSki_File_Needs_Bones:
        ski_type = 9	# with "bonemap"?
    else:
        ski_type = 8	# older ski files
    file.write(struct.pack('<I',ski_type))	# 4 bytes, int32 little endian
    
    # Count mesh objects we have, separated into MeshTypes:
    # -----------------------------------------------------
    objTypeCount = [0,0,0,0]
    for mesh_obj in meshes:
        MeshType = pwSki_FetchProperty (mesh_obj, "MeshType", 0)
        objTypeCount[MeshType] += 1
    
    file.write(struct.pack('<4I', objTypeCount[0], objTypeCount[1], objTypeCount[2], objTypeCount[3]))	# 16 bytes: normally 1 DWORD value, 3 DWORDS ZERO
    
    
    # Count textures and materials
    # ----------------------------
    tex_mat_offsets = []
    mat_count = 0
    tex_count = 0
    for mesh in meshes:
        nMesh = mesh.getData()
        mat_index = -1	# None
        tex_index = -1	# None
        for mat in nMesh.materials:
            mat_count +=1
            mat_index = mat_count -1
            
            textures = mat.getTextures()
            tex_enabled = mat.enabledTextures
            
            #tex_count = len(textures)	# wrong
            tex_index = -1	# None
            for tex_channel, tex in enumerate(textures):
                if tex is not None and tex_channel in tex_enabled:
                    tex_count +=1
                    tex_index = tex_count -1
                    if gExportOnlyOneTexPerMesh:
                        break
            
            # Because PW has no Multi-Material meshes, break after first mat:
            break
        
        # Store info about the offsets (tex_index, mat_index)
        tex_mat_offsets.append((tex_index, mat_index))
    
    
    print "#materials:",mat_count,", #textures:",tex_count
    
    #tex_count = 1
    file.write(struct.pack('<I',tex_count))	# 4 bytes value
    
    #mat_count = 1
    file.write(struct.pack('<I',mat_count))	# 4 bytes value
    
    # This Byte depends on ski file having bone names
    if gSki_File_Needs_Bones:
        bip_count = gSki_Num_Bones	# with "bonemap"?
    else:
        bip_count = 4	# actually 0 "armatures" though - older ski files
    file.write(struct.pack('<I',bip_count))	# 4 bytes value
    
    unk_2_cnt = 0
    file.write(struct.pack('<I',unk_2_cnt))	# 4 bytes ZERO
    
    # Get property of this "type_mask" value
    TypeMask = pwSki_FetchProperty (meshes[0], "TypeMask", 41)
    file.write(struct.pack('<I',TypeMask))	# 4 bytes UNKNOWN VALUE (mostly hex 29)
    
    # Write additional 60 ZERO bytes
    file.write(struct.pack('<15I',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))	# 60 bytes ZERO
    
    return tex_mat_offsets
    
    
# -----------------------------------------------------------------------------
def pwSki_WriteBones (file, meshes):
    global gSki_File_Needs_Bones
    if gSki_File_Needs_Bones:
        mesh = meshes[0]
        nMesh = mesh.getData()
        vertex_group_names = nMesh.getVertGroupNames()
        for group_name in vertex_group_names:
            if group_name[0:5] != "_grp_" \
            and group_name != "AssignERRORs":			# ignore our special groups here
                if group_name[0:11] != "Articular_W":
                    name_len = len(group_name)
                    file.write(struct.pack('<I',name_len))	# 4 bytes value
                    file.write(group_name)					# the Bip name
            

# Exports enabled textures in materials of the mesh (maybe only one)
# -----------------------------------------------------------------------------
def pwSki_WriteTexture(file,mesh):
    tex_count = 0
    nMesh = mesh.getData()
    for mat in nMesh.materials:
        textures = mat.getTextures()
        tex_enabled = mat.enabledTextures
        
        for tex_channel, texture in enumerate(textures):
            if texture is not None and tex_channel in tex_enabled:
                tex = textures[tex_channel].tex
                
                tex_name = tex.getName()	# maybe check for "if tex.getType=='Image'"
                tex_count +=1
                
                # Append ".dds" if name has no DOT
                # (see function "pwSki_ReadTexture()" in import to get an idea why)
                dotpos = tex_name.find('.')
                if dotpos < 0:
                   tex_name += ".dds"
                
                # Write Lenght and Name of texture file
                tex_len = len(tex_name)
                file.write(struct.pack('<I',tex_len))	# 4 bytes, int32 value
                file.write(tex_name)					# the texture filename
                
                if gExportOnlyOneTexPerMesh:
                    break
        
    return tex_count
    
    
# -----------------------------------------------------------------------------
def pwSki_WriteMaterial(file,mesh):
    
    file.write("MATERIAL: ")			# 10 bytes
    file.write(struct.pack('<B',0)) 	# +1 byte (trailing Zero \0)
    
    # Write 16 float values - may be a matrix or just 16 material parameters
    # ----------------------------------------------------------------------
    mat_list = [0x00,0x00,0x80,0x3F,0x00,0x00,0x80,0x3F,0x00,0x00,0x80,0x3F,0x00,0x00,0x80,0x3F, \
                0x00,0x00,0x80,0x3F,0x00,0x00,0x80,0x3F,0x00,0x00,0x80,0x3F,0x00,0x00,0x80,0x3F, \
                0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x3F, \
                0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x3F]
    # Then write the block to file
    # ----------------------------
    ### for mat in mat_list:
    ###     file.write(struct.pack('<B',mat))
    
    # Better write as floats:
    # -----------------------
    mat_values = [ 1.0, 1.0, 1.0, 1.0, \
                   1.0, 1.0, 1.0, 1.0, \
                   0.0, 0.0, 0.0, 1.0, \
                   0.0, 0.0, 0.0, 1.0 ]
    
    
    # Overwrite some of those values with parameters we stored in Blender:
    # --------------------------------------------------------------------
    nMesh = mesh.getData()
    mat_0 = nMesh.materials[0]
    
    # values from first material[0]:
    diffuse_color = mat_0.getRGBCol()
    specular_color = mat_0.getSpecCol()
    emissive_color = mat_0.getMirCol()
    
    # replace in mat_list:
    mat_values[0] = diffuse_color[0]
    mat_values[1] = diffuse_color[1]
    mat_values[2] = diffuse_color[2]
    
    mat_values[4] = specular_color[0]
    mat_values[5] = specular_color[1]
    mat_values[6] = specular_color[2]
    
    mat_values[8] = emissive_color[0]
    mat_values[9] = emissive_color[1]
    mat_values[10] = emissive_color[2]
    
    # Then write the block of floats to file
    # --------------------------------------
    for mat_val in mat_values:
        file.write(struct.pack('<f',mat_val))	# 4 bytes per float
    
    
    # GET PROPERTIES BACK:
    # ++++++++++++++++++++
    fScaling = pwSki_FetchProperty (mesh, "Scaling", 9.99999)
    bClothing = pwSki_FetchProperty (mesh, "Clothing", 0)
    
    
    # Then write the block of 4 bytes which we don't know what it means 
    # -----------------------------------------------------------------
    file.write(struct.pack('<f',fScaling))	# 4 bytes per float
    
        
    # Finally write the value 0x00 (or 0x01) for avatar or clothing: (if it means that)
    # --------------------------------------------------------------
    file.write(struct.pack('<B',bClothing))	# 1 byte
    
    

# Helper function: calculate a corrected vertex weight (or give warning)
# ----------------------------------------------------------------------
def CalcNormalizedWeight (weight, vertex, source):
    doAdapt = False
    sum = weight[0] + weight[1] + weight[2]
    if sum > 1.1:
        print "Warning: Sum of vWeights above 1.1 at vertex %d. Sum: %.2f  from: '%s'" % (vertex.index, sum, source)
        if gVerbose:
            print "values:",weight
            print "vertex:",vertex.co
            print ""
        doAdapt = gNormalizeWeights
    
    # Now we could re-normalize those values; but... HOW?
    # Current spotted values have shown that "RED" (w[0]) is always >= "GREEN" (w[1])
    # and that "GREEN" (w[1]) is always >= "BLUE" (w[2]).
    # We could try this: 
    if doAdapt:
        w0 = weight[0]
        w1 = weight[1]
        w2 = weight[2]
        
        # First ensure that w0 is biggest, w2 is smallest (w1 between)
        if w1 > w0:
           w1 = w0
        if w2 > w1:
           w2 = w1
        
        # check and adapt w0,w1,w2
        if (w0+w1+w2 > 1.0):
            sub = (w0+w1+w2 - 1.0)/3.0
            if w2-sub < 0:  # ensure w2 does not fall below 0
                sub = w2
            w0 -= sub
            w1 -= sub
            w2 -= sub
            
            # check and adapt w0,w1
            if (w0+w1+w2 > 1.0):
                sub = (w0+w1+w2 - 1.0)/2.0
                if w1-sub < w2:  # ensure w1 does not fall below w2
                    sub = w1-w2
                w0 -= sub
                w1 -= sub
                
                # check and adapt w0
                if (w0+w1+w2 > 1.0):
                    sub = w0+w1+w2 - 1.0
                    if w0-sub < w1:  # ensure w0 does not fall below w1
                        sub = w0-w1
                    w0 -= sub
            
        
        weight = (w0,w1,w2)
        
        # TODO: maybe check for "lower than 0"; but can this happen in Blender?
    
    return (weight,doAdapt)


# Helper function: get vertex weight (= some kind of "bone influence")
# -----------------------------------------------------------------------------
def Ski_GetBoneInfluence (vertex, vertex_weights, vertex_colors):
    
    # if we stored our bone influence in groups "Articular_W1" etc.
    # (which is the new behavior), get the value from there;
    # otherwise get if from the vertex color (old-style behavior)
    # if nothing found, just apply the values 1.0, 0,0, 0,0 to be safe
    
    # NOTE: Seems that the sum of the 3 values should be <= 1.0 in total
    #       maybe we better correct the value if it's above 1.0 already?
    #       Or just give a warning?
    
    if len(vertex_weights) > 0:
        (v_weight,bAdapted) = CalcNormalizedWeight (vertex_weights[vertex.index], vertex, "vGroups")
    elif len(vertex_colors) > 0:
        (v_weight,bAdapted) = CalcNormalizedWeight (vertex_colors[vertex.index], vertex, "vColors")
    else:
        v_weight = (1.0, 0.0, 0.0)	#DEFAULT_WEIGHT
        bAdapted = True
    
    return (v_weight,bAdapted)
        
    
# Helpers: Name to Index, and vice versa
# -----------------------------------------------------------------------------
def Grp_NameToIndex (group_name):
    group_index = int(group_name[5:8])	# OLD STYLE groups were named like "_grp_042" (without "_A")
    
    # do we have a NEW STYLE named group?
    if (len(group_name) >= 12 and group_name[10:12] == " (" )\
    or len(group_name) == 10:			# NEW STYLE groups are named like "_grp_010_C (L UpperArm)" or just "_grp_010_C"
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
        
    #return
    

# -----------------------------------------------------------------------------
def pwSki_WriteMesh(file, mesh, tex_mat_offset):
    
    # Get object name from Blender
    name = mesh.name		# the object's name, not yet the mesh name
    ob_name = name
    
    # we may have to remove blender's automatic object numbering
    dotpos = name.find('.')
    if dotpos > 0:
       autonum = name[dotpos:]
       if len(autonum)==4 and name.endswith(autonum):	# e.g. '.010'
           ob_name = name[0:dotpos]
    name_len = len(ob_name)
    
    # a) name_length und name
    file.write(struct.pack('<I',name_len))	# 4 bytes, int32 value
    file.write(ob_name)						# the object's name
    
    
    # b) texture_index
    texture_index = tex_mat_offset[0]
    file.write(struct.pack('<I',texture_index))		# 4 bytes value
    
    # c) material_index
    material_index = tex_mat_offset[1]
    file.write(struct.pack('<I',material_index))	# 4 bytes value
    
    # d) vertex_count
    # let's first get the number of vertices and faces back
    nMesh = mesh.getData()
    vertex_count = len(nMesh.verts)
    faces_count = len(nMesh.faces)
    
    print "vertex_count:",vertex_count
    print "faces_count:",faces_count
    
    file.write(struct.pack('<I',vertex_count))	# 4 bytes value
    
    # e) index_count (means "total number of face vertex indices")
    index_count = faces_count * 3
    file.write(struct.pack('<I',index_count))	# 4 bytes value
    
    
    # now output the vertices, normals and uv
    # =======================================
        
    nMesh = mesh.getData()		#Note: this gives an NMesh, not Mesh
    
    # EXPERIMENT: Zusaetzlich Mesh zu NMesh
    #######################################
    mesh_name = nMesh.name		# e.g. "Mesh"
    print "mesh_name:",mesh_name
    real_mesh = Mesh.Get(mesh_name)
    # NOTE: This gives access to the Mesh, but it's not linked to the object.
    #######################################
    
    realMeshObject = mesh.getData(False,True) # gets a Mesh object instead of an NMesh
    
    ### Cleanup the old AssingERRORs Group
    # ++++++++++++++++++++++++++++++++++++
    if "AssignERRORs" in realMeshObject.getVertGroupNames():
        realMeshObject.removeVertGroup("AssignERRORs")    
    
    
    vertex_colors = []
    
    # We stored 3 floats into face colors
    # ---------------------------------------------
    # a) Check if we have vertex colors applied	(user could have removed it)
    if realMeshObject.vertexColors:		# not "mesh" or "nMesh" !
    
        # b) pre-fill with defaults
        for vertex in nMesh.verts:
            vertex_colors.append((1.0, 0.0, 0.0))	#DEFAULT_WEIGHT
        
        # c) get the colors applied
        for face in nMesh.faces:
            for i, vertex in enumerate(face):
                
                # only accessible if we do no have 4 vertices per face
                if i < len(face.col):
                    face_color = face.col[i]
                    
                    red = float(face_color.r) / 255.0
                    green = float(face_color.g) / 255.0
                    blue = float(face_color.b) / 255.0
                
                    vertex_colors[vertex.index] = (red, green, blue)
    
    
    # Get the vertex groups "_grp_$$$_X" in this mesh
    # -----------------------------------------------
    vertex_groups = []
    num_groups = 0
    vertex_group_names = nMesh.getVertGroupNames()
    for group_name in vertex_group_names:
        if group_name[0:5] == "_grp_":			# take only those named "_grp_$$$_X"
            group_index = Grp_NameToIndex(group_name)
            
            # create the array (sorry: 'list') of vertex groups
            while num_groups <= group_index:
                vertex_groups.extend([num_groups])
                vertex_groups[num_groups] = []
                num_groups +=1
            
            # now get the vertex indices
            #NEW: Add only vertices with weight == 1 (now: > 0.5)
            if gExportWeightsOnlyIfOne:
                localVerts = []
                localVertListTupels = nMesh.getVertsFromGroup(group_name, 1)
                for localVertex in localVertListTupels:
                    #if localVertex[1] == 1.0:
                    if localVertex[1] > 0.5:				# value
                        localVerts.append(localVertex[0])	# index
                # finally assign
                vertex_groups[group_index] = localVerts
            
            # OLD behaviour
            else:
                vertex_groups[group_index] = nMesh.getVertsFromGroup(group_name)
            
    
    # Get the vertex_weights from "Articular_" groups, if present
    # ===========================================================
    vertex_weights = []
    
    # a) check if three groups "Articular_W1" - ".._W3" exist
    # -------------------------------------------------------
    vertex_group_names = nMesh.getVertGroupNames()
    if "Articular_W1" in vertex_group_names \
    and "Articular_W2" in vertex_group_names \
    and "Articular_W3" in vertex_group_names:
        
        # b) pre-fill vertex_weights with defaults
        # ----------------------------------------
        for vertex in nMesh.verts:
            vertex_weights.append((1.0, 0.0, 0.0))	#DEFAULT_WEIGHT
        
        # c) for each group, get the applied vertex weight
        # ------------------------------------------------
        for group_name in vertex_group_names:
            if group_name[0:11] == "Articular_W":	# take only those named "Articular_W$"
                gi = int(group_name[11:])			# groups were named like "Articular_W1"
                localVertListTupels = nMesh.getVertsFromGroup(group_name, 1)
                for localVertex in localVertListTupels:
                    v_index = localVertex[0]
                    v_weight = localVertex[1]
                    
                    # now allocate:
                    if gi == 1:
                        vertex_weights[v_index] = (v_weight, vertex_weights[v_index][1], vertex_weights[v_index][2])
                    elif gi == 2:
                        vertex_weights[v_index] = (vertex_weights[v_index][0], v_weight, vertex_weights[v_index][2])
                    elif gi == 3:
                        vertex_weights[v_index] = (vertex_weights[v_index][0], vertex_weights[v_index][1], v_weight)
                    
    
    ### Check if we got weights, give warning if not
    if len(vertex_weights) == 0:
        if len(vertex_colors) == 0:
            print "Warning: No vertex weights found in vColors or vGroups"
            Blender.Draw.PupMenu("Warning%t|No vertex weights found in vColors or vGroups")
        else:
            print "Note: vertex weights taken from vColors instead of vGroups"
    
    
    ### Use uv-coords from Mesh, not NMesh, because otherwise we are going to export old data (edits will be lost)
    ### Astonishing, this does not have any effect; maybe we have to use Face-uv-coords instead of vertex.uvco...
    ##############################################################################################################
    real_coords = []
    for real_vert in real_mesh.verts:
        real_uvco = real_vert.uvco
        real_coords.append(real_uvco)
        #print "real_uvco=",real_uvco	# e.g.[0.5234,0.345](vector)
    
    # Overwrite with Face-related uvcos:
    for face in nMesh.faces:
        for point, face_vert in enumerate(face.v):
            # Note: since face.uv[point] is a Tuple, we have to copy index by index
            #       because we're going to change a single member later (uv[1] = 1.0-uv[1])
            real_coords[face_vert.index][0] = face.uv[point][0]
            real_coords[face_vert.index][1] = face.uv[point][1]
    ##############################################################################################################
    
    bWeightsAdapted = False
    bErrorsDetected = False
    nMoreGroupCount = 0
    nLessGroupCount = 0
    nByteCollisions = 0
    
    for vert in nMesh.verts:
        # 1. VERTICES (position)
        # ----------------------
        # Write in order x,z,y
        co = vert.co
        file.write(struct.pack('<3f', co[0], co[2], -co[1]))		# 12 bytes at all
        
        # We stored 3 floats into face colors, and 4 bytes as groups coded
        # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        # 2. THREE FLOAT VALUES
        # ---------------------
        (v_weight,bAdapted) = Ski_GetBoneInfluence (vert, vertex_weights, vertex_colors)
        bWeightsAdapted = bWeightsAdapted or bAdapted
        
        file.write(struct.pack('3f', v_weight[0], v_weight[1], v_weight[2]))	# writes 12 bytes
        
        
        # 3. FOUR BYTE VALUES
        # -------------------
        # Retrieve the 4 bytes from the groups we have attached the vertices to
        # First check
        num_assigns = 0
        grp_list = []
        for group, vert_list in enumerate(vertex_groups):
            if vert.index in vert_list:
                grp_list.append(Grp_IndexToName(group))
                num_assigns +=1
                
        # CHECKING OF BONE GROUP ASSIGNMENTS
        # ==================================
        # Check for MORE than 4 assignments
        if num_assigns >= 5:
            nMoreGroupCount +=1
            print "WARNING: Vertex", vert.index, vert.co
            print "         assigned to", len(grp_list), "groups", grp_list
        
        # Check also if we have LESS than 4 assignments
        if num_assigns <= 3:
            nLessGroupCount +=1
            print "WARNING: Vertex", vert.index, vert.co
            print "         assigned to only", len(grp_list), "groups", grp_list
        
        
        # Then assign to four bytes, and check finally for subgroup collision
        # (this means, if the vertex occupies the same byte again - danger!)
        # -------------------------------------------------------------------
        vg = [0,0,0,0]
        v_check = [False,False,False,False]
        sub_list = []
        num_bytes = 0
        bByteCollision = False
        for group, vert_list in enumerate(vertex_groups):
            if vert.index in vert_list:
                
                ### ATTENTION: Vertices don't have to be assigned to the same byte_index (sub-group)!
                # ++++++++++++++++++++++
                byte_index = group % 4
                
                # Check subgroup collision
                if v_check[byte_index]:		# already taken?
                    bByteCollision = True
                    sub_list.extend([chr(ord('A')+byte_index)])
                
                vg[byte_index] = int(group/4)
                v_check[byte_index] = True
                num_bytes +=1
                if num_bytes >= 4:
                    break
                    
        
        # Report a Byte Collision if this happened
        # ----------------------------------------
        if bByteCollision:
            nByteCollisions +=1
            print "WARNING: Vertex", vert.index, vert.co
            print "         assigned more than once to subgroups", sub_list
            
            
        # Add any error to the ERROR groups list
        # --------------------------------------
        if num_assigns != 4 or bByteCollision:
            bErrorsDetected = True
            
            # create an Error group if needed
            ErrorGrp_name = "AssignERRORs"
            if not ErrorGrp_name in realMeshObject.getVertGroupNames():
                realMeshObject.addVertGroup(ErrorGrp_name)
            
            vert_list = [vert.index]
            if num_assigns > 4:
                err_val = 1.0	# RED
            elif num_assigns < 4:
                err_val = 0.5	# GREEN
            else:
                err_val = 0.75	# YELLOW
            realMeshObject.assignVertsToGroup(ErrorGrp_name, vert_list, err_val, Blender.Mesh.AssignModes.ADD)
        
        
        file.write(struct.pack('4B', vg[0], vg[1], vg[2], vg[3]))	# writes 4 bytes
        # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        
        # 4. NORMALS
        # ----------
        normal = vert.no
        
        # Write in order x,z,y
        file.write(struct.pack('<3f', normal[0], normal[2], -normal[1]))	# 12 bytes at all
        
        
        # 5. uv-coords
        # ------------
        ### Use uv-coords from Mesh, not NMesh, because otherwise we are going to export old data (edits will be lost)
        ##############################################################################################################
        uv_coord = real_coords[vert.index]
        uv_coord[1] = 1.0 - uv_coord[1]
        file.write(struct.pack('<2f',uv_coord[0], uv_coord[1]))	# 8 bytes at all	(ab 0116 bis 011D) OKAY
        
    
    ## If we had to apply corrections to vertex weights, show a warning
    if bWeightsAdapted:
        Blender.Draw.PupMenu("Warning%t|Vertex weights were out of range and got adapted; Check console, and check your export !")
    
    if bErrorsDetected:
        nMesh.update()		# mainly update the AssignERRORs group display
            
    
    # Finally export the faces
    # =======================================
    zaehler=0
    nFaceErrors = 0
    for face in nMesh.faces:
        face_v = face.v
        if len(face_v) == 3:
            file.write(struct.pack('<3H',face_v[0].index, face_v[1].index, face_v[2].index))	# 6 bytes at all
        else:
            nFaceErrors += 1
            print "WARNING: Face",zaehler,"does not have 3 vertices!"
            print face_v
        zaehler += 1
    
    # report errors
    # +++++++++++++
    if nFaceErrors > 0:
        Blender.Draw.PupMenu("Error%%t|Each face in mesh must be of type Triangle, not Quad, to properly export (%d wrong)! Review your mesh!" % nFaceErrors)
        
    if nMoreGroupCount > 0:
        Blender.Draw.PupMenu("Warning%%t|%d vertices assigned to MORE than 4 groups! (marked red {1.0} in AssignERRORs)" % nMoreGroupCount)
        
    if nLessGroupCount > 0:
        Blender.Draw.PupMenu("Warning%%t|%d vertices assigned to LESS than 4 groups! (marked green {0.5} in AssignERRORs)" % nLessGroupCount)
    
    if nByteCollisions > 0:
        Blender.Draw.PupMenu("Warning%%t|%d vertices not properly dispersed to subgroups (A,B,C and D)! (marked yellow {.75} in AssignERRORs)" % nByteCollisions)
    
    #return

    
# -----------------------------------------------------------------------------
    


# script main function
# --------------------
def ExportToSki(file_name):
    scene = Blender.Scene.GetCurrent()
    
    in_emode = Window.EditMode()
    if in_emode: Window.EditMode(0)
    
    # make lists of individual objects
    meshes = []
    
    # Export Only Selected Objects
    selected_objects = Blender.Object.GetSelected()
    
    # Start checking selected objects
    # -------------------------------
    bReady = True
    if len(selected_objects) == 0:
        bReady = False
        Blender.Draw.PupMenu("Error%t|No objects selected.")
    
    if bReady:
        for selected_object in selected_objects:
            if selected_object.getType() == 'Mesh':
                meshes.append(selected_object)
            
        # Check if all objects are of same Ski_Type
        bReady = CheckUniqueSkiType(meshes)
        if not bReady:
            Blender.Draw.PupMenu("Error%t|Objects of different Ski_Type cannot be exported together into the same file.")
        
    if bReady:
        # Check if all objects share the same TypeMask
        bReady = CheckUniqueTypeMask(meshes)
        if not bReady:
            Blender.Draw.PupMenu("Error%t|Objects of different TypeMask cannot be exported together into the same file.")
    
    if bReady:
        file = open(file_name, "wb")
        
        # Determine the file type to generate
        pwSki_DetermineSkiType(meshes[0])
        
		# write header
        tex_mat_offsets = pwSki_WriteHeader(file, meshes)
        
        # Insert Bone names (after Header, before Texture)
        pwSki_WriteBones(file, meshes)
        
        # Write Textures
        for mesh in meshes:
            pwSki_WriteTexture(file, mesh)
        
        # Write Materials
        for mesh in meshes:
            pwSki_WriteMaterial(file, mesh)
        
        # Write Meshes
        # ------------
        for mesh_index, mesh in enumerate(meshes):
            # Check if this mesh is actually mirrored; if true, we can just 
            # store it unchanged because that's the way PW needs the SKI.
            # If NOT, we should flip it (if allowed by global setting):
            # -------------------------------------------------------------
            mirrored = pwSki_FetchProperty (mesh, "mirrored", True)
            if mirrored or gFlipLeftToRight==False:
                pwSki_WriteMesh(file, mesh, tex_mat_offsets[mesh_index])
            else:
                # a) Flip the mesh, b) export it, c) flip it back
                # Yes I know this is messy - but no way out :(
                # -----------------------------------------------
                FlipMeshLeftRight (mesh)
                try:
                    pwSki_WriteMesh(file, mesh, tex_mat_offsets[mesh_index])
                finally:
                    FlipMeshLeftRight (mesh)
        
        file.close()
    
    if in_emode: Window.EditMode(1)
    Blender.Redraw()


# -----------------------------------------------------------------------------
def FileSelectorCB(file_name):
    if not file_name.lower().endswith('.ski'):
        file_name += '.ski'
    ExportToSki(file_name)

if __name__ == '__main__':
    Blender.Window.FileSelector(FileSelectorCB, "Export SKI", Blender.sys.makename(ext='.ski'))

