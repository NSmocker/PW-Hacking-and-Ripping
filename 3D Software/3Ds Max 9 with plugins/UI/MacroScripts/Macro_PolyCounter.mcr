/*

-- MacroScript File

-- Created: 		Sept 21 1999
-- Last Modified: 	Aug 06 2004
-- Author:   Fred Ruff
-- Modified Larry Minton, June 02, 2002
-- clean up screen drit, changed "triangles" to "faces" 
-- Modified Alexander Esppeschit Bicalho, Aug 06, 2004
-- Added a new macroscript to count triangle faces, instead of Polygons
-- Changed some locals to globals so users can swap between both counters
-- MacroScript for Turning On a Polygon counter in the viewpot on an object.
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
*/

macroScript Triangle_Counter
enabledIn:#("max")
	category:"MAX Script Tools"
	internalcategory:"MAX Script Tools"
	buttontext:"Triangle Counter"
	toolTip:"Triangle Counter" 
(
	global TriangleCounterOn = false, PolygonCounterOn, fn_TriangleCounterText, fnPolygonCounterText
	local viewText, lastText
	local lastViewport
	local textPos
	local updateRect
	fn fn_TriangleCounterText = 
	(
		try 
		(
			viewText = ""
			if selection.count == 1 do
			(	if getCommandPanelTaskMode() == #modify and subobjectlevel == 1 then
					viewText = "Vertices: " + (getTrimeshFaceCount $)[2] as string
				else
					viewText = "Triangles: " + (getTrimeshFaceCount $)[1] as string
			)
			local needUpdate = viewText != lastText
			
			if viewport.activeViewport != lastViewport then
			(	completeredraw()
				lastViewport = viewport.activeViewport 
			)
			else if needUpdate do
			(	local rect = gw.getTextExtent lastText
				updateRect.w = rect.x+1
				updateRect.h = rect.y+1
				gw.clearscreen updateRect useBkg:true
				gw.enlargeUpdateRect updateRect 
				gw.updateScreen() 
				gw.resetUpdateRect()
			)
			
			if (viewText != "") do
			(	gw.wtext textPos viewText color:(color 255 234 0)
				rect = gw.getTextExtent viewText 
				updateRect.w = rect.x+1
				updateRect.h = rect.y+1
				gw.enlargeUpdateRect updateRect
				gw.updateScreen() 
			)
			lastText = viewText
		)
		catch ()
	)

	on ischecked return TriangleCounterOn 
	
	On execute do
	(	if TriangleCounterOn then 
			unregisterRedrawViewsCallback fn_TriangleCounterText
		else
		(	if PolyCounterOn != undefined do
				if PolyCounterOn do unregisterRedrawViewsCallback fn_PolygonCounterText
			registerRedrawViewsCallback fn_TriangleCounterText
			textPos = [5,40,0]
			updateRect = box2 (textPos.x) (textPos.y-(gw.getTextExtent "X").y) 0 0
			lastText = ""
		)
		PolyCounterOn = false
		TriangleCounterOn = not TriangleCounterOn 
		completeredraw()
		updateToolbarButtons()
	) 
) 

macroScript Poly_Counter
enabledIn:#("max") --pfb: 2003.12.12 added product switch
	category:"MAX Script Tools"
	internalcategory:"MAX Script Tools"
	buttontext:"Polygon Counter"
	toolTip:"Polygon Counter" 
(
	global PolyCounterOn = false, fn_PolygonCounterText, TriangleCounterOn, fn_triangleCounterText
	local viewText, lastText
	local lastViewport
	local textPos
	local updateRect
	fn fn_PolygonCounterText = 
	(
		try 
		(
			viewText = ""
			if selection.count == 1 do
			(	if getCommandPanelTaskMode() == #modify and subobjectlevel == 1 then
					viewText = "Vertices: " + (getPolygoncount $)[2] as string
				else
					viewText = "Faces: " + (getPolygoncount $)[1] as string
			)
			local needUpdate = viewText != lastText
			
			if viewport.activeViewport != lastViewport then
			(	completeredraw()
				lastViewport = viewport.activeViewport 
			)
			else if needUpdate do
			(	local rect = gw.getTextExtent lastText
				updateRect.w = rect.x+1
				updateRect.h = rect.y+1
				gw.clearscreen updateRect useBkg:true
				gw.enlargeUpdateRect updateRect 
				gw.updateScreen() 
				gw.resetUpdateRect()
			)
			
			if (viewText != "") do
			(	gw.wtext textPos viewText color:(color 255 234 0)
				rect = gw.getTextExtent viewText 
				updateRect.w = rect.x+1
				updateRect.h = rect.y+1
				gw.enlargeUpdateRect updateRect
				gw.updateScreen() 
			)
			lastText = viewText
		)
		catch ()
	)

	on ischecked return PolyCounterOn 
	
	On execute do
	(	if PolyCounterOn then 
			unregisterRedrawViewsCallback fn_PolygonCounterText
		else
		(	if TriangleCounterOn != undefined do
				if triangleCounterOn do unregisterRedrawViewsCallback fn_TriangleCounterText
			registerRedrawViewsCallback fn_PolygonCounterText
			textPos = [5,40,0]
			updateRect = box2 (textPos.x) (textPos.y-(gw.getTextExtent "X").y) 0 0
			lastText = ""
		)
		TriangleCounterOn = false
		PolyCounterOn = not PolyCounterOn 
		completeredraw()
		updateToolbarButtons()
	) 
)

