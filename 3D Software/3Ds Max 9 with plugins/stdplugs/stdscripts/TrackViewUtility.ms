-- Scripted Track View Utility plugins
-- ***********************************************
-- Created By Adam Felt
-- Modify at your own risk.
-- ***********************************************

plugin TrackViewUtility SoftSelectionManager
	name:"Soft Selection Settings Manager"
	category:"Scripted TV Utilities"
	classID:#(0x9ba0d47b, 0xcd3f255f)
(

 	rollout SoftSelectParams "Soft Selection" width:230 height:24
	(
		local tv
		local closing = false
		
		checkbutton useSoftSelect "Soft" pos:[6,4] width:30 height:20
		spinner range "Range:" pos:[60,5] width:70 height:20 range:[0,99999,10] type:#integer
		spinner falloff "Falloff:" pos:[152,5] width:70 height:20 range:[0.01,10.0,1.0] scale:0.01 type:#float
		
		on SoftSelectParams open do
		(
			tv = trackviews.current
			if tv != undefined do 
			(
				useSoftSelect.state = tv.useSoftSelect
				range.value = tv.softSelectRange
				falloff.value = tv.softSelectFalloff
			)
		)
		on SoftSelectParams closed do
		(
			if trackviews.current != undefined do
			(
				trackviews.current.closeUtility "Soft Selection Settings Manager"
			)
		)

		on useSoftSelect changed state do
		(
			if tv == undefined do
				tv = trackviews.current
			if tv != undefined do
				tv.useSoftSelect = state
		)
		on range changed value do
		(
			if tv == undefined do
				tv = trackviews.current
			if tv != undefined do
				tv.softSelectRange = value
		)
		on falloff changed value do
		(
			if tv == undefined do
				tv = trackviews.current
			if tv != undefined do
				tv.softSelectFalloff = value
		)
		on SoftSelectParams close do
		(
			if trackviews.current != undefined do
			(
				closing = true
				trackviews.current.closeUtility "Current Value Editor"
			)
		)

	)
	on Init val do
	(
		tv = val
		if tv != undefined do
		(
			createDialog SoftSelectParams parent:tv.ui.hwnd -- pos:[100,100]
			cui.registerDialogBar SoftSelectParams parent:tv.ui.hwnd style:#(#cui_dock_horz, #cui_floatable, #cui_handles) minSize:[240,30] maxSize:[240,30]
			SoftSelectParams.closing = false
		)
	)
	
	on TrackViewClosed do
	(
		if SoftSelectParams != undefined do (
			if SoftSelectParams.closing == false do (
				cui.UnregisterDialogBar SoftSelectParams
				destroyDialog SoftSelectParams
			)
		)
	)
	
	on keySelectionChanged do
	(
		if trackviews.current != undefined do
			SoftSelectParams.useSoftSelect.state = trackviews.current.useSoftSelect
	)
)

-- Current Value Editor
-- Transform type-in functionality for selected tracks
-- Lets you edit the value of selected tracks at the current frame.  
plugin TrackViewUtility KeyValueUtility
	name:"Current Value Editor"
	category:"Scripted TV Utilities"
	classID:#(0x57088e0e, 0x50b6e750)
