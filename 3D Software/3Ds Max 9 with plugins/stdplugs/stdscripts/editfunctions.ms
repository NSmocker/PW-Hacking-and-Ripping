/*

-- Edit Functions Script File
--
-- Created:  		May 17 2000
--
-- Version:  3D Studio Max Version 6.0
--
-- 

Revision History

	Mai 26th 2003, pfb
               added in 3ds MAX 6
        Jan 30th 2003, pfb
		added product id check for VIZR:  hardcoded to meters
		
	Sept 4th 2001, pfb
	Added InchesToSystemScale function

	main usage: 
		allowing creation of objects based on the current system units, in order to always be in 'normal world' scale
		for example, a fluorescent panel is usually 4ft long, no matter if the system units are in cm, miles or inches.
*/

 
-- Filter and Operation Functions for conext sensitve menus.
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- 


fn ApplyOperation ctype oper =
(
	If (Modpanel.getcurrentObject () == $.baseobject) then oper $
	If Classof (Modpanel.getcurrentObject ()) == ctype then (oper $.modifiers[modPanel.getModifierIndex $ (Modpanel.getcurrentObject ())])	
)

-------------------------------------------------------------------------------------
-- Sept 4th 2001, pfb
-- Added Functions for VIZ R4
-------------------------------------------------------------------------------------


-- pass an inch value and returns corresponding value based on the system units
-- it is called by the 'Preset Lights' macros in the Macro_ObjectsLights.mcr file and by the mentalray scripted lights

fn InchesToSystemScale val=
(		
	if productAppID != #vizR 
	then
	(
		case units.systemtype of
		(
			#inches:val = val
			#feet:val = 0.08333333333333333 * val
			#miles:val = 0.000015782828282828283 * val
			
			#millimeters:val = 25.4 * val
			#centimeters:val = 2.54 * val
			#meters:val = 0.0254 * val
			#kilometers:val = 0.000025399999999999997 * val
		)
	
	)
	else val = 0.0254 * val

	return val
)