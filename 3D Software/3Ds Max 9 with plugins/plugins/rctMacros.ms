-------------------------------------------------------
---- 3dsmax4: 
---- 3dsmax5: place this in the plugins directory
-------------------------------------------------------

--------------------------------------------------------------------------
-- HavokUtilityFunctions MaxScript
-- Implements the functionality of the Havok Floating Toolbar and
-- the Quad Menus for mxe version 1.6.0.1
-- Havok 2003
--------------------------------------------------------------------------

-- Somehow rctUtilityFunction.ms needs to be loaded twice to fully work
fileIn "rctUtilityFunctions.ms"
fileIn "rctUtilityFunctions.ms"
 
fn rctCreateMultiBodyConstraints constraintType disableCollisions:true =
(
	local filteredBodies = rct_filterOnlyRigidBodies ($selection as array)
	
	constraintList = #()
	
	if (filteredBodies.count > 1) then
	(
		-- first try to use the links
		constraintList = rct_constrainLinkedObjects filteredBodies constraintType disableCollisions

		-- if that didn't succeed, use spatial relationships		
		if (constraintList.count == 0) then
		(
			local sortedBodies = rct_sortAlongPrincipalAxis filteredBodies
			for i = 1 to (sortedBodies.count-1) do	
			(
				constraint = constraintType()
				constraint.parentBody = sortedBodies[i]
				constraint.childBody = sortedBodies[i+1]
				constraint.hasParent = true
				append constraintList constraint
				if (disableCollisions) then
				(
					reactor.disableCollisions sortedBodies[i] sortedBodies[i+1]
				)
			)
		)
	)
	else
	(
		StartObjectCreation constraintType
	)
	
	select constraintList
	
	return constraintList
)
				
				


-------------------------------------------------
-- all these functions are interface functions --
-- (i.e. called directly by the Macroscript)   --
-------------------------------------------------

fn rctMakeRagdollConstraints =
(
	rctCreateMultiBodyConstraints rctRagdoll
)

fn rctMakeLinearDashpots =
(
	rctCreateMultiBodyConstraints rctLinearDashpot
)

fn rctMakeAngularDashpots =
(
	rctCreateMultiBodyConstraints rctAngularDashpot disableCollisions:false
)

fn rctMakeMotorConstraints =
(
	------------------------------------------------------------
	---- If more than two bodies are selected then apply a motor
	---- to each body
	------------------------------------------------------------
	
 	if (selection.count > 1) then
 	(
 		local sorted_RBs = rct_sortSelectionAlongPrincipleAxis()
 		
 		bAreAnyGeoms = false
		for i = 1 to (sorted_RBs.count) do	
		(
			bAreAnyGeoms = true
			m = rctMotor()
			m.rigidBody = sorted_RBs[i]
					
		)
		if (bAreAnyGeoms == false) then
		(
			StartObjectCreation rctMotor
		)
	)
	else if (selection.count == 1) then
 	(
 		if (rct_isRigidBody selection[1]) then
		(
			h = rctMotor()
			h.rigidBody  = selection[1]
		)
		else
		(
			StartObjectCreation rctMotor
		)
 	)
	else
	(
		StartObjectCreation rctMotor
	)
)

fn rctMakePointToPointConstraints =
(
	rctCreateMultiBodyConstraints rctPointToPoint
)

---------------------------------------------- 
---- rctMakeCarWheelConstraints
---- USE: 
---- User selects a number of geometries (>0)
---- User clicks carwheel icon
---- User is prompted to select the chassis
----------------------------------------------

fn rctMakeCarwheelConstraints =
(
	rctCreateMultiBodyConstraints rctCarWheel
)

fn rctMakePrismaticConstraints =
(
	rctCreateMultiBodyConstraints rctPrismatic

)

fn rctMakeHingeConstraints =
(
	rctCreateMultiBodyConstraints rctHinge
)

fn rctMakeSprings =
(
	rctCreateMultiBodyConstraints rctSpring disableCollisions:false
)

fn rctMakeRBCollection = 
(
	local sel = ($selection as array)
	col = rctRBCollection()
	
	for s in sel do
	(
		col.addRigidBody s
	)
	
	if (col.getNumRigidBodies()==0) then
	(
		delete col
		startObjectCreation rctRBCollection
	)
	else
	(
		col.pos = rct_averagePositions col.rigidBodies
		select col
		max modify mode
	)
)

fn rctMakeCLCollection = 
(
	local sel = ($selection as array)
	col = rctCLCollection()
	
	for s in sel do
	(
		col.addCloth s
	)
	
	if (col.getNumCloths()==0) then
	(
		delete col
		startObjectCreation rctCLCollection
	)
	else
	(
		col.pos = rct_averagePositions col.cloths
		select col
		max modify mode
	)
)

fn rctMakeSBCollection = 
(
	local sel = ($selection as array)
	col = rctSBCollection()
	
	for s in sel do
	(
		col.addSoftBody s
	)
	
	if (col.getNumSoftBodies()==0) then
	(
		delete col
		startObjectCreation rctSBCollection
	)
	else
	(
		col.pos = rct_averagePositions col.softBodies
		select col
		max modify mode
	)
)

fn rctMakeRPCollection = 
(
	local sel = ($selection as array)
	col = rctRPCollection()
	
	for s in sel do
	(
		col.addRope s
	)
	
	if (col.getNumRopes()==0) then
	(
		delete col
		startObjectCreation rctRPCollection
	)
	else
	(
		col.pos = rct_averagePositions col.ropes
		select col
		max modify mode
	)
)

fn rctMakeDMCollection = 
(
	local sel = ($selection as array)
	col = rctDMCollection()
	
	for s in sel do
	(
		col.addDefMesh s
	)
	
	if (col.getNumDefMeshes()==0) then
	(
		delete col
		startObjectCreation rctDMCollection
	)
	else
	(
		col.pos = rct_averagePositions col.defMeshes
		select col
		max modify mode
	)
)

fn rctMakeFracture = 
(
	local sel = ($selection as array)
	col = rctFracture()
	
	for s in sel do
	(
		col.addPiece s
	)
	
	if (col.getNumPieces()==0) then
	(
		delete col
		startObjectCreation rctFracture
	)
	else
	(
		col.pos = rct_averagePositions col.pieces
		select col
		max modify mode
	)
)

fn rctMakeConstraintSolver =
(
	local sel = ($selection as array)
	col = rctConstraintSolver()
	
	for s in sel do
	(
		col.addConstraint s
	)
	
	if (col.getNumConstraints()==0) then
	(
		delete col
		startObjectCreation rctConstraintSolver
	)
	else
	(
		col.pos = rct_averagePositions col.constraints
		select col
		max modify mode
	)
)


fn rctApplyModifierToSelection modifier =
( 
	local sel = ($selection as array)
	for s in sel do
	(
		themod = modifier()
		addModifier s themod
	)
	if (sel.count>0) then
	(
		select sel[1]
	)
	max modify mode
)

