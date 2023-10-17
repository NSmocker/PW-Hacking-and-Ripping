/*
 
***************************************************************************
Macro_Scripts File
Author:   Adam Felt
Macro_Scripts that implement some animation specific methods

Revision History
    May 26, 2004 - Adam Felt - Created
    December 14, 2004 - Nicolas Léonard - added ToggleLimits
	
-- MODIFY THIS AT YOUR OWN RISK
***************************************************************************

*/

macroScript DeleteSelectedAnimation
enabledIn:#("max", "viz")
buttontext:"Delete Selected Animation"
category:"Animation Tools" 
internalCategory:"Animation Tools" 
tooltip:"Delete Selected Animation" 
(
	On isEnabled Return 
	(
		$selection.count != 0 
	)
	
	
	On Execute Do
	(
		maxOps.deleteSelectedAnimation()
	)
)

macroScript OpenReactionManager
	enabledIn:#("max")
	buttontext:"Reaction Manager"
	category:"Animation Tools"
	toolTip:"Reaction Manager"
(
	reactionMgr.openEditor()
)

macroScript ToggleLimits
	enabledIn:#("max")
	buttontext:"Toggle Limits"
	category:"Animation Tools"
	toolTip:"Toggle Limits"
(
	Fn toggleAnimLimits anim &limitTab &toggleValue =
	(
		local ILimitControl
		if anim != undefined do
		(
			if (ILimitControl = getInterface anim #limits) != undefined do		
			(
				if toggleValue and anim.IsEnabled() do
				(
					toggleValue = false
				)
				append limitTab anim 
			)
			
			for i = 1 to anim.numsubs do
			(
				toggleAnimLimits (getSubAnim anim i) &limitTab &toggleValue
			) 
		)
	)

	On isEnabled Return 
	(
		$selection.count != 0 
	)
	
	On Execute Do
	(
		local limitTab = #()
		local toggleValue = true
		for s in selection do
		(
			toggleAnimLimits s &limitTab &toggleValue
		)
		for limit in limitTab do 
		(
			limit.SetEnabled toggleValue
		)
	)
)

-- END OF FILE
