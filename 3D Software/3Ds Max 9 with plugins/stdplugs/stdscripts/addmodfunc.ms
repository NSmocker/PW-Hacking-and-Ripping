/*
Scripts File
Purposes:  
    
    Fucnction for Macros used to apply modifiers
	AddMod Modname Example:(Addmod Bend) Will Check to see if an object can have this type of modifier applied and add it.
	

Revision History

	29 Mai 2003: Pierre-felix Breton
	modified for 3ds MAX 6 in the hope of improving performance
	
	Feb 27 1999: Frank DeLise
	created
*/

-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK


--
fn AddMod Modname =
(

if getCommandPanelTaskMode() != #modify do setCommandPanelTaskMode mode:#modify --switches to modify panel if not
modPanel.addModToSelection (Modname())

)


-- Utility function for macroScripts

Struct mcrUtils (
  
  -- return true when at editable mesh or edit mesh in modify panel
  -- pfb 27 juin 2003 : does not appear to be used at all by any of the Macros
/*
	fn EditingMesh = selection.count == 1 and
	(	Try
		(	local co_class = Classof (modPanel.GetcurrentObject ())
			co_class == Edit_Mesh or 
			co_class == Editable_Mesh
		)
		Catch (false) 
	),
*/
  -- Returns true of the modifier is applicable to the current selection set
  
  	fn ValidMod Mod = --pfb 27 juin 2003 refactored to improve performance of execution
	(	
		ValidModifier $ Mod
	),


  -- Return true of the class passed to it is currently being created.
  fn IsCreating Obj = 
  ( 	Try ((isCreatingObject Obj) and (iskindof Obj node))
  		Catch (false)
  )
)

