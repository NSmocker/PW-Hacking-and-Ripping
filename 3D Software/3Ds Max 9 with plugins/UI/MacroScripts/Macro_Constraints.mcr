/*
Constraints assignment MacroScript File
Constraint tools
This script increases workflow on assigning constraints by adding a controller automatically.

-- Aug 15 added prompting
-- Aug 20 added LinkConstraint
-- Nov 6  added "H" key support ForceListenerFocus
-- Dec 14 Added Biped Support  
-- Dec 18 Fixed LookAt, Orientation and Noise Rotation constraints - passing wrong channel to AddConstraint
-- Jan 4  Added support for HI IK and HD IK objects; Added group support
-- Feb 16 04 Attachment filter fnc detects attaching controller to self
-- Feb 18 04 Added check for return value of constraint.AppendTarget
-- Feb 23 04 Updated pick filter of constraints to use DependencyLoopTest 


Author :   Frank DeLise
Version:  3ds max 6

Revision History:

	11 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macroscript file can be shared with all Discreet products


***********************************************************************************************
 MODIFY THIS AT YOUR OWN RISK

*/
MacroScript Path
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Path Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Path Constraint" 
	SilentErrors:(Debug != false)

(
	Global EC_OBJ, EC_TargetOBJ = "None"
	
	-- Check to see if something is selected
		
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)
	 
	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Define Filter Function for PickObject Selection
			-------------------------------------------------------------------------------------------
			
			fn ShapeFilt o = superClassOf o == Shape and (refs.DependencyLoopTest o EC_OBJ.controller) == false
			
			-------------------------------------------------------------------------------------------
					
			--Format "%\n" ("Pick Shape to Constrain " + EC_OBJ.name + " to:") to:Listener
			
			EC_TargetOBJ = PickObject count:1 select:true filter:ShapeFilt message:"Pick Shape to Constrain to.." Rubberband:EC_OBJ.transform.pos ForceListenerFocus:False

			If EC_TargetOBJ != undefined and EC_TargetOBJ != "None" then
			(
				-------------------------------------------------------------------------------------------
				-- Add List Controller
				-------------------------------------------------------------------------------------------
				
				local cont = AddListController EC_OBJ "Pos" Position_List
				
				-------------------------------------------------------------------------------------------
				-- Add Constraint
				-------------------------------------------------------------------------------------------
				If classof cont[listCtrl.GetActive cont].object != Path then constraint = AddConstraint EC_OBJ "Pos" Path true
				else constraint = cont[listCtrl.GetActive cont].object
		
				-------------------------------------------------------------------------------------------
				-- Add Position Constraint Objects
				-------------------------------------------------------------------------------------------
						
				If ((constraint.AppendTarget EC_TargetOBJ 50) == true) then
				(
				-------------------------------------------------------------------------------------------
				-- Set Active Controller
				-------------------------------------------------------------------------------------------
						
				SetActiveController cont constraint
							
				--Format "%\n"  (EC_OBJ.name + " is Path Constrained to " + EC_TargetOBJ.name) to:Listener
				
				-------------------------------------------------------------------------------------------			
				Select EC_OBJ
			)	
				else throw 0
			)	
		)
		Catch (MessageBox "Path Constraint Not Completed" Title:"Constraints")
	)    
)


