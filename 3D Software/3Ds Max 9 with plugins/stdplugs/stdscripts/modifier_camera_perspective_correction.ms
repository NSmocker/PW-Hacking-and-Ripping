/*
scripted plugin: modifier
author: Pierre-Felix Breton
creation date: August 20th 2001

description:
	This scripted modifer is based on the existing Skew modifier (thanks to Alex Bicalho and finding this neat trick)
	Once applied on the camera, it guesses the right skew amount based on the world camera position.
	The user can always changes the '2 point perspective' correction amount by changing the amount and angle values.
	
	Since it's based on the skew modifer, it will work on geometry but the effect is no real magic.
	
version history:

	Jan 7th 2003: added version checking for skew amount to support MAX 4, VIZ 4, MAX 5 and VIZ R

	Feb 19 2002:pfb fixed values for 3dsmax 4.2

	Oct 17 2001 - 04: pfb
		updates to support changes made to the new camera icon: it required a new 'guessed' value

	Sept 12 2001 - 03: p.f.breton
		file renammed from 'modifier.camera.perspective.correction.ms' to 'modifier_camera_perspective_correction.ms'
		made the modifier invisible and using the new 'on applied' event
	
	02: changes from A.B.
	01: initial implementation	
*/


plugin modifier CamPerspCorrect 
name:"Camera Correction" 
classID:#(0xe5d36ef0, 0x5e0178bd)
extends:Skew 
replaceUI:true 
version:1
invisible:true
silenterrors:false
( 

		--////// PARAMETERS //////////////////////////////////////////////	
	parameters main rollout:rltCamPerspCorrect
	( 
		paramPerspectCorrectAmount type:#float animatable:true ui:spnPerspectCorrectAmount 
		paramPerspectCorrectDir type:#float animatable:true ui:spnPerspectCorrectDir default:90
		
		on paramPerspectCorrectAmount set val do 
			(
				delegate.amount = val
			)

		on paramPerspectCorrectDir set val do 
			(
				delegate.direction = val
			)
			
	) --end parameters

	--guess skew values
	mapped fn GetCorrectionAmount obj = 
	(
		-- local variables
		local SkewAmnt = 0
		local Dist = 0
		local CamPos
		local CamTargPos
		local CamAngle
		local r
		local h
		
		/* operates if a single object is selected only and if it a camera
		   the skew modifer will not work well on camera instances
		   assigning the same distortion on cameras @ different position
		   defeats the purposes of figuring out automaticaly
		   the skew amount
		*/

			if classof(obj) == FreeCamera do Dist = obj.target_Distance
			if classof(obj) == Targetcamera do Dist = obj.targetDistance
			
			CamPos = obj.pos
			CamTargPos = (obj.pos +(-obj.dir * dist))
						
			-- do some maths based in this info
			CamAngle= asin((CamTargPos.z - campos.z)/Dist)
			
			-- compute the skew amount.
			-- use a value of 39.799286 for VIZ 4, MAX 5 and 6
			-- use a value of 12.8 for MAX 4, VIZR
			
			if (productAppID == undefined) or (productAppID == #vizR)  --max 4.2 returns undefined while VIZ 4 and above return a value like #viz
				then SkewAmnt = - 12.8 * tan(CamAngle) -- use a value of 39.799286 instead of 12.8 for VIZ 4 and MAX 5 since the camera icon changed
				else SkewAmnt = - 39.799286 * tan(CamAngle)
				
			if abs(CamAngle) > 75 do SkewAmnt = 0 -- AB: normalizes the SkewAmount if the rotation is too large
		
	
		
		return SkewAmnt -- returns the skew amount to the modifier
	)--end fn
	
	-- this initialize the modifier.  it is called when applying it and when pressing the reset button
	fn InitModifierSettings obj = 
	(
		try (
				delegate.axis = 2 --sets the skew to the Y axis
				if classof obj.controller == lookat 
					then delegate.direction = 90.0 - obj.controller.roll_angle 
					else delegate.direction = 90.0 -- sets Skew to 90 deg in direction

				delegate.amount = GetCorrectionAmount(obj) --guess the amount based on camera position - AB: used Selection[1] instead of $
				paramPerspectCorrectAmount = delegate.amount --updates the modifier parameter
				paramPerspectCorrectDir = delegate.direction --updates the modifier parameter
			)
	   catch ()

	) --end fn
	


	--////// ROLLOUT //////////////////////////////////////////////
	rollout rltCamPerspCorrect "2 point perspective correction" width:163 height:137
	(
	
		--/////////////  rollout ui //////////////////////////////
		spinner spnPerspectCorrectAmount "Amount: " pos:[37,5] width:112 height:16 range:[-500,500,0] type:#float scale:0.01
		spinner spnPerspectCorrectDir "Direction: " pos:[31,26] width:118 height:16 range:[-180,180,90] type:#float scale:0.01
		
		button btnUpdateCorrection "Guess.." pos:[72,48] width:77 height:16

		Group "" -- pos:[4,64] width:154 height:66
		(
		label lbl_01 "Use this modifier to obtain" offset:[0,-6] -- pos:[18,73] width:126 height:13
		label lbl_02 "2-point perspective effect" offset:[0,-4] -- pos:[21,91] width:120 height:13
		label lbl_03 "on a camera" offset:[0,-4] -- pos:[52,109] width:59 height:13
		)

		--/////////////  rollouts events //////////////////////////////			
		on btnUpdateCorrection pressed do
		(
			InitModifierSettings(selection[1])
		)
		
		
	) -- end rollout
	
	
	--/////////////  plugin events //////////////////////////////	
	on attachedToNode obj do
	(
		--tests if it's a camera and a single selection
		if iskindof obj Camera do InitModifierSettings(obj)
	)
) -- end plugin
