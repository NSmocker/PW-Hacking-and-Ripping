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
Name: 'Mirror complete mesh while maintaining normals'
Blender: 249
Group: 'Object'
Tooltip: 'Flips the currently selected mesh object left to right, while maintaining normal vectors'	
"""

__author__= "Rainer Kesselschlaeger"
__email__ = ["katzeklick:gmx*de"]
__url__ = ("http://www.blender.org", "http://www.texturu.org")
__version__ = "v1.0"	

__bpydoc__ = """\
Flips the currently selected mesh object left to right, while maintaining normal vectors.

Usage:

First select an object in Object Mode, then call this script.
"""

import Blender
from Blender import Window


# Flips a mesh in X-direction, while maintaining the vertex normals
# -----------------------------------------------------------------------------
def FlipMeshLeftRight (mesh_obj):
    # 1. Save the vertex normals
    # 2. Revert x-coordinate of each vertex
    # 3. Flip the vertex normals, because they now point inside
    # 4. Restore the vertex normals
    
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
    

def main():
    scene = Blender.Scene.GetCurrent()
    obj = scene.getActiveObject()
    
    in_emode = Window.EditMode()
    if in_emode: 
        Blender.Draw.PupMenu('Error, this does not work in Edit Mode, aborting.')
        return
    
    if not obj or obj.getType() != 'Mesh':
        Blender.Draw.PupMenu('Error, no active mesh object, aborting.')
        return
    
    FlipMeshLeftRight (obj)
    
    Blender.Redraw()
	
	
if __name__ == '__main__':
	main()