MacroScript LinkConstraint
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Link Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Link Constraint" 
	SilentErrors:(Debug != True)
	
	(
	Global EC_OBJ, EC_TargetOBJ = "None"

		
	-- Check to see if something is selected
		
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)
	 
	on execute do 
	(
		Try 
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Define Filter Function for PickObject Selection
			-------------------------------------------------------------------------------------------
			
			fn SameFilt o = (refs.DependencyLoopTest o EC_OBJ.controller) == false
			-------------------------------------------------------------------------------------------
			
			--Format "%\n" ("Pick Object to Link " + EC_OBJ.name + " to:") to:Listener
			
			-------------------------------------------------------------------------------------------
			-- Pick Target Object
			-------------------------------------------------------------------------------------------
					
			EC_TargetOBJ = PickObject count:1 select:true Filter:SameFilt message:"Pick Object to Link to.." Rubberband:EC_OBJ.transform.pos ForceListenerFocus:False

			If EC_TargetOBJ != undefined and EC_TargetOBJ != "None" then
			(
				---------------------------------------------------------------------------------------
				-- Add Constraint 
				-- If it's not a link constraint already, check for IK object and IK goal object
				---------------------------------------------------------------------------------------	
				local constraint
				if Classof EC_OBJ.controller == IKControl then (constraint = EC_OBJ.Transform.controller.fk_sub_control.controller)
					else if Classof EC_OBJ.controller == IKChainControl then (constraint = EC_OBJ.Transform.controller.ik_goal.controller)	
						else (constraint = EC_OBJ.Transform.controller)
				If Classof constraint != Link_Constraint do 
				(
					constraint = Link_Constraint ()
					if Classof EC_OBJ.controller == IKControl then (EC_OBJ.Transform.controller.fk_sub_control.controller = constraint)
						else if Classof EC_OBJ.controller == IKChainControl then (EC_OBJ.Transform.controller.ik_goal.controller = constraint)	
							else (EC_OBJ.Transform.controller = constraint)
				)
				
				---------------------------------------------------------------------------------------
				-- Add Links to Link Constraint
				---------------------------------------------------------------------------------------
				local res = true;
				if Classof EC_OBJ.controller == IKControl then res = EC_OBJ.controller.fk_sub_control.controller.AddTarget EC_TargetOBJ SliderTime
					else if Classof EC_OBJ.controller == IKChainControl then res = EC_OBJ.controller.ik_goal.controller.AddTarget EC_TargetOBJ SliderTime	
						else  res = EC_OBJ.Transform.controller.AddTarget EC_TargetOBJ SliderTime
						
				if (res == true) then Select EC_OBJ		
				else throw 0
			)
		)	
		Catch (MessageBox "Link Constraint Not Completed" Title:"Constraints")
	)
)


MacroScript Position_Constraint
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Position Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Position Constraint" 
	SilentErrors:(Debug != True)

(
	Global EC_OBJ, EC_TargetOBJ = "None" 
		
	-- Check to see if something is selected
		
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)
	 
	on execute do 
	(
		Try 
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Define Filter Function for PickObject Selection
			-------------------------------------------------------------------------------------------
			
			fn SameFilt o = (refs.DependencyLoopTest o EC_OBJ.controller) == false
			
			-------------------------------------------------------------------------------------------
			
			--Format "%\n" ("Pick Object to Constrain " + EC_OBJ.name + " to:") to:Listener
			
			-------------------------------------------------------------------------------------------
			-- Pick Target Object
			-------------------------------------------------------------------------------------------
		
			EC_TargetOBJ = PickObject count:1 select:true Filter:SameFilt message:"Pick Object to Constraint to..." Rubberband:EC_OBJ.transform.pos ForceListenerFocus:False
		
			If EC_TargetOBJ != undefined and EC_TargetOBJ != "None" then
			(
				-------------------------------------------------------------------------------------------
				-- Add List Controller
				-------------------------------------------------------------------------------------------
				
				local cont = AddListController EC_OBJ "Pos" Position_List
				-- print cont

				-------------------------------------------------------------------------------------------
				-- Add Constraint
				---------------------------------------------------------------------------------------
				If classof cont[listCtrl.GetActive cont].object != Position_Constraint then constraint = AddConstraint EC_OBJ "Pos" Position_Constraint true
				else constraint = cont[listCtrl.GetActive cont].object
				-------------------------------------------------------------------------------------------
				-- Add Position Constraint Objects
				-------------------------------------------------------------------------------------------
				If ((constraint.AppendTarget EC_TargetOBJ 50) == true) then
				(
				-------------------------------------------------------------------------------------------
				-- Set Active Controller
				-------------------------------------------------------------------------------------------
						
				SetActiveController cont constraint
							
				--Format "%\n"  (EC_OBJ.name + " is Constrained to " + EC_TargetOBJ.name) to:Listener
			
				-------------------------------------------------------------------------------------------
				Select EC_OBJ		
			)	
				else throw 0
			)	
		)
		Catch messagebox "Position Constraint Not Completed!"
	)
)


