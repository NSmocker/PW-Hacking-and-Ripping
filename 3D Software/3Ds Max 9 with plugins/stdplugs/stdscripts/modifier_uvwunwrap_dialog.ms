/*
UVW Unwrap functions and dialog

Version: 3dsmax 6

Revision History:
		
	24 April 2004 added the pen tool and the loop selection tool
	12 dec 2003, Pierre-Felix Breton, 
		moved functions and dialog definition into the /stdplug/stdscripts/modifier_uvwunwrap_dialog.ms from the Macro_UnwrapUI.mcr

*/



Global unwrapUIdialog
rollout unwrapUIdialog "Unwrap Tools" width:604 height:158
(
	local IconsBitmap = GetDir #ui +"\\Icons\\UVIcons.bmp"
	Local IconsBitmapAlpha = GetDir #ui +"\\Icons\\UVIcons_a.bmp"
	
	GroupBox grp3 "Soft Selection" pos:[4,0] width:264 height:76
	checkbox dash_SoftSel "On" pos:[12,20] width:44 height:16 checked:false
	spinner dash_SoftFalloff "Falloff:" pos:[170,19] width:80 height:16 enabled:false range:[0,100,0.2] scale:0.01 fieldwidth:40
	radiobuttons dash_UVSpace "" pos:[64,20] width:83 height:16 enabled:true labels:#("XY", "UV") columns:2
    checkbutton dash_FalloffLin "" pos:[180,42] width:24 height:24 images:#(IconsBitmap, IconsBitmapAlpha, 11, 1, 1, 1, 1) toolTip:"Linear Falloff"
	checkbutton dash_FalloffSin "" pos:[154,42] width:24 height:24 images:#(IconsBitmap, IconsBitmapAlpha, 11, 2, 2, 2, 2) toolTip:"Smooth Falloff"
	checkbutton dash_FalloffIn "" pos:[206,42] width:24 height:24 images:#(IconsBitmap, IconsBitmapAlpha, 11, 3, 3, 3, 3) toolTip:"Slow Out Falloff"
	checkbutton dash_FalloffOut "" pos:[232,42] width:24 height:24 images:#(IconsBitmap, IconsBitmapAlpha, 11, 4, 4, 4, 4) toolTip:"Fast Out Falloff"
	spinner dash_EdgeDistAmount "" pos:[108,44] width:42 height:16 enabled:true range:[0,50,4] type:#integer scale:0.1 fieldwidth:25
	checkbox dash_edgeDist "Edge Distance" pos:[12,44] width:90 height:16 checked:false
	
	GroupBox grp5 "Selection Modes" pos:[272,0] width:276 height:76
	checkbutton dash_VertexMode "" pos:[300-24,15] width:27 height:27 images:#(IconsBitmap, IconsBitmapAlpha, 11, 8, 5, 5, 5) highlightColor:(color ((colorman.getcolor #activecommand).x *255) ((colorman.getcolor #activecommand).y *255)((colorman.getcolor #activecommand).z *255)) toolTip:"Vertex Sub-object Mode"
	checkbutton dash_EdgeMode "" pos:[332-24,15] width:27 height:27 images:#(IconsBitmap, IconsBitmapAlpha, 11, 9, 6, 6, 6) highlightColor:(color ((colorman.getcolor #activecommand).x *255) ((colorman.getcolor #activecommand).y *255)((colorman.getcolor #activecommand).z *255)) toolTip:"Edge Sub-object Mode"
	checkbutton dash_FaceMode "" pos:[364-24,15] width:27 height:27 images:#(IconsBitmap, IconsBitmapAlpha, 11, 10, 7, 7, 7)highlightColor:(color ((colorman.getcolor #activecommand).x *255) ((colorman.getcolor #activecommand).y *255)((colorman.getcolor #activecommand).z *255)) toolTip:"Face Sub-object Mode"

	checkbox dash_element "Select Element" pos:[280,48] width:92 height:16 checked:false
	button dash_grow "+" pos:[416-45,16] width:24 height:24 toolTip:"Expand Selection"
	button dash_shrink "-" pos:[444-45,16] width:24 height:24 toolTip:"Contract Selection"
	
	checkbutton dash_PaintMode "" pos:[490-57,16] width:27 height:28 images:#(IconsBitmap, IconsBitmapAlpha, 11, 11, 11, 11, 11)highlightColor:(color ((colorman.getcolor #activecommand).x *255) ((colorman.getcolor #activecommand).y *255)((colorman.getcolor #activecommand).z *255)) toolTip:"Paint Select Mode"

	button dash_PaintModeInc "+" pos:[520-57,16] width:14 height:14  toolTip:"Paint Brush Grow"

	button dash_PaintModeDec "-" pos:[520-57,30] width:14 height:14  toolTip:"Paint Brush Shrink"

	button dash_EdgeLoop "Edge Loop" pos:[520-40,16] width:64 height:20  toolTip:"Edge Loop Selection"



	
--	checkbox dash_sync "Sync to Viewport" pos:[378,48] width:98 height:16 checked:false
	
	button dash_RotateCW "Rot. +90" pos:[520+30,4] width:50 height:20 
	button dash_RotateCCW "Rot. -90" pos:[520+30,28] width:50 height:20 	
	
	checkbutton dash_options "Options..." pos:[520+30,56] width:50 height:18
	
	GroupBox grp10 "Bitmap Options" pos:[4,76] width:244 height:78
	spinner dash_picwidth "Width:" pos:[20,110] width:76 height:16 range:[2,2048,256] type:#integer fieldwidth:40
	spinner dash_picheight "Height:" pos:[20,130] width:76 height:16 range:[2,2048,256] type:#integer  fieldwidth:40
	checkbox dash_custombitmapsize "Use Custom Bitmap Size" pos:[12,92] width:136 height:16	
	checkbox dash_TileOn "Tile Bitmap" pos:[164,92] width:72 height:16
	spinner dash_Tileamount "Tiles:" pos:[164,112] width:64 height:16 range:[0,100,1] type:#integer fieldwidth:40
	spinner dash_brightness "Brightness:" pos:[140,132] width:88 height:16 range:[0,1,.5] scale:.1 type:#float fieldwidth:40	
	
	GroupBox grp20 "Viewport Options" pos:[252,76] width:164 height:78
	checkbox dash_ConstantUpdate "Constant Update" pos:[264,100] width:104 height:14 
--	checkbox dash_highlightverts "Highlight Selected Verts." pos:[264,119] width:140 height:14 
	
	GroupBox grp21 "Unwrap Editor Options" pos:[420,76] width:180 height:78
	checkbox dash_showhiddenedges "Show Hidden Edges" pos:[432,96] width:124 height:14 
	spinner dash_WeldThresh "Weld Threshold:" pos:[464,132] width:120 height:16 range:[0,100,0.2] scale:0.01 fieldwidth:40
	checkbox dash_MidPixelSnap "Center Pixel Snap" pos:[432,112] width:104 height:16 
	
	
	fn UpdateUI = 
	(
	 if unwrapUIdialog.open do 
	 (

			unwrapMod = modpanel.getcurrentobject()
		
			-- Get all selection Modes and set the UI correctly
			dash_SoftSel.checked = unwrapMod.getEnableSoftSelection() 
	
			dash_SoftFalloff.value = unwrapMod.getFalloffDist() 
			if 	unwrapMod.getEnableSoftSelection() == true do dash_SoftFalloff.enabled = true
			if 	unwrapMod.getEnableSoftSelection() == false do dash_SoftFalloff.enabled = false
	
			dash_FalloffLin.state = false 
			dash_FalloffSin.state = false
			dash_FalloffIn.state = false
			dash_FalloffOut.state = false
			
			dash_VertexMode.checked = false
			dash_EdgeMode.checked = false
			dash_FaceMode.checked = false
	
	
			dash_UVSpace.state = unwrapMod.getFalloffSpace()
			if unwrapMod.getFalloffType() == 1 do dash_FalloffLin.state = true 
			if unwrapMod.getFalloffType() == 2 do dash_FalloffSin.state = true
			if unwrapMod.getFalloffType() == 3 do dash_FalloffIn.state = true
			if unwrapMod.getFalloffType() == 4 do dash_FalloffOut.state = true
			dash_EdgeDistAmount.value  = unwrapMod.getLimitSoftSelRange()
			dash_edgeDist.state =  unwrapMod.getLimitSoftSel()
			
			if unwrapMod.getTVSubObjectMode() == 1 do dash_VertexMode.checked = true
			if unwrapMod.getTVSubObjectMode() == 2 do dash_EdgeMode.checked = true
			if unwrapMod.getTVSubObjectMode() == 3 do dash_FaceMode.checked = true
			
			dash_EdgeLoop.enabled = false
			if unwrapMod.getTVSubObjectMode() == 2 do dash_EdgeLoop.enabled= true
			
			dash_element.checked = unwrapMod.getTVElementMode()
	--		dash_sync.checked = unwrapMod.getSyncSelectionMode()
			dash_picwidth.value = unwrapMod.getRenderWidth()
			dash_picheight.value = unwrapMod.getRenderHeight()
			
			dash_custombitmapsize.checked = not unwrapMod.getUseBitmapRes()
			dash_TileOn.checked = unwrapMod.getTileMap()
			dash_Tileamount.value = unwrapMod.getTileMapLimit() 
			dash_brightness.value = unwrapMod.getTileMapBrightness() 
			dash_ConstantUpdate.checked = unwrapMod.getConstantUpdate() 
	--		dash_highlightverts.checked = unwrapMod.getShowSelectedVertices() 
			
			dash_showhiddenedges.checked = unwrapMod.getDisplayHiddenEdges() 
			if (unwrapMod.IsMesh()==false) then dash_showhiddenedges.Enabled = false
			dash_WeldThresh.value = unwrapMod.getWeldThreshold() 
			dash_MidPixelSnap.checked = unwrapMod.getMidPixelSnap() 
			
			dash_PaintMode.checked = unwrapMod.unwrap2.getPaintSelectMode()
	
		)
		
	)

	on unwrapUIdialog open do 
	(
	  	unwrapModPKW = modpanel.getcurrentobject()
	  	h =  unwrapModPKW.GetWindowH()	
		if (h==0) then
		unwrapUIdialog.height = 0		
		else unwrapUIdialog.height = 78
		
		unwrapModPKW .unwrap5.setWindowYOffset (78+10)		
		
		-- Get all selection Modes and set the UI correctly
		UpdateUI()
	)
	
	on dash_EdgeLoop pressed do
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.uvEdgeSelect()

	)
	
	on dash_PaintMode changed state do
	(
		unwrapMod = modpanel.getcurrentobject()
		if state == false do 
		(
		unwrapMod.setPaintSelectMode false
		)
		if state == true do 
		(
		unwrapMod.setPaintSelectMode true		
		)

	)
	on dash_PaintModeInc pressed do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.PaintSelectIncSize()
	)
	on dash_PaintModeDec pressed do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.PaintSelectDecSize()
	)
	
	
	-- Soft Selection UI items
	on dash_SoftSel changed state do
	(
		unwrapMod = modpanel.getcurrentobject()
		if state == false do 
			(
--			unwrapMod.SetFalloffDist 0
			unwrapMod.setEnableSoftSelection false
			dash_SoftFalloff.enabled = false
			)
		if state == true do
			(
--			unwrapMod.SetFalloffDist dash_SoftFalloff.value
			unwrapMod.setEnableSoftSelection true
			dash_SoftFalloff.enabled = true
			)
	)
	on dash_FalloffLin changed state do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setFalloffType 1
		dash_FalloffLin.checked = true
		dash_FalloffSin.checked = false
		dash_FalloffIn.checked = false
		dash_FalloffOut.checked = false

	)
	on dash_FalloffSin changed state do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setFalloffType 2
		dash_FalloffLin.checked = false
		dash_FalloffSin.checked = true
		dash_FalloffIn.checked = false
		dash_FalloffOut.checked = false
		
	)
	on dash_FalloffIn changed state do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setFalloffType 3
		dash_FalloffLin.checked = false
		dash_FalloffSin.checked = false
		dash_FalloffIn.checked = true
		dash_FalloffOut.checked = false
		
	)
	on dash_FalloffOut changed state do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setFalloffType 4
		dash_FalloffLin.checked = false
		dash_FalloffSin.checked = false
		dash_FalloffIn.checked = false
		dash_FalloffOut.checked = true		
	)
	
	on dash_SoftFalloff changed val do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.SetFalloffDist val
	)
	on dash_UVSpace changed stat do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.SetFalloffSpace stat
	)
	on dash_EdgeDistAmount changed val do 
	(
   		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setLimitSoftSelRange val
	)
	on dash_edgeDist changed state do
	(
	unwrapMod = modpanel.getcurrentobject()	
	if state == false do 
		(
		unwrapMod.setLimitSoftSel false
	
		)
	if state == true do
		(
		unwrapMod.setLimitSoftSel true
		)
	)
	
	
	
	
	
	-- Selection Modes and UI Items
	on dash_VertexMode changed state do
	(
		unwrapMod = modpanel.getcurrentobject()
		if state == true do 
		(
		dash_VertexMode.checked = true
		dash_EdgeMode.checked = false
		dash_FaceMode.checked = false
		dash_EdgeLoop.enabled = false
		)
		if state == false do 
		(
		dash_VertexMode.checked = true
		dash_EdgeMode.checked = false
		dash_FaceMode.checked = false
		)
	unwrapMod.setTVSubObjectMode 1
	)
	on dash_EdgeMode changed state do
	(
	unwrapMod = modpanel.getcurrentobject()	
		if state == true do 
		(
		dash_VertexMode.checked = false
		dash_EdgeMode.checked = true
		dash_FaceMode.checked = false
		dash_EdgeLoop.enabled = true
		)
		if state == false do 
		(
		dash_VertexMode.checked = false
		dash_EdgeMode.checked = true
		dash_FaceMode.checked = false
		)
	unwrapMod.setTVSubObjectMode 2
	)
	on dash_FaceMode changed state do
	(
	unwrapMod = modpanel.getcurrentobject()
		if state == true do 
		(
		dash_VertexMode.checked = false
		dash_EdgeMode.checked = false
		dash_FaceMode.checked = true
		dash_EdgeLoop.enabled = false
		)
		if state == false do 
		(
		dash_VertexMode.checked = false
		dash_EdgeMode.checked = false
		dash_FaceMode.checked =true
		)
	unwrapMod.setTVSubObjectMode 3
	)
	on dash_element changed state do
	(
	unwrapMod = modpanel.getcurrentobject()	
		if state == false do 
			(
			unwrapMod.setTVElementMode false
			)
		if state == true do
			(
			unwrapMod.setTVElementMode true
			)
	)
