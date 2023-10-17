/*
Filter Functions MacroScript File

Revision History:
 June 2000; Frank Delise
 	Created for 3ds MAX4

 10 Juin 2003; Pierre-Felix Breton
	3ds MAX 6 changes	
	
27 juin 2003; Pierre-Felix Breton

	performance optimizations:
		
		>added and (superclassof selection[1] == Class) checks on mesh, patc, poly, nurbs, splines fileters functions 
		to bail out as fast as possible when selecting lights, helpers etc...
		
		>refactored with findItem #(Edit_Mesh, Editable_Mesh) for clarity reasons
	
		>removed the Is_PosXYZ, Is_ScaleXYZ, Is_RotationXYZ

26 Sept 2003; Larry Minton. 
	Put back in functions that were removed: 
	
28 May 2004: Steve Anderson - adding Is_EditPolyMod and Is_EPoly tests, to help build
    macros for the new Edit Poly modifier.


Filter functions for conext sensitve menus.
*/


--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- 


Struct Filters (

 
	fn Is_EditMesh = (Selection.count == 1) and (superclassof selection[1] == GeometryClass) and
	(	
	Try (	
			local obj = if $.modifiers.count == 0 then $.baseobject else modPanel.GetcurrentObject ()
			local CO_class = Classof obj
			findItem #(Edit_Mesh, Editable_Mesh) CO_class != 0
		)--end try
		Catch (false)
	),
	
	-- added for 3dsmax6; pfb 10 juin 2003
	-- Uses subobjectLevel + 1 because we don't have collections with a 0 index.
	fn Is_EditMeshSpecifyLevel levelPlusOneSet = ((getCommandPanelTaskMode() == #modify) and Filters.Is_EditMesh() and levelPlusOneSet[subobjectLevel+1]),
												   
	fn Is_NURBS = (Selection.count == 1) and (superclassof selection[1] == GeometryClass) and
	(	Try	(Classof $.baseobject == NURBS_Surface and $.modifiers.count == 0)
 		Catch (false)
	),
	
	fn GetModOrObj = 
	(
		Try (
			if $.modifiers.count == 0 then $.baseobject else modPanel.GetCurrentObject()
		)--end try
		Catch (null)
	),

	fn Is_EditPoly = (Selection.count == 1)  and (superclassof selection[1] == GeometryClass) and
	(	Try (
			local modOrObj = (if $.modifiers.count == 0 then $.baseobject else modPanel.GetCurrentObject())
			findItem #(Editable_Poly) (Classof modOrObj) != 0
		)--end try
		Catch (false)
	),
	
	-- Uses subobjectLevel + 1 because we don't have collections with a 0 index.
	fn Is_EditPolySpecifyLevel levelPlusOneSet = ((getCommandPanelTaskMode() == #modify) and Filters.Is_EditPoly() and levelPlusOneSet[subobjectLevel+1]),
	
	fn Is_EditPolyMod = (Selection.count == 1)  and (superclassof selection[1] == GeometryClass) and
	(	Try (	
			local modOrObj = (if $.modifiers.count == 0 then $.baseobject else modPanel.GetCurrentObject())
			findItem #(Edit_Poly) (Classof modOrObj) != 0
		)--end try
		Catch (false)
	),

	fn Is_This_EditPolyMod modOrObj = (findItem #(Edit_Poly) (classof modOrObj) != 0),
	fn Is_This_EditPolyObj modOrObj = (findItem #(Editable_Poly) (classof modOrObj) != 0),
	fn Is_This_EPoly modOrObj = (findItem #(Edit_Poly, Editable_Poly) (classof modorobj) != 0),

	-- Uses subobjectLevel + 1 because we don't have collections with a 0 index.
	fn Is_EditPolyModSpecifyLevel levelPlusOneSet = ((getCommandPanelTaskMode() == #modify) and Filters.Is_EditPolyMod() and levelPlusOneSet[subobjectLevel+1]),
	
	fn Is_EPoly = (Selection.count == 1)  and (superclassof selection[1] == GeometryClass) and
	(	Try (
			local modOrObj = (if $.modifiers.count == 0 then $.baseobject else modPanel.GetCurrentObject())
			findItem #(Editable_Poly, Edit_Poly) (Classof modOrObj) != 0
		)--end try
		Catch (false)
	),
	
	fn Is_EPoly_SliceMode = Filters.Is_EPoly() and 
	(	Try (
			local modOrObj = (if $.modifiers.count == 0 then $.baseobject else modPanel.GetCurrentObject())
			modOrObj.inSlicePlaneMode()
		)
		Catch (false)
	),
	
	-- Uses subobjectLevel + 1 because we don't have collections with a 0 index.
	fn Is_EPolySpecifyLevel levelPlusOneSet = ((getCommandPanelTaskMode() == #modify) and Filters.Is_EPoly() and levelPlusOneSet[subobjectLevel+1]),
	
	fn Is_EditPatch = (Selection.count == 1)  and (superclassof selection[1] == GeometryClass) and
	(	Try (	
			local obj = if $.modifiers.count == 0 then $.baseobject else modPanel.GetcurrentObject ()
			local CO_class = Classof obj
			findItem #(Edit_Patch, Editable_Patch) CO_class != 0
		)--end try
		Catch (false)
	),

	
	-- added for 3dsmax6; pfb 10 juin 2003
	-- Uses subobjectLevel + 1 because we don't have collections with a 0 index.
	fn Is_EditPatchSpecifyLevel levelPlusOneSet = ((getCommandPanelTaskMode() == #modify) and Filters.Is_EditPatch() and levelPlusOneSet[subobjectLevel+1]),

	fn Are_Modifiers_Applied = (Try (selection.count == 1 and $.modifiers.count != 0) Catch (false)),

	fn Is_EditSpline = (Selection.count == 1)  and --(superclassof selection[1] == Shape) and
	(	Try (	
			local obj = if $.modifiers.count == 0 then $.baseobject else modPanel.GetcurrentObject ()
			local CO_class = Classof obj
			findItem #(Edit_Spline, Line, SplineShape) CO_class != 0
		)--end try
		Catch (false)
	),
	
	-- added for 3dsmax6; pfb 10 juin 2003
	-- Uses subobjectLevel + 1 because we don't have collections with a 0 index.
	fn Is_EditSplineSpecifyLevel levelPlusOneSet = ((getCommandPanelTaskMode() == #modify) and Filters.Is_EditSpline() and levelPlusOneSet[subobjectLevel+1]),
	
	fn Is_MeshSelect = 
	(	Try (Classof (modPanel.GetcurrentObject ()) == Mesh_Select)
		Catch (false)
	),
	
	fn Is_PolySelect = 
	(	Try (Classof (modPanel.GetcurrentObject ()) == Poly_Select)
		Catch (false)
	),

	fn Is_SplineSelect =  
	(	Try (Classof (modPanel.GetcurrentObject ()) == SplineSelect)
		Catch (false)
	),

	fn Is_PatchSelect =  
	(	Try (Classof (modPanel.GetcurrentObject ()) == Patch_Select)
		Catch (false)
	),

	/* 
	pfbreton 27 juin 2003: following functions should not be used in macroscript isEnabled and isVisible handlers
	                       due to potentially significant decrease in UI performance
	
	example: for n in selection do ---  WHAT IS THIS????  NEVER LOOP ON SELECTIONS in MXS to determine if a menu should be enabled or not

	*/
	--==========================================================================================================
	fn Is_PosXYZ = 
	(	
		local res = false
		for n in selection while not res do
		(
			try
			(	
				local c = n.pos.controller
				local c_class = classOf c
				if c_class == Position_XYZ or
					(c_class == Position_List and classOf c[ListCtrl.GetActive c].controller == Position_XYZ)
				do res = true
	        )
	    	catch ()
		)
    	res
	),
	
	
	fn Is_RotationXYZ = 
	(
		local res = false
		for n in selection while not res do
		(
			try
			(	
				local c = n.Rotation.controller
				local c_class = classOf c
				if c_class == Euler_XYZ or
					c_class == Local_Euler_XYZ or
					(	c_class == Rotation_List and 
						(	c_class = classOf c[ListCtrl.GetActive c].controller
							c_class == Euler_XYZ or
							c_class == Local_Euler_XYZ
						)
					)
				do res = true
			)
	    	catch ()
        )
    	res
	),
	
	fn Is_ScaleXYZ = 
	(
		local res = false
		for n in selection while not res do
		(
			try
	        (
				local c = n.Scale.controller
				local c_class = classOf c
				if c_class == ScaleXYZ or
					(c_class == Scale_List and classOf c[ListCtrl.GetActive c].controller == ScaleXYZ)
				do res = true
			)
	    	catch ()
		)
    	res
	),
	--==========================================================================================================
	
	fn is_Child Parent Child = 
	(	Try
		(	local c_parent = child.parent
			c_parent != undefined and
			(	c_parent == Parent or
				filters.is_Child Parent c_parent
			)
		)
		Catch (false)
	),
	
	
	fn is_Parent Child Parent = filters.is_Child Parent Child,
	
	fn CanSwitchTo_Vertex = 
	(	filters.Is_EditMesh() or 
		filters.Is_EditSpline() or 
		filters.Is_EditPatch() or 
		filters.Is_EditPoly() or 
		filters.is_MeshSelect() or
		filters.is_SplineSelect() or
		filters.is_PatchSelect() or
		filters.is_PolySelect()
	),
	
	fn CanSwitchTo_Edge = 
	(	filters.Is_EditMesh() or 
		filters.Is_EditPatch() or 
		filters.Is_EditPoly() or 
		filters.is_MeshSelect() or
		filters.is_PatchSelect() or
		filters.is_PolySelect()
	),
	
	fn CanSwitchTo_Face = 
	(	filters.Is_EditMesh() or
		filters.is_MeshSelect()
	),
	
	fn CanSwitchTo_Polygon = 
	(	filters.Is_EditMesh() or 
		filters.Is_EditPoly() or 
		filters.is_MeshSelect() or
		filters.is_PolySelect()
	),
	
	fn CanSwitchTo_Element = 
	(	filters.Is_EditMesh()or 
		filters.Is_EditPatch()or 
		filters.Is_EditPoly()or 
		filters.is_MeshSelect()or
		filters.is_PatchSelect()or
		filters.is_PolySelect()
	),
	
	fn CanSwitchTo_Border = 
	(	filters.Is_EditPoly() or 
		filters.is_PolySelect()
	),
	
	fn CanSwitchTo_Patch = 
	(	filters.Is_EditPatch() or 
		filters.is_PatchSelect()
	),
	
	fn CanSwitchTo_Segment = 
	(	filters.Is_EditSpline() or 
		filters.is_SplineSelect()
	),
	
	fn CanSwitchTo_Spline = 
	(	filters.Is_EditSpline() or
		filters.is_SplineSelect()
	),


	-- Following require a node to be passed into the function
	
	fn Is_Bone Node = 
	(	Try (Classof Node == BoneGeometry)
		Catch(false)
	),
	
	fn Is_IKChain Node = 
	(	Try (Classof Node == IK_Chain_Object)
		Catch (false)
	),
	
	fn Is_Point Node = 
	(	Try (Classof Node == Point)
		Catch (false)
	),

	fn Is_Light Node = 
	(	Try (Superclassof Node == light) 
		Catch (false)
	),

	fn Is_Camera Node = 
	(	Try (Superclassof Node == Camera)
		Catch (false)
	),

	fn Is_Grid Node =
	(	Try (Classof Node == Grid)
		Catch (false)
	),
	
	-- R4.2+ additions
	
	fn Is_Target Node = 
	(	isValidNode Node and Node.isTarget -- isValidNode Node will never throw
	), 

	-- Following functions require a node and property name as arguments
	-- These filters are for testing/getting/setting properties on the base object
	-- and handle the base object being a normal object or a scripted plugin instance.
	-- The get/set/taoogle functions will return #error if the operation failed

	-- returns true/false
	fn HasBaseObjectProperty Node Prop = 
	(	try
		(	if isValidNode Node then
			(	local bo = Node.baseObject
				isProperty bo Prop OR
				(  isProperty bo #delegate AND isProperty bo.delegate Prop)
			)
			else
				false
		)
		catch (false)
	),
	
	-- returns value/#error
	fn GetBaseObjectProperty Node Prop = 
	(	try
		(	if isValidNode Node then
			(	local bo = Node.baseObject
				IF isProperty bo Prop THEN getProperty bo Prop 
				ELSE IF isProperty bo #delegate AND isProperty bo.delegate Prop THEN getProperty bo.delegate Prop 
				ELSE #error
			)
			else
				#error
		)
		catch (#error)
	),
	
	-- returns new value/#error
	fn SetBaseObjectProperty Node Prop val = 
	(	try
		(	if isValidNode Node then
			(	local bo = Node.baseObject
				IF isProperty bo Prop THEN setProperty bo Prop val
				ELSE IF isProperty bo #delegate AND isProperty bo.delegate Prop THEN setProperty bo.delegate Prop val
				ELSE #error
			)
			else
				#error
		)
		catch (#error)
	),
	
	-- returns new value/#error
	fn ToggleBaseObjectProperty Node Prop = 
	(	try
		(	if isValidNode Node then
			(	local bo = Node.baseObject
				local target, oldVal
				IF isProperty bo Prop then target = bo
				ELSE IF isProperty bo #delegate AND isProperty bo.delegate Prop THEN target = bo.delegate
				IF target != undefined and isKindOf (oldVal = getProperty target Prop ) BooleanClass THEN 
					setProperty target Prop (not oldVal)
				ELSE 
					#error
			)
			else
				#error
		)
		catch (#error)
	)
)
