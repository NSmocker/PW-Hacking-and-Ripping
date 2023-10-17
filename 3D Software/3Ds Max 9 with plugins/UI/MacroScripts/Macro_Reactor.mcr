-- reactor Macro Scripts File
-- Created:  28 April 2003
-- Author:   Paco Vidal
-- Macro Scripts for reactor Commands
-- ***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK


-- CREATE COLLECTIONS

macroScript rctCreateRBCollection 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Rigid Body Collection" 
            buttontext:"Rigid Body Collection" 
            Icon:#("reactor",1)
(
   on execute do rctMakeRBCollection()
   on isChecked return (mcrUtils.IsCreating rctRBCollection)
)

macroScript rctCreateCLCollection 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Cloth Collection" 
            buttontext:"Cloth Collection" 
            Icon:#("reactor",2)
(
   on execute do rctMakeCLCollection()
   on isChecked return (mcrUtils.IsCreating rctCLCollection)
)

macroScript rctCreateSBCollection 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Soft Body Collection" 
            buttontext:"Soft Body Collection" 
            Icon:#("reactor",3)
(
   on execute do rctMakeSBCollection()
   on isChecked return (mcrUtils.IsCreating rctSBCollection)
)

macroScript rctCreateRPCollection 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Rope Collection" 
            buttontext:"Rope Collection" 
            Icon:#("reactor",4)
(
   on execute do rctMakeRPCollection()
   on isChecked return (mcrUtils.IsCreating rctRPCollection)
)

macroScript rctCreateDMCollection 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Deforming Mesh Collection" 
            buttontext:"Deforming Mesh Collection" 
            Icon:#("reactor",5)
(
   on execute do rctMakeDMCollection()
   on isChecked return (mcrUtils.IsCreating rctDMCollection)
)

-- CREATE HELPERS

macroScript rctCreatePlane 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Plane" 
            buttontext:"Plane" 
            Icon:#("reactor",6)
(
   on execute do StartObjectCreation rctPlane
   on isChecked return (mcrUtils.IsCreating rctPlane)
)

macroScript rctCreateSpring 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Spring" 
            buttontext:"Spring" 
            Icon:#("reactor",7)
(
   on execute do rctMakeSprings() 
   on isChecked return (mcrUtils.IsCreating rctSpring)
)

macroScript rctCreateLinearDashpot 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Linear Dashpot" 
            buttontext:"Linear Dashpot" 
            Icon:#("reactor",8)
(
   on execute do rctMakeLinearDashpots() 
   on isChecked return (mcrUtils.IsCreating rctLinearDashpot)
)

macroScript rctCreateAngularDashpot 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Angular Dashpot" 
            buttontext:"Angular Dashpot" 
            Icon:#("reactor",9)
(
   on execute do rctMakeAngularDashpots()
   on isChecked return (mcrUtils.IsCreating rctAngularDashpot)
)

macroScript rctCreateMotor 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Motor" 
            buttontext:"Motor" 
            Icon:#("reactor",10)
(
   on execute do rctMakeMotorConstraints()
   on isChecked return (mcrUtils.IsCreating rctMotor)
)

macroScript rctCreateWind 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Wind" 
            buttontext:"Wind" 
            Icon:#("reactor",11)
(
   on execute do StartObjectCreation rctWind
   on isChecked return (mcrUtils.IsCreating rctWind)
)

macroScript rctCreateToyCar 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Toy Car" 
            buttontext:"Toy Car" 
            Icon:#("reactor",12)
(
   on execute do StartObjectCreation rctToyCar
   on isChecked return (mcrUtils.IsCreating rctToyCar)
)

macroScript rctCreateFracture 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Fracture" 
            buttontext:"Fracture" 
            Icon:#("reactor",13)
(
   on execute do rctMakeFracture()
   on isChecked return (mcrUtils.IsCreating rctFracture)
)

macroScript rctCreateWater 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Water" 
            buttontext:"Water" 
            Icon:#("reactor",14)
(
   on execute do StartObjectCreation rctWaterWSMObject
   on isChecked return (mcrUtils.IsCreating rctWaterWSMObject)
)

-- CREATE CONSTRAINTS AND SOLVER

macroScript rctCreateConstraintSolver 
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Constraint Solver" 
            buttontext:"Constraint Solver" 
            Icon:#("reactor",15)
(
   on execute do rctMakeConstraintSolver()
   on isChecked return (mcrUtils.IsCreating rctConstraintSolver)
)

macroScript rctCreateRagdoll
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Rag Doll Constraint" 
            buttontext:"Rag Doll Constraint" 
            Icon:#("reactor",16)
(
   on execute do rctMakeRagdollConstraints()
   on isChecked return (mcrUtils.IsCreating rctRagdoll)
)

macroScript rctCreateHinge
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Hinge Constraint" 
            buttontext:"Hinge Constraint" 
            Icon:#("reactor",17)
(
   on execute do rctMakeHingeConstraints()
   on isChecked return (mcrUtils.IsCreating rctHinge)
)