MacroScript Orientation_Constraint
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Orientation Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Orientation Constraint" 
	SilentErrors:(Debug != True)


(
	Local ConstraintCompleted = False
	Global EC_OBJ, EC_TargetOBJ = "None"
	
	-- Check to see if something is selected
		
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[2].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)
	 
	on execute do 
	(
		Try 
		(
	
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Define Filter Function for PickObject Selection
			-------------------------------------------------------------------------------------------
			
			fn SameFilt o = (refs.DependencyLoopTest o EC_OBJ.controller) == false
			
			-------------------------------------------------------------------------------------------
			
			--Format "%\n" ("Pick Object to Constrain " + EC_OBJ.name + " to:") to:Listener
			
			EC_TargetOBJ = PickObject count:1 select:true filter:SameFilt message:"Pick Object to Constrain to..." Rubberband:EC_OBJ.transform.pos ForceListenerFocus:False

			If EC_TargetOBJ != undefined and EC_TargetOBJ != "None" then
			(
				-------------------------------------------------------------------------------------------
				-- Add List Controller
				-------------------------------------------------------------------------------------------
				
				local cont = AddListController EC_OBJ "Rotation" Rotation_List
				
				-------------------------------------------------------------------------------------------
				-- Add Constraint
				---------------------------------------------------------------------------------------
				If classof cont[listCtrl.GetActive cont].object != Orientation_Constraint then constraint = AddConstraint EC_OBJ "Rotation" Orientation_Constraint true
					else constraint = cont[listCtrl.GetActive cont].object

				-------------------------------------------------------------------------------------------
				-- Add Position Constraint Objects
				-------------------------------------------------------------------------------------------
						
				If ((constraint.AppendTarget EC_TargetOBJ 50) == true) then
				(
				-------------------------------------------------------------------------------------------
				-- Set Active Controller
				-------------------------------------------------------------------------------------------
						
				SetActiveController cont constraint
		
				--Format "%\n"  (EC_OBJ.name + " is Constrained to " + EC_TargetOBJ.name) to:Listener
				
				-------------------------------------------------------------------------------------------
				Select EC_OBJ
			)	
				else throw 0
			)	
		)
		Catch (MessageBox "Orientation Constraint Not Completed" Title:"Constraints")
	)
)


MacroScript LookAt
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"LookAt Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"LookAt Constraint"
	SilentErrors:(Debug != True) 


(
	Local ConstraintCompleted = False
	Global EC_OBJ, EC_TargetOBJ = "None"
	
	-- Check to see if something is selected
		
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[2].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)
	 
	on execute do 
	(
		Try 
		(
	
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Define Filter Function for PickObject Selection
			-------------------------------------------------------------------------------------------
			
			fn SameFilt o = (refs.DependencyLoopTest o EC_OBJ.controller) == false
			
			-------------------------------------------------------------------------------------------
			
			-- Format "%\n" ("Pick Object to Constrain " + EC_OBJ.name + " to:") to:Listener
	
			-------------------------------------------------------------------------------------------
			-- Pick Target Object
			-------------------------------------------------------------------------------------------
			
			EC_TargetOBJ = PickObject count:1 select:true filter:SameFilt Message:"Pick Object to Look At.." Rubberband:EC_OBJ.transform.pos ForceListenerFocus:False
		
			If EC_TargetOBJ != undefined and EC_TargetOBJ != "None" then
			(
				-------------------------------------------------------------------------------------------
				-- Add List Controller
				-------------------------------------------------------------------------------------------
				
				local cont = AddListController EC_OBJ "Rotation" Rotation_List
				
				-------------------------------------------------------------------------------------------
				-- Add Constraint
				---------------------------------------------------------------------------------------
				
				If classof cont[listCtrl.GetActive cont].object != LookAt_Constraint then constraint = AddConstraint EC_OBJ "Rotation" LookAt_Constraint true
					else constraint = cont[listCtrl.GetActive cont].object
				-------------------------------------------------------------------------------------------
				-- Add Look At Constraint Objects
				-------------------------------------------------------------------------------------------
						
				If ((constraint.AppendTarget EC_TargetOBJ 50) == true) then
				(
				-------------------------------------------------------------------------------------------
				-- Set Active Controller
				-------------------------------------------------------------------------------------------
						
				SetActiveController cont constraint
		
				-- Format "%\n"  (EC_OBJ.name + " is Constrained to " + EC_TargetOBJ.name) to:Listener
				
				-------------------------------------------------------------------------------------------
				Select EC_OBJ
			)
				else throw 0
			)
		)
		Catch (MessageBox "LookAt Constraint Not Completed" Title:"Constraints")
	)
)


