/*

Skin Operations Macro Script File

 Created:  		Aug 6 2000
	
 Author :   Peter Watje
 Version:  3ds max 6

 	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products


*/
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- 

MacroScript SkinLoopSelection
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Loop Selection"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Loop Selection (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)	
	On Execute do
		(
		skinOps.loopSelection (modPanel.GetcurrentObject())
		)
)

MacroScript SkinRingSelection
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Ring Selection"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Ring Selection (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)	
	On Execute do
		(
		skinOps.ringSelection (modPanel.GetcurrentObject())
		)
)

MacroScript SkinGrowSelection
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Grow Selection"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Grow Selection (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)	
	On Execute do
		(
		skinOps.growSelection (modPanel.GetcurrentObject())
		)
)

MacroScript SkinShrinkSelection
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Shrink Selection"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Shrink Selection (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)	
	On Execute do
		(
		skinOps.shrinkSelection (modPanel.GetcurrentObject())
		)
)

MacroScript SkinSelectVerticesByBone
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Select Vertices By Bone"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Select Vertices By Bone (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)	
	On Execute do
		(
		skinOps.selectVerticesByBone (modPanel.GetcurrentObject())
		)
)



MacroScript WeightTable_Dialog
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Weight Table Dialog"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Weight Table Dialog (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	on isChecked return (
						 if (classof(modPanel.GetcurrentObject())) == Skin then
						 	(
							bopen = skinOps.isWeightTableOpen (modPanel.GetcurrentObject())
							if (bopen != 0) then return TRUE						    
							)
							return FALSE
					    )	
	on closeDialogs do 
		(
		
			skinOps.closeWeightTable  (modPanel.GetcurrentObject())

		) 
						
	On Execute do
		(
		skinOps.WeightTable  (modPanel.GetcurrentObject())
		)
)
MacroScript BlendWeights
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Blend Weights"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Blend Weights (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)	
	On Execute do
		(
		skinOps.blendSelected (modPanel.GetcurrentObject())
		)
)

MacroScript RemoveZeroWeights
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Remove Zero Weights"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Remove Zero Weights (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.RemoveZeroWeights (modPanel.GetcurrentObject())
		)
)

MacroScript WeightTool_Dialog
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Weight Tool Dialog"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Weight Tool Dialog (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	on isChecked return (
						 if (classof(modPanel.GetcurrentObject())) == Skin then
						 	(
							bopen = skinOps.isWeightToolOpen (modPanel.GetcurrentObject())
							if (bopen != 0) then return TRUE						    
							)
							return FALSE
					    )	
	on closeDialogs do 
		(
		
			skinOps.closeWeightTool  (modPanel.GetcurrentObject())

		) 
						
	On Execute do
		(
		skinOps.WeightTool  (modPanel.GetcurrentObject())
		)
)

MacroScript SetWeight_00
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Set Weight To 0.0"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Set Weight To 0.0 (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.SetWeight  (modPanel.GetcurrentObject()) 0.0
		)
)

MacroScript SetWeight_01
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Set Weight To 0.10"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Set Weight To 0.10 (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(

		skinOps.SetWeight  (modPanel.GetcurrentObject()) 0.1
		)
)

MacroScript SetWeight_25
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Set Weight To 0.25"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Set Weight To 0.25 (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(

		skinOps.SetWeight  (modPanel.GetcurrentObject()) 0.25
		)
)

MacroScript SetWeight_50
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Set Weight To 0.50"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Set Weight To 0.5 (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(

		skinOps.SetWeight  (modPanel.GetcurrentObject()) 0.5
		)
)

MacroScript SetWeight_75
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Set Weight To 0.75"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Set Weight To 0.75 (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(

		skinOps.SetWeight  (modPanel.GetcurrentObject()) 0.75
		)
)

MacroScript SetWeight_90
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Set Weight To 0.90"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Set Weight To 0.90 (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(

		skinOps.SetWeight  (modPanel.GetcurrentObject()) 0.90
		)
)

MacroScript SetWeight_100
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Set Weight To 1.0"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Set Weight To 1.0 (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(

		skinOps.SetWeight  (modPanel.GetcurrentObject()) 1.0
		)
)

MacroScript SetWeight_Custom
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Set Weight Custom"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Set Weight Custom (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		tmod = modPanel.GetcurrentObject()
		v = tmod.weightTool_weight
		skinOps.SetWeight  (modPanel.GetcurrentObject()) v
		)
)

MacroScript AddWeight
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Add Weight"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Add Weight (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(

		skinOps.AddWeight  (modPanel.GetcurrentObject()) 0.05
		)
)

