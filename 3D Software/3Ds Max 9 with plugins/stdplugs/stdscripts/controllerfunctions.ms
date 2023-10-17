-- Functions for Controller Access, MacroScript File
--
-- Created:  		May 17 2000
-- Last Updated: 	Jan 4 2000
--
-- Author :   Frank DeLise
-- Version:  3D Studio Max Version 4.0
--
-- 
-- Functions for accessing Controllers
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- Removed IsPosXYZ() filters, moved them into FilterFunctions.ms
-- Removed Prompting to the listner window Aug 15, 2000 -FD
-- Updated Target additions for the new constraint function publishing October 6 2000
-- Jan 4 Added support for HI and HD IK

fn AddListController OBJ Trans ListType = 
(
	Try
	(
		local xformC
		-------------------------------------------------------------------------------------------
		-- If object has IK assigned apply to subController, if it's an IK goal apply to Ik goal  if not, apply to controller
		-------------------------------------------------------------------------------------------
		if classof OBJ.controller == IKControl then  xformC = OBJ.controller.fk_sub_control.controller
			else if classof OBJ.controller == IKChainControl then  xformC = OBJ.controller.IK_goal.controller
				else xformC = OBJ.controller
		
		if classof xformC == IK_ControllerMatrix3Controller do
		(	if (substring (Trans as string) 1 3) as name == #pos then Trans = getsubanimname xformC 1
			else if (substring (Trans as string) 1 3) as name == #rot then Trans = getsubanimname xformC 2
		)

		if classof xformC == Link_Constraint do xformC = xformC.link_params
		if classof xformC == Link_Transform do xformC = xformC.Scene_Transform

		local oldC = getPropertyController xformC trans
		if classof oldC != ListType then
		(	local newC = execute (ListType as string + "()")
			if (setPropertyController xformC trans newC) == undefined do throw 0
			newC
		)
		else
			oldC
	)
	Catch (MessageBox "List Controller Error!" Title:"Controller Functions";throw())
) 

fn AddConstraint OBJ Trans Constraint List =
(
	Try
	(	
		local xformC
		-------------------------------------------------------------------------------------------
		-- If object has IK assigned apply to subController, if not, apply to controller
		-------------------------------------------------------------------------------------------
		if classof OBJ.controller == IKControl then xformC = OBJ.controller.fk_sub_control.controller
			else if classof OBJ.controller == IKChainControl then xformC = OBJ.controller.IK_goal.controller
				else xformC = OBJ.controller
		
		if classof xformC == IK_ControllerMatrix3Controller do
		(	if (substring (Trans as string) 1 3) as name == #pos then Trans = getsubanimname xformC 1
			else if (substring (Trans as string) 1 3) as name == #rot then Trans = getsubanimname xformC 2
		)

		if classof xformC == Link_Constraint do xformC = xformC.link_params
		if classof xformC == Link_Transform do xformC = xformC.Scene_Transform
		
		local newC = execute (constraint as string + "()")
		If List == True then
		(	local oldC = getPropertyController xformC  trans
			oldC.available.controller = newC
		)
		Else 
			if (setPropertyController xformC trans newC) == undefined do throw 0
		newC
	)
	Catch (MessageBox "Constraint Error!" Title:"Controller Functions";throw())
)

fn SetActiveController Controller subController =
(
	Try
	(	local index
		for i = 1 to (Controller.numsubs-1) do
			if controller[i].controller == subController do index = i
		if index != undefined do
		(	listCtrl.setActive controller index
			format "Setting % as active controller\n" (listCtrl.getName controller index)
		)
	)
	Catch ( MessageBox "Set Active Controller Error" Title:"Controller Functions")
)


