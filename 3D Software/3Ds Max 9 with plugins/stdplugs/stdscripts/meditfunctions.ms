-- Medit Functions Script
-- Created:       Feb 25 2005
-- Last Modified: Feb 25 2005
-- meditUtilities Structure
-- Version: 3dsmax 8
-- Author: Alexander Esppeschit Bicalho, Discreet
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

/* History

Feb 25 - split the functions from the MeditUtilities into this script to make them re-usable

NOTE TO LOCALIZATION

Nothing should be localized in this script

*/

struct meditUtilities (

fn getDefaultsFile =
(
	defaultsFolder = getDir #defaults
	defaultsFile = defaultsFolder + #'\\CurrentDefaults.INI' as string
	if (getFiles defaultsFile).count == 0 do
		defaultsFile = defaultsFolder + #'\\FactoryDefaults\\CurrentDefaults.INI' as string
	if (getFiles defaultsFile).count == 0 then 
		return undefined 
	else 
		return defaultsFile
),
-- end getDefaultsFile

fn getDefaultMaterial defaultsFileStr =
(
	defaultMtl = StandardMaterial
	local classidStr = #()
	if defaultsFileStr == undefined do return defaultMtl
	if (getFiles defaultsFileStr).count == 0 do return defaultMtl
	if (getFiles defaultsFileStr).count == 1 do
	(
		defaultsFile = openFile defaultsFileStr
		while not eof defaultsFile do
		(
			foundMaterialKey = false
			if not eof defaultsFile and not foundMaterialKey do
			(
				defaultLine = readLine defaultsFile
				if defaultLine[1] != #';' as string do
				(
					filteredDefault = filterString defaultLine (#'= ' as string)
					if filteredDefault[1] == (#materialType as string) and filteredDefault.count == 3 do
					(
						classIDstr[1] = filteredDefault[2]
						classIDstr[2] = filteredDefault[3]
						foundMaterialKey = true
					) -- end we found it!
				) -- end skip comment
			) -- end if eof
		) -- end while
		close defaultsFile
		if classIDStr.count == 2 do
		(
			hexStr = #x as string
			if classIDstr[1][2] == hexStr and classIDstr[2][2] == hexStr do -- do not localize
			( -- if it's Hex, remove the "0x"
				classIDStr[1] = substring classIDStr[1] 3 (classIDStr[1].count-2)
				classIDStr[2] = substring classIDStr[2] 3 (classIDStr[2].count-2)
			)
			for i in 1 to material.classes.count do
			(
				mtlIDs = #()
				mtlIDs[1] = material.classes[i].classid[1]
				mtlIDs[2] = material.classes[i].classid[2]
				-- format "% : #(%,%)\n" i mtlIDs[1] mtlIDs[2]
				if (mtlIDs[1] as string == classIDStr[1] and mtlIDs[2] as string == classIDStr[2]) or
				   (bit.intAsHex mtlIDs[1] == classIDStr[1] and bit.intAsHex mtlIDs[2] == classIDStr[2]) do
				(
					return material.classes[i]
				)
			) -- end iterate through classes
		) -- end search for Mtl
	)
	return defaultMtl -- if we get here, we did not find a match, so return StdMaterial
),
-- end getDefaultMaterial

fn isMaterialInUse mtl =
(
	local foundSceneRef = false
	if superClassof mtl == material or superClassof mtl == textureMap do
	(
		local deps = refs.dependents mtl
		for i in deps while not foundSceneRef do
		(
			local c = classof i
			local sc = superclassof i
			local sid = i.superclassid
			-- exclude scene root, scene mtl lib, medit, materials, texturemaps, and texture map containers (used by std mtl to hold texmaps)
			foundSceneRef = c != Scene and c != MtlBaseLib and c != Material_Editor and sc != Material and sc != TextureMap and sid != 4224
		)
	)
	return foundSceneRef 	
)
-- end isMaterialInUse

) -- end struct