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

plugin light miAreaLight 
	  name:"mr Area Spot" 
	  category:"Standard" 
	  extends:targetSpot 
	  classID:#(112233,554434)
	  initialRollupState:0xfffe
	  autoPromoteDelegateProps:true
(  
	local leTypes = #("Rectangle", "Disc")
	local lfHgt, lfWid
	local LightIcon
		           
	parameters lpbMain rollout:params 
	( 
		-- ParamBlock2 Support
		  
		Area_Enable			type:#boolean	ui:cbEnabled	default:true	animatable:true
		Area_Visible		type:#boolean	ui:cbVisible	default:false	animatable:true
				
		Area_Type			type:#integer	ui:ddList		default:1
          
		Disc_Radius			type:#worldUnits		ui:fsRadius		default:(InchesToSystemScale(1))		animatable:true
		Rectangle_Height	type:#worldUnits		ui:fsHeight		default:(InchesToSystemScale(1))		animatable:true
		Rectangle_Width		type:#worldUnits		ui:fsWidth		default:(InchesToSystemScale(1))		animatable:true
                
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
				1: false
				2: true
			)	
		)
			
		fn MR_HW =
		(
			case ddList.selection of
			(
				1: true
				2: false
			)	
		)
			
		spinner fsRadius "Radius:" range:[0,99999,(InchesToSystemScale(1))] Width:90 enabled:(MR_Radius ()) type:#worldunits
		spinner fsHeight "Height:" range:[0,99999,(InchesToSystemScale(1))] Width:90 enabled:(MR_HW ()) type:#worldunits
		spinner fsWidth "Width:" range:[0,99999,(InchesToSystemScale(1))] Width:90 enabled:(MR_HW ()) type:#worldunits
		Group "Samples"
		(
			spinner sSubdivU "U:" range:[1,99999,5] Width:60 Offset:[-20,0] type:#integer Across:2
			spinner sSubdivV "V:" range:[1,99999,5] Width:60 Offset:[-10,0] type:#integer
		)
 
			
		fn MR_AdjustIcon =
		(
			case ddList.selection of
			(
				1: LightIcon = BoxGizmo transform:$.transform
				2: LightIcon = CylGizmo transform:$.transform
			)	
		)
			
		on ddList selected sel do  
		(
			Area_Type = sel
			case sel of 
			(	 
				1:  
				(	
					fsRadius.enabled = false
					fsHeight.enabled = true
					fsWidth.enabled  = true
				)
						
				2:  
				(
					fsRadius.enabled = true
					fsHeight.enabled = false
					fsWidth.enabled  = false
				)
			)  		 
		)  
		
		on fsRadius ButtonDown do 
		(
			MR_AdjustIcon ()
		)
					
		on fsRadius Changed value do
		(
			Try (LightIcon.radius = Value) Catch ()
		)
				
		on fsRadius ButtonUp do 
		(
			Try (Delete LightIcon) Catch ()
		)
		
		on fsHeight ButtonDown do 
		(
			try(MR_AdjustIcon ())Catch()
		)
							
		on fsHeight Changed value do
		(
			Try
			(
				LightIcon.length = Value
				LightIcon.height = 0
				LightIcon.width = fsWidth.value
			)
			Catch ()
		)
		
		on fsHeight ButtonUp do 
		(
			Try (Delete LightIcon) Catch ()
		)
					
		on fsWidth ButtonDown do 
		(
			try(MR_AdjustIcon ())Catch()
		)
							
		on fsWidth Changed value do
		(
			Try
			(
				LightIcon.width = Value
				LightIcon.height = 0
				LightIcon.length = fsHeight.value
			)
			Catch ()
		)
			
		on fsWidth ButtonUp do 
		(
			Try (Delete LightIcon) Catch ()
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
			--Rectangle Area Light
			1:	
			(							
				if Area_Enable then 
				(
					lfHgt = Rectangle_Height / 2
					lfWid = Rectangle_Width / 2
					format "\t rectangle 0 % 0 % 0 0 " lfHgt lfWid  to:MRString
					format "% %\n" Area_U_Samples Area_V_Samples   to:MRString
				)
				else
				(
					format "\t rectangle\n" to:MRString
				)
			)
			
			-- Disc Area Light
			2:	
			(	
				if Area_Enable then 
				(								
					format "\t disc 0 0 -1 % " Disc_Radius  to:MRString
					format "% % \n" Area_U_Samples Area_V_Samples   to:MRString
				)
				else
				(
					format "\t disc\n" to:MRString
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
