-- Added functions for improved scripter workflow
-- Created:  		April 7 2000
-- Last Updated: 	April 7 2000
--
-- Author:Frank DeLise
-- Version:3D Studio Max Release 4.0
--
-- -- This script Allows you to add your own functions for help when writting scripts
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
--***********************************************************************************************

-- Example:  Help "Box" 

fn Help What = 
(
	If what == "" then 
	(
		Format "%\n" "You must type in an command you are looking for like" to:Listener
		Format "%\n" "Help \"Box\", which will list all commands with the name Box in it." to:Listener
		Format "%\n" "Help All, will list all commands" to:Listener
	)
	Else if what == all then
	(
		Apropos ""
	)
	Else	
	(
		Try (Apropos (What))
		Catch (Format "%\n" "No Info Found, Example: Help \"Box\"" to:Listener)
	)
)

-- Example Show $

fn Show What =
(	
	Try 
	(	if (isDeleted What) then
			format "%\n" "<<Deleted MAX object>>" to:listener
		else
			ShowProperties What
	)
	Catch 
	(	Try	(ShowProperties What)
		Catch (format "%\n" ("No Info Found on: " + What as string) to:listener)
	)
)
