-- Custom Attributes MacroScript Struct Definition File
--
-- Created:  		Nov 7 2000
-- Last Updated: 	March 30, 2004 - Larry Minton 
--
-- Author :   Frank DeLise / Installed into stdplugs\stdscrpts by jbw 11.7.00
-- Version:  3D Studio Max Version 7.0
--
-- 
-- Custom Attributes Macroscript Struct Definition file.
--
--    Must reside in stdplugs\stdscripts for Custom Attribute dialogs to work.
--
-- Revision History:
--	March 30, 2004 - Larry Minton,
--		added Array and Alpha to CAT_UIItem
--
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
--

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Paramblock Definition
----------------------------------------------------------------------------------------------------------------------------------------------------------------

Struct CAT_ParamBlock
(
	Name,	-- the name of the parameter
	Type,	-- the type of the parameter
	UI,		-- the name of the rollout ui item
	Default = "", -- the default value for the parameter
	OrigName -- the original name of the parameter. Used when editting attributes
)

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- UI Items Definition
----------------------------------------------------------------------------------------------------------------------------------------------------------------
Struct CAT_UIItem
(
	UI, 								-- ui item type
	Name,								-- ui item name
	String,								-- ui item caption
	Type,								-- value type
	Range = "[0,100,0]",				-- spinner, slider
	Default = "1",						-- default value
	Width = "70",						-- ui item width
	Height = "25",						-- ui item height
	Enabled = "True",					-- not used
	Orient = "Horizontal",				-- slider
	Checked = "False",					-- not used
	Color = "(color 0 0 0)",			-- colorswatch default color
	HighLightColor = "(color 0 255 0)",	-- checkbutton
	Align = "Left",						-- alignment
	Items = "#()",						-- typically contains var name pointing at array
	Ticks = "10",						-- slider
	Array = #(),						-- array of strings
	Alpha = "False",					-- colorpicker - true if frgba
	Offset = "[0,0]",					-- UI control offset
	LabelOnTop = "False"				-- Label on top for edittext
)