MacroScript Attachment
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Attachment Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Attachment Constraint"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"
	
	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Define Filter Function for PickObject Selection
			-------------------------------------------------------------------------------------------
			
			fn GeomFilt o = superClassOf o == GeometryClass and (refs.DependencyLoopTest o EC_OBJ.controller) == false
			
			-------------------------------------------------------------------------------------------
					
			--Format "%\n" ("Pick Object to Attach " + EC_OBJ.name + " to:") to:Listener
			
			EC_TargetOBJ = PickObject count:1 select:true filter:GeomFilt message:"Pick Object to Attach to.." Rubberband:EC_OBJ.transform.pos ForceListenerFocus:False
		
			If EC_TargetOBJ != undefined and EC_TargetOBJ != "None" then
			(
		
				-------------------------------------------------------------------------------------------
				-- Add List Controller
				-------------------------------------------------------------------------------------------
				
				local cont = AddListController EC_OBJ "Pos" Position_List
				
				-------------------------------------------------------------------------------------------
				-- Add Constraint
				-------------------------------------------------------------------------------------------
				If classof cont[listCtrl.GetActive cont].object != Attachment then constraint = AddConstraint EC_OBJ "Pos" Attachment true
					else constraint = cont[listCtrl.GetActive cont].object

				-------------------------------------------------------------------------------------------
				-- Set Node Attached To, initial key
				-------------------------------------------------------------------------------------------
						
				constraint.Node = EC_TargetOBJ
				local key = AttachCtrl.addnewkey constraint 0
				key.face=1
		
				-------------------------------------------------------------------------------------------
				-- Set Active Controller
				-------------------------------------------------------------------------------------------
						
				SetActiveController cont constraint
														
				--Format "%\n"  (EC_OBJ.name + " is Attached to " + EC_TargetOBJ.name) to:Listener
				
				-------------------------------------------------------------------------------------------
						
				Select EC_OBJ
				
			)
		)
		Catch (MessageBox "Attachment Constraint Not Completed" Title:"Constraints")
	)
)


MacroScript Surface
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Surface Constraint"
	Category:"Constraints" 
	internalCategory:"Constraints" 
	Tooltip:"Surface Constraint"
	SilentErrors:(Debug != True) 


(
	Local ConstraintCompleted = False
	Global EC_OBJ, EC_TargetOBJ = "None"
	
	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Undo on
		(
			Try 
			(
				-------------------------------------------------------------------------------------------
				-- Switch to Motion Panel
				-------------------------------------------------------------------------------------------
			
				IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
				
				-------------------------------------------------------------------------------------------
				-- Check for Groups and act accordingly
				-------------------------------------------------------------------------------------------
			
				EC_OBJ = selection[1]
				if selection.count > 1 do 
				(
					local h = EC_OBJ.parent 
					if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
				)
				
				-------------------------------------------------------------------------------------------
				-- Define Filter Function for PickObject Selection
				-------------------------------------------------------------------------------------------
				
				fn GeomFilt o = ((refs.DependencyLoopTest o EC_OBJ.controller) == false and
								 (	oclass = ClassOf o
									 oclass == NURBSSurf or 
									 oclass == Editable_Patch or 
									 oclass == Sphere or 
									 oclass == Cone or 
									 oclass == Cylinder or 
									 oclass == Torus or 
									 oclass == Loft
								 )
								)
				
				-------------------------------------------------------------------------------------------
						
				--Format "%\n" ("Pick NURBS Surface to Attach " + EC_OBJ.name + " to:") to:Listener
				
				EC_TargetOBJ = PickObject count:1 select:true filter:GeomFilt message:"Pick Surface to Attach to.." Rubberband:EC_OBJ.transform.pos ForceListenerFocus:False
			
				If EC_TargetOBJ != undefined and EC_TargetOBJ != "None" then
				(
			
					-------------------------------------------------------------------------------------------
					-- Add List Controller
					-------------------------------------------------------------------------------------------
					
					local cont = AddListController EC_OBJ "Pos" Position_List
					
					-------------------------------------------------------------------------------------------
					-- Add Constraint
					---------------------------------------------------------------------------------------
					If classof cont[listCtrl.GetActive cont].object != Surface_Position then constraint = AddConstraint EC_OBJ "Pos" Surface_Position true
						else constraint = cont[listCtrl.GetActive cont].object

					-------------------------------------------------------------------------------------------
					-- Add Object
					-------------------------------------------------------------------------------------------
						
					constraint.Surface = EC_TargetOBJ
							
					-------------------------------------------------------------------------------------------
					-- Set Active Controller
					-------------------------------------------------------------------------------------------
							
					SetActiveController cont constraint
	
					Select EC_OBJ
					
				)
			)
			Catch (MessageBox "Surface Constraint Not Completed" Title:"Constraints")
		)
	)
)