(

	rollout valueRollout "Current Value" width:120 height:149
	(
		radiobuttons editMode "" pos:[12,6] width:63 height:32 labels:#("absolute", "relative") columns:1
		GroupBox valueGroup "Float" pos:[7,44] width:105 height:96
		spinner xvalue "X : " pos:[4,64] width:100 height:16 range:[-1e+007,1e+008,0] type:#float
		spinner yValue "Y : " pos:[4,89] width:100 height:16 range:[-1e+007,1e+008,0] type:#float
		spinner zValue "Z : " pos:[4,114] width:100 height:16 range:[-1e+007,1e+008,0] type:#float
		local origValue = 0.0
		local tv
		local closing = false
		
		fn UpdateValue =
		(
--			print "updating"
			-- defines that show selected controller type commonality
			local UNDEFINED_CONTROL = 0
			local FLOAT_CONTROL = 1
			local POINT3_CONTROL = 2
			local MIXED_CONTROL = 16
			local type = UNDEFINED_CONTROL
			
			xValue.value = 0.0
			yValue.value = 0.0
			zValue.value = 0.0
			
			tv = trackviews.current
			if tv == undefined then
			(
				print "no tv interface"
				return 0
			)
			
			for i in 1 to tv.numSelTracks() do
			(
				curControl = (tv.getSelected i)
				
				if ((SuperClassOf curControl) == FloatController) then 
				(
					if (type == UNDEFINED_CONTROL) then
					(
						if editMode.state != 2 do xValue.value = curControl.value
						type = FLOAT_CONTROL
					) 
					else
					(
						if (type == FLOAT_CONTROL) then
						(
							if xValue.value != curControl.value And editMode.state != 2 do
							(
								xValue.value = 0.0
							)
						)
						else
						(
							type = MIXED_CONTROL
						)
					)
				)
				-- Look for common position controllers
				else 
				(
					if ((SuperClassOf curControl) == PositionController or (SuperClassOf curControl) == Point3Controller or
						(SuperClassOf curControl) == RotationController or (SuperClassOf curControl) == ScaleController) then
					(
						if type == UNDEFINED_CONTROL then
						(
							if editMode.state != 2 do
							(
								xValue.value = curControl.value.x
								yValue.value = curControl.value.y
								zValue.value = curControl.value.z
							)
							type = POINT3_CONTROL
						)
						else 
						(
							if type == POINT3_CONTROL then
							(
								if xValue.value != curControl.value And editMode.state != 2 do
								(
									xValue.value = 0.0
									yValue.value = 0.0
									zValue.value = 0.0
								)
							)
							else
							(
								type = MIXED_CONTROL
							)
						)
					)
					else 
					(
						type= MIXED_CONTROL
					)
				)
				if type == MIXED_CONTROL  or type == UNDEFINED_CONTROL do
				(
					height = 135
					valueGroup.caption = "Mixed"
					xvalue.caption = ""
					xvalue.enabled = false
					yvalue.enabled = false
					zvalue.enabled = false
					xvalue.caption = ""
					yvalue.caption = ""
					zvalue.caption = ""
				)
				if type == FLOAT_CONTROL do
				(
					height = 80
					valueGroup.caption = "Float"
					xvalue.enabled = true
					yvalue.enabled = false
					zvalue.enabled = false
					xvalue.caption = ""
					yvalue.caption = ""
					zvalue.caption = ""
					
				)
				if type == POINT3_CONTROL do
				(
					height = 135
					valueGroup.caption = "Point3"
					xvalue.caption = "X :"
					yvalue.caption = "Y :"
					zvalue.caption = "Z :"
					xvalue.enabled = true
					yvalue.enabled = true
					zvalue.enabled = true
				)
			)
			if editMode.state == 2 then -- relative mode
			(
				xValue.value = 0.0
				yValue.value = 0.0
				zValue.value = 0.0
			)

		)
		
		fn setCurrentValue axis = 
		(
--			print "setting"
			tv = trackviews.current
			if tv == undefined then
			(
				return 0
			)
			
			trackCount = tv.numSelTracks()
			for i in 1 to trackCount do
			(
				curControl = (tv.getSelected i)
				if ((SuperClassOf curControl) == FloatController) then 
				(
					if (editMode.state == 1) then
					(
						curControl.value = xvalue.value
					)
					else
					(
						curControl.value += xvalue.value - origValue
						if i == trackCount do origValue = xvalue.value
					)
				)
				else
				(
					if (editMode.state == 1) then
					(
						if axis == 1 do 
						(
							curControl.value.x = xvalue.value
						)
						if axis == 2 do 
						(
							curControl.value.y = yvalue.value
						)
						if axis == 3 do 
						(
							curControl.value.z = zvalue.value
						)
					)
					else
					(
						if axis == 1 do 
						(
							curControl.value.x += xvalue.value - origValue
							if i == trackCount do origValue = xvalue.value
						)
						if axis == 2 do 
						(
							curControl.value.y += yvalue.value - origValue
							if i == trackCount do origValue = yvalue.value
						)
						if axis == 3 do 
						(
							curControl.value.z += zvalue.value - origValue
							if i == trackCount do origValue = zvalue.value
						)
					)
				)
			)
		)
		
		on valueRollout close do
		(
			if trackviews.current != undefined do
			(
				closing = true
				trackviews.current.closeUtility "Current Value Editor"
			)
		)
		on editMode changed state do
		(
			if state == 2 then
			(
				xValue.value = 0.0
				yValue.value = 0.0
				zValue.value = 0.0
			)
			else
			(
				UpdateValue()
			)
		)
		on xvalue changed val do
		(
			setCurrentValue 1
		)
		on xvalue buttondown do
		(
			origValue = 0.0
		)
		on xvalue buttonup do
		(
			origValue = 0.0
			if (editMode.state == 2) do
			(
				xvalue.value = 0.0
			)
		)
		on yValue changed val do
		(
			setCurrentValue 2
		)
		on yValue buttondown do
		(
			origValue = 0.0
		)
		on yValue buttonup do
		(
			origValue = 0.0
			if (editMode.state == 2) do
			(
				yvalue.value = 0.0
			)
		)
		on zValue changed val do
		(
			setCurrentValue 3
		)
		on zValue buttondown do
		(
			origValue = 0.0
		)
		on zValue buttonup do
		(
			origValue = 0.0
			if (editMode.state == 2) do
			(
				zvalue.value = 0.0
			)
		)
	)

	on create do
	(
--		print "creating..."
	)

	on trackSelectionChanged do
	(
--		print "track selection changed..."
		valueRollout.UpdateValue()
	)
	on nodeSelectionChanged do
	(
--		print "node selection changed..."
	)
	on keySelectionChanged do
	(
--		print "key selection changed..."
	)
	on timeSelectionChanged do
	(
--		print "time selection changed..."
	)
	on MajorModeChanged do
	(
--		print "major mode changed..."
	)
	on TrackListChanged do
	(
--		print "track list changed..."
	)
	
	on TrackViewClosed do
	(
		if valueRollout != undefined do (
			if valueRollout.closing == false do (
				cui.UnregisterDialogBar valueRollout
				destroyDialog valueRollout
			)
		)
	)
	
	on Init val do 
	(
		if val != undefined do 
		(
			valueRollout.tv = val
			createDialog valueRollout parent:(val.ui.hwnd)
			cui.registerDialogBar valueRollout parent:val.ui.hwnd
			valueRollout.closing = false
			valueRollout.updateValue()
		)
	)
)



