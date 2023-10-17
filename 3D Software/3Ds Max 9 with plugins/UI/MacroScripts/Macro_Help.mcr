/*

***************************************************************************
Macro_Scripts File
Author:   Attila Szabo
Macro_Scripts that implement some of the Help menu items

Revision History
    Aug 06, 2003 - aszabo - Created
	
	12 dec 2003, Pierre-Felix Breton, 
		added product switcher: this macro file can be shared with all Discreet products
		consolidated the hotkey movie macro in this file

-- MODIFY THIS AT YOUR OWN RISK
***************************************************************************

*/


macroScript Help_IntroAndNewFeaturesGuide
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
buttontext:"&New Features Guide..."
category:"Help" 
internalCategory:"Help" 
tooltip:"New Features Guide" 
(
	local fname = "\\NEWFEATURES.PDF"
	local fpath = getdir #help
	local strErrMsg = "We are unable to display the New Features Guide.\n\nPlease make sure that Adobe Acrobat Reader is properly\ninstalled on your system and then try displaying it again."
	local strMsgTitle = ""
	if (productAPPID == #viz) do 
	(
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do 
	(
		strMsgTitle = "3ds max"
	)
		
	On isEnabled Return 
	(
		(getfiles (fpath + fname)).count != 0 
	)
	
	
	On Execute Do
	(
		try
		(
			if (fpath != undefined) do
			(
				res = ShellLaunch (fpath + fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

MacroScript Help_New_Features_Workshop
enabledIn:#("viz") 
ButtonText:"New Features &Workshop..."
category:"Help" 
internalcategory:"Help" 
Tooltip:"New Features Workshop" 
(
	fname = "\\viz_nfw.chm"
	fpath = getdir #help
	
	On isEnabled Return 
	(
		(getfiles (fpath + fname)).count != 0 
	)
	strMsgTitle = "Autodesk VIZ"
	local strErrMsg = "We are unable to display the New Features Workshop help.\n\nPlease make sure that your help (.chm) viewer is properly\ninstalled on your system and then try displaying it again."
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fpath + fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

MacroScript Help_QuickStart_Guide
enabledIn:#("vizr") --pfb: 2003.12.12 added product switch
ButtonText:"Quick Start Guide"
category:"Help" 
internalcategory:"Help" 
Tooltip:"Quick Start Guide" 
(
	fname = "\\VIZ_RENDER_QUICK_START_GUIDE.PDF"
	fpath = getdir #help
	
	On isEnabled Return 
	(
		(getfiles (fpath + fname)).count != 0 
	)
	
	
	On Execute Do
	(
		try
		(
			if (fpath != undefined) do
			(
				ShellLaunch (fpath + fname) ""
			)
		) 
		catch()
	)
)

macroScript Help_Web_OnlineSupport
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
buttontext:"Online &Support..."
category:"Help" 
internalCategory:"Help" 
tooltip:"Online Support" 
(
	local fname = ""
	local strMsgTitle = ""	
	
	if (productAPPID == #vizR) do -- msw 04 Feb 2004: VIZR
	(
		fname = "http://www.autodesk.com/support"
		strMsgTitle = "VIZ Render"
	)
	if (productAPPID == #viz) do -- pfb 19 Dec 2003: VIZ
	(
		fname = "http://www.autodesk.com/viz2005onlinesupport"
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do -- pfb 19 Dec 2003: MAX
	(
		local fname = "http://www.autodesk.com/3dsmax-support"
		strMsgTitle = "3ds max"
	)

	local strErrMsg = "We are unable to display the Online Support web page.\n\nPlease make sure that your web browser is properly\ninstalled on your system and then try displaying it again."
		
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

macroScript Help_Web_Updates
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
buttontext:"&Updates..."
category:"Help" 
internalCategory:"Help" 
tooltip:"Online Updates" 
(
	local fname = ""
	local strMsgTitle = ""	

	if (productAPPID == #viz) do -- pfb 19 Dec 2003: VIZ
	(
		fname = "http://www.autodesk.com/viz2005updates"
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do -- pfb 19 Dec 2003: MAX
	(
		fname = "http://www.autodesk.com/3dsmax-updates "
		strMsgTitle = "3ds max"
	)
	
	local strErrMsg = "We are unable to display the Updates web page.\n\nPlease make sure that your web browser is properly\ninstalled on your system and then try displaying it again."
		
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

macroScript Help_Web_Resources
enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
buttontext:"&Resources..."
category:"Help" 
internalCategory:"Help" 
tooltip:"Online Resources" 
(

	local fname = ""
	local strMsgTitle = ""	
        
    if (productAPPID == #vizR) do -- msw 04 Feb 2004
	(
		fname = "http://www.autodesk.com/us/archdesk/html/adt_plugins/adt_plugins.htm"
		strMsgTitle = "VIZ Render"
	)
	if (productAPPID == #viz) do -- pfb 19 Dec 2003: VIZ
	(
		fname = "http://www.autodesk.com/viz2005helpmenu"
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do -- pfb 19 Dec 2003: MAX
	(
		fname = "http://www.autodesk.com/3dsmax-resources"
		strMsgTitle = "3ds max"
	)

	
	local strErrMsg = "We are unable to display the Resources web page.\n\nPlease make sure that your web browser is properly\ninstalled on your system and then try displaying it again."
		
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

macroScript Help_Web_Training
enabledIn:#("max") --pfb: 2003.12.12 added product switch
buttontext:"&Training..."
category:"Help" 
internalCategory:"Help" 
tooltip:"Training" 
(

	local fname = ""
	local strMsgTitle = ""	
        
    if (productAPPID == #vizR) do
	(
		fname = "http://www.autodesk.com/"
		strMsgTitle = "VIZ Render"
	)
	if (productAPPID == #viz) do 
	(
		fname = "http://www.autodesk.com/"
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do 
	(
		fname = "http://www.autodesk.com/me_training"
		strMsgTitle = "3ds max"
	)

	
	local strErrMsg = "We are unable to display the Resources web page.\n\nPlease make sure that your web browser is properly\ninstalled on your system and then try displaying it again."
		
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)

macroScript Help_Web_Partners
enabledIn:#("max", "viz") --pfb: 2003.12.12 added product switch
buttontext:"&Partners..."
category:"Help" 
internalCategory:"Help" 
tooltip:"Online Partners" 
(
	local fname = ""
	
	local strMsgTitle = ""
	if (productAPPID == #viz) do -- pfb 19 Dec 2003: VIZ
	(
		fname = "http://www.autodesk.com/viz-content"
		strMsgTitle = "Autodesk VIZ"
	)
	if (productAPPID == #max) do -- pfb 19 Dec 2003: MAX
	(
		fname = "http://www.autodesk.com/3dsmax-developers"
		strMsgTitle = "3ds max"
	)	
        
	local strErrMsg = "We are unable to display the Partners web page.\n\nPlease make sure that your web browser is properly\ninstalled on your system and then try displaying it again."
	On Execute Do
	(
		try
		(
			if (fname != undefined) do
			(
				res = ShellLaunch (fname) ""
				if (res == false) then
					MessageBox strErrMsg  title:strMsgTitle
			)
		) 
		catch()
	)
)


macroScript HotkeyFlash 
enabledIn:#("max") --pfb: 2003.12.12 added product switch, aszabo|feb.06.04|No hotkey map for VIZ
category:"Help" 
internalCategory:"Help"
tooltip:"Hotkey Flash Movie" 
(
	rollout rFlashError "Hotkey Map"
	(
		label lbl "Cannot create Flash ActiveX player, please get the \nlatest player from " height:50 offset:[100,10] across:2
		hyperLink hl "http://www.macromedia.com" address:"http://www.macromedia.com/software/flash/" color:blue hoverColor:red offset:[-50,24]
		button btn "Ok" height:25 width:60 offset:[0, -10]

		on btn pressed do destroyDialog rFlashError	
	)
	rollout rHotkeyFlash "Hotkey Map"
	( 
		activeXControl axFlash "ShockwaveFlash.ShockwaveFlash.5" height:300 width:600 align:#center offset:[0,-5]
		
	 	on rHotkeyFlash open do
		( 
			local vText = (getDir #maxroot) + "\\splash.cfg"
			local vMovie = (getDir #maxroot) + "\\hotkeymap.swf"
	
			local vData = ""
			local vStream = openFile vText
			axFlash.Menu = false
		 	while not eof vStream do vData += readLine vStream
			close vStream			
			axFlash.movie =  vMovie
		)	
	)
	on execute do
	(
		try
		(
			createDialog rHotkeyFlash width:600 height:300 escapeEnable:false
		)
		catch 
		( 			
			destroyDialog rHotkeyFlash
			createDialog rFlashError width:300 height:100 modal:true
		)
	)
)

-- END OF FILE