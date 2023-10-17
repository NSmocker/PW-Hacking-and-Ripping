-- Generic radius manipulator
-- Written by Scott Morrison

-- This manipulator sets the radius on any object or modifier with
-- a parameter named "radius".  It creates a circle gizmo of the appropriate
-- radius centered at the origin in the XY plane.

plugin simpleManipulator radiusManip
    name:"RadiusManip"
    invisible:true
(
    -- Create the green and red colors for the gizmo
    local greenColor =  colorMan.getColor #manipulatorsActive
    local redColor =    colorMan.getColor #manipulatorsSelected
	local offsetLength = 0.0  -- AF (3/23/01) Used for mouse tracking

    -- This manipulator manipulates any node with a "radius" property
    on canManipulate target return (findItem (getPropNames target) #radius) != 0

    -- Create the manipulator gizmo.
    -- This is called initially and whenever the manipulator target changes
    on updateGizmos do
    (
        -- Clear the current gizmo cache
        this.clearGizmos()
        
        -- Set the radius of circle gizmo a little bigger than the target radius
        giz = manip.makeCircle [0,0,0] (target.radius * 1.01) 28

        -- Add the circle to the manipulator
        this.addGizmoShape giz 0 greenColor redColor  

        -- return the ToolTip string
        return node.name + " radius = " + target.radius as string 
    )

    -- mouseMove is called on every mouse move when dragging the manip
    -- It needs to convert the mouse position 'm' into a new value for the radius
    on mouseMove m which do
    (
        -- Create the XY plane.   
        -- manip.makePlaneFromNormal takes a normal vector and a point
        -- and creates a plane passing through the point with the given normal
        local pl = manip.makePlaneFromNormal z_axis [0, 0, 0],
        projectedPoint = [0,0,0]
		
        -- Compute the hit-ray in local coordinates
        viewRay = this.getLocalViewRay m

        -- Intersect the plane with the view ray
        res = pl.intersect viewRay &projectedPoint
    
        -- If the intersection worked, set the radius
        if (res) then
		(
			target.radius = (length projectedPoint) / 1.01
			offsetLength = 0.0
			return true
		)
		-- AF (3/23/01) Plan B : the point wasn't on the plane because the plane 
		-- was parallel to view or close to it.  Use the plane perpendicular to the view instead
		pl = manip.makePlaneFromNormal viewRay.dir [0, 0, 0]
		projectedPoint = [0,0,0]
		res = pl.intersect viewRay &projectedPoint
		if (res) then 
		(  
			 -- (length projectedPoint) is equal to distance traveled
			 -- radius = distance traveled + the offset from the original mouse down point    
			if offsetLength == 0.0 then 
				offsetLength = target.radius - (length projectedPoint)
			target.radius = ((length projectedPoint) + offsetLength) / 1.01
		)
    )
	
	on MouseDown m which do
	(
		offsetLength = 0.0
	)
)
