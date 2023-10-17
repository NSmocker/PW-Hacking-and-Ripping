-------------------------------------------------------------------------------
-- Macro_Mixer.mcr
--
-- History:
--  02.22.05 - Michael Zyracki
--
-- Copyright ©2005, Discreet
-------------------------------------------------------------------------------




macroScript OpenMotionMixerDlg
	category:"Mixer"
	tooltip:"Motion Mixer (Open)"
	buttontext:"Motion Mixer (Open)..."
(

	on execute do
	(
		themixer.showmixer()
	)

)


macroScript CloseMotionMixerDlg
	category:"Mixer"
	tooltip:"Motion Mixer (Close)"
	buttontext:"Motion Mixer (Close)..."
(

	on execute do
	(
		themixer.hidemixer()
	)

)


macroScript OpenMotionMixerDlg
	category:"Mixer"
	tooltip:"Motion Mixer (Open)"
	buttontext:"Motion Mixer (Open)..."
(

	on execute do
	(
		themixer.showmixer()
	)

)


macroScript ToggleMotionMixerDlg
	category:"Mixer"
	tooltip:"Motion Mixer"
	buttontext:"Motion Mixer..."
(

	on execute do
	(
		themixer.togglemixer()
	)

)