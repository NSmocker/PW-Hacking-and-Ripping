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
Name: '_Rotate Face-UV'
Blender: 249
Group: 'Mesh'
Tooltip: 'Rotates UV-Coordinates of one or more selected faces'
"""

__author__= "Rainer Kesselschlaeger"
__email__ = ["katzeklick:gmx*de"]
__url__ = ("http://www.blender.org", "http://www.texturu.org")
__version__ = "v1.0"	

__bpydoc__ = """\
Rotates UV-Coordinates of a selected face.

Usage:

First select a face in Edit Mode, then call this script.
"""

import Blender
from Blender import Window


# -----------------------------------------------------------------------------
def Rotate_Faces (mesh):
    for face in mesh.faces:
        if face.sel:
            # first check if we have a Triangle (does not work for Quads currently; TODO)
            if len(face.verts) != 3:
                continue
            # search in vertices for 3 vertices of this face
            i = 0
            for vert in mesh.verts:
                if vert == face.verts[0]:
                    vert_0 = vert
                    i += 1
                elif vert == face.verts[1]:
                    vert_1 = vert
                    i += 1
                elif vert == face.verts[2]:
                    vert_2 = vert
                    i += 1
                if i >= 3:
                    break
            
            # now exchange their uv-coords
            if i == 3:
                dummy_uv = vert_0.uvco
                vert_0.uvco = vert_1.uvco
                vert_1.uvco = vert_2.uvco
                vert_2.uvco = dummy_uv
            
            # Oh - we are using face-UVs, so exchange them as well
            # face.uv = (face.uv[1], face.uv[2], face.uv[0])	# This does NOT work (!)
            # Better:
            newPoint0 = Blender.Mathutils.Vector(face.uv[1][0], face.uv[1][1])
            newPoint1 = Blender.Mathutils.Vector(face.uv[2][0], face.uv[2][1])
            newPoint2 = Blender.Mathutils.Vector(face.uv[0][0], face.uv[0][1])
            newFaceUV = tuple([newPoint0, newPoint1, newPoint2])
            face.uv = newFaceUV
    

# -----------------------------------------------------------------------------
def main():
    scene = Blender.Scene.GetCurrent()
    obj = scene.getActiveObject()
    
    if not obj or obj.getType() != 'Mesh':
        Blender.Draw.PupMenu('Error%t|No active mesh object, aborting.')
        return
    
    in_emode = Window.EditMode()
    if in_emode: Window.EditMode(0)
    
    mesh = obj.getData(False,True)
    Rotate_Faces (mesh)
    
    if in_emode: Window.EditMode(1)
    Blender.Redraw()
	
	
if __name__ == '__main__':
	main()