MacroScript Bezier_P
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Bezier Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Bezier Position Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List
			
			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Bezier_Position then controller = AddConstraint EC_OBJ "Pos" Bezier_Position true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Bezier Position Controller Not Completed" Title:"Controllers")
			
	)
)

MacroScript Bezier_S
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Bezier Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Bezier Scale Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Scale" Scale_List
			
			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Bezier_Scale then controller = AddConstraint EC_OBJ "Scale" Bezier_Scale true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Bezier Scale Controller Not Completed" Title:"Controllers")
			
	)
)



MacroScript Noise_P
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Noise Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Noise Position Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Noise_Position then controller = AddConstraint EC_OBJ "Pos" Noise_Position true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Noise Position Controller Not Completed" Title:"Controllers")
			
	)
)


MacroScript Noise_R
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Noise Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Noise Rotation Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[2].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
		
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
		
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Rotation" Rotation_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Noise_Rotation then controller = AddConstraint EC_OBJ "Rotation" Noise_Rotation true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			select EC_OBJ
		
		)
		Catch (MessageBox "Noise Rotation Controller Not Completed" Title:"Controllers")
			
	)
)

	
MacroScript Noise_S
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Noise Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Noise Scale Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 	(classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Scale" Scale_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Noise_Scale then controller = AddConstraint EC_OBJ "Scale" Noise_Scale true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
		
		)
		Catch (MessageBox "Noise Scale Controller Not Completed" Title:"Controllers")
	)
)

MacroScript Audio_P
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Audio Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Audio Position Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != AudioPosition then controller = AddConstraint EC_OBJ "Pos" AudioPosition true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Audio Position Controller Not Completed" Title:"Controllers")
			
	)
)
	

MacroScript Audio_R
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Audio Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Audio Rotation Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Rotation" Rotation_List

			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != AudioRotation then controller = AddConstraint EC_OBJ "Rotation" AudioRotation true
				else controller = cont[listCtrl.GetActive cont].object
			
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------

			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Audio Rotation Controller Not Completed" Title:"Controllers")
			
	)
)


MacroScript Audio_S
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Audio Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Audio Scale Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 	(classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Scale" Scale_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != AudioScale then controller = AddConstraint EC_OBJ "Scale" AudioScale true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
		
		)
		Catch (MessageBox "Audio Scale Controller Not Completed" Title:"Controllers")
	)
)

MacroScript Linear_P
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Linear Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Linear Position Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List
			
			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Linear_Position then controller = AddConstraint EC_OBJ "Pos" Linear_Position true
				else controller = cont[listCtrl.GetActive cont].object
			
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Linear Position Controller Not Completed" Title:"Controllers")
			
	)
)




MacroScript Linear_R
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Linear Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Linear Rotation Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Rotation" Rotation_List

			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Linear_Rotation then controller = AddConstraint EC_OBJ "Rotation" Linear_Rotation true
				else controller = cont[listCtrl.GetActive cont].object
			

			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Linear Rotation Controller Not Completed" Title:"Controllers")
			
	)
)