MacroScript SubtractWeight
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Subtract Weight"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Subtract Weight (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(

		skinOps.AddWeight  (modPanel.GetcurrentObject()) -0.05
		)
)

MacroScript ScaleWeight_Custom
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Scale Weight Custom"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Scale Weight Custom (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		tmod = modPanel.GetcurrentObject()
		v = tmod.weightTool_scale
		skinOps.ScaleWeight  (modPanel.GetcurrentObject()) v
		)
)

MacroScript ScaleWeight_Up
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Scale Weight Up"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Scale Weight Up (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.ScaleWeight  (modPanel.GetcurrentObject()) 1.05
		)
)

MacroScript ScaleWeight_Down
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Scale Weight Down"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Scale Weight Down (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.ScaleWeight  (modPanel.GetcurrentObject()) 0.95
		)
)

MacroScript CopyWeights
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Copy Weights"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Copy Weights (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.CopyWeights  (modPanel.GetcurrentObject())
		)
)

MacroScript PasteWeights
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Paste Weights"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Paste Weights (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.PasteWeights  (modPanel.GetcurrentObject())
		)
)


MacroScript PasteWeightsByPos
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Paste Weights By Pos"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Paste Weights By Pos(Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		tmod = modPanel.GetcurrentObject()
		v = tmod.weightTool_tolerance		
		skinOps.pasteWeightsByPos (modPanel.GetcurrentObject()) v
		)
)


MacroScript selectParent
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Parent Bone"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Select Parent Bone (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.SelectParent  (modPanel.GetcurrentObject()) 
		)
)

MacroScript selectChild
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Child Bone"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Select Child Bone (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.SelectChild  (modPanel.GetcurrentObject()) 
		)
)

MacroScript selectNextSibling
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Sibling Next"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Select Next Sibling Bone (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.SelectNextSibling  (modPanel.GetcurrentObject()) 
		)
)

MacroScript selectPreviousSibling
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Sibling Previous"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Select Previous Sibling Bone (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.SelectPreviousSibling  (modPanel.GetcurrentObject()) 
		)
)




MacroScript backFaceCullVertices
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Backface Cull Vertices"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Backface Cull Vertices (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	on isChecked return (
					    if (classof(modPanel.GetcurrentObject())) == Skin then return  (modPanel.GetcurrentObject()).backfacecull
						return FALSE
					    )

	On Execute do
		(
		if  (modPanel.GetcurrentObject()).backfacecull then
			 (modPanel.GetcurrentObject()).backfacecull  = FALSE
		else  (modPanel.GetcurrentObject()).backfacecull  = TRUE
		)
)


MacroScript AddBonesFromView
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Add Bones"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Add Bones (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		format "-- Click object to add as Bone\n"
		skinOps.AddBoneFromViewStart  (modPanel.GetcurrentObject())
		)
)

MacroScript multiRemove
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Remove Bones"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Remove Multiple Bones (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.MultiRemove  (modPanel.GetcurrentObject())
		)
)

MacroScript selectPrevious
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Previous Bone"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Select Previous Bone (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.SelectPreviousBone  (modPanel.GetcurrentObject()) 
		)
)

MacroScript selectNext
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Next Bone"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Select Next Bone (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.SelectNextBone  (modPanel.GetcurrentObject())
		)
)

MacroScript zoomToBone
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Zoom To Bone"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Zoom To Selected Bone (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.ZoomToBone  (modPanel.GetcurrentObject()) FALSE
		)
)

MacroScript zoomToGizmo
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Zoom To Gizmo"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Zoom To Selected Gizmo (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.ZoomToGizmo  (modPanel.GetcurrentObject()) FALSE
		)
)


MacroScript selectEndPoint
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Select End Point"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Select End Point (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.SelectEndPoint  (modPanel.GetcurrentObject())
		)
)

MacroScript selectStartPoint
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Select Start Point"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Select Start Point (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.SelectStartPoint  (modPanel.GetcurrentObject())
		)
)

MacroScript filterVertices
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Select Vertices"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Filter Vertices (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	on isChecked return (
					    if (classof(modPanel.GetcurrentObject())) == Skin then return  (modPanel.GetcurrentObject()).filter_vertices
						return FALSE
					    )

	On Execute do
		(
		if  (modPanel.GetcurrentObject()).filter_vertices then
			 (modPanel.GetcurrentObject()).filter_vertices = FALSE
		else  (modPanel.GetcurrentObject()).filter_vertices = TRUE
		)
)