/*	on dash_sync changed state do
	(
	unwrapMod = modpanel.getcurrentobject()	
		if state == false do 
			(
			unwrapMod.setSyncSelectionMode false
			)
		if state == true do
			(
			unwrapMod.setSyncSelectionMode true
			)
	)
*/
	on dash_grow pressed do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.expandSelection()
	)
	on dash_shrink pressed do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.contractSelection()
	)
	
	-- Tools and Misc
	on dash_RotateCW pressed do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.RotateSelectedCenter 1.5708
	)
	on dash_RotateCCW pressed do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.RotateSelectedCenter -1.5708
	)
	
		
	-- Options Panel UI elements
	on dash_options changed state do
	(
			unwrapMod = modpanel.getcurrentobject()
			if state == true do 
			(
			unwrapUIdialog.height = 163
			unwrapMod.unwrap5.setWindowYOffset (163+10)
			)
			if state == false do 
			(
			unwrapUIdialog.height = 78
			unwrapMod.unwrap5.setWindowYOffset (78+10)
			)
	)
	on dash_custombitmapsize changed state do
	(	
		unwrapMod = modpanel.getcurrentobject()
		if state == true do  unwrapMod.setUseBitmapRes false
		if state == false do  unwrapMod.setUseBitmapRes true
	)
	on dash_picwidth changed val do 
	(
		unwrapMod = modpanel.getcurrentobject()	
		unwrapMod.setRenderWidth val
	)
	on dash_picheight changed val do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setRenderHeight val	
	)
	on dash_TileOn changed state do	
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setTileMap state
	)
	on dash_TileAmount changed val do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setTileMapLimit val
	)
	on dash_brightness changed val do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setTileMapbrightness val
	)
	on dash_constantUpdate changed state do	
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setConstantUpdate state
	)
/*
	on dash_highlightVerts changed state do	
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setShowSelectedVertices state
	)
*/
	on dash_showHiddenEdges changed state do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setDisplayHiddenEdges state
	)
	on dash_MidPixelSnap changed state do 
	(
		unwrapMod = modpanel.getcurrentobject()	
		unwrapMod.setMidPixelSnap state
	)
	on dash_weldThresh changed val do 
	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.setWeldThreshold val
	)
	
    on unwrapUIdialog  lbuttonup p do 
	  	(
		unwrapMod = modpanel.getcurrentobject()
		unwrapMod.Edit()
	  	)
	  

)