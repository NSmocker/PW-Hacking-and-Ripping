struct RTT_methods_struct
(

_debug = false,
_networkRender_BM,
_inNetRender = false,
_cached_RadiosityPreferences_computeRadiosity = undefined,

-- function to create a directory if it does not already exist. 
-- Returns true if directory existed or was created, false if directory could not be created
function ValidateDirectory _dirNameIn  =
(
	local _dirName = copy _dirNameIn
	-- strip terminating '\' or '/'
	local c
	for i = _dirName.count to 1 by -1 while (c=_dirName[i]; c=="\\" or c== "/") do
		_dirName = subString _dirName 1 (i-1)
	-- create the dir if we don't have one
	local dirExists = false
	if doesFileExist _dirName do
		dirExists = getfileattribute _dirName #directory

	if _debug do 
		if _inNetRender then
			logsystem.logEntry ("directory " + _dirName + " exists: " + (dirExists as string)) info:true
		else
			format "directory % exists: %\n" _dirName dirExists 

	if not dirExists then
	(
		if _debug do 
			if _inNetRender then
				logsystem.logEntry ("make directory = " + _dirName) info:true
			else
				format "make directory = %\n" _dirName
		-- make a new dir
		makeDir _dirName all:true

		if doesFileExist _dirName do
			dirExists = getfileattribute _dirName #directory

		if _debug do 
			if _inNetRender then
				logsystem.logEntry ("directory " + _dirName + " exists: " + (dirExists as string)) info:true
			else
				format "directory % exists: %\n" _dirName dirExists 
	)
	return dirExists
), -- end - function validateDirectory 

-- function to make a filename valid by replacing illegal characters with a '_'
function MakeFileNameValid fname = -- fname must be just filename, no path....
(
	local illegal_characters =":/\\~!@#$%^&*()+=|'?><;[]{}\"" -- illegal characters in file name
	local res = copy fname
	if _debug do 
		if _inNetRender then
			logsystem.logEntry ("checking for illegal characters in = " + res) info:true
		else
			format "\tchecking for illegal characters in %\n" res
	-- make sure the object name is legal for a filename
	local count = res.count
	for i = 1 to count do
		if (findString illegal_characters res[i]) != undefined do -- replace illegal characters with _
			res[i] = "_"
	if _debug do 
		if _inNetRender then
			logsystem.logEntry ("was: '" + fname + "' is: '" + res + "'") info:true
		else
			format "\t\twas: '%' is: '%'\n" fname res
	return res
), -- end - function MakeFileNameValid 


-- utility to make a formated number 0000 style
function FormatNumber _num _length:4 =
(
	local s = _num as string
	for i = s.count to (_length-1) do s = "0" + s
	return s
), -- end - function FormatNumber 


-------------------------------------------------
-- Function to update the filename for the selected bake element
-- returns the filename
function MakeBakeElementFileName _obj _element _oldName curFrameString defaultFileType subObjectName:"" strip_cur: = 
(
	-- get the path if it has one
	local path = getFilenamePath _oldName
	local ext = getFilenameType _oldName
	local fname = getFilenameFile _oldName
	if _debug do 
		if _inNetRender then
			logsystem.logEntry ("make filename: path: " + path + ", fname: " + fname + ", extension: " + ext + 
								"; curFrameString: " + curFrameString + "; ele name: " + _element.elementName + 
								"; ele filenameUnique: " + (_element.filenameUnique as string) +"; obj name: " + _obj.name +
								", subObjectName: " + subObjectName) info:true
		else
			format "\tmake filename: path: %, fname: %, extension: %; ele name: %; ele filenameUnique: %; ele curFrameString: %; obj name: %; subObject name: %\n" \
					path fname ext _element.elementName _element.filenameUnique curFrameString _obj.name subObjectName
		
	-- check for modified names!!
	local theName
	if ext == "" do ext = defaultFileType
	if ((rendTimeType == 1) and (strip_cur == unsupplied)) do
		curFrameString = ""
	if (_element.filenameUnique) and ( _oldName != "" ) then
	(
		-- unique name, use as is, add SO name and frame #
		if subObjectName != "" do subObjectName = "_" + subObjectName
		theName = fname + subObjectName
	) 
	else 
	(
		-- it's a non-unique name, generate it
		if subObjectName != "" do subObjectName = "_" + subObjectName  + "_"
		theName = MakeFileNameValid (_obj.name + subObjectName + _element.elementName)
		
	)
	if (strip_cur != unsupplied) do
		theName = ("_STP" + (FormatNumber strip_cur _length:5) + "_" + theName)
	
	-- create the full name
	theName = path + theName + curFrameString + ext
	return theName
), -- end - function MakeBakeElementFileName 

--	Function to create/update bitmaps on the bake elements of the object
function UpdateBitmapFilenames _obj _nFrame defaultPath defaultFileType subObjectName:"" strip_cur: =
(
	if _debug do 
		if _inNetRender then
			logsystem.logEntry ("update filenames on elements - node: " + _obj.name + "; frame: " + (_nFrame as string) + "; subObjectName: " + subObjectName) info:true
		else
			format "\tupdate filenames on elements - node: %; frame: %; subObjectName: %\n" _obj.name _nFrame subObjectName
	
	-- make the file number
	local curFrameString = FormatNumber _nFrame
	
	local bakeInterface = _obj.INodeBakeProperties
	local nElements = bakeInterface.NumBakeElements()
	for i = 1 to nElements do
	(
		-- get element & filename
		local element = bakeInterface.GetBakeElement i 
		local fname = element.filename
		fname = MakeBakeElementFileName _obj element fname curFrameString defaultFileType subObjectName:subObjectName strip_cur:strip_cur

		-- add the path & save it all in fileType
		with undo off -- no undo records for element changes...
		(
			if (getFilenamePath fname != "") then
				element.fileType = fname -- has a path
			else
				element.fileType = defaultPath + fname
			if _debug do 
				if _inNetRender then
					logsystem.logEntry ("elements: " + element.elementName + "; filename: " + element.fileType) info:true
				else
					format "\t\telements: %; filename: %\n" element.elementName element.fileType 
		)
			
	) -- end, for each element
), -- end - function UpdateBitmapFilenames 

-- function to see if all files to be created by node's elements already exist. If so, returns true, 
-- otherwise false
function CheckAllBakeElementOutputFilesExist _obj =
(
	local bakeInterface = _obj.INodeBakeProperties
	local nElements = bakeInterface.numBakeElements()
	local res = true
	for i = 1 to nElements while res do
	(
		-- get the element
		local ele = bakeInterface.getBakeElement i
		
		-- see if the file exists
		res = doesFileExist ele.fileType
	) -- end, for each element
	
	return res
), -- end - function CheckAllBakeElementOutputFilesExist 

-- function to see if all directories to be output to exist. If not, create. If can't create, returns first
-- directory can't create in badDir. If directories exist or were created, return true, otherwise false
function CheckAllBakeElementOutputDirsExist _obj &badDir =
(
	local bakeInterface = _obj.INodeBakeProperties
	local nElements = bakeInterface.numBakeElements()
	local res = true
	for i = 1 to nElements while res do
	(
		-- get the element
		local ele = bakeInterface.getBakeElement i
		
		if ele.enabled do
		(
			-- see if the directory exists
			local theDir = getFilenamePath ele.fileType
			res = ValidateDirectory theDir
			if not res do badDir = theDir
		)
	) -- end, for each element
	
	return res
), -- end - function CheckAllBakeElementOutputDirsExist 

-- function to return array of frames to render based on render pickup frames string 
function ConvertFrameStringToFrames _str =
(
	local theFrames = #()
	local wasError = false
	-- break into sequences
	local s1=filterstring _str ","
	-- detect negative numbers
	for i = 1 to s1.count do if s1[i].count == 0 or s1[i][1] == "-" do 
	(	
		if isNetServer() then 
			throw ("Not a Valid Frame Number List:\n"+_str)
		else 
			messageBox ("Not a Valid Frame Number List:\n"+_str)
		return theFrames 
	)
	-- break each sequence into to/from values
	for i = 1 to s1.count do s1[i]=filterstring s1[i] "-"
	-- convert each sequence into frame numbers
	try
	(
		for s in s1 do
		(
			if s.count == 1 then
				append theFrames (s[1] as integer)
			else
			(
				local fromV = s[1] as integer
				local toV = s[2] as integer
				for i = fromV to toV do append theFrames i
			)
		)
	)
	catch
	(
		wasError = true
	)
	if wasError do 
	(	
		if isNetServer() then 
			throw ("Not a Valid Frame Number List:\n"+_str)
		else 
			messageBox ("Not a Valid Frame Number List:\n"+_str)
		theFrames = #()
	)
	return theFrames 
), -- end - function ConvertFrameStringToFrames

-- function to return array of frames to render based on values in Time Output group, 
-- Common Parameters rollout, Common tab, of Render Scene dialog
function GetRenderFrames =
(
	local theFrames = #()
	local sequenceStart, sequenceEnd 
	case rendTimeType of
	(
		1: 	( -- single
				sequenceStart = sequenceEnd = currentTime
			)
		2:	( -- active animation segment
				sequenceStart = animationRange.start
				sequenceEnd = animationRange.end
			)
		3:	( -- from...to frame
				sequenceStart = rendStart
				sequenceEnd = rendEnd
			)
		4:	( -- string of frames, parse off next sequence
				theFrames = ConvertFrameStringToFrames rendPickupFrames
			)
	) -- end, case of rendTimeType
	
	if (rendTimeType != 4) do
	(
		-- convert to frame #
		if classof sequenceStart == time then 
			sequenceStart = (sequenceStart as integer) / ticksPerFrame
		if classof sequenceEnd == time then 
			sequenceEnd = (sequenceEnd as integer) / ticksPerFrame
		for i = sequenceStart to sequenceEnd by rendNthFrame do append theFrames i
	)
	return theFrames	
), -- end - function GetRenderFrames 

------------------------------------------------------------------
--
--	Function to get the render region for a node, if any - called by NetBakeNode 
--
function GetRenderRegion theNode strip_cur: strip_count: strip_overlap: =
(
	local renderWidth = theNode.renderWidth()
	local renderHeight = theNode.renderHeight()
	if ((strip_count != unsupplied) and (strip_cur != unsupplied) and (strip_overlap != unsupplied)) then
	(
		local strip_size	= renderHeight / strip_count
		local strip_start	= (strip_size * strip_cur) - strip_overlap
		local strip_end		= (strip_size * strip_cur) + strip_overlap + strip_size
		
		if (strip_start<0) do strip_start = 0
		if (strip_end>=renderHeight) do strip_end = (renderHeight-1)
		
		return #(0,strip_start,renderWidth-1,strip_end)
	)
	else return undefined
),

------------------------------------------------------------------
--
--	Function to render a set of textures on a node - called by NetBakeNode 
--
function NetBakeNode_Render theNode renderFrameList defaultPath defaultFileType geomSelName &errMSg \
	strip_cur: strip_count: strip_overlap: = 
(
	local renderRegion = GetRenderRegion theNode strip_cur:strip_cur strip_count:strip_count strip_overlap:strip_overlap
	
	local firstPass = true
	-- for each frame
	for nFrame in renderFrameList do
	(
		-- update the bitmap names
		local n = if (rendTimeType == 2) or (rendTimeType == 3) then 
					(nFrame + rendFileNumberBase) 
				  else nFrame
		updateBitmapFilenames theNode n defaultPath defaultFileType subObjectName:geomSelName strip_cur:strip_cur
		
		if firstPass do
		(
			local badDir
			local res = CheckAllBakeElementOutputDirsExist theNode &badDir
			if ( not res) then
			(
				errMSg  = "Output directory not found or not creatable:" + badDir
				return #cancel
			)
		)
		
		if not (skipRenderedFrames and (CheckAllBakeElementOutputFilesExist theNode)) do
		(
			-- render the texture elements
			local wasCanceled = false
			try
			(
				if (renderRegion == undefined) then
					render rendertype:#bakeSelected frame:nFrame to:_networkRender_BM vfb:off cancelled:&wasCanceled
				else (
					local renderWidth = theNode.renderWidth()
					local renderHeight = theNode.renderHeight()
					
					render rendertype:#bakeSelectedCrop frame:nFrame region:renderRegion outputWidth:renderWidth outputHeight:renderHeight \
						to:_networkRender_BM vfb:off cancelled:&wasCanceled
				)
				
				if (_cached_RadiosityPreferences_computeRadiosity == undefined) do
				(
					_cached_RadiosityPreferences_computeRadiosity = RadiosityPreferences.computeRadiosity
					RadiosityPreferences.computeRadiosity = false
				)
			)
			catch
			(
				errMSg  = "System exception occurred during render"
				return #cancel
			)

			if ( wasCanceled ) then
			(
				errMSg  = "user cancelled render"
				return #cancel
			)
		)
		firstPass = false
	) -- end, for each frame
	ok
),

------------------------------------------------------------------
--
--	Function to bake a set of textures on a node
--
function NetBakeNode theNode frame: strip_cur: strip_count: strip_overlap: = with undo off
(
	local inbp = theNode.INodeBakeProperties
	local inbpp = theNode.INodeBakeProjProperties

	_inNetRender = true
	if _debug do logsystem.logEntry ("NetBakeNode entered. Node: "+theNode.name+" frame: "+(frame as string)) info:true
	if _debug do logsystem.logEntry ("rendTimeType: "+(rendTimeType as string)+" rendFileNumberBase: "+(rendFileNumberBase as string)) info:true
	if _debug do logsystem.logEntry ("rendStart: "+(rendStart as string)+" rendEnd: "+(rendEnd as string)+" animationRange: "+(animationRange as string)) info:true

	local renderFrameList 
	if frame != unsupplied then 
		renderFrameList = #(frame)
	else
		renderFrameList = getRenderFrames()
	if renderFrameList.count == 0 do 
	(
		_inNetRender = false
		return false
	)
	
	if not renderers.current.supportsTexureBaking do
	(
		_inNetRender = false
		if classof renderers.current == mental_ray_renderer then
			throw "Mental ray needs MAX to be licensed to run in offline/network mode"
		else
			throw "Current renderer does not support texture baking"
	)

	local defaultPath
	local defaultFileType
	local renderTimeType
	
	local i = fileproperties.findProperty #custom "RTT_Default_Path"
	if i != 0 then 
		defaultPath = fileproperties.getpropertyValue #custom i
	else
	(
		_inNetRender = false
		throw "cannot find RTT_Default_Path in file properties"
	)

	i = fileproperties.findProperty #custom "RTT_Default_FileType"
	if i != 0 then 
		defaultFileType = fileproperties.getpropertyValue #custom i
	else
	(
		_inNetRender = false
		throw "cannot find RTT_Default_FileType in file properties"
	)

	i = fileproperties.findProperty #custom "RTT_RenderTimeType"
	if i != 0 then 
		renderTimeType = fileproperties.getpropertyValue #custom i
	else
	(
		_inNetRender = false
		throw "cannot find RTT_RenderTimeType in file properties"
	)

	local renderWidth = theNode.renderWidth()
	local renderHeight = theNode.renderHeight()
	local renderRegion = GetRenderRegion theNode strip_cur:strip_cur strip_count:strip_count strip_overlap:strip_overlap
	
	local proportionalOutput = inbpp.proportionalOutput

	if (renderRegion != undefined) do
	(
		proportionalOutput = false
		renderHeight = (renderRegion[4] - renderRegion[2]) + 1
	)

	if rendShowVFB then
	(
		if ((_networkRender_BM == undefined) or (_networkRender_BM == unsupplied) or 
		    (_networkRender_BM.width != renderWidth) or (_networkRender_BM.height != renderHeight)) do
		(	
			-- create new bm
			if _networkRender_BM != undefined then 
				close _networkRender_BM -- close the VFB and free bitmap's memory
			_networkRender_BM = bitmap renderWidth renderHeight
			display _networkRender_BM
		)
	)
	else
		_networkRender_BM = unsupplied

	if _debug do logsystem.logEntry ("renderFrameList: "+(renderFrameList as string)+" renderTimeType: "+(renderTimeType as string)) info:true

	local restoreToGroup = false
	if isGroupMember theNode then
	(
		setGroupMember theNode false
		restoreToGroup = true
	)
	
	local saveRenderMtlIndex = -1
	
	-- force render to use original material for baking
	local materialType = classof theNode.material
	if (materialType == Shell_Material) then
	(
		saveRenderMtlIndex = theNode.material.renderMtlIndex
		theNode.material.renderMtlIndex = 0
	)

	--  select the object
	select theNode
	
	-- push rendTimeType
	local old_rendTimeType = rendTimeType
	rendTimeType = renderTimeType
	
	local cached_RadiosityPreferences_computeRadiosity
	
	local errMsg
	local res = ok
	
	-- render pass 1
	-- render object level?
	if (not inbpp.enabled) or inbpp.BakeObjectLevel do
		res = NetBakeNode_Render theNode renderFrameList defaultPath defaultFileType "" &errMSg \
				strip_cur:strip_cur strip_count:strip_count strip_overlap:strip_overlap
	
	-- render pass 2
	-- render subobject level?
	if res == ok and inbpp.enabled and inbpp.BakeSubObjLevels do
	(
		local projMod = inbpp.projectionMod 
		local numGeomSels = projMod.numGeomSels()
		local firstSORender = true
		local totalSurfArea
		if inbpp.proportionalOutput do
			totalSurfArea = projMod.getGeomSelFaceArea theNode 0
		for i = 1 to numGeomSels while res == ok do 
		(
			local geomSelLevel = projMod.getGeomSelLevel i
			if geomSelLevel == #face or geomSelLevel == #element do
			(
				local geomSelName = projMod.getGeomSelName i
				inbpp.projectionModTarget = geomSelName 
				local elementOutSizes 
				local numBakeElements
				if proportionalOutput do
				(
					local geomSelSurfArea = projMod.getGeomSelFaceArea theNode i
					local geomSelSurfAreaFrac = if totalSurfArea > 1e-10 then (sqrt geomSelSurfArea)/(sqrt totalSurfArea) else 1.
					geomSelSurfAreaFrac *= projMod.getGeomSelMapProportion i
					elementOutSizes = #()
					numBakeElements = inbp.numBakeElements()
					elementOutSizes.count = numBakeElements 
					for j = 1 to numBakeElements do
					(
						local ele = inbp.getBakeElement j
						local szX = ele.outputSzX
						local szY = ele.outputSzY
						elementOutSizes[j] = Point2 szX szY 
						if (szX != 0) do szX = amax (ceil szX*geomSelSurfAreaFrac) 1
						if (szY != 0) do szY = amax (ceil szY*geomSelSurfAreaFrac) 1
						ele.outputSzX = szX 
						ele.outputSzY = szY 
					)
				)
				local mapChannel_Obj = inbp.bakeChannel
				inbp.bakeChannel = inbpp.subObjBakeChannel 
				
				res = NetBakeNode_Render theNode renderFrameList defaultPath defaultFileType geomSelName &errMSg \
						strip_cur:strip_cur strip_count:strip_count strip_overlap:strip_overlap
						
				inbp.bakeChannel = mapChannel_Obj
				if proportionalOutput do
				(
					for j = 1 to numBakeElements do
					(
						local ele = inbp.getBakeElement j
						local elementOutSize = elementOutSizes[j] 
						ele.outputSzX = elementOutSize.x
						ele.outputSzY = elementOutSize.y
					)
				)
				firstSORender = false
			)
		)
		inbpp.projectionModTarget = "" 
	)
	
	-- restore object to the group
	if restoreToGroup do
		setGroupMember theNode true
	if saveRenderMtlIndex >= 0 do
		theNode.material.renderMtlIndex = saveRenderMtlIndex 
	_inNetRender = false
	rendTimeType = old_rendTimeType

	if (cached_RadiosityPreferences_computeRadiosity != undefined) do
		RadiosityPreferences.computeRadiosity = cached_RadiosityPreferences_computeRadiosity
	
	if res != ok then
		throw errMSg

	return true
) -- end - function NetBakeNode

) -- end - struct RTT_methods

-- create instance of structure
RTT_methods = RTT_methods_struct ()