MacroScript filterEnvelopes
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Select Cross Sections"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Filter Cross Sections (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	on isChecked return (
					    if (classof(modPanel.GetcurrentObject())) == Skin then return  (modPanel.GetcurrentObject()).filter_cross_sections
						return FALSE
					    )	

	On Execute do
		(
		if  (modPanel.GetcurrentObject()).filter_cross_sections then
			 (modPanel.GetcurrentObject()).filter_cross_sections  = FALSE
		else  (modPanel.GetcurrentObject()).filter_cross_sections  = TRUE
		)
)

MacroScript filterCrossSections
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Select Envelopes"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Filter Envelopes (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	on isChecked return (
					    if (classof(modPanel.GetcurrentObject())) == Skin then return  (modPanel.GetcurrentObject()).filter_envelopes
						return FALSE
					    )	

	On Execute do
		(
		if  (modPanel.GetcurrentObject()).filter_envelopes then
			 (modPanel.GetcurrentObject()).filter_envelopes  = FALSE
		else  (modPanel.GetcurrentObject()).filter_envelopes  = TRUE
		)
)

MacroScript excludeVerts
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Exclude Verts"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Exclude Verts (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)

	On Execute do
		(
		skinOps.ButtonExclude  (modPanel.GetcurrentObject())
		)
)

MacroScript includeVerts
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Include Verts"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Include Verts (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)

	On Execute do
		(
		skinOps.ButtonInclude  (modPanel.GetcurrentObject())
		)
)

MacroScript selectIncludeVerts
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Select Excluded Verts"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Select Excluded Verts (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)

	On Execute do
		(
		skinOps.ButtonSelectExcluded  (modPanel.GetcurrentObject())
		)
)

-- Added August 27 2000 Fred Ruff

MacroScript CopySelectedBone
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Copy Envelope"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Copy Envelope (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)

	On Execute do
		(
		skinOps.copySelectedBone (modPanel.GetcurrentObject())
		)
)
MacroScript PasteToSelectedBone
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Paste Envelope"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Paste Envelope (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)

	On Execute do
		(
		skinOps.PasteToSelectedBone (modPanel.GetcurrentObject())
		)
)
MacroScript PasteToAllBones
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Paste to All Envelope"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Paste To All Envelopes (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)

	On Execute do
		(
		skinOps.PasteToAllBones  (modPanel.GetcurrentObject())
		)
)
MacroScript AddCrossSection
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Add Cross Section"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Add Cross Section (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin) 

	On Execute do
		(
		skinOps.ButtonAddCrossSection  (modPanel.GetcurrentObject())
		)
)
MacroScript RemoveCrossSection
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Remove Cross Section"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Remove Cross Section (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin) 

	On Execute do
		(
		skinOps.ButtonRemoveCrossSection  (modPanel.GetcurrentObject())
		)
)
MacroScript DrawEnvelopeOnTop
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Envelope On Top"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Draw Envelope On Top (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	on isChecked return (
					    if (classof(modPanel.GetcurrentObject())) == Skin then return  (modPanel.GetcurrentObject()).envelopesAlwaysOnTop
						return FALSE
					    )

	On Execute do
		(
		if Selection[1].modifiers[#Skin].envelopesAlwaysOnTop then
			Selection[1].modifiers[#Skin].envelopesAlwaysOnTop = FALSE
		else Selection[1].modifiers[#Skin].envelopesAlwaysOnTop = TRUE
		)
)
MacroScript DrawCrossSectionsOnTop
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"CrossSections On Top"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Draw CrossSections On Top (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	on isChecked return (
					    if (classof(modPanel.GetcurrentObject())) == Skin then return  (modPanel.GetcurrentObject()).crossSectionsAlwaysOnTop
						return FALSE
					    )

	On Execute do
		(
		if (modPanel.GetcurrentObject()).crossSectionsAlwaysOnTop then
			 (modPanel.GetcurrentObject()).crossSectionsAlwaysOnTop = FALSE
		else  (modPanel.GetcurrentObject()).crossSectionsAlwaysOnTop = TRUE
		)
)
MacroScript GizmoResetRotationPlane
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Gizmo Reset Reset Rotation Plane"
Category:"Skin Modifier" 
internalCategory:"Skin Modifier" 
Tooltip:"Gizmo Reset Reset Rotation Plane (Skin)" 
-- Needs Icon
(
    on isVisible return ( (classof(modPanel.GetcurrentObject())) == Skin)
    on isEnabled return ((classof(modPanel.GetcurrentObject())) == Skin)
	On Execute do
		(
		skinOps.GizmoResetRotationPlane (modPanel.GetcurrentObject())
		)
)
