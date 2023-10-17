-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
--	
--	Projection Mod Helper Functions
--
--	Created: April 21, 2004
--
--	Author :  Michael Russo
--
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- MODIFY THIS AT YOUR OWN RISK
 

--
--	GetPModObjectNames
--
--	For a given Projection Modifier, return an array of the name of the Geometry Selections
--
function GetPModObjectNames pmod =
(
	local ObjList = #()
	
	pmodInterface = pmod.ProjectionModOps
	if pmodInterface == undefined do return ObjList
	
	local iObjCount = pmodInterface.NumObjects()
	ObjList.count = iObjCount 
	
	for i = 1 to iObjCount do 
		ObjList[i]= pmodInterface.GetObjectName i
	
	return ObjList
)

--
--	FindPMod
--
function FindPMod nodeSrc =
(
	local pmod = undefined
	theMods = nodeSrc.modifiers
	
	for theMod in theMods while pmod == undefined do (
		if (Classof theMod) == Projection do pmod = theMod
	)
	
	return pmod
)


--
--	AddPModObjects
--
--	nodeList : Array of nodes to apply Projection Modifiers
--	bCreateNewPMods : set to true to always append a new Projection Modifier, else use the highest in stack
--	bDeletaAll : before adding objList (targets), make sure the object list in projection modifier is empty
--	objList : if defined, these objects will be added to projection modifier, else use selectByName dialog
--
--	Array of PMods corresponding to nodeList is returned.
--
function AddPModObjects nodeList bCreateNewPMods bDeleteAll objList:undefined =
(
	local PModList = #()
	
	-- Add PMods
	for nodeSrc in nodeList do (
		local newPMod = undefined
		if bCreateNewPMods == false do (
			newPMod = FindPMod nodeSrc		
		)
		if newPMod == undefined do (
			newPMod = Projection()
			AddModifier nodeSrc newPMod
		)
		append PModList newPMod
	)

	-- Prompt for obj nodes
	if objList == undefined do (
		function selectFilter obj = iskindof obj GeometryClass
		objList = selectByName title:"Add Targets" buttonText:"Add" filter:selectFilter showhidden:false single:false
	)

	for pmod in PModList do (
		if pmod != undefined do (
			local pmodInterface = pmod.projectionmodops
			if bDeleteAll == true do pmodInterface.deleteAll()
			for objNode in objList do (
				 pmodInterface.AddObjectNode objNode
			)
		)
	)
	
	return PModList
)

