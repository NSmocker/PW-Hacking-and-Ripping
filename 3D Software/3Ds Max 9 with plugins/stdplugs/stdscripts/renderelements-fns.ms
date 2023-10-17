-- Render Elements Fonctions
-- Created:		Aug 16 2000
-- Author:		Fred Moreau
-- Modified:	Feb 07 2002 11:41am
-- Modified by: Yann Bertaud
-- Version:		1.2
-- Modifications: added support for Ink and Paint render elements.
-- Modified:	Mar 19 2002 5:00pm
-- Modified by: Yann Bertaud
-- Version:		1.21
-- Modifications: fixed bug where shadows were getting composited incorrectly over ink n paint elements. Moved shadow element below ink n paint elements in cws file.

-- 3dsmax 5.0 / combustion V2.0

--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
--***********************************************************************************************

struct CINCfg (BlackPoint, WhitePoint)
fn getCINCfg =
(
	try
	(
		currentCINCfg = cincfg 0 0
		CINCfgFile = openfile "$plugcfg\Cineon.ini"
		SkipToString CINCfgFile "White="
		currentcincfg.WhitePoint = readvalue CINCfgFile
		SkipToString CINCfgFile "Black="
		currentcincfg.BlackPoint = readvalue CINCfgFile
		close CINCfgFile
		return currentCINCfg
	)
	catch
	(
		currentCINCfg = cincfg 685 95
		return currentCINCfg
	)
)

fn KindOfRenderElement RElement = -- return the kind of a given element
(
	kindstring = stringstream (RElement as string)
	readchars kindstring 16
	_kind = stringstream ("#" + (readvalue kindstring) as string)
	kind = readvalue _kind
	close kindstring
	close _kind
	return kind
)

struct relement (name, kind, file, transferMode, Visibility)
-- kind being #Diffuse #Specular #Shadow #Colored_Shadow #Reflection #Refraction
-- #Self_Illumination #Atmosphere #Blend #Z_Depth #Alpha #Background #Ink #Paint

