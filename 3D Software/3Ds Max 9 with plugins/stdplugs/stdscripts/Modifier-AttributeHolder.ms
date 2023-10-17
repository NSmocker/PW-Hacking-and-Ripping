-- Attribute Holder
-- Great for Adding custom attributes to object 			
--
-- Author :  Fred Ruff / Larry Minton
-- Version:  3ds max 4 / 3ds max 7
--

-- r7 def:
plugin modifier EmptyModifier
	name:"Attribute Holder"
	classID:#(0x6335c722, 0x86dab777)
	version:1
(
)

-- < r7 def. When instances are loaded from file
-- the postload2 callback converts the instance
-- to a r7 def. 
plugin SimpleMod EmptyModifier_Old
	name:"Attribute Holder (old)"
	classID:#(0x6335c721, 0x86dab777)
	version:1
	invisible:true
(
	parameters pblock rollout:params
	(
		myparam type:#string ui:ab default:"Add Custom Attributes Here"
	)
    
	rollout params "Custom Attributes"
	(
		Label ab "Add Custom Attributes Here"
	)
	on postload do
	(	
		local newMod = EmptyModifier()
		replaceinstances this newMod transferCAs:true
	)
)