macroScript rctCreatePointPoint
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Point-Point Constraint" 
            buttontext:"Point-Point Constraint" 
            Icon:#("reactor",18)
(
   on execute do rctMakePointToPointconstraints()
   on isChecked return (mcrUtils.IsCreating rctPointToPoint)
)

macroScript rctCreatePrismatic
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Prismatic Constraint" 
            buttontext:"Prismatic Constraint" 
            Icon:#("reactor",19)
(
   on execute do rctMakePrismaticConstraints()
   on isChecked return (mcrUtils.IsCreating rctPrismatic)
)

macroScript rctCreateCarWheel
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Car-Wheel Constraint" 
            buttontext:"Car-Wheel Constraint" 
            Icon:#("reactor",20)
(
   on execute do rctMakeCarWheelConstraints()
   on isChecked return (mcrUtils.IsCreating rctCarwheel)
)

macroScript rctCreatePointPath
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Point-Path Constraint" 
            buttontext:"Point-Path Constraint" 
            Icon:#("reactor",21)
(
   on execute do StartObjectCreation rctPointToPath
   on isChecked return (mcrUtils.IsCreating rctPointToPath)
)

-- APPLY MODIFIER 

macroScript rctApplyClothModifier
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Apply Cloth Modifier" 
            buttontext:"Cloth Modifier" 
            Icon:#("reactor",22)
(
   on execute do (rctApplyModifierToSelection rctClothModifier)
   on isEnabled return mcrUtils.ValidMod rctClothModifier
)

macroScript rctApplySoftBodyModifier
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Apply Soft Body Modifier" 
            buttontext:"Soft Body Modifier" 
            Icon:#("reactor",23)
(
   on execute do (rctApplyModifierToSelection rctSoftBodyModifier)
   on isEnabled return mcrUtils.ValidMod rctSoftBodyModifier
)

macroScript rctApplyRopeModifier
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Apply Rope Modifier" 
            buttontext:"Rope Modifier" 
            Icon:#("reactor",24)
(
   on execute do (rctApplyModifierToSelection rctRopeModifier)
   on isEnabled return mcrUtils.ValidMod rctRopeModifier
)

-- OPEN PROPERTY EDITOR

macroScript rctOpenPropertyEditor
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Open Property Editor..." 
            buttontext:"Open Property Editor..." 
            Icon:#("reactor",25)
(
   on execute do (rctMakeRBPropertiesUI())
   on isEnabled return TRUE
)

-- UTILITIES

macroScript rctAnalyzeWorld
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Analyze World..." 
            buttontext:"Analyze World..." 
            Icon:#("reactor",26)
(
   on execute do (reactor.analyzeWorld())
   on isEnabled return TRUE
)

macroScript rctConvexityTest
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Convexity Test" 
            buttontext:"Convexity Test" 
            Icon:#("reactor",27)
(
   on execute do (reactor.testSelectedConvexity())
   on isEnabled return (selection.count == 1)
)

macroScript rctViewStoredCollisions
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"View Stored Collisions..." 
            buttontext:"View Stored Collisions..." 
            Icon:#("reactor",28)
(
   on execute do (reactor.viewStoredCollisions())
   on isEnabled return TRUE
)

macroScript rctReduceKeysSelection
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Reduce Keys (Selection)" 
            buttontext:"Reduce Keys (Selection)" 
            Icon:#("reactor",29)
(
   on execute do (reactor.reduceKeysForSelectedObjects())
   on isEnabled return (selection.count > 0)
 )

macroScript rctReduceKeysAll
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Reduce Keys (All)" 
            buttontext:"Reduce Keys (All)" 
            Icon:#("reactor",30)
(
   on execute do (reactor.reduceKeysForAllObjects())
   on isEnabled return TRUE
)

macroScript rctDeleteKeysSelection
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Delete Keys (Selection)" 
            buttontext:"Delete Keys (Selection)" 
            Icon:#("reactor",31)
(
   on execute do (reactor.deleteKeysForSelectedObjects())
   on isEnabled return (selection.count > 0)
)

macroScript rctDeleteKeysAll
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Delete Keys (All)" 
            buttontext:"Delete Keys (All)" 
            Icon:#("reactor",32)
(
   on execute do (reactor.deleteKeysForAllObjects())
   on isEnabled return TRUE
)


-- PREVIEW, CREATE AND ABOUT

macroScript rctPreviewAnimation
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Preview Animation..." 
            buttontext:"Preview Animation..." 
            Icon:#("reactor",33)
(
   on execute do (reactor.previewAnimation())
   on isEnabled return TRUE
)

macroScript rctCreateAnimation
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"Create Animation" 
            buttontext:"Create Animation" 
            Icon:#("reactor",34)
(
   on execute do (reactor.createAnimation(FALSE	))
   on isEnabled return TRUE
)

macroScript rctAbout
enabledIn:#("max") --IB: 2004.9.23 added product switch
            category:"reactor" 
            internalcategory:"reactor" 
            tooltip:"About reactor..." 
            buttontext:"About reactor..." 
            Icon:#("reactor",35)
(
   on execute do (reactor.showAbout())
   on isEnabled return TRUE
)
