/*
Macro_scripts for UVW Unwrap

Version: 3dsmax 6



Revision History:
		
	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products
		moved functions and dialog definition into the /stdplug/stdscripts/modifier_uvwunwrap_dialog.ms

*/




macroScript OpenUnwrapUI
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	category:"UVW Unwrap"           
	internalcategory: "UVW Unwrap"  --do not localize
	toolTip:"OpenUnwrapUI"		
	silentErrors:TRUE

	
(

  unwrapModPKW = modpanel.getcurrentobject()
  xPKW =  unwrapModPKW.GetWindowX()
  yPKW =  unwrapModPKW.GetWindowY()
  hPKW =  unwrapModPKW.GetWindowH()
  if (hPKW==0) then
  	(
	yPKW = -10
	)  
  pPKW = Point2 xPKW (yPKW+hPKW)
  CreateDialog UnwrapUIDialog pos:pPKW style:#(#style_border)
  
  if (hPKW==0) then
  	(
	unwrapUIdialog.height = 0 
	)
  
)


macroScript MoveUnwrapUI
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	category:"UVW Unwrap"           
	internalcategory: "UVW Unwrap"  --do not localize
	toolTip:"MoveUnwrapUI"	
	silentErrors:TRUE

	
(
  unwrapModPKW = modpanel.getcurrentobject()
  xPKW = unwrapModPKW .GetWindowX()
  yPKW = unwrapModPKW .GetWindowY()
  hPKW = unwrapModPKW .GetWindowH()
  
  if (hPKW==0) then  
  	(
	yPKW = -10
	)

  pPKW = Point2 xPKW (yPKW+hPKW)
  SetDialogPos UnwrapUIDialog pPKW
    
  if (hPKW==0) then
  	(
	unwrapUIdialog.height = 0 
	)
   else
    (
	if 	(UnwrapUIDialog.dash_options.state==TRUE) then
		(
		if (unwrapUIdialog.height != 163 ) then
			unwrapUIdialog.height = 163  
		)
	else 
		(
		if (unwrapUIdialog.height != 78 ) then
			unwrapUIdialog.height = 78  
		)
	unwrapUIdialog.UpdateUI()
	)
)


macroScript CloseUnwrapUI
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
	category:"UVW Unwrap"           
	internalcategory: "UVW Unwrap"  --do not localize
	toolTip:"CloseUnwrapUI"
	silentErrors:TRUE

	
(
  DestroyDialog UnwrapUIDialog
)