MacroScript Linear_S
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Linear Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Linear Scale Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 	(classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Scale" Scale_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Linear_Scale then controller = AddConstraint EC_OBJ "Scale" Linear_Scale true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
		
		)
		Catch (MessageBox "Linear Scale Controller Not Completed" Title:"Controllers")
	)
)


MacroScript Expression_P
enabledIn:#("max") --pfb: 2003.12.11 added product switch
	ButtonText:"Position Expression"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Position Expression Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List
			
			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Position_Expression then controller = AddConstraint EC_OBJ "Pos" Position_Expression true
				else controller = cont[listCtrl.GetActive cont].object
			
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Position Expression Controller Not Completed" Title:"Controllers")
			
	)
)



MacroScript Expression_S
enabledIn:#("max") --pfb: 2003.12.11 added product switch

	ButtonText:"Scale Expression"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Scale Expression Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 	(classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Scale" Scale_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Scale_Expression then controller = AddConstraint EC_OBJ "Scale" Scale_Expression true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
		
		)
		Catch (MessageBox "Scale Expression Controller Not Completed" Title:"Controllers")
	)
)


MacroScript Mocap_P
enabledIn:#("max") --pfb: 2003.12.11 added product switch

	ButtonText:"Position Motion Capture"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Position Motion Capture Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List
			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Position_Motion_Capture then controller = AddConstraint EC_OBJ "Pos" Position_Motion_Capture true
				else controller = cont[listCtrl.GetActive cont].object
			
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Position Motion Capture Controller Not Completed" Title:"Controllers")
			
	)
)




MacroScript Mocap_R
enabledIn:#("max") --pfb: 2003.12.11 added product switch

	ButtonText:"Rotation Motion Capture"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Rotation Motion Capture Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Rotation" Rotation_List

			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Rotation_Motion_Capture then controller = AddConstraint EC_OBJ "Rotation" Rotation_Motion_Capture true
				else controller = cont[listCtrl.GetActive cont].object
			

			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Rotation Motion Capture Controller Not Completed" Title:"Controllers")
			
	)
)


MacroScript Mocap_S
enabledIn:#("max") --pfb: 2003.12.11 added product switch

	ButtonText:"Scale Motion Capture"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Scale Motion Capture Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 	(classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Scale" Scale_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Scale_Motion_Capture then controller = AddConstraint EC_OBJ "Scale" Scale_Motion_Capture true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
		
		)
		Catch (MessageBox "Scale Motion Capture Controller Not Completed" Title:"Controllers")
	)
)


MacroScript Reactor_P
enabledIn:#("max") --pfb: 2003.12.11 added product switch

	ButtonText:"Position Reaction"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Reaction Position Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List
			
			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Position_Reactor then controller = AddConstraint EC_OBJ "Pos" Position_Reactor true
				else controller = cont[listCtrl.GetActive cont].object
			
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Position Reaction Controller Not Completed" Title:"Controllers")
			
	)
)




MacroScript Reactor_R
enabledIn:#("max") --pfb: 2003.12.11 added product switch

	ButtonText:"Rotation Reaction"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Reaction Rotation Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Rotation" Rotation_List

			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Rotation_Reactor then controller = AddConstraint EC_OBJ "Rotation" Rotation_Reactor true
				else controller = cont[listCtrl.GetActive cont].object
			

			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Rotation Reaction Controller Not Completed" Title:"Controllers")
			
	)
)


MacroScript Reactor_S
enabledIn:#("max") --pfb: 2003.12.11 added product switch

	ButtonText:"Scale Reaction"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Reaction Scale Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 	(classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Scale" Scale_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Scale_Reactor then controller = AddConstraint EC_OBJ "Scale" Scale_Reactor true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
		
		)
		Catch (MessageBox "Scale Reaction Controller Not Completed" Title:"Controllers")
	)
)


MacroScript Script_P
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Position Script"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Script Position Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List
			
			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Position_Script then controller = AddConstraint EC_OBJ "Pos" Position_Script true
				else controller = cont[listCtrl.GetActive cont].object
			
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Position Script Controller Not Completed" Title:"Controllers")
			
	)
)




