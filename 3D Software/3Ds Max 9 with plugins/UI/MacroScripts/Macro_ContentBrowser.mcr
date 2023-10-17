/*
*/
macroScript StartContentBrowser
	enabledIn:#("VIZR", "viz")
	ToolTip:"Start Content Browser"
	ButtonText:"Start Content Browser"
	Category:"Architectural Desktop Tools"
	InternalCategory:"ADT Tools"
	Icon:#("ACADCB",1) -- this points the icon to the ACADCB.BMP file, 1st icon
(
	
	on isEnabled return (doesFileExist(getDir #maxroot + "AECCB47.EXE") or doesFileExist(getDir #maxroot + "AECCB47D.EXE"))
	on execute do
	(
		if doesFileExist(getDir #maxroot + "AECCB47.EXE") then
			shelllaunch (getDir #maxroot + "AECCB47.EXE") ""
		else if doesFileExist(getDir #maxroot + "AECCB47D.EXE") do
			shelllaunch (getDir #maxroot + "AECCB47D.EXE") ""
	)
)
