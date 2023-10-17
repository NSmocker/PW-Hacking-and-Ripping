/*
Functions for loading a UI Scheme, saving, loading quads colors etc...

Theses functions are accessed by the Load Custom UI scheme script and the CUI/Defaults switcher.


Revision history:

Oct 25 2001: Fred Ruff, Frank Delise
	max 4.5 implementation

August 13 2003: Pierre-Felix Breton
	max 6 implementation:  
		
		pulled out of the Macro_IUScheme.mcr to allow the same function being acessed by more than one macro
		consolidated the quadsxolors functions into the same file
		
		added localization comments

--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
*/


/*
---------------------------------------------------------------------------------------
SaveQuadClr
 
It's main function is to store the Quad colors from the "Advanced Options" in the 
"Customize User Interface" dialog box.  It's secondary usage is for the Custom UI Schemes.  

That script uses this function to save out the current quad colors into the scripts 
startup directory so they will load when MAX starts.  

It also saves the quad colors 
into a .qop file to be loaded with each custom scheme.
-----------------------------------------------------------------------------------------
*/


function SaveQuadClr ColorFilePath ColorFileName Extention Remarks =
(
	try (
		local OpenColorFile = CreateFile (ColorFilePath + "\\" + ColorFileName + Extention) 
	
		local QMS = QuadMenuSettings
		OpenColorFile = CreateFile (ColorFilePath + "\\" + ColorFileName + Extention) 
		format "-- Quad Color File\n" to:OpenColorFile --LOC_NOTES: do not localize this
		format "-- Created automatically by % \n" Remarks to:OpenColorFile --LOC_NOTES: do not localize this
		format "-- To restore Quad Menu to these settings, simply run this script.\n" to:OpenColorFile --LOC_NOTES: do not localize this

		for Quadnum = 1 to 4 do
		(
			format "\n-- Quad number % colors \n" QuadNum to:OpenColorFile --LOC_NOTES: do not localize this
			format "QuadMenuSettings.SetTitleBarBackgroundColor % %\n" QuadNum (QMS.GetTitleBarBackgroundColor QuadNum) to:OpenColorFile --LOC_NOTES: do not localize this
			format "QuadMenuSettings.SetTitleBarTextColor % %\n" QuadNum (QMS.GetTitleBarTextColor QuadNum) to:OpenColorFile --LOC_NOTES: do not localize this				
			format "QuadMenuSettings.SetItemBackgroundColor % %\n" QuadNum (QMS.GetItemBackgroundColor QuadNum) to:OpenColorFile --LOC_NOTES: do not localize this
			format "QuadMenuSettings.SetItemTextColor % %\n" QuadNum (QMS.GetItemTextColor QuadNum) to:OpenColorFile --LOC_NOTES: do not localize this
			format "QuadMenuSettings.SetLastExecutedItemTextColor % %\n" QuadNum (QMS.GetLastExecutedItemTextColor QuadNum) to:OpenColorFile --LOC_NOTES: do not localize this					
			format "QuadMenuSettings.SetHighlightedItemBackgroundColor % %\n" QuadNum (QMS.GetHighlightedItemBackgroundColor QuadNum) to:OpenColorFile --LOC_NOTES: do not localize this
			format "QuadMenuSettings.SetHighlightedItemTextColor % %\n" QuadNum (QMS.GetHighlightedItemTextColor QuadNum) to:OpenColorFile --LOC_NOTES: do not localize this
			format "QuadMenuSettings.SetBorderColor % %\n" QuadNum (QMS.GetBorderColor QuadNum) to:OpenColorFile --LOC_NOTES: do not localize this
			format "QuadMenuSettings.SetDisabledShadowColor % %\n" QuadNum (QMS.GetDisabledShadowColor QuadNum) to:OpenColorFile	 --LOC_NOTES: do not localize this	
			format "QuadMenuSettings.SetDisabledHighlightColor % %\n" QuadNum (QMS.GetDisabledHighlightColor QuadNum) to:OpenColorFile --LOC_NOTES: do not localize this		
		)--end for Quadnum = 1 to 4 do
		
		format "\n-- Interaction Settings\n" to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetUseLastExecutedItem %\n" (QMS.GetUseLastExecutedItem()) to:OpenColorFile --LOC_NOTES: do not localize this
	
		format "\n-- Animation Settings\n" to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetDisplayMethod %\n" (QMS.GetDisplayMethod()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetAnimatedStepTime %\n" (QMS.GetAnimatedStepTime()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetAnimatedSteps %\n" (QMS.GetAnimatedSteps()) to:OpenColorFile --LOC_NOTES: do not localize this
	
		format "\n-- Display Settings\n" to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetSubMenuPauseTime %\n" (QMS.GetSubMenuPauseTime()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetOpacity %\n" (QMS.GetOpacity()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetRemoveRedundantSeparators %\n" (QMS.GetRemoveRedundantSeparators()) to:OpenColorFile --LOC_NOTES: do not localize this
	
		format "\n-- PositionSettings\n" to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetInitialCursorLocInBox_0to1 % %\n" (QMS.GetInitialCursorLocXInBox_0to1()) (QMS.GetInitialCursorLocYInBox_0to1()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetFirstQuadDisplayed %\n" (QMS.GetFirstQuadDisplayed()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetMirrorQuad %\n" (QMS.GetMirrorQuad()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetRepositionWhenClipped %\n" (QMS.GetRepositionWhenClipped()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetMoveCursorOnReposition %\n" (QMS.GetMoveCursorOnReposition()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetReturnCursorAfterReposition %\n" (QMS.GetReturnCursorAfterReposition()) to:OpenColorFile --LOC_NOTES: do not localize this
		
		format "\n-- Size Settings\n" to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetBorderSize %\n" (QMS.GetBorderSize()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetUseUniformQuadWidth %\n" (QMS.GetUseUniformQuadWidth()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetUseUniformItemHeight %\n" (QMS.GetUseUniformItemHeight()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetHorizontalMarginInPoints %\n" (QMS.GetHorizontalMarginInPoints()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetVerticalMarginInPoints %\n" (QMS.GetVerticalMarginInPoints()) to:OpenColorFile --LOC_NOTES: do not localize this
	
		format "\n-- Font Settings\n" to:OpenColorFile
		format "QuadMenuSettings.SetItemFontFace \"%\"\n" (QMS.GetItemFontFace()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetItemFontSize %\n" (QMS.GetItemFontSize()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetTitleFontFace \"%\"\n" (QMS.GetTitleFontFace()) to:OpenColorFile --LOC_NOTES: do not localize this
		format "QuadMenuSettings.SetTitleFontSize %\n" (QMS.GetTitleFontSize()) to:OpenColorFile --LOC_NOTES: do not localize this
		
		close OpenColorFile
		)--end try
		Catch
		(
			local str = "Error saving " + ColorFilePath + "\\" + ColorFileName + Extention +"\n(The file may be read only.)\n\nAdvanced Quad Options not saved." --LOC_NOTES: localize this
			messagebox str title:"Error" --LOC_NOTES: localize this
		)--end catch
)--function SaveQuadClr ColorFilePath ColorFileName Extention Remarks


/*
--------------------------------------------------------------------------------------------------------
Function to load a set of CUI files

It's main function is to load the set of CUI files contained in *.cui, *.qop, *.clr, *.kbd and *.mnu
Is accessed by the Load Custom UI scheme macro and CUI/DefaultUI switcher macro
------------------------------------------------------------------------------------------------------
*/


function loadCUIScheme UIScheme_Filename = 
(

	local UIScheme_Icon_Folder, UIScheme_Icon_Type, UIScheme_Icon_Display, UIScheme_Filename, UIScheme_Icon_Setup, LoadSchemename, UIScheme_Root, UIScheme_Directories	
	local UIScheme_LoadDialog, UIScheme_IconDialog
	
	global UIScheme_Bitmap_Init
	
	If UIScheme_Filename != undefined do
	(

		-------------------------------------------------------------------------------------------------------
		-- Post a note and do nothing if the user has browsed to a new location for the .ui file.
		-- Only UI files from the getdir #ui folder may be loaded.  (current max limitation)
		-------------------------------------------------------------------------------------------------------
		if ((stricmp (GetFileNamepath UIScheme_Filename) (getdir #ui + "\\") ) != 0) do -- root path of target file does not match UI folder
		(
				msgtext = "Note: Custom UI files can only be loaded from the default UI folder (" + (getdir #ui) + ")\n\n" --LOC_NOTES: localize this
				msgtext += "Please copy " + (getfilenamefile UIScheme_Filename) + ".ui and all associated UI customization files (.cui, .kbd, .qop, .clr, .mnu)\n to " + (getdir #ui) + " and retry." --LOC_NOTES: localize this
				messagebox msgtext title:"Error" --LOC_NOTES: localize this
				return()
		)
	
	
		-------------------------------------------------------------------------------------------------------
		-- Create Loading dialog
		-------------------------------------------------------------------------------------------------------
		Rollout UIScheme_LoadDialog "Custom Scheme" Width:200 Height:100 --LOC_NOTES: localize this
		(
			label lbl2 "Loading Custom Scheme"  offset:[0,30] --LOC_NOTES: localize this
			label lbl3 "Please Wait..."   --LOC_NOTES: localize this
		)
		
		CreateDialog UIScheme_LoadDialog width:200 height:100
	
		-------------------------------------------------------------------------------------------------------
		-- Load set of CUI files
		-------------------------------------------------------------------------------------------------------
	
			LoadSchemeName = ((getdir #ui + "\\") + (GetFileNameFile UIScheme_Filename))
	
			-- reads the pull down menus and quads definition file
			if (doesFileExist (LoadSchemeName +".mnu" )) == true do 
			(
				MenuMan.LoadMenuFile (LoadSchemeName +".mnu" )
				--print ((LoadSchemeName +".mnu") + " loaded.")
			)
			
			-- reads the ui color definition file
			if (doesFileExist (LoadSchemeName +".clr" )) == true do
			(	
				ColorMan.LoadColorFile (LoadSchemeName +".clr" )
				--print ((LoadSchemeName +".clr") + " loaded.")
			)
			
			-- reads the keyboard shortcuts definition file
			if (doesFileExist (LoadSchemeName +".kbd" )) == true do 
			(
				ActionMan.LoadKeyboardFile (LoadSchemeName +".kbd" )
				--print ((LoadSchemeName +".kbd") + " loaded.")
			)
			
			-- reads the toolbars definition file
			if (doesFileExist (LoadSchemeName +".cui" )) == true do 
			(
				cui.loadConfig (LoadSchemeName +".cui" )
				--print ((LoadSchemeName +".cui") + " loaded.")				
			)
	
			--reads the quads colors (really, qop files contains MXS code that is evaluated)
			if (doesFileExist (LoadSchemeName +".qop" )) == true do 
			(
				filein (LoadSchemeName +".qop")
			)

			-- reads the brush presets definition file
			if (doesFileExist (LoadSchemeName +".bpr" )) == true do 
			(
				local Bpr = BrushPresetMgr
				if Bpr != undefined do Bpr.LoadPresetFile (LoadSchemeName +".bpr" )
				--print ((LoadSchemeName +".bpr") + " loaded.")				
			)			
		-------------------------------------------------------------------------------------------------------
			-- Save Quad colors as startup
		-------------------------------------------------------------------------------------------------------
			SaveQuadClr (GetDir #MaxRoot + "stdplugs\\stdscripts") "QuadColor_Startup" ".ms" (LoadSchemeName + " Scheme") --LOC_NOTES: do not localize this
	--					Print UIScheme_Filename
		-------------------------------------------------------------------------------------------------------
			-- Save CUI file as startup so your changes are loaded when restarting MAX
		-------------------------------------------------------------------------------------------------------
			cui.saveConfigAs ("MaxStartUI.cui") --LOC_NOTES: do not localize this
		-------------------------------------------------------------------------------------------------------
			-- If an Icon .ui file exisit, Use it when loading Scheme
		-------------------------------------------------------------------------------------------------------
			
			DestroyDialog (UIScheme_LoadDialog)

			
	-- reads the toolbars definition file
	if (doesFileExist (LoadSchemeName +".ui" )) == true do 
	(
			
			-- looks for the bitmap thumbnail to display in the Icons loader dialog
			UIScheme_Icon_Folder = OpenFile (LoadSchemeName + ".ui")
			If UIScheme_Icon_Folder != undefined do 
			(
				UIScheme_Icon_Type = (ReadLine UIScheme_Icon_Folder)
				UIScheme_Root = (GetDir #maxroot + "ui\\")

				if (doesFileExist (UIScheme_Root + UIScheme_Icon_Type + "\\CreateTypes_16i.bmp")) == true 
				then UIScheme_Bitmap_Init  = (UIScheme_Root + UIScheme_Icon_Type + "\\CreateTypes_16i.bmp")
				else 
				(
					if (doesFileExist (UIScheme_Root + "Icons" + "\\Null_24i.bmp")) == true do
					(
						UIScheme_Bitmap_Init = (UIScheme_Root + "Icons" + "\\Null_24i.bmp")
					)--end if
				)--end if
		
			)--end if UIScheme_Icon_Folder != undefined
				
		
		
		
		-------------------------------------------------------------------------------------------------------
			-- Loading Icons Dialog
		-------------------------------------------------------------------------------------------------------		



			Rollout UIScheme_IconDialog "Custom Scheme" Width:200 Height:200
			(
				Bitmap UIScheme_Icon_Display "" filename:UIScheme_Bitmap_Init
				label lbl2 "Loading Icons"  offset:[0,5]
				label lbl3 "Please Wait..."  
				/*
				On UIScheme_IconDialog Open do
				(
					if (UIScheme_Bitmap_Init != undefined) do UIScheme_Icon_Display.filename = UIScheme_Bitmap_Init		
				)--end On UIScheme_IconDialog Open
				*/				
			)--end rollout
			
			CreateDialog UIScheme_IconDialog width:200 height:100
	
		-------------------------------------------------------------------------------------------------------
				-- Load Icons
		-------------------------------------------------------------------------------------------------------
	
				ColorMan.SetIconFolder UIScheme_Icon_Type
				Close UIScheme_Icon_Folder
				UIScheme_Bitmap_Init = undefined	
				
				DestroyDialog UIScheme_IconDialog
				forceCompleteRedraw()	
	
	)--end if (doesFileExist (LoadSchemeName +".ui" )) == true
	)--end if UIScheme_Filename != undefined do

)--end function loadCUIScheme UIScheme_Filename