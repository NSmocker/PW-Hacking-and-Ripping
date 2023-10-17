-- Combustion workspace file output fonctions
-- Created:		April 15 2000
-- Modified:	Dec 21 2000 2:45am
-- Author:		Fred Moreau
-- Version:		1.0

-- 3dsmax 4.0 / combustion V1.01

-- Aug 10 2005 : Modified by Chloe Mignot : added ".exr" extension to the list of image type ( IsCwsImgType )

--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
--***********************************************************************************************

struct cwskey (frame, value)
struct cwschannel (index, value, keys)
struct cwsoperator (class, name, channels)
struct cwscomposite (name, objects)
struct cwsobject (name, kind, operator, order, channels, parent, target, isvisible, stencil, hinge) -- kind being #layer #light #camera #null
struct CombustionWorkSpace (Operators, Connections)
---------------------------------------------------------------------------------------------------------------------------
--	***Building discreet combustion Operator Classes Array***
global cws_ops_array = #()
--		Usual Operators
append cws_ops_array "0x6ed73e76 0x32505a4d"	-- 1 composite
append cws_ops_array "0x764521a0 0x2b271cba"	-- 2 Footage
append cws_ops_array "0x4e23277f 0x31c27e5f"	-- 3 paint
--		3D Operators
append cws_ops_array "0x676a7cb0 0x4cdcaaea"	-- 4 3D Depth of Field...
append cws_ops_array "0x676a7cb0 0x8bf322fc"	-- 5 3D Fog...
append cws_ops_array "0x676a7cb0 0x38a84b96"	-- 6 3D Glow...
append cws_ops_array "0x676a7cb0 0x8b39ba9e"	-- 7 3D Lens Flare...
append cws_ops_array "0x676a7cb0 0xaa3e715a"	-- 8 G-Buffer Extract...
append cws_ops_array "0x676a7cb0 0xa7b1447a"	-- 9 RPF Motion Blur...
append cws_ops_array "0x676a7cb0 0x49bd683b"	-- 10 Show G-Buffer...
append cws_ops_array "0x676a7cb0 0x3f2f7527"	-- 11 Texture Map...
--		discreet Effect Operators
append cws_ops_array "0x23ec6df8 0x6bb03a21"	-- 12 discreet Color Corrector
append cws_ops_array "0x481e5fd7 0x194d4bbb"	-- 13 discreet Keyer
--		RenderEffects matching Operators
append cws_ops_array "0x8baf2fc7 0xefd23f35"	-- 14 Balance...
append cws_ops_array "0x8baf2fc7 0x5f6ede1d"	-- 15 Brightness/Contrast...
--		Cineon Operators
append cws_ops_array "0x481ab7a3 0xc407af72"	-- 16 Cineon Color Converter...
--		Add more if you need, but do not mess up those ones' order !
---------------------------------------------------------------------------------------------------------------------------
-- ***combustion image compliance filter***
fn IsCwsImgType img =
(
	cws_imgtype = #(".avi", ".bmp", ".cin", ".jpg", ".png", ".mov", ".rgb", ".rla", ".rpf", ".tga", ".tif",".exr")
	if findItem cws_imgtype (getfilenameType img) == 0 then return false else return true
)
-- ***combustion Warning***
fn cwsWarn message =
(
	outputTextColor = Red
	print message
	outputTextColor = Blue
)
--	***combustionScalarChannel output fonction***
fn write_cws_channel channel =
(
	index = ""
	for i = 1 to channel.index.count do
	(
		index += "~" + (channel.index[i] as string) ; if i != channel.index.count then index += "/" else(nothing)
	)
	channel_string = "		ResetChannel " + index + " " + channel.value as string + " on\n"
	if channel.keys.count > 0 then
	(
		channel_string += "		SetChannelKeys " + index
		for k in channel.keys do
		(
			channel_string += " " + (k.frame as string) + " " + k.value as string
		)
		channel_string += "\n"
	)
	return channel_string
)
--	***combustionHeader output fonction***
fn write_cws_head comment:"Output from discreet 3dsmax 4.0"=
(
	cws_head_string = "\n" +
	"		// combustion 3.0 by discreet. Workspace File. \n" +
	"		// " + comment + "\n" +
	"\n" +
	"ScriptInfo 1 0 1\n" +
	"\n"
	return cws_head_string
)
--	***combustionOperatorTable output fonction***
fn write_cws_operator OpClass num =
(
	cws_ops_string = "NewOperator " + OpClass + " " + num as string + "\n" +
	"\n"
	return cws_ops_string
)
--	***combustionComposite output fonction***
fn write_cws_composite num name width height pratio rate length =
(
	cws_comp_string = "\n" +
	"SetCurrentOperator " + num as string + "\n" +
	"	OperatorEnabled on\n" +
	"	SetOperatorName \"" + name + "\"\n" +
	"\n"
	cws_comp_string += "	CompositionSettings " + 
	width as string + " " + 
	height as string + " " + 
	pratio as string + " " + 
	rate as string + " " + 
	length as string + "\n" +
	"\n"
	return cws_comp_string
)
--	***combustionCompositeSettings output fonction***
fn write_cws_composite_settings  ambInt:0.1 ambientColor:[1,1,1] Width:720 Height:486 Fields:0 =
(
	cws_compsettings_string = "\n" +
	"	CD :~399999999\n" +
	"	ResetChannel ~5 " + ambInt as string + " on 0 0\n" +
	"	ResetChannel ~6/~1 " + ambientColor.x as string + " on 0 0\n" +
	"	ResetChannel ~6/~2 " + ambientColor.y as string + " on 0 0\n" +
	"	ResetChannel ~6/~3 " + ambientColor.z as string + " on 0 0\n" +
	"	ResetChannel ~9/~6 " + Width as string + " off 0 0\n" +
	"	ResetChannel ~9/~7 " + Height as string + " off 0 0\n" +
	"	ResetChannel ~9/~9 " + Fields as string + " off 0 0\n" +
	"\n"
	return cws_compsettings_string
)
--	***combustionCompositeObject output fonction***
fn write_cws_object object =
(
	cws_object_string = ""
	case object.kind of
	(
		#layer	:	cws_object_string += "	NewLayer "
		#light	:	cws_object_string += "	NewLight "
		#camera	:	cws_object_string += "	NewCamera "
		#null	:	cws_object_string += "	NewNull "
	)
	cws_object_string += object.order as string + "\n" +
	"		SetName \"" + object.name as string + "\"\n" +
	"		ObjectVisible " + (if object.isvisible then "On" else "Off") + "\n"
	if object.kind == #layer then (cws_object_string += "		LayerTrim 0 0 -1\n") else()
	cws_object_string += "\n"
	for c in object.channels do
	(
		cws_object_string += (write_cws_channel c)
	)
	cws_object_string += "\n"
	return cws_object_string
)
--	***combustion Parenting/Targeting output fonction***
fn write_cws_parenting cwsobject =
(
	if cwsobject.parent != undefined or cwsobject.target != undefined or cwsobject.stencil != undefined or cwsobject.hinge != undefined then
	(
		parenting_string = "	SetCurrentObject " + cwsobject.order as string + "\n"
		if cwsobject.parent != undefined then	(parenting_string += "		Parent " + cwsobject.parent as string + "\n")
		if cwsobject.target != undefined then	(parenting_string += "		Target " + cwsobject.target as string + "\n")
		if cwsobject.stencil != undefined then	(parenting_string += "		Stencil " + cwsobject.stencil as string + "\n")
		if cwsobject.hinge != undefined then	(parenting_string += "		Hinge " + cwsobject.hinge as string + "\n") -- srcEdge tgtEdge
		return parenting_string
	)
	else return ""
)
-- Turning filename into sequence filename
fn TurnToSeq file suffix:8 =
(
	suf = "" ; for s = 1 to suffix do (suf += "#")
	return ((getFileNamePath file) + (GetFilenameFile file) + "[" + suf + "]" + (GetFilenameType file))
)
--	***combustionFootage output fonction***
fn write_cws_footage footagenum footagename width height clipsrc opacity:0 color:[0,0,0] IsASeq:0 IsSolid:0 channels:#() =
(
	if IsASeq != 0 and (GetFilenameFile clipsrc) != ".avi" and (GetFilenameFile clipsrc) != ".mov" then
	(clipsrc = (TurnToSeq clipsrc suffix:IsASeq)) else()
	cws_footage_string = "SetCurrentOperator " + footagenum as string + "\n" +
	"	OperatorEnabled on\n" +
	"	SetOperatorName \"" + footagename as string + "\"\n" +
	"\n"
	
	if IsSolid != 1 then
	(
		cws_footage_string += "	SetCurrentClip 0\n" +
		"\n" +
		"	Filename \"" + clipsrc as string + "\" 1 1 1 1" + "\n" +
		"\n" +
		"	SetCurrentClip 1\n" +
		"\n"
	)
	cws_footage_string += "	SolidLayer " + width as string + " " + height as string + " " + color.x as string +
	" " + color.y as string + " " + color.z as string + " " + opacity as string + "\n" +
	"\n"
	for c in channels do
	(
		cws_footage_string += (write_cws_channel c)
	)
	cws_footage_string += "\n"
	return cws_footage_string
)
fn write_cws_cineonConverter OpNum OpName:"Cineon Color Converter" BlackP:95 WhiteP:685 GammaC:0.6 SoftClip:0.0 ColorDataInAlpha:1 ConvertMethod:3 =
(
	CineonString = "SetCurrentOperator " + OpNum as string + "\n" +
	"OperatorEnabled on\n" +
	"SetOperatorName \"" + OpName + "\"\n" +
	"\n" +
	"ResetChannel ~1 " + BlackP as string + " on 0 0\n" +
	"ResetChannel ~2 " + WhiteP as string + " on 0 0\n" +
	"ResetChannel ~3 " + GammaC as string + " on 0 0\n" +
	"ResetChannel ~4 " + SoftClip as string + " on 0 0\n" +
	"ResetChannel ~5 " + ColorDataInAlpha as string + " on 0 0\n" +
	"ResetChannel ~6 " + ConvertMethod as string + " off 0 0\n"
	return CineonString
)
--	***combustionConnection output fonction***
fn write_cws_connect opnum:1 _with:0 _at:0 =
(
	cws_connect_string = "SetCurrentOperator " + opnum as string + "\n" +
	"MakeConnection " + _with as string + " " + _at as string + "\n" +
	"\n"
	return cws_connect_string
)
--	***combustionEOF output fonction***
fn write_cws_eof start end audiofile:"" =
(
	cws_bom_string = "Mon1ViewSetup 1\n" +
	"SetCurrentView 0\n" +
	"ViewOperator 1 1 0\n" +
	"ViewOptions 1 8\n" +
	"ViewSettings 1 0 0 0 0 off off off off off off 1 0 0.5 0.5 0 0.5 0\n" +
	"\n" +
	"CurrentFrame 0\n" +
	"AudioSetup \"" + audiofile as string + "\" 0 0 0 0\n" +
	"PlayRange " + start as string + " " + end as string + "\n"
	return cws_bom_string
)