fn RElements2cws re_array cws_file =
(
	local cwsstart, cwsend
	-- Setting Comp Range
	case rendTimeType of
	(
		1	:	(cwsstart = 0 ; cwsend = 0)
		2	:	(cwsstart = 0 ; cwsend = (animationRange.end.frame as integer)-(animationRange.start.frame as integer))
		3	:	(cwsstart = 0 ; cwsend = (rendEnd.frame as integer)-(rendStart.frame as integer))
		4	:	(cwsstart = 0 ; cwsend = 0)
	)
	local seqSuffix = 0
	case of
	(
		(cwsend == 0)								:	seqSuffix = 0
		(cwsend > 0 and cwsend <= 9999)				:	seqSuffix = 4
		(cwsend > 9999 and cwsend <= 99999)			:	seqSuffix = 5
		(cwsend > 99999 and cwsend <= 999999)		:	seqSuffix = 6
		(cwsend > 999999 and cwsend <= 9999999)		:	seqSuffix = 7
		(cwsend > 9999999 and cwsend <= 99999999)	:	seqSuffix = 8
		default										:	seqSuffix = 0
	)
	local fields = 0
	if rendFieldRender == true then
	(
		if rendFieldOrder == 1 then fields = 2 else fields = 1
	)
	-- sorting elements by kind
	re_sorted = #(#(), #(), #(), #(), #(), #(), #(), #(), #(), #(), #(), #(), #(), #(), #())
	for e in re_array do
	(
		case e.kind of
		(
			default				:	append re_sorted[1]		e
			#Z_Depth			:	append re_sorted[2]		e
			#Alpha				:	append re_sorted[3]		e
			#Blend				:	append re_sorted[4]		e
			#Atmosphere			:	append re_sorted[5]		e
			#Colored_Shadow		:	append re_sorted[6]		e
			#Self_Illumination	:	append re_sorted[7]		e
			#Refraction			:	append re_sorted[8]		e
			#Reflection			:	append re_sorted[9]		e
			#Specular			:	append re_sorted[10]	e
			#Ink				:	append re_sorted[11]	e
			#Paint				:	append re_sorted[12]    e
			#Shadow				:	append re_sorted[13]	e
			#Diffuse			:	append re_sorted[14]	e
			#Background			:	append re_sorted[15]	e
		)
	)
	re_array = #()
	for r in re_sorted do
	(
		for e in r do
		(
			append re_array e
		)
	)
	-- create and open the cwsfile
	try(deletefile cws_file) catch()
	cws_filesave = createFile cws_file
	format (write_cws_head comment:"3dsmax - Render Elements") to:cws_filesave
	-- write the composite operator class
	format (write_cws_operator cws_ops_array[1] 1) to:cws_filesave
	-- write all footage operators classes
	for f = 1 to re_array.count do
	(
		format (write_cws_operator cws_ops_array[2] (f+1)) to:cws_filesave
	)
	-- Cineon converter if Cineon file detected
	for f = 1 to re_array.count do
	(
		if getfilenameType re_array[f].file == ".cin" then
		(
			format (write_cws_operator cws_ops_array[16] (f+re_array.count+1)) to:cws_filesave
		)
	)
	-- write the comp settings
	format (write_cws_composite 1 "3dsmax - Render Elements" renderWidth renderHeight renderPixelAspect framerate (cwsend+1)) to:cws_filesave
	-- add all layers to the composite
local NoMoreShadows=false, NoMoreBGrd=false, NoMoreDiffuse=false, NoMorePaint=false, NoMoreInk= false, NoMoreSpecular=false, NoMoreReflect=false, NoMoreRefract=false, NoMoreSelfIllum=false, NoMoreAtmosphere=false
	for l in re_array do
	(
		-- setting params based of kinds (transfer mode & visibility) / preventing Dupplicate
		case l.kind of
		(
			#Background			:	(l.transferMode = 1 ; (if NoMoreBGrd != true then l.Visibility = on) ; NoMoreBGrd=true)
			#Diffuse			:	(l.transferMode = 1 ; (if NoMoreDiffuse != true then l.Visibility = on) ; NoMoreDiffuse=true)
			#Paint				:	(l.transferMode = 1 ; (if NoMorePaint != true then l.Visibility = on) ; NoMorePaint=true)
			#Ink				:	(l.transferMode = 1 ; (if NoMoreInk != true then l.Visibility = on) ; NoMoreInk=true)
			#Specular			:	(l.transferMode = 3 ; (if NoMoreSpecular != true then l.Visibility = on) ; NoMoreSpecular=true)
			#Shadow				:	(l.transferMode = 1 ; (if NoMoreShadows != true then l.Visibility = on) ; NoMoreShadows=true)
			#Colored_Shadow		:	(l.transferMode = 12 ; (if NoMoreShadows != true then l.Visibility = on) ; NoMoreShadows=true)
			#Reflection			:	(l.transferMode = 3 ; (if NoMoreReflect != true then l.Visibility = on) ; NoMoreReflect=true)
			#Refraction			:	(l.transferMode = 3 ; (if NoMoreRefract != true then l.Visibility = on) ; NoMoreRefract=true)
			#Self_Illumination	:	(l.transferMode = 3 ; (if NoMoreSelfIllum != true then l.Visibility = on) ; NoMoreSelfIllum=true)
			#Atmosphere			:	(l.transferMode = 1 ; (if NoMoreAtmosphere != true then l.Visibility = on) ; NoMoreAtmosphere=true)
			#Blend				:	(l.transferMode = 1 ; l.Visibility = off)
			#Z_Depth			:	(l.transferMode = 1 ; l.Visibility = off)
			#Alpha				:	(l.transferMode = 1 ; l.Visibility = off)
			default				:	(l.transferMode = 1 ; l.Visibility = off)
		)
		rechannels = #()
		append rechannels (cwschannel index:#(3,9) value:l.transferMode keys:#()) -- sets the transfer mode
		cwslayer = (cwsobject name:l.name kind:#layer operator:1 order:((findItem re_array l) + 2) channels:rechannels parent:0 target:0 isvisible:l.Visibility)
		format (write_cws_object cwslayer) to:cws_filesave
	)
	-- write the lights
	cwslight = (cwsobject name:"default light" kind:#light operator:1 order:2 channels:#() parent:0 target:0 isvisible:on)
	format (write_cws_object cwslight) to:cws_filesave
	-- write the camera
	cwscam = (cwsobject name:"default camera" kind:#camera operator:1 order:1 channels:#() parent:0 target:0 isvisible:on)
	format (write_cws_object cwscam) to:cws_filesave
	-- write composite settings
	format (write_cws_composite_settings Width:renderWidth Height:renderHeight Fields:fields) to:cws_filesave
	-- write the footages
	for f in re_array do
	(
		case f.kind of
		(
			#Background			:	(AlphaOn=0 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Diffuse			:	(AlphaOn=2 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Paint				:	(AlphaOn=2 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Ink				:	(AlphaOn=2 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Specular			:	(AlphaOn=0 ; AlphaInvert=0 ; AlphaPreMultiply=0 ; PreMultiColor=[0,0,0])
			#Shadow				:	(AlphaOn=2 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Colored_Shadow		:	(AlphaOn=0 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Reflection			:	(AlphaOn=0 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Refraction			:	(AlphaOn=0 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Self_Illumination	:	(AlphaOn=0 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Atmosphere			:	(AlphaOn=2 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Blend				:	(AlphaOn=2 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Z_Depth			:	(AlphaOn=0 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			#Alpha				:	(AlphaOn=2 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
			default				:	(AlphaOn=2 ; AlphaInvert=0 ; AlphaPreMultiply=1 ; PreMultiColor=[0,0,0])
		)
		footageChannels = #()
		append footageChannels (cwschannel index:#(1) value:0 keys:#())
		append footageChannels (cwschannel index:#(2) value:AlphaOn keys:#())
		append footageChannels (cwschannel index:#(3) value:AlphaInvert keys:#())
		append footageChannels (cwschannel index:#(4) value:AlphaPreMultiply keys:#())
		append footageChannels (cwschannel index:#(32,1) value:PreMultiColor.x keys:#())
		append footageChannels (cwschannel index:#(32,2) value:PreMultiColor.y keys:#())
		append footageChannels (cwschannel index:#(32,3) value:PreMultiColor.z keys:#())
		append footageChannels (cwschannel index:#(32,4) value:1 keys:#())
		append footageChannels (cwschannel index:#(8) value:fields keys:#())
		append footageChannels (cwschannel index:#(10) value:renderWidth keys:#())
		append footageChannels (cwschannel index:#(11) value:renderHeight keys:#())
		append footageChannels (cwschannel index:#(13) value:framerate keys:#())
		append footageChannels (cwschannel index:#(14) value:renderPixelAspect keys:#())
		append footageChannels (cwschannel index:#(18) value:cwsstart keys:#())
		append footageChannels (cwschannel index:#(19) value:cwsend keys:#())
		append footageChannels (cwschannel index:#(20) value:renderWidth keys:#())
		append footageChannels (cwschannel index:#(21) value:renderHeight keys:#())
		format (write_cws_footage ((findItem re_array f) + 1) f.name renderWidth renderHeight f.file IsASeq:seqSuffix channels:footageChannels) to:cws_filesave
	)
	-- Add Cineon converters
	for f = 1 to re_array.count do
	(
		if getfilenameType re_array[f].file == ".cin" then
		(
			format (write_cws_cineonConverter (f+re_array.count+1) BlackP:(getCINCfg()).BlackPoint WhiteP:(getCINCfg()).WhitePoint) to:cws_filesave
		)
	)
	-- make connections
	format (write_cws_connect()) to:cws_filesave
	for f = 1 to re_array.count do
	(
		if getfilenameType re_array[f].file == ".cin" then
		(
			format (write_cws_connect opnum:(f+re_array.count+1) _with:1 _at:(f + 2)) to:cws_filesave
			format (write_cws_connect opnum:(f + 1) _with:(f+re_array.count+1) _at:1) to:cws_filesave
		)
		else
		(
			format (write_cws_connect opnum:(f + 1) _with:1 _at:(f + 2)) to:cws_filesave
		)
	)
	-- write EOF
	format (write_cws_eof cwsstart cwsend audiofile:WAVsound.filename) to:cws_filesave
	-- close file
	close cws_filesave
)