MacroScript Script_R
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Rotation Script"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Script Rotation Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Rotation" Rotation_List

			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Rotation_Script then controller = AddConstraint EC_OBJ "Rotation" Rotation_Script true
				else controller = cont[listCtrl.GetActive cont].object
			

			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Rotation Script Controller Not Completed" Title:"Controllers")
			
	)
)


MacroScript Script_S
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Scale Script"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Script Scale Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 	(classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Scale" Scale_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Scale_Script then controller = AddConstraint EC_OBJ "Scale" Scale_Script true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
		
		)
		Catch (MessageBox "Scale Script Controller Not Completed" Title:"Controllers")
	)
)


MacroScript XYZ_P
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Position XYZ"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"XYZ Position Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List
			
			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Position_XYZ then controller = AddConstraint EC_OBJ "Pos" Position_XYZ true
				else controller = cont[listCtrl.GetActive cont].object
			
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Position XYZ Controller Not Completed" Title:"Controllers")
			
	)
)




MacroScript EulerXYZ_R
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Euler XYZ"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Euler XYZ Controller"
	SilentErrors:(Debug != True) 
	
(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Rotation" Rotation_List

			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Euler_XYZ then controller = AddConstraint EC_OBJ "Rotation" Euler_XYZ true
				else controller = cont[listCtrl.GetActive cont].object
			

			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Euler XYZ Controller Not Completed" Title:"Controllers")
			
	)
)


MacroScript XYZ_S
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Scale XYZ"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"XYZ Scale Controller"
	SilentErrors:(Debug != True) 
	
(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 	(classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Scale" Scale_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != ScaleXYZ then controller = AddConstraint EC_OBJ "Scale" ScaleXYZ true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
		
		)
		Catch (MessageBox "Scale XYZ Controller Not Completed" Title:"Controllers")
	)
)

MacroScript Slave_P
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Slave Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Slave Position Controller"
	SilentErrors:(Debug != True) 

(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List
			
			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != SlavePos then controller = AddConstraint EC_OBJ "Pos" SlavePos true
				else controller = cont[listCtrl.GetActive cont].object
			
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Slave Position Controller Not Completed" Title:"Controllers")
			
	)
)




MacroScript Slave_R
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Slave Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Slave Rotation Controller"
	SilentErrors:(Debug != True) 

(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Rotation" Rotation_List

			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != SlaveRotation then controller = AddConstraint EC_OBJ "Rotation" SlaveRotation true
				else controller = cont[listCtrl.GetActive cont].object
			

			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Slave Rotation Controller Not Completed" Title:"Controllers")
			
	)
)


MacroScript Slave_S
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Slave Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Slave Scale Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 	(classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Scale" Scale_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != SlaveScale then controller = AddConstraint EC_OBJ "Scale" SlaveScale true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
		
		)
		Catch (MessageBox "Slave Scale Controller Not Completed" Title:"Controllers")
	)
)

MacroScript Spring_P
enabledIn:#("max") --pfb: 2003.12.11 added product switch

	ButtonText:"Spring Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Spring Position Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List
			
			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Spring then controller = AddConstraint EC_OBJ "Pos" SpringPositionController true
				else controller = cont[listCtrl.GetActive cont].object
			
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Spring Position Controller Not Completed" Title:"Controllers")
			
	)
)




MacroScript Smooth_R
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Smooth Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Smooth Rotation Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Rotation" Rotation_List

			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != Smooth_Rotation then controller = AddConstraint EC_OBJ "Rotation" bezier_rotation true
				else controller = cont[listCtrl.GetActive cont].object
			

			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "Smooth Rotation Controller Not Completed" Title:"Controllers")
			
	)
)

MacroScript TCB_P
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"TCB Position"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"TCB Position Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Pos" Position_List

			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != TCB_Position then controller = AddConstraint EC_OBJ "Pos" TCB_Position true
				else controller = cont[listCtrl.GetActive cont].object
			

			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "TCV Position Controller Not Completed" Title:"Controllers")
			
	)
)



