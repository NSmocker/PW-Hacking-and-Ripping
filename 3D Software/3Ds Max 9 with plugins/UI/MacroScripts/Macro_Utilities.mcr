/*
  
Macro Scripts File
Created:  24 mai 2003
Version:  3ds MAX 6
Author:   PF Breton

Macro Scripts that fires some Utilities
Purpose: Hooking up some of them from the Main menu

Revision History:
   24 mai 2003, initial implementation for 3ds max 6, pfbreton

   4 dec 2003, adding File Link Manager launcher for 3ds max 6 and  File Link Extension, pfbreton

	17 dec 2003, Pierre-Felix Breton, 
		added File Link Manager Launcher
		added Substitute Manager Launcher

	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products

Macro Scripts that fires some Utilities
Purpose: Hooking up some of them from the Main menu

*/
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

MacroScript Panoramic_Exporter
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Panorama Exporter..."
category:"Render" 
internalcategory:"Render" 
Tooltip:"Panorama Exporter..." 
(
	try(
            max utility mode
	    utilitypanel.openutility Panorama_Exporter
		) catch()
)


MacroScript Color_Clip_Board
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Color Clipboard..."
category:"Tools" 
internalcategory:"Tools" 
Tooltip:"Color Clipboard..." 
(
	try (utilitypanel.openutility Color_Clipboard) catch()
)


MacroScript Assign_Vertex_Colors
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Assign Vertex Colors..."
category:"Tools" 
internalcategory:"Tools" 
Tooltip:"Assign Vertex Colors..." 
(
	try (utilitypanel.openutility Assign_Vertex_Colors) catch()
)


MacroScript Camera_Match
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Camera Match..."
category:"Tools" 
internalcategory:"Tools" 
Tooltip:"Camera Match..." 
(
	try (utilitypanel.openutility Camera_Match) catch()
)


MacroScript Resource_Collector
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Resource Collector..."
category:"File" 
internalcategory:"File" 
Tooltip:"Resource Collector..." 
(
	try(
		max utility mode
		utilitypanel.openutility Resource_Collector
	) catch()
)

MacroScript Map_Path_Editor
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Map/Photometric Path Editor..."
category:"File" 
internalcategory:"File" 
Tooltip:"Map/Photometric Path Editor..." 
(
	try(
		max utility mode
		utilitypanel.openutility Bitmap_Photometric_Paths
	) catch()
)


MacroScript Channel_Info
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Channel Info..."
category:"Tools" 
internalcategory:"Tools" 
Tooltip:"Channel Info Editor..." 
(
	on execute do	(
		try(
			channelInfo.Dialog ()
		) catch()
	)
	on closeDialogs do (
		try (
			channelInfo.closeDialog()
		) catch ()
	)
	on isChecked return (
		try (
			channelInfo.IsChecked ()
		) catch ( false )
	)
)

MacroScript Launch_VMS
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
ButtonText:"Visual MAXScript Editor..."
Category:"MAX Script" 
internalCategory:"MAX Script" 
Tooltip:"Visual MAXScript Editor..." 
(
 vms = visualMS.CreateForm()
 vms.Open()
)

MacroScript Substitute_Manager
enabledIn:#("vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Substitute Manager..."
category:"Tools" 
internalcategory:"Tools" 
Tooltip:"Substitute Manager..." 
(
	try (utilitypanel.openutility Substitute_Manager) catch()
)

MacroScript Lighting_Data_Export
enabledIn:#("vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Lighting Data Export..."
category:"Tools" 
internalcategory:"Tools" 
Tooltip:"Lighting Data Export..." 
(
	try (utilitypanel.openutility ShineExp) catch()
)
