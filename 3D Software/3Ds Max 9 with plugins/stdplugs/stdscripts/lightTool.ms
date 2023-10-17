-- LightCreationTool Script
-- Created:       Jan 18 2005
-- Last Modified: Mar 18 2005
-- Version: VIZ 2006
-- Author: Alexander Esppeschit Bicalho, Discreet
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

/*

This file is intended to use with the creation tools available in the tool palette.

Usage is inside a macroscript. The macro will have to create a light and hand it to the tool for positioning.

Example Macros:

macroScript Free_40W_Bulb_ZBased
enabledIn:#("max", "viz", "vizr") -- new for viz 2006
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"40W Bulb Z-Based"
            tooltip:"40W Bulb Z-Based" 
            icon:#("PhotometricLights",3)
            --palettehint: Incandescent --used for publishing to palettes
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 244.214 214.62  --sets the 'incandescent' color
			n.distribution = 0 -- sets to a isotropic distribution
			n.intensityType = 1 --sets to be in cd
			n.Intensity = 38
			n.useMultiplier = on
		)

	 )
     on execute do 
	 (
	 	LightHeight = 20
		SetCommandPanelTaskMode #create
		LightCreationTool.isCreatingLight = #Free_40W_Bulb_ZBased
		LightCreationZHeight free_point LightHeight setProps lightName:#Free_40W_Bulb
	 )
     on isChecked return LightCreationTool.isCreatingLight == #Free_40W_Bulb_ZBased
)

macroScript Target_40W_Bulb
enabledIn:#("max", "viz", "vizr") -- new for viz 2006
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"40W Bulb Targeted"
            tooltip:"40W Bulb Targeted" 
            icon:#("PhotometricLights",3)
            --palettehint: Incandescent --used for publishing to palettes
(
	-- sets properties of newly created linear lights based on the newNodeCallback callback
	 fn setprops n =
	 (
	 	if isKindof n Light do -- pfb march 4 2003: make sure it only happens on lights.  the callback can also pass the target if the user click "targeted" while creating the light
		(
		 	n.useKelvin = off --forces to use the color dropdown
		 	n.rgb = color 255 244.214 214.62  --sets the 'incandescent' color
			n.distribution = 0 -- sets to a isotropic distribution
			n.intensityType = 1 --sets to be in cd
			n.Intensity = 38
			n.useMultiplier = on
		)

	 )
     on execute do 
	 (
	 	LightHeight = 20
		SetCommandPanelTaskMode #create
		LightCreationTool.isCreatingLight = #Target_40W_Bulb
		LightCreationZHeight target_point LightHeight setProps isTargeted:true LightName:#Target_40W_Bulb
	 )
     on isChecked return LightCreationTool.isCreatingLight == #Target_40W_Bulb
)

*/



struct lightCreationToolStr (lightObj, 
							lightHeight, 
							lightClass,
							lightPropfn,
							isTargeted = false,
							isCreatingLight = false)

global LightCreationTool = lightCreationToolStr()

fn LightCreationZHeight lightClass lightHeight lightPropfn isTargeted:false LightName:undefined =
(

-- Setup parameters in the Struct
-- The Tool cannot take local parameters, it needs to grab them from the struct

	lightCreationTool.lightClass = lightClass
	lightCreationTool.lightPropfn = lightPropfn
	lightCreationTool.isTargeted = isTargeted
	LightCreationTool.lightHeight = if lightHeight == undefined then 0 else lightHeight

	tool LiftedLightTool
	(
		on mousePoint clickNo do 
		(
			if clickNo == 1 do -- 1st Click position the light
			(
				local pt = gridPoint
				if lightCreationTool.isTargeted == false then -- Free light
				(
					if snapmode.active == true and snapMode.type == #3D then -- Snap ON
						in coordsys grid lightCreationTool.lightObj = LightCreationTool.LightClass pos:pt
					else -- Snap Off, lift Z
						in coordsys grid lightCreationTool.lightObj = LightCreationTool.LightClass pos:[pt.x, pt.y, lightCreationTool.Lightheight]
				)
				else -- Target Light
				(
					if snapmode.active == true and snapMode.type == #3D then -- Snap ON
						in coordsys grid lightCreationTool.lightObj = LightCreationTool.LightClass pos:pt \
							target:(targetObject())
					else -- Snap off, lift Z
						in coordsys grid lightCreationTool.lightObj = LightCreationTool.LightClass \
							pos:[pt.x, pt.y, lightCreationTool.Lightheight] target:(targetObject())
				)
				if classof lightCreationTool.lightPropfn == MAXScriptFunction do  -- Apply Properties
					lightCreationTool.lightPropfn lightCreationTool.lightObj
				if isValidNode lightCreationTool.lightObj do
					select lightCreationTool.lightObj
			)
			if clickNo == 2 then -- Release mouse = stop
			(
				#stop
			)
		)--end mousepoint

		on MouseMove clickNo do 
		(
			if (clickNo == 2) do -- Dragging the mouse moves the light (when free) or target (when targeted)
			(
				if isValidNode lightCreationTool.lightObj then
				(
					local st = gridPoint
					if lightCreationTool.isTargeted == false then -- Free Light
					(
						if snapmode.active == true and snapMode.type == #3D then -- Snap On
							in coordsys grid lightCreationTool.lightObj.pos = st
						else -- Snap Off (keep Z up)
							in coordsys grid lightCreationTool.lightObj.pos = [st.x, st.y, lightCreationTool.Lightheight]
					)
					else -- Target Light
					( -- No Snap considerations - it doesn't matter for the target
						in coordsys grid lightCreationTool.lightObj.target.pos = st
					)
				)
				else #abort
			)
		)--end mouse move
	)-- end tool

	-- Start the creation
	local status
	
	if lightClass != undefined and lightClass.creatable do -- if it cannot be created or doesn't exist, bail out
	(
	  local undoName = if lightName == undefined then lightClass.localizedName else lightName as string
	  undo label:undoName on
	  (
		status = starttool LiftedLightTool
		
		-- If it user aborted, delete the light
		if status == #abort then 
			if isValidNode lightCreationTool.lightObj do delete lightCreationTool.lightObj
		else -- ok, user created it, so let's apply the final touch - modify panel, naming, etc
		(
			if isValidNode lightCreationTool.lightObj do
			(
				if lightName != undefined do -- Name the Light based on the name passed to the function
				(
					lightCreationTool.lightObj.name = uniqueName (lightName as string)
					if isTargeted == true do -- if Target Light, name the target too
						lightCreationTool.lightObj.target.name = lightCreationTool.lightObj.name + "." + \
							Targetobject.localizedName
				)
				-- Set Command Panel and select the object
				SetCommandPanelTaskMode #modify
			)
		)
	  ) -- end Undo
	)
	
	--resets the variables and updates the UI
	lightCreationTool.lightObj = undefined
	lightCreationTool.isCreatingLight = false
	updateToolbarButtons()
	
) -- end zHeightLightTool