MacroScript TCB_R
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"TCB Rotation"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"TCB Rotation Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller or selection[1].controller[1].controller != undefined) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Rotation" Rotation_List

			-------------------------------------------------------------------------------------------
			-- Add Controller
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != TCB_Rotation then controller = AddConstraint EC_OBJ "Rotation" TCB_Rotation true
				else controller = cont[listCtrl.GetActive cont].object
			

			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
			SetActiveController cont controller

			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
				
		)
		Catch (MessageBox "TCB Rotation Controller Not Completed" Title:"Controllers")
			
	)
)

MacroScript TCB_S
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"TCB Scale"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"TCB Scale Controller"
	SilentErrors:(Debug != True) 


(
	Global EC_OBJ, EC_TargetOBJ = "None"

	-- Check to see if something is selected
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 	(classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
						)

	on execute do 
	(
		Try
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)
			
			-------------------------------------------------------------------------------------------
			-- Add List Controller
			-------------------------------------------------------------------------------------------
			
			local cont = AddListController EC_OBJ "Scale" Scale_List
			
			-------------------------------------------------------------------------------------------
			-- Add Constraint
			---------------------------------------------------------------------------------------
			If classof cont[listCtrl.GetActive cont].object != TCB_Scale then controller = AddConstraint EC_OBJ "Scale" TCB_Scale true
				else controller = cont[listCtrl.GetActive cont].object
	
			-------------------------------------------------------------------------------------------
			-- Set Active Controller
			-------------------------------------------------------------------------------------------
					
			SetActiveController cont controller
	
			-------------------------------------------------------------------------------------------
					
			Select EC_OBJ
		
		)
		Catch (MessageBox "TCB Scale Controller Not Completed" Title:"Controllers")
	)
)


MacroScript PRS
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch
	ButtonText:"PRS Controller"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"PRS Controller" 
	SilentErrors:(Debug != True)
	
	(
	Global EC_OBJ, EC_TargetOBJ = "None"

		
	-- Check to see if something is selected
		
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
					)
	 
	on execute do 
	(
		Try 
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)

			local constraint
			constraint = EC_OBJ.Transform.controller
			if Classof constraint != prs() do
			(
				EC_OBJ.Transform.controller = prs()
			)

			
			-------------------------------------------------------------------------------------------

			Select EC_OBJ		
		)	
		Catch (MessageBox "PRS Controller Not Completed" Title:"Controller")
	)
)

MacroScript Transform_script
enabledIn:#("max", "viz") --pfb: 2003.12.11 added product switch

	ButtonText:"Transform Script"
	Category:"Controllers" 
	internalCategory:"Controllers" 
	Tooltip:"Transform Script" 
	SilentErrors:(Debug != True)
	
	(
	Global EC_OBJ, EC_TargetOBJ = "None"

		
	-- Check to see if something is selected
		
	on isEnabled return (selection.count != 0 and
						 classof selection[1].controller != BipSlave_Control and
						 (classof selection[1].controller != IK_ControllerMatrix3Controller) and
						 (	selection.count == 1 or 
							selection.count > 1 and
							(
								local h = selection[1].parent 
								h != undefined and h.isSelected and isGroupHead h
							)
						 )
					)
	 
	on execute do 
	(
		Try 
		(
			-------------------------------------------------------------------------------------------
			-- Switch to Motion Panel
			-------------------------------------------------------------------------------------------
		
			IF getCommandPanelTaskMode() != #motion then SetCommandPanelTaskMode Mode:#Motion
			
			-------------------------------------------------------------------------------------------
			-- Check for Groups and act accordingly
			-------------------------------------------------------------------------------------------
			
			EC_OBJ = selection[1]
			if selection.count > 1 do 
			(
				local h = EC_OBJ.parent 
				if (h != undefined and h.isSelected and isGroupHead h) do EC_OBJ = h
			)

			local constraint
			constraint = EC_OBJ.Transform.controller
			if Classof constraint != transform_script() do
			(
				EC_OBJ.Transform.controller = transform_script()
			)

			
			-------------------------------------------------------------------------------------------

			Select EC_OBJ		
		)	
		Catch (MessageBox "Transform Script Controller Not Completed" Title:"Controller")
	)
)
