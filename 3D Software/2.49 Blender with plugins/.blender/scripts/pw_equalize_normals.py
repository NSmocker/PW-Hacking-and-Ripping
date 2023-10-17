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


""" Registration info for Blender menus
Name: 'Equalize normals on adjacent faces'
Blender: 249
Group: 'Object'
Tooltip: 'Equalize vertex normals on adjacent faces to make them appear virtually connected'	
"""

__author__= "Rainer Kesselschlaeger"
__email__ = ["katzeklick:gmx*de"]
__url__ = ("http://www.blender.org", "http://www.texturu.org")
__version__ = "v1.0"	

__bpydoc__ = """\
Equalizes vertex normals on adjacent faces to make them appear virtually connected.

Usage:

First select an object in Object Mode, then call this script from Object menu.

The calculated vertex normals of this script remain only temporary, because
Blender calculates them again at own will after various operations, like 
editing parts of a mesh - or even simply switching from Edit mode to
Object Mode.
Because of that, the main use of this script is preparing data for an
export or setup objects for nicer rendering.
"""

import Blender
from Blender import Window


# Helper: Make a copy of a mesh (only vertices and faces)
#         this makes unlinking the mesh easier
# -----------------------------------------------------------------------------
def CopyMesh_VNF (srcMesh, newName):
    newMesh = Blender.Mesh.New(newName)
    
    # Copy vertices
    for vert in srcMesh.verts:
        newMesh.verts.extend(vert.co)
        vertex = newMesh.verts[-1]
        vertex.no = vert.no
    
    # Copy faces
    for face in srcMesh.faces:
        face_verts = (face.verts[0].index, face.verts[1].index, face.verts[2].index)
        #print face_verts
        newMesh.faces.extend(face_verts)
    
    return newMesh
    

# -----------------------------------------------------------------------------
def GetMeshTemplate(Mesh_obj):
    
    posi_array = []
    norm_array = []
    
    workMesh = Mesh_obj.getData(False,True) # gets a Mesh object instead of an NMesh
    
    # Read the mesh, store information about vertex position + normal vector
    # ----------------------------------------------------------------------
    for vert in workMesh.verts:
        
        # 1. VERTEX POSITION (co)
        # -----------------------
        position = vert.co
        
        # 2. NORMAL VECTORS
        # -----------------
        normal = vert.no
        
        # Finally insert into the arrays
        # ++++++++++++++++++++++++++++++
        posi_array.append(position)
        norm_array.append(normal)
        
    print "template read:done"
    
    return (posi_array, norm_array)
    

# Helper: Check if a vertex position is close enough to treat as "same"
# -----------------------------------------------------------------------------
def posMatch(pos1, pos2):
    max_dist = 0.0005	#max_dist = 0.00001
    dist_0 = abs(pos1[0]-pos2[0])
    dist_1 = abs(pos1[1]-pos2[1])
    dist_2 = abs(pos1[2]-pos2[2])
    if dist_0 > max_dist:
        return False
    if dist_1 > max_dist:
        return False
    if dist_2 > max_dist:
        return False
    return True


# Helper: Find a vertex by position
# -----------------------------------------------------------------------------
def findMatchingVertex(position, index, posi_array):
    # First compare position at index in the array with needed position;
    # if they match, we can just take the normals vector at this index.
    if index < len(posi_array):
        if posMatch(position, posi_array[index]):
            return index
    
    # else we have to seek in the whole array if we find a matching position
    for ix, pos in enumerate(posi_array):
        if posMatch(position, pos):
            return ix
    
    return -1	# not found
    
    
# Patches vertex normals in given mesh_object using values from norm_array
# -----------------------------------------------------------------------------
def PatchNormals(realMesh, posi_array, norm_array):
    
    for vert in realMesh.verts:
        # get the position (coord)
        position = vert.co
        
        # find a matching vertex in template at this position
        t_index = findMatchingVertex(position, vert.index, posi_array)
        
        normal = vert.no
        # patch normal vector if we found a match
        if t_index >= 0:
            normal[0] = norm_array[t_index][0]
            normal[1] = norm_array[t_index][1]
            normal[2] = norm_array[t_index][2]
            vert.no = normal
        else:
            print "Warning: no matching position for vertex", vert.index, "found;"
            print "vertex coordinates(X,Y,Z):",position[0],position[1],position[2]
        

# -----------------------------------------------------------------------------
def RemoveDuplicateVertices(mesh_obj):
    Mesh_2 = mesh_obj.getData(False,True)
    for vert in Mesh_2.verts:
        vert.sel = 1
    vertsRemoved = Mesh_2.remDoubles(0.001)
    return vertsRemoved
    

# -----------------------------------------------------------------------------
def EqualizeNormalsOfAdjacentFaces(mesh_obj):
    realMesh = mesh_obj.getData(False,True)
    meshCopy = CopyMesh_VNF(realMesh, "TEMP_MESH")
    
    # The copy must be linked to an object to get remDoubles work:
    Mesh2_obj = Blender.Object.New('Mesh', "TEMPORARY")
    Mesh2_obj.link(meshCopy)
    scene = Blender.Scene.GetCurrent()
    scene.objects.link(Mesh2_obj)
    
    vertsRemoved = RemoveDuplicateVertices(Mesh2_obj)
    posi_array, norm_array = GetMeshTemplate(Mesh2_obj)
    
    # unlink the working copy of our mesh
    scene.objects.unlink(Mesh2_obj)
    scene.update(0)
    
    PatchNormals(realMesh, posi_array, norm_array)
    return vertsRemoved
    

# -----------------------------------------------------------------------------
def main():
    scene = Blender.Scene.GetCurrent()
    obj = scene.getActiveObject()
    
    in_emode = Window.EditMode()
    if in_emode: 
        Blender.Draw.PupMenu('Error%t|This does not work in Edit Mode, aborting.')
        return
    
    if not obj or obj.getType() != 'Mesh':
        Blender.Draw.PupMenu('Error%t|No active mesh object, aborting.')
        return
    
    Window.WaitCursor(1)
    
    vertsRemoved = EqualizeNormalsOfAdjacentFaces(obj)
    
    if vertsRemoved > 0:
        Blender.Draw.PupMenu("Normals calculated.%%t|%d vertices have been virtually connected, faces flattened.|Be sure to export your object immediately." % vertsRemoved)
    else:
        Blender.Draw.PupMenu("(There was nothing to do; %d vertices found that could be stitched. Model already fine.)" % vertsRemoved)
    
    Window.WaitCursor(0)
    Blender.Redraw()
	
	
if __name__ == '__main__':
	main()

