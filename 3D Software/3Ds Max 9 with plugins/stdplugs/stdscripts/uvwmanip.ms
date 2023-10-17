-- UVW Mapping modifier manipulator

-- This file implements manipulators for the width, length and height of the
-- UVW mapping.

-- Written by Scott Morrison, July 26, 2000
-- Updated by Scott to support the position manipulator, Fall 2004

-- Utilities used by the UVW manipulators
Struct uvwManipUtils (
  
    -- Compute the transform matrix for the mapping gizmo.  This maps gizmo space
    -- into the local coordinate space for the modifier.  In gizmo space,
    -- the gizmo extends from -1 to 1 in x and y.

    function gizmoMatrix UVWMod  = 
    (
        local tm = UVWMod.gizmo.transform
    
        -- Rotate the frame for each mapping type.  This step is black magic
        -- copied from MaxSDK/Samples/Modifier/MapMod.cpp.
        case UVWMod.mapType of 
        (
             0: tm = preRotateZ tm 180
             1: tm = preRotateZ tm  90
             2: tm = preRotateZ tm  90
             4: tm = preRotateZ tm 180
        )
    
        -- Compensate for the specified axis of projection
        case UVWMod.axis of
        (
             0: tm = preRotateY tm -90
             1: tm = preRotateX tm  90
        )
    
        -- Scale by the width, length and height of the mapper
        local s = [UVWMod.width, UVWMod.length, UVWMod.height]
    
        case UVWMod.mapType of 
        (
             0: (s.x = s.x * 0.5; s.y = s.y * 0.5)
             1: (s.x = s.x * 0.5; s.y = s.y * 0.5)
             2: s = s * 0.5
             4: s = s * 0.5
        )
        
        tm = preScale tm s
    
        return tm
    ),
    
    -- return the axis of the UVW Mapping gizmo
    
    function gizmoAxis UVWMod =
    (
        case UVWMod.axis of
        (
             0: return x_axis
             1: return y_axis
             2: return z_axis
        )
    
        return z_axis
    ),
    
    -- return the axis TM of the UVW Mapping gizmo
    
    function gizmoAxisTM UVWMod =
    (
        local tm = Matrix3(1)
        case UVWMod.axis of
        (
             0: tm = preRotateY tm 90
             1: tm = preRotateX tm 90
        )
    
        return tm
    ),
    
    -- Project the given screen coordinate to the gizmo plane.
    -- returns 2 values: a flag saying whether the pojection worked,
    -- and the projected point
    
    function projectPointToGizmo this m gizmoTM =
    (
        local axis = uvwManipUtils.makeXYGizmoAxis gizmoTM
    
        -- Create the plane that the gizmo lies on
        local pl = manip.makePlaneFromNormal axis ([0, 0, 0] * gizmoTM)
              projectedPoint = [0,0,0]
    
        -- Compute the hit-ray in local coordinates
        local viewRay = this.getLocalViewRay m
    
        -- Intersect the plane with the view ray
        local res = pl.intersect viewRay &projectedPoint
    
        return #(res, projectedPoint)
    ),
    
    -- Project the given screen coordinate to the gizmo plane.
    -- returns 2 values: a flag saying whether the pojection worked,
    -- and the projected point
    
    function projectPointToPlane this m pl =
    (
        local projectedPoint = [0,0,0]
    
        -- Compute the hit-ray in local coordinates
        local viewRay = this.getLocalViewRay m
    
        -- Intersect the plane with the view ray
        local res = pl.intersect viewRay &projectedPoint
    
        return #(res, projectedPoint)
    ),
    
    -- Returns true if the given UVWMapper uses a gizmo
    
    function usesGizmo UVWMod =
    (
        local mapType = UVWMod.mapType
        if mapType != 0 and mapType != 1 and mapType != 2 and mapType != 4 then return false
        return UVWMod.length != 1.0 or UVWMod.width != 1.0 or UVWMod.height != 1.0
    ),

    function isPhysicalScaleMapper UVWMod =
    (
        return UVWMod.length == 1.0 and UVWMod.width == 1.0 and UVWMod.height == 1.0
    ),

    -- Compute the normal of the projection axis
    function makeXYGizmoAxis gizmoTM = 
    (
        local p0 = [-1.0, -1.0, 0.0] * gizmoTM,
              p1 = [ 1.0, -1.0, 0.0] * gizmoTM,
              p2 = [ 1.0,  1.0, 0.0] * gizmoTM
        local d1 = p2 - p1
        local d2 = p2 - p0
        return cross d1 d2
    ),

    -- Create a cube gizmo with the given posistion and size
    
    function makeCubeGizmo pos size =
    (
        local giz = manip.makeGizmoShape()
        local halfSize = size / 2
    
        -- The corners of the cube
        local p000 = pos + [ halfSize,  halfSize,  halfSize]
        local p001 = pos + [ halfSize,  halfSize, -halfSize]
        local p010 = pos + [ halfSize, -halfSize,  halfSize]
        local p011 = pos + [ halfSize, -halfSize, -halfSize]
        local p100 = pos + [-halfSize,  halfSize,  halfSize]
        local p101 = pos + [-halfSize,  halfSize, -halfSize]
        local p110 = pos + [-halfSize, -halfSize,  halfSize]
        local p111 = pos + [-halfSize, -halfSize, -halfSize]
    
        -- Create the top of the box
        giz.AddPoint(p000)
        giz.AddPoint(p010)
        giz.AddPoint(p011)
        giz.AddPoint(p001)
        giz.AddPoint(p000)
    
        -- Create the bottom of the box
        giz.startNewLine()
        giz.AddPoint(p100)
        giz.AddPoint(p110)
        giz.AddPoint(p111)
        giz.AddPoint(p101)
        giz.AddPoint(p100)
    
        -- Create the struts
        giz.startNewLine()
        giz.AddPoint(p000)
        giz.AddPoint(p100)
    
        giz.startNewLine()
        giz.AddPoint(p010)
        giz.AddPoint(p110)
    
        giz.startNewLine()
        giz.AddPoint(p011)
        giz.AddPoint(p111)
    
        giz.startNewLine()
        giz.AddPoint(p001)
        giz.AddPoint(p101)
    
        return giz    
    ),
    
    -- Get the UV transform for the texture on the diffuse map
    -- return identity matrix if that doesn't exist
    function GetUVTransform node = 
    (
        local uvgen = uvwManipUtils.GetUVGen node
        if ((uvgen != undefined) and 
            (IsProperty uvgen #UVTransform)) then return uvgen.UVTransform
        return Matrix3(1)
    ),

    -- Get the uvgen object for the texture on the diffuse map
    -- return undefined
    function GetUVGen node = 
    (
        if (node == undefined) then
            return undefined
        if not(IsProperty node #Material) then
            return undefined
        local mat = node.Material
        return uvwManipUtils.GetUVGenFromMat mat
    ),

    function GetUVGenFromMat mat =
    (
        if (mat == undefined) then
            return undefined

        local tex
        if (IsProperty mat #diffuseMap) then
            tex = mat.diffuseMap
        else (
            if ((classOf mat) == Multimaterial) then (
                for i = 1 to mat.numsubs do (
                    local subMat = mat[i]
                    local gen = uvwManipUtils.GetUVGenFromMat subMat
                    if (gen != undefined) then 
                        return gen
                )
            ) 
            return undefined
        )
        if (tex == undefined) then
            return undefined
        if not(IsProperty tex #Coordinates) then
            return undefined
        local uvgen = tex.Coordinates
        if (uvgen == undefined) then
            return undefined
        return uvgen
    )

)  -- uvwManipUtils


plugin simpleManipulator uvwMappingPositionManip
    name:"UVW Position Manip"
    invisible:true
(
    -- Create the green and red colors for the gizmo
    local greenColor =  colorMan.getColor #manipulatorsActive
    local redColor =    colorMan.getColor #manipulatorsSelected

    local zColor = [1, 0, 0]
    local yColor = [0, 1, 0]
    local xColor = [1, 1, 0]
 
    -- Some useful transforms
    local gizmoTM, inverseGizmoTM, gizmoVectorTM, inverseGizmoVectorTM
    -- lists  of points axes planes and colors used by the gizmo
    local origP, axisList, planeList, colorList

    -- These are the corders of a single texture tile in UV space
    local uvList = #([0,0,0], [1,0,0], [1,1,0], [0,1,0])

    -- This manipualtor manipulates the UVWMap modifier
    on canManipulate target do
    (
        return (modPanel.getCurrentObject() == target) and ((classOf target) == UVWMap)
    )

    -- The parameter block contains a reference to the UVWGen for
    -- the material assigned to the node being manipulated.  This
    -- lets the manipulator update when the material changes.
    parameters main
    ( 
         -- The UVGen of the material
         uvgen      type:#maxObject
    )
 
    -- Given a uv value and a plane, find the 3d point on
    -- the plane which maps to the given uv value.
    -- This method inverts the mapping algorithm found
    -- in mesh/uvwmap.cpp
    function MapUVToLocal3dCoords uvValue projPlane = 
    (
        -- Get the UV transform from the material, if available
        this.uvgen = uvwManipUtils.GetUVGen(node)
        local uvTM = uvwManipUtils.GetUVTransform(node)

        -- tranforming by the inverse of the UV transform gives the
        -- source UVW value which produces the given uvValue
        local uvw = uvValue * (inverse uvTM)

        -- Get the plane normal in gizmo space
        local axis = (Normalize projPlane.Normal) * inverseGizmoVectorTM

        -- Compute the box mapping direction
        local x = abs axis[1]
        local y = abs axis[2]
        local z = abs axis[3]
        local whichCoord = if (y > x) then 1 else 0;
        if (z > abs(axis[whichCoord+1])) then whichCoord = 2;
        if (axis[whichCoord+1] < 0) then whichCoord = whichCoord+3;

        local p
        -- Invert the box mapping equations for each of the 6 directions
        case whichCoord of
        (
        0: (
                p = [0, 2*uvw.x-1, 2*uvw.y-1]
                axis = [1, 0, 0]
            ) 
        1: (
                p = [1-2*uvw.x, 0, 2*uvw.y-1]
                axis = [0, 1, 0]
            ) 
        2: (
                p = [2*uvw.x-1, 2*uvw.y-1, 0]
                axis = [0, 0, 1]
            ) 
        3: (
                p = [0, 1-2*uvw.x, 2*uvw.y-1]
                axis = [1, 0, 0]
            ) 
        4: (
                p = [2*uvw.x-1, 0, 2*uvw.y-1]
                axis = [0, 1, 0]
            ) 
        5:
            (
                p = [1-2*uvw.x, 2*uvw.y-1, 0]
                axis = [0, 0, 1]
            )
        )

        -- Transform the inverted UV to the gizmo coordinate system
        p = p * gizmoTM

        -- Transform the axis similarly
        axis = axis * gizmoVectorTM

        -- Compute the ray which represents the set of points
        -- wiht the given UV values
        local r = ray (p-axis) axis
        local retVal = [0,0,0]

        -- Intersect the ray with the given plane to get the final point
        local res = projPlane.intersect r &retVal
        return retVal
    )

    -- Find the plane which is most orthogonal to the given axis.
    -- extreme is an end of the bounding box for the UVW modifier
    -- growth factor is a number slightly greater than 1 to make the
    -- gizmo rise off the surface a little.
    function FindMostOrthogonalPlane axis extreme growthFactor = 
    (
        local x = abs axis[1]
        local y = abs axis[2]
        local z = abs axis[3]

        local plane
        local a
        if (x > y and x > z) then 
        (
            a = if axis[1] > 0 then 1 else (-1)
            plane = manip.makePlaneFromNormal [a,0,0] [extreme.X*growthFactor,0,0]
        ) 
        else if (y > x and y > z) then 
        (
            a = if axis[2] > 0 then 1 else (-1)
            plane = manip.makePlaneFromNormal [0,a,0] [0,extreme.Y*growthFactor,0]
        )
        else 
        (
            a = if axis[3] > 0 then 1 else (-1)
            plane = manip.makePlaneFromNormal [0,0,a] [0,0,extreme.Z*growthFactor]
        )


        return plane
    )

    -- Add the points for the manipulator on the given plane
    function AddPointsForTextureTile plane color axis =
    (
        append planeList plane
        for i = 1 to uvList.count do 
        (
            append origP (MapUVToLocal3dCoords uvList[i] plane)
            append axisList axis
            append colorList color
        )
    )    

    -- Create the lines wich connect the manipulator handles
    function CreateFaces =
    (
        local numFaces
        if (target.mapType == 4) then numFaces = 6 else numFaces = 2
        for i = 1 to numFaces do
        (
            local j = 4*(i-1)
            for k = j+1 to j+4 do
            (
                local giz = manip.makeGizmoShape()
                -- Gizmo 0 - width
                local p1 = origP[k]
                local index
                if (k == (j+4)) then index = j+1 else index = k+1
                local p2 = origP[index]
                giz.AddPoint p1
                giz.AddPoint p2
                this.addGizmoShape giz gizmoDontHitTest colorList[k] [1,1,1]
    
            )
        )
    )

    -- Tolerance for testing vector components agains zero
    local epsilon = 0.01

    -- Given a plane object, return the transform matrix which
    -- transforms the XY plane to this plane.
    function GetPlaneTM plane =
    (
        local normal = plane.Normal

        -- Decompose the plane normal to spherical coordinates
        local rho = Length(normal)
        local theta = (atan2 normal.y normal.x)
        local phi = (acos (normal.z/rho))

        -- Create a matrix which reproduces those spherical rotations
        local b = Matrix3(1)
        b = PreRotateY b phi
        local c = Matrix3(1)
        c = PreRotateZ c theta
        local m = b*c

        -- Find a point on the plane also on the XY plane, if it exists
        -- If the plane is parallel to the XY plane, just get any point
        -- on the plane.  
        -- This untilizes the plane equation: for any point p in the
        -- plane, it satisfies dot(p, normal) + planeConstant = 0
        local p
        if ((abs(normal.x) < epsilon) and 
            (abs(normal.y) < epsilon) and 
            ((abs(normal.z - 1) < epsilon) or (abs(normal.z + 1) < epsilon))) then
            p = plane.Point
        else if (abs(normal.x) > epsilon) then 
            p = Point3 (-plane.planeConstant/normal.x) 0 0
        else if (abs(normal.y) > epsilon) then
            p = Point3 0 (-plane.planeConstant/normal.y) 0
        else
            p = Point3 0 0 0 -- This should never happen

        -- translate the rotation matrix by the point on the XY plane
        return Translate m p
    )

    -- Create the manipulator gizmo.
    -- This is called initially and whenver the manipulator target changes
    on updateGizmos do
    (
        -- Clear the current gizmo cache
        this.clearGizmos()

        -- Clear the reference to the uvgen
        this.uvgen = undefined

        -- This manipulator inly works for planar and box mapping types
        if ((target.mapType != 0) and (target.mapType != 4)) then
            return ""

        -- Initialize our transforms
        gizmoTM = uvwManipUtils.gizmoMatrix target 

        local modTM = getModContextTM node target
        -- check to see if modifier is in a valid state
        if (modTM == undefined) then return ""

        if (not uvwManipUtils.isPhysicalScaleMapper target) then
            return ""

        modTM = inverse modTM

        gizmoTM = gizmoTM * modTM

        inverseGizmoTM = inverse gizmoTM

        gizmoVectorTM = copy gizmoTM
        gizmoVectorTM.translation = [0,0,0]

        inverseGizmoVectorTM = copy inverseGizmoTM
        inverseGizmoVectorTM.translation = [0,0,0]

        origP = #()
        axisList = #()
        planeList = #()
        colorList = #()

        local bboxMax = getModContextBBoxMax node target
        local bboxMin = getModContextBBoxMin node target
        local growthFactor = 1.002

        local plane

        
        if ( target.mapType == 0) then
        ( 
            -- For planar mappings, create a gizmo in the plane of the mapping.
            local planeAxis = uvwManipUtils.gizmoAxis target
            planeAxis = planeAxis * gizmoVectorTM
            planeAxis = Normalize planeAxis
            local offset = (1 - growthFactor) * planeAxis
            plane = manip.makePlaneFromNormal planeAxis (gizmoTM.Translation + offset)
            AddPointsForTextureTile plane zColor 1

            plane = manip.makePlaneFromNormal planeAxis (gizmoTM.Translation - offset)
            AddPointsForTextureTile plane zColor 2

        ) 
        else 
        (
            -- For box mapping create a gizmo on each bounding box face.
            plane = FindMostOrthogonalPlane [0,0,1] bboxMax growthFactor
            AddPointsForTextureTile plane zColor 1

            plane = FindMostOrthogonalPlane [0,0,-1] bboxMin growthFactor
            AddPointsForTextureTile plane zColor 2

            plane = FindMostOrthogonalPlane [0,1,0] bboxMax growthFactor
            AddPointsForTextureTile plane yColor 3
    
            plane = FindMostOrthogonalPlane [0,-1,0] bboxMin growthFactor
            AddPointsForTextureTile plane yColor 4
      
            plane = FindMostOrthogonalPlane [1,0,0] bboxMax growthFactor
            AddPointsForTextureTile plane xColor 5

            plane = FindMostOrthogonalPlane [-1,0,0] bboxMin growthFactor
            AddPointsForTextureTile plane xColor 6
        )

        -- Add the handles to the manipulator gizmo
        for i = 1 to origP.count do
        (
            this.addGizmoMarker #hollowBox origP[i] 0 colorList[i] [1,1,1]
        )

        -- Create the lines connecting the handles.
        CreateFaces()

        return node.name + " Texture Position: " + (target.gizmo.Transform.Translation as string)
    )

    -- Called on every mouse move when dragging a handle
    on mouseMove m which do
    (
        -- Get the plane the handle lives on
        local plane = planeList[axisList[which+1]]

        -- Get the TM for the plane which we are prjecting to
        local planeTM = GetPlaneTM plane
        local worldTM = node.transform
        local worldTMInv = Inverse(worldTM)
        planeTM = planeTM*worldTM
        -- Project the current mouse point to that plane
        local l = uvwManipUtils.projectPointToPlane this m plane

        -- If the intersection worked, set the gizmo postion
        if (l[1]) then 
        (
            -- Snap the point to the gizmo plane, using the current snap settings.
            local p1 = gw.snapPoint m snapPlane:planeTM snapType:#in3d

            -- Transform the returned points, which is in construction plane
            -- cordinates to the local coordiantes of the modifier.
            p1 = p1 * planeTM
            p1 = p1 * worldTMInv

            -- Compute the delta of the snapped point to the original point
            local delta = p1 - origP[which+1]

            -- Update the gizmo transform with that delta
            mat = target.gizmo.Transform
            mat.Position += delta
            target.gizmo.Transform = mat
        )        
    )
)

plugin simpleManipulator uvwMappingWidthManip
    name:"UVW Width Manip"
    invisible:true
(
    -- Set the green and red colors for the gizmo
    local greenColor =  colorMan.getColor #manipulatorsActive
    local redColor =    colorMan.getColor #manipulatorsSelected

    -- Some useful transforms
    local gizmoTM, inverseGizmoTM

    -- This manipualtor manipulates any UVWMapping modifier
    on canManipulate target do
    (
        return (modPanel.getCurrentObject() == target) and ((classOf target) == UVWMap)
    )

    -- Create the manipulator gizmo.
    -- This is called initially and whenver the manipulator target changes
    on updateGizmos do
    (
        -- Clear the current gizmo cache
        this.clearGizmos()

        -- Initialize our transforms
        gizmoTM = uvwManipUtils.gizmoMatrix target 

        local modTM = getModContextTM node target

        -- check to see if modifier is in a valid state
        if (modTM == undefined) then return ""
        modTM = inverse modTM

        gizmoTM = gizmoTM * modTM

        inverseGizmoTM = inverse gizmoTM

        if uvwManipUtils.usesGizmo target then
        (
    
            local p0 = [-1.0, -1.0, 0.0],
                  p1 = [ 1.0, -1.0, 0.0],
                  p2 = [ 1.0,  1.0, 0.0],
                  p3 = [-1.0,  1.0, 0.0]
            
            local giz = manip.makeGizmoShape()
    
            -- Gizmo 0 - width
            giz.AddPoint p1
            giz.AddPoint p2
            giz.transform gizmoTM
            this.addGizmoShape giz 0 greenColor redColor
    
            giz = manip.makeGizmoShape()
    
            -- Gizmo 1 - width
            giz.AddPoint p3
            giz.AddPoint p0
            giz.transform gizmoTM
          
            this.addGizmoShape giz 0 greenColor redColor
    
            return node.name + " UVW Width: " + (target.width as string)
       ) else return ""
    )

   -- Compute the shift to compensate for changing the width
   -- but leaving the other side fixed
   function getShiftVector target shift =
   (
       if target.mapType == 1 or target.mapType == 2 then 
       (
           case target.axis of 
           (
               0: return [0, 0, shift/2]
               1: return [0, shift/2, 0]
               2: return [0, shift/2, 0]
           )
       )
       else
       (
           case target.axis of
           (
               0: return [0, 0,  shift/2]
               1: return [-shift/2, 0, 0]
               2: return [-shift/2, 0, 0]
           )
       )
   )

    on mouseMove m which do
    (
        local l = uvwManipUtils.projectPointToGizmo this m gizmoTM

        -- If the intersection worked, set the width
        if (l[1]) then (
            -- project the point back into gizmo space
            local p = l[2] * inverseGizmoTM
            local oldWidth = target.width
            local newWidth = abs(p.x * target.width)
            local shift = (newWidth - oldWidth) / 2
            newWidth -= shift

            target.width  = newWidth

            -- Now compensate for the change by shifting the
            -- gizmo center to keep the opposite side stationary.
            if p.x < 0 then shift = -shift
            local gizmoTM = target.gizmo.transform
            local shiftVector = getShiftVector target shift
            target.gizmo.transform = preTranslate gizmoTM shiftVector
        )   
    )
)

plugin simpleManipulator uvwMappingLengthManip
    name:"UVW Length Manip"
    invisible:true
(
    -- Create the green and red colors for the gizmo
    local greenColor =  colorMan.getColor #manipulatorsActive
    local redColor =    colorMan.getColor #manipulatorsSelected

    -- Some useful transforms
    local gizmoTM, inverseGizmoTM

    -- This manipualtor manipulates the UVWMapping modifier for planar, cylindircal
    -- spherical or box
    on canManipulate target do
    (
        return (modPanel.getCurrentObject() == target) and ((classOf target) == UVWMap)
    )

    -- Create the manipulator gizmo.
    -- This is called initially and whenver the manipulator target changes
    on updateGizmos do
    (
        -- Clear the current gizmo cache
        this.clearGizmos()

        -- Initialize our transforms
        gizmoTM = uvwManipUtils.gizmoMatrix target 

        local modTM = getModContextTM node target
        -- check to see if modifier is in a valid state
        if (modTM == undefined) then return ""
        modTM = inverse modTM

        gizmoTM = gizmoTM * modTM

        inverseGizmoTM = inverse gizmoTM

        if uvwManipUtils.usesGizmo target then
        (
            local p0 = [-1.0, -1.0, 0.0],
                  p1 = [ 1.0, -1.0, 0.0],
                  p2 = [ 1.0,  1.0, 0.0],
                  p3 = [-1.0,  1.0, 0.0]
            
            local giz = manip.makeGizmoShape()
    
            -- Gizmo 0 - length
            giz.AddPoint p0
            giz.AddPoint p1
            giz.transform gizmoTM
            this.addGizmoShape giz 0 greenColor redColor
    
            giz = manip.makeGizmoShape()
    
            -- Gizmo 1 - length
            giz.AddPoint p2
            giz.AddPoint p3
            giz.transform gizmoTM
            this.addGizmoShape giz 0 greenColor redColor
    
            return node.name + " UVW Length: " + (target.length as string)
       ) else return ""
    )

   -- Compute the shift to compensate for changing the length
   -- but leaving the other side fixed
   function getShiftVector target shift =
   (
       if target.mapType == 1 or target.mapType == 2 then 
       (
           case target.axis of 
           (
               0: return  [-shift/2, 0, 0]
               1: return  [0, 0,  shift/2]
               2: return  [-shift/2, 0, 0]
           )
       )
       else
       (
           case target.axis of
           (
               0: return [0, -shift/2, 0]
               1: return [0, 0,  shift/2]
               2: return [0, -shift/2, 0]
           )
       )
   )

    on mouseMove m which do
    (
        local l = uvwManipUtils.projectPointToGizmo this m gizmoTM

        -- If the intersection worked, set the length
        if (l[1]) then (
            -- project the point back into gizmo space
            local p = l[2] * inverseGizmoTM
            local oldLength = target.length
            local newLength = abs(p.y * target.length)
            local shift = (newLength - oldLength) / 2.0
            newLength -= shift

            target.length  = newLength

            -- Now compensate for the change by shifting the
            -- gizmo center to keep the opposite side stationary.
            if p.y < 0 then shift = -shift
            local gizmoTM = target.gizmo.transform
            local shiftVector = getShiftVector target shift
            target.gizmo.transform = preTranslate gizmoTM shiftVector

        )
    )
)

plugin simpleManipulator uvwMappingHeightManip
    name:"UVW Height Manip"
    invisible:true
(
    -- Create the green and red colors for the gizmo
    local greenColor =  colorMan.getColor #manipulatorsActive
    local redColor =    colorMan.getColor #manipulatorsSelected

    -- Some useful transforms
    local gizmoTM, inverseGizmoTM

    -- This manipualtor manipulates the UVWMapping modifier for planar, cylindircal
    -- spherical or box
    on canManipulate target do
    (
        return (modPanel.getCurrentObject() == target) and ((classOf target) == UVWMap)
    )

    -- Create the manipulator gizmo.
    -- This is called initially and whenver the manipulator target changes
    on updateGizmos do
    (
        -- Clear the current gizmo cache
        this.clearGizmos()

        -- Initialize our transforms
        gizmoTM = uvwManipUtils.gizmoMatrix target 

        local modTM = getModContextTM node target
        -- check to see if modifier is in a valid state
        if (modTM == undefined) then 
            return ""

        modTM = inverse modTM

        gizmoTM = gizmoTM * modTM

        inverseGizmoTM = inverse gizmoTM

        -- Height isn't used for planar mapping
        if uvwManipUtils.usesGizmo target and target.mapType != 0 then
        (
            local p0 = [0, 0, 0],
                  p1 = [0, 0, 1]

            if (target.mapType == 1) then p1.z = 0.5

            local giz = manip.makeGizmoShape()
    
            -- Gizmo 0 - length
            giz.AddPoint p0
            giz.AddPoint p1
            giz.transform gizmoTM
            this.addGizmoShape giz gizmoDontHitTest greenColor greenColor

            local bboxMin = getModContextBBoxMin node target
            local bboxMax = getModContextBBoxMax node target
            local size = (length (bboxMax - bboxMin)) / 25
            giz = uvwManipUtils.makeCubeGizmo (p1 * gizmoTM) size
            this.addGizmoShape giz 0 greenColor redColor
    
            return node.name + " UVW Height: " + (target.height as string)
       ) else return ""
    )

    -- Project the given screen coordinate to the height gizmo plane
    -- return 2 values: a flag saying whether the pjection worked,
    -- and the projected point
    
    function makeXYGizmoAxis gizmoTM = 
    (
        local p0 = [-1.0, -1.0, 0.0] * gizmoTM,
              p1 = [ 1.0, -1.0, 0.0] * gizmoTM,
              p2 = [ 1.0,  1.0, 0.0] * gizmoTM
        local d1 = p2 - p1
        local d2 = p2 - p0
        return cross d1 d2
    )

    function makeXZGizmoAxis gizmoTM = 
    (
        local p0 = [-1.0, 0.0, -1.0] * gizmoTM,
              p1 = [ 1.0, 0.0, -1.0] * gizmoTM,
              p2 = [ 1.0, 0.0,  1.0] * gizmoTM
        local d1 = p2 - p1
        local d2 = p2 - p0
        return cross d1 d2
    )

    function makeYZGizmoAxis gizmoTM = 
    (
        local p0 = [0.0, -1.0, -1.0] * gizmoTM,
              p1 = [0.0, -1.0,  1.0] * gizmoTM,
              p2 = [0.0,  1.0,  1.0] * gizmoTM
        local d1 = p2 - p1
        local d2 = p2 - p0
        return cross d1 d2
    )

    function projectPointToHeightGizmo this m UVWMod gizmoTM =
    (
        local axis1, axis2
    
        -- create the two planes we can project on to
        
        case UVWMod.axis of
        (
             0: (axis1 = makeXZGizmoAxis(gizmoTM); axis2 = makeYZGizmoAxis(gizmoTM))
             1: (axis1 = makeYZGizmoAxis(gizmoTM); axis2 = makeXZGizmoAxis(gizmoTM))
             2: (axis1 = makeYZGizmoAxis(gizmoTM); axis2 = makeXZGizmoAxis(gizmoTM))
        )
        
        local plane1 = manip.makePlaneFromNormal  axis1 ([0, 0, 0] * gizmoTM)
        local plane2 = manip.makePlaneFromNormal  axis2 ([0, 0, 0] * gizmoTM)
        local projectedPoint = [0,0,0]
    
        -- Compute the hit-ray in local coordinates
        local viewRay = this.getLocalViewRay m
    
        -- Figure out which plane is most "square" to the view ray
        local pl = plane1.mostOrthogonal viewRay plane2
    
        -- Intersect the plane with the view ray
        local res = pl.intersect viewRay &projectedPoint
    
        return #(res, projectedPoint)
    )
    
    on mouseMove m which do
    (
        local l = projectPointToHeightGizmo this m target gizmoTM 

        -- If the intersection worked, set the height
        if (l[1]) then (
            -- project the point back into gizmo space
            local p = l[2] * inverseGizmoTM
            if (target.mapType == 1) then 
                target.height  = abs(p.z * target.height) * 2
            else
                target.height  = abs(p.z * target.height) 
        )
    )
)
