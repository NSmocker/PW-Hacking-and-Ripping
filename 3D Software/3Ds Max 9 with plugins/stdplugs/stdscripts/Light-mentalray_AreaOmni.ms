/*
Scripted Plugin File
Scripted Plugin for mental ray Area Lights
3DStudio MAX Version 7.x

12/1/99  Renamed Visable label due to confusion to users to what it meant -Frank DeLise
12/1/99  Added CastShadows and Raytracing by default -Frank DeLise
2/25/2000  Updated ranges for Spinners
2/18/2004 Changed the defaults size to use something that adapt itself to the scene scale, PFB
	

--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

*/

-- include editFunctions.ms here to ensure that it is evaluated before the plugin def.
-- the default values are evaluated when the param block is evaluated, not when an instance
-- of the plugin is created. So we can't just declare InchesToSystemScale as global, it
-- needs to have been evaluated.

global InchesToSystemScale 
if InchesToSystemScale == undefined do
	filein "$max/stdplugs/stdscripts/editfunctions.ms" --LOC_Notes: do not localize this

plugin light miAreaLightomni 
	  name:"mr Area Omni" 
	  category:"Standard" 
	  extends:omnilight 
	  classID:#(112233,554433)
	  initialRollupState:0xfffe
	  autoPromoteDelegateProps:true
(  
	local leTypes = #("Sphere", "Cylinder")
	local LightIcon, LightIcon2
		           
	parameters lpbMain rollout:params 
	( 
		-- ParamBlock2 Support
		  
		Area_Enable			type:#boolean	ui:cbEnabled	default:true	animatable:true
		Area_Visible		type:#boolean	ui:cbVisible	default:false	animatable:true
				
		Area_Type			type:#integer	ui:ddList		default:1
          
		Sphere_Radius		type:#worldUnits		ui:fsRadius		default:(InchesToSystemScale(1))		animatable:true
		Cylinder_Height	    type:#worldUnits		ui:fsHeight		default:(InchesToSystemScale(1))		animatable:true
		                
		Area_U_Samples		type:#integer	ui:sSubdivU		default:5		animatable:true
		Area_V_Samples		type:#integer	ui:sSubdivV		default:5  		animatable:true					  
	) 
          
	rollout params "Area Light Parameters" 
	(
		
		CheckBox cbEnabled "On" Offset:[-5,0] Checked:true
		CheckBox cbVisible "Show Icon in Renderer" Offset:[-5,0] Checked:false

		Dropdownlist ddList "Type:" items:leTypes selection:Area_Type

		fn MR_Radius =
		(
			case ddList.selection of
			(
				1: true
				2: true
			)	
		)
			
		fn MR_HW =
		(
			case ddList.selection of
			(
				1: false
				2: true
			)	
		)
			
		spinner fsRadius "Radius:" range:[0,99999,(InchesToSystemScale(1))] Width:90 enabled:(MR_Radius ()) type:#worldunits
		spinner fsHeight "Height:" range:[0,99999,(InchesToSystemScale(1))] Width:90 enabled:(MR_HW ()) type:#worldunits
				
		Group "Samples"
		(
			spinner sSubdivU "U:" range:[1,99999,5] Width:60 Offset:[-20,0] type:#integer Across:2
			spinner sSubdivV "V:" range:[1,99999,5] Width:60 Offset:[-10,0] type:#integer
		)
 
			
		fn MR_AdjustIcon =
		(
			case ddList.selection of
			(
				1: LightIcon = SphereGizmo transform:$.transform
				2: (LightIcon = CylGizmo Transform:$.transform; LightIcon2 = CylGizmo Transform:$.transform)
			)	
		)
			
		on ddList selected sel do  
		(
			Area_Type = sel
			case sel of 
			(	 
				1:  
				(	
					fsRadius.enabled = true
					fsHeight.enabled = false
				
				)
						
				2:  
				(
					fsRadius.enabled = true
					fsHeight.enabled = true
				
				)
			)  		 
		)  
		
		on fsRadius ButtonDown do 
		(
			try(MR_AdjustIcon ())Catch()
		)
					
		on fsRadius Changed value do
		(
			Try (	
					LightIcon.radius = fsRadius.value
					LightIcon.height = fsHeight.value
					LightIcon2.radius = fsRadius.value
					LightIcon2.height = -(fsHeight.value)					
				)
			Catch ()		 
		)
				
		on fsRadius ButtonUp do 
		(
			Try (
					Delete LightIcon
					Delete LightIcon2
				) 
			Catch ()
		)
		
		on fsHeight ButtonDown do 
		(
			try(MR_AdjustIcon ())catch()
		)
							
		on fsHeight Changed value do
		(
			Try	(
					
					LightIcon.height = fsHeight.value
					LightIcon.radius = fsRadius.value
					LightIcon2.height = -(fsHeight.value)
					LightIcon2.radius = fsRadius.value	
				)
			Catch ()
		)
		
		on fsHeight ButtonUp do 
		(
			Try (
					Delete LightIcon
					Delete LightIcon2
				) 
			Catch()
		)
					
			
		
	)

	--
	-- Handler used by translator to obtain custom translation
	--
	on MR_TranslateAppend do
	(
		local MRString = StringStream ""
		local iType

		iType = Area_Type
		if Area_Type > 2 then iType = 2
		if Area_Type < 1 then iType = 1
		case iType of
		(
			--Spherical Area Light
			1:	
			(							
				if Area_Enable then 
				(
					format "\t sphere % " Sphere_Radius  to:MRString
					format "\t% %\n" Area_U_Samples Area_V_Samples   to:MRString
				)
				else
				(
					format "\t sphere\n" to:MRString
				)
			)
			
			-- Disc Area Light
			2:	
			(	
				if Area_Enable then 
				(								
					format "\t cylinder 0 0 % % " Cylinder_Height Sphere_Radius  to:MRString
					format "% % \n" Area_U_Samples Area_V_Samples   to:MRString
				)
				else
				(
					format "\t cylinder\n" to:MRString
				)
			)
		)
		if Area_Visible then
			format "\t visible\n" to:MRString

		MRString -- Send the translation to mental
	)	  
	--
	-- Handler used by translator to obtain custom validity interval
	--
	on MR_Validity do
	(
		local validity = interval currentTime currentTime
		validity
	)
	on create do
	(
		delegate.raytracedshadows = true
		delegate.Castshadows = true
	)

)
