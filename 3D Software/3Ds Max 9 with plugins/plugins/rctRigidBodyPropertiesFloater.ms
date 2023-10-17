-------------------------------------------------------
---- 3dsmax4: place this in the scripts\Havok directory
---- 3dsmax5: place this in the scripts\Havok directory
-------------------------------------------------------

---------------------------------------------------
-- global 'script active' flag
-- required to block updates when rollout is closed
---------------------------------------------------

fileIn "rctUtilityFunctions.ms"

global bool RCT_STUPID_BUG = false

if RCTPropertiesFloaterSize == undefined then RCTPropertiesFloaterSize = [190,475]
if RCTPropertiesFloaterPos == undefined then RCTPropertiesFloaterPos = [200,200]
if RCTPropertiesFloaterScrollPos == undefined then RCTPropertiesFloaterScrollPos = 0
if ( RCTPropertiesFloater != undefined ) then closeRolloutFloater RCTPropertiesFloater
RCTPropertiesFloater = newRolloutFloater "Rigid Body Properties" 0 0 0 0
closeRolloutFloater RCTPropertiesFloater

global rctCurrentSelectionOfRigidBodies = #()
global rctAreAllRigidBodies = false
------------------------------------------------------
---- study selection fn
---- examines the current selection for havok entities
------------------------------------------------------

fn rctStudySelection = 
(
	-------------------------
	---- wipe the slate clean
	--------------------------
	rctCurrentSelectionOfRigidBodies = #()
	rctAreAllRigidBodies = true

	---------------------------------------------------------------------------------
	---- sort the selection into mini-selections and gather stats on 
	---- what type of havok objecsts we have selected
	---------------------------------------------------------------------------------
	
	for ob in selection do
	(
		if ((rct_isRigidBody ob) or (rct_isPrimitive ob)) then
		(   
			append rctCurrentSelectionOfRigidBodies ob
		)
		else 
		(
			rctAreAllRigidBodies = false		
		)
	)
	if (selection.count==0) then rctAreAllRigidBodies = false
	
	-----------------------------------------------------------------------------
	---- check to see if there is a closed grouphead present in the rigidbody list
	---- and if there is one present then remove it's children from the RB list
	-----------------------------------------------------------------------------

	closedGroupHeads = #()

	for i in rctCurrentSelectionOfRigidBodies do
	(
		if (isGroupHead i and not isOpenGroupHead i) then 
		(
			append closedGroupHeads i
		)
	)

	for h in closedGroupHeads do
	(
		for c in h.children do
		(
			index = findItem rctCurrentSelectionOfRigidBodies c

			if (index != 0) then
			(
				deleteItem rctCurrentSelectionOfRigidBodies index
			)
		)
	)
)	

function setRCTProperties o 			\
	mass:0.000000				\
	elasticity:0.300000			\
	friction:0.300000			\
	unyielding:0				\
	simulationGeometry:2			\
	proxyGeometry:"<None>"			\
	useDisplayProxy:0			\
	disableCollisions:0			\
	inactive:0				\
	displayProxy:"<None>" 	 		\
	phantom:0= 
(
	if not undefined == o then
	(
		
		if isGroupHead o then
		(
			-- o is a RB grouphead
			if (undefined == (rct_getFloatUserProp o "Ellasticity")) 		then setUserProp o "Ellasticity" 			elasticity
			if (undefined == (rct_getFloatUserProp o "Friction")) 			then setUserProp o "Friction" 				friction	
			if (undefined == (getUserProp o "Unyielding")) 			then setUserProp o "Unyielding" 			unyielding
			if (undefined == (getUserProp o "Use_Display_Proxy")) 	then setUserProp o "Use_Display_Proxy" 		useDisplayProxy
			if (undefined == (getUserProp o "Inactive")) 			then setUserProp o "Inactive" 				inactive
			if (undefined == (getUserProp o "Display_Proxy")) 		then setUserProp o "Display_Proxy" 			displayProxy					
		)
		else if isGroupMember o then
		(
			-- o is a primitive
						
			massOfPrimitives = 10.0 / o.parent.children.count 

			if (undefined == (rct_getFloatUserProp o "Mass")) 				then setUserProp o "Mass" 					massOfPrimitives
			if (undefined == (getUserProp o "Simulation_Geometry")) then setUserProp o "Simulation_Geometry" 	simulationGeometry
			if (undefined == (getUserProp o "Proxy_Geometry")) 		then setUserProp o "Proxy_Geometry" 		proxyGeometry
			if (undefined == (getUserProp o "Disable_Collisions")) 	then setUserProp o "Disable_Collisions" 	disableCollisions
			if (undefined == (getUserProp o "Phantom")) 			then setUserProp o "Phantom" 				phantom

		)
		else
		(
			-- o is a simple RB
			
			if (undefined == (rct_getFloatUserProp o "Mass")) 				then setUserProp o "Mass" 					mass
			if (undefined == (rct_getFloatUserProp o "Ellasticity")) 		then setUserProp o "Ellasticity" 			elasticity
			if (undefined == (rct_getFloatUserProp o "Friction")) 			then setUserProp o "Friction" 				friction
			if (undefined == (getUserProp o "Optimization_Level")) 	then setUserProp o "Optimization_Level" 	optimizationLevel
			if (undefined == (getUserProp o "Unyielding")) 			then setUserProp o "Unyielding" 			unyielding
			if (undefined == (getUserProp o "Simulation_Geometry")) then setUserProp o "Simulation_Geometry"	simulationGeometry
			if (undefined == (getUserProp o "Proxy_Geometry")) 		then setUserProp o "Proxy_Geometry" 		proxyGeometry
			if (undefined == (getUserProp o "Use_Display_Proxy")) 	then setUserProp o "Use_Display_Proxy" 		useDisplayProxy
			if (undefined == (getUserProp o "Disable_Collisions")) 	then setUserProp o "Disable_Collisions" 	disableCollisions
			if (undefined == (getUserProp o "Inactive")) 			then setUserProp o "Inactive" 				inactive
			if (undefined == (getUserProp o "Display_Proxy")) 		then setUserProp o "Display_Proxy" 			displayProxy	
			if (undefined == (getUserProp o "Phantom")) 			then setUserProp o "Phantom" 				phantom
		)
			
	)--if
)

-- This rollout is declared first as it is referenced by the properties rollout
rollout rctDisplayOptions "Display" width:190 height:65
(
	local bUpdate = true
	local bDisplayProxyChanged = false;

	function GeometryFilter obj =
	(
		isKindOf obj GeometryClass
	)
	
	function IsEntity obj = 
	(
		if isKindOf obj GeometryClass then return true
		if isKindOf obj rctPlane then
		(
			return true
		)
		if isGroupHead obj then 
		(
			if obj.children.count < 1 then return false
			for obj_child in obj.children do
			(

				if isKindOf obj_child GeometryClass and isGroupMember obj_child then return true
			) 
		)
		return false
	)
	
	checkbox displayProxyCB "Use Display Proxy" pos:[23,9] width:125 height:16
	pickButton pickDisplayProxy "<None>" pos:[52,29] width:93 height:21 filter:GeometryFilter toolTip:"Pick Proxy Display"
	label proxyLabel2 "Proxy" pos:[17,33] width:31 height:16 enabled:true
	

	function enableAll = 
	(
		displayProxyCB.enabled = true
		pickDisplayProxy.enabled = true
		proxyLabel2.enabled = true
	)

	function disableAll = 
	(
		bUpdate = false
		displayProxyCB.enabled = false
		displayProxyCB.checked = false
		displayProxyCB.text = "Use Display Proxy"
		pickDisplayProxy.enabled = false
		pickDisplayProxy.text = "<None>"
		proxyLabel2.enabled = false
		bUpdate = true		
	)

	
	function updateProperties =
	(
		if bUpdate then 
		(
			for obj in rctCurrentSelectionOfRigidBodies do
			(
				if 	bDisplayProxyChanged==true then
				(
					if displayProxyCB.checked then setUserProp obj "Use_Display_Proxy" 1
					else setUserProp obj "Use_Display_Proxy" 0
				)
			)--for
		)--if

	)

	function updateRollout = 
	(
		enableAll()
		if (0 == rctCurrentSelectionOfRigidBodies.count) then 
		(
			disableAll()
			return false
		)
	
		local hasCommonDisplayProxyCheck = true
		local hasCommonDisplayProxyObject = true
		
		if (undefined == (getUserProp rctCurrentSelectionOfRigidBodies[1] "Use_Display_Proxy")) then 
		(
			--format "Use_Display_Proxy\n"
			
			setRCTProperties rctCurrentSelectionOfRigidBodies[1]
		)
		
		local initialDisplayProxyCheck = getUserProp rctCurrentSelectionOfRigidBodies[1] "Use_Display_Proxy"
		local initialDisplayProxyObject = getUserProp rctCurrentSelectionOfRigidBodies[1] "Display_Proxy"
		for o in rctCurrentSelectionOfRigidBodies do
		(
			----------------------------------------------------------------------
			---- The display options only apply to RBs and not to primitves
			----------------------------------------------------------------------

			if (isGroupMember o) then
			(
				disableAll()					
				return false
			)
			
			if (not isEntity o) then
			(
				disableAll()
				return false
			)
			if (undefined == (getUserProp o "Use_Display_Proxy")) then
			(
				--format "Use_Display_Proxy" 
				setRCTProperties o
			)
			if (initialDisplayProxyCheck != (getUserProp o "Use_Display_Proxy")) then
			(
				hasCommonDisplayProxyCheck = false
			)
			if (initialDisplayProxyObject != (getUserProp o "Display_Proxy")) then
			(
				hasCommonDisplayProxyObject = false
			)
		)
		bUpdate = false
			
		if (hasCommonDisplayProxyCheck==true) and (initialDisplayProxyCheck==1) then
		(
				displayProxyCB.text = "Use Display Proxy"
				displayProxyCB.state = (initialDisplayProxyCheck==1)
		)
		else
		(
			if (hasCommonDisplayProxyCheck==false) then 
			(
				displayProxyCB.text = "Use Display Proxy -NC"
			)
			displayProxyCB.checked = false
		)
		if hasCommonDisplayProxyObject then
		(
			if (initialDisplayProxyObject != "<None>") then
			(
				temp_name = "$"+ initialDisplayProxyObject
				obj_node = readvalue (temp_name as stringStream) -- bit hacky but you can't get at it otherwise
				if((obj_node == undefined) or (not isKindOf obj_node GeometryClass)) then
				(
					for o in rctCurrentSelectionOfRigidBodies do
					(
						setUserProp	o "Display_Proxy" "<None>"
					)
					updateRollout()
				)
				else
				(
					pickDisplayProxy.text = initialDisplayProxyObject
				)
			)
			else
			(
				pickDisplayProxy.text = "<None>"
			)
		)
		else
		(
			pickDisplayProxy.text = "NOT COMMON"
		)		
		
		
		pickDisplayProxy.enabled = displayProxyCB.checked
				
		bUpdate = true
	)
	
	--------------------------------------------------------------------------------------
	---- The selection to the left and right of rigidbodies is a special case
	---- as the rigidbody properties are displayed across 3 separate rollouts
	--------------------------------------------------------------------------------------
	
	on displayProxyCB changed state do 
	(
		bDisplayProxyChanged = true
		updateProperties()
		updateRollout()
		bDisplayProxyChanged = false
	)
	on pickDisplayProxy picked obj do
	(
		for o in rctCurrentSelectionOfRigidBodies do 				
		(
 			setUserProp	o "Display_Proxy" obj.name
		)--for 		
		pickDisplayProxy.text=obj.name
	)	
	on rctDisplayOptions open do 
	(
		rctStudySelection()
		updateRollout()
	)
)

rollout rctPhysicsProperties "Physical Properties" width:190 height:155
(
	local bUpdate = false;
	local bMassChanged = false;
	local bElasticityChanged = false;
	local bFrictionChanged = false;
	local bInactiveChanged = false;
	local bDisableAllCollisionsChanged = false;
	local bUnyieldingChanged = false;
	local bPhantomChanged = false;

	checkbox inactiveCB "Inactive" pos:[26,89] width:130 height:16
	checkbox disableAllCollisionsCB "Disable All Collisions" pos:[26,108] width:135 height:16
	checkbox unyieldingCB "Unyielding" pos:[26,128] width:130 height:16
	checkbox phantomCB "Phantom" pos:[26,148] width:130 height:16
	spinner massValue "Mass" pos:[42,9] width:94 height:16 range:[0,1e+006,0]
	spinner frictionValue "Friction" pos:[33,33] width:103 height:16 range:[0.0,5.0,0.3] scale:0.01
	spinner elasticityValue "Elasticity" pos:[26,56] width:110 height:16 range:[0.0,5.0,0.3] scale:0.01
	label massNotCommon "" pos:[140,9] width:20 height:16
	label frictionNotCommon "" pos:[140,33] width:20 height:16
	label elasticityNotCommon "" pos:[140,56] width:20 height:16

	function IsEntity obj = 
	(
		if isKindOf obj GeometryClass then return true
		if isKindOf obj rctPlane then
		(
			return true
		)
		if isOpenGroupHead obj then 
		(
			if obj.children.count < 1 then return false
			for obj_child in obj.children do
			(
				if isKindOf obj_child GeometryClass and isGroupMember obj_child then return true
			) 
		)
		return false
	)

	function enableAll = 
	(
		massValue.enabled = true
		elasticityValue.enabled = true
		frictionValue.enabled = true
		inactiveCB.enabled = true
		disableAllCollisionsCB.enabled = true
		unyieldingCB.enabled = true	
		phantomCB.enabled = true
	)

	function disableAll =
	(
		massValue.enabled = false
		elasticityValue.enabled = false
		frictionValue.enabled = false
		inactiveCB.enabled = false
		inactiveCB.text = "Inactive"
		phantomCB.enabled = false
		phantomCB.text = "Phantom"
		disableAllCollisionsCB.enabled = false
		disableAllCollisionsCB.text = "Disable All Collisions"
		unyieldingCB.enabled = false
		unyieldingCB.text = "Unyielding"
		massNotCommon.text = ""
		frictionNotCommon.text = ""
		elasticityNotCommon.text = ""
	)
	
	function disablePrimitiveBits = 
	(
		massValue.enabled = false
		massNotCommon.text = ""
		
		phantomCB.enabled = false
		phantomCB.text = "Phantom"

	)

	function disableRigidBodyBits = 
	(
		elasticityValue.enabled = false
		elasticityNotCommon.text = ""
		
		frictionValue.enabled = false
		frictionNotCommon.text = ""
		
		inactiveCB.enabled = false
		inactiveCB.text = "Inactive"
				
		unyieldingCB.enabled = false
		unyieldingCB.text = "Unyielding"
	)	
	
	function updateProperties =
	(
		if bUpdate then 
		(
			for obj in rctCurrentSelectionOfRigidBodies do
			(
				if bMassChanged then setUserProp obj "Mass" massValue.value	
				if bElasticityChanged then setUserProp obj "Ellasticity" elasticityValue.value	
				if bFrictionChanged then 
				( 
					setUserProp obj "Friction" frictionValue.value
				)
				if bInactiveChanged then 
				(
					if inactiveCB.checked==true then setUserProp obj "Inactive" 1
					else setUserProp obj "Inactive" 0
				)
				if bDisableAllCollisionsChanged then 
				(
					if disableAllCollisionsCB.checked==true then setUserProp obj "Disable_Collisions" 1
					else setUserProp obj "Disable_Collisions" 0
				)	
				if bUnyieldingChanged then 
				(
					if unyieldingCB.checked==true then setUserProp obj "Unyielding" 1
					else setUserProp obj "Unyielding" 0
				)
				if bPhantomChanged then 
				(
					if phantomCB.checked==true then setUserProp obj "Phantom" 1
					else setUserProp obj "Phantom" 0
				)	
			)--for
		)--if
	)--function
	
	function updateRollout = 
	(
		if (rctCurrentSelectionOfRigidBodies.count == 0) then 
		(
			disableAll()
			return false
		)
	
		if ( (undefined == (rct_getFloatUserProp rctCurrentSelectionOfRigidBodies[1] "Mass")) or (undefined == (getUserProp rctCurrentSelectionOfRigidBodies[1] "Phantom")) ) then 
		(	
			setRCTProperties rctCurrentSelectionOfRigidBodies[1]			
		)
		
		-----------------------
		---- Get initial values
		-----------------------
				
		-----------------------------------------------------
		---- The mass of a group is the sum of the masses of 
		---- it's children
		-----------------------------------------------------		
		if (isGroupHead rctCurrentSelectionOfRigidBodies[1]) then
		(		
			initial_mass = 0
			
			for c in rctCurrentSelectionOfRigidBodies[1].children do
			(
				if rct_isPrimitive c then
				(
					primMass = rct_getFloatUserProp c "Mass"
					if (primMass == Undefined) then
					(
						primMass = 0.0
					) 
					initial_mass += primMass
				)
			)
		)
		else
		(
			initial_mass = rct_getFloatUserProp rctCurrentSelectionOfRigidBodies[1] "Mass"	
		)
		
		initial_friction = rct_getFloatUserProp rctCurrentSelectionOfRigidBodies[1] "Friction"
		initial_elasticity = rct_getFloatUserProp rctCurrentSelectionOfRigidBodies[1] "Ellasticity"
		initial_unyielding = getUserProp rctCurrentSelectionOfRigidBodies[1] "Unyielding"
		initial_disableAllCollisions = getUserProp rctCurrentSelectionOfRigidBodies[1] "Disable_Collisions"
		initial_inactive = getUserProp rctCurrentSelectionOfRigidBodies[1] "Inactive"
		initial_phantom = getUserProp rctCurrentSelectionOfRigidBodies[1] "Phantom"
		
		bHasCommonMass = (initial_mass != undefined )
		bHasCommonFriction = (initial_friction != undefined)
		bHasCommonElasticity = (initial_elasticity != undefined)
		bHasCommonUnyielding = (initial_unyielding != undefined)
		bHasCommonDisableAllCollisions = (initial_disableallCollisions != undefined)
		bHasCommonInactive = (initial_inactive != undefined)
		bHasCommonPhantom = (initial_phantom != undefined)
		bIsEntity = false
	
		local bIsGroupPresent = false
		local bIsPrimitivePresent = false
		
		for rbody in rctCurrentSelectionOfRigidBodies do
		(			
			if (isGroupHead rbody) then
			(
				bIsGroupPresent = true
			)
			
			if (isGroupMember rbody) then
			(
				bIsPrimitivePresent = true
			)
			
			if (undefined == (getUserProp rbody "Phantom")) or
				(undefined == (rct_getFloatUserProp rbody "Ellasticity")) then
			(			
				setRCTProperties rbody
			)
			
			-----------------------------------------------------
			---- The mass of a group is the sum of the masses of 
			---- it's children
			-----------------------------------------------------
			
			if (isGroupHead rbody) then
			(			
				massOfGroup = 0 
				
				for p in rbody.children do
				(
					if rct_isPrimitive p then
					(
						primMass = rct_getFloatUserProp p "Mass"
						if (primMass == Undefined) then
						(
							primMass = 0.0
						) 
						massOfGroup += primMass
					)
				)
				
				if (initial_mass != massOfGroup) then
				(	
					bHasCommonMass = false
				)	
			)
			else if (initial_mass != (rct_getFloatUserProp rbody "Mass")) then
			(
				bHasCommonMass = false
			)
			
			if (initial_elasticity != (rct_getFloatUserProp rbody "Ellasticity")) then
			(
				bHasCommonElasticity = false
			)
			if (initial_friction != (rct_getFloatUserProp rbody "Friction")) then
			(
				bHasCommonFriction = false
			)
			if (initial_inactive != (getUserProp rbody "Inactive")) then
			(
				bHasCommonInactive = false
			)
			if (initial_disableAllCollisions != (getUserProp rbody "Disable_Collisions")) then
			(
				bHasCommonDisableAllCollisions = false
			)
			if (initial_unyielding != (getUserProp rbody "Unyielding")) then
			(
				bHasCommonUnyielding = false
			)
			if (initial_phantom != (getUserProp rbody "Phantom")) then
			(
				bHasCommonPhantom = false
			)
		
		)--for
		
		bUpdate = false
		if bHasCommonMass then 
		(
			massValue.value = initial_mass
			massNotCommon.text = ""
		)
		else
		(
			massValue.value = 0.0
			massNotCommon.text = "-NC"
		)
		if bHasCommonFriction then 
		(
			frictionValue.value = initial_friction	
			frictionNotCommon.text = ""
		)
		else
		(
			frictionValue.value = 0.3
			frictionNotCommon.text = "-NC"
		)
		if bHasCommonElasticity then 
		(
			elasticityValue.value = initial_elasticity
			elasticityNotCommon.text = ""
		)
		else
		(
			elasticityValue.value = 0.3
			elasticityNotCommon.text = "-NC"
		)
		if bHasCommonUnyielding then 
		(
			unyieldingCB.checked = (initial_unyielding==1)
			unyieldingCB.text = "Unyielding"
		)
		else
		(
			unyieldingCB.checked = false
			unyieldingCB.text = "Unyielding -NC"
		)
		if bHasCommonInactive then 
		(
			inactiveCB.checked = (initial_inactive==1)
			inactiveCB.text = "Inactive"
		)
		else
		(
			inactiveCB.checked = false
			inactiveCB.text = "Inactive -NC"
		)
		if bHasCommonDisableAllCollisions then 
		(
			disableAllCollisionsCB.checked = (initial_disableAllCollisions==1)
			disableAllCollisionsCB.text = "Disable All Collisions"
		)
		else
		(
			disableAllCollisionsCB.checked = false
			disableAllCollisionsCB.text = "Disable All Collisions -NC"
		)
		if bHasCommonPhantom then 
		(
			phantomCB.checked = (initial_phantom==1)
			phantomCB.text = "Phantom"
		)
		else
		(
			phantomCB.checked = false
			phantomCB.text = "Phantom -NC"
		)		
		bUpdate = true
		
		enableAll()
		
		---------------------------------------------------------------------------------
		---- If groups are present in the selection we disable the mass spinner
		---- If primitives are in the selection we disable all the other properties
		---------------------------------------------------------------------------------
		
		if bIsGroupPresent then
		(
			disablePrimitiveBits()
		)
		
		if bIsPrimitivePresent then
		(
			disableRigidBodyBits()
		)
	)--function

	on massValue entered do 
	(
		bMassChanged = true
		updateProperties()
		updateRollout()
		bMassChanged = false
	)
		
	on elasticityValue entered do 
	(
		bElasticityChanged = true
		updateProperties()
		updateRollout()
		bElasticityChanged = false
	)
	
	on frictionValue entered do 
	(
		bFrictionChanged = true
		updateProperties()
		updateRollout()
		bFrictionChanged = false
	)	
	
	on unyieldingCB changed state do 
	(
		bUnyieldingChanged = true
		updateProperties()
		updateRollout()
		bUnyieldingChanged = false
	)
	
	on inactiveCB changed state do 
	(
		bInactiveChanged = true
		updateProperties()
		updateRollout()
		bInactiveChanged = false
	)
	
	on disableAllCollisionsCB changed state do 
	(
		bDisableAllCollisionsChanged = true
		updateProperties()
		updateRollout()
		bDisableAllCollisionsChanged = false
	)
	
	on phantomCB changed state do 
	(
		bPhantomChanged = true
		updateProperties()
		updateRollout()
		bPhantomChanged = false
	)	
	
	on rctPhysicsProperties open do
	(
		-- updateRollout assigns default params to bodies 
		rctStudySelection()
		updateRollout()
	)
	on rctPhysicsProperties close  do
	(
		if (RCTPropertiesFloater!= undefined) then
		(
			RCTPropertiesFloaterSize = RCTPropertiesFloater.size
			RCTPropertiesFloaterPos  = RCTPropertiesFloater.pos
			if (rctDisplayOptions != undefined) then
			(
				--this gets closed first so the scroll position of the last rollout before
				--any get closed is the correct scroll position for the rollout window
				RCTPropertiesFloaterScrollPos = rctDisplayOptions.scrollPos
			)
		)			
	)		
)

rollout rctSimulationGeometry "Simulation Geometry" width:190 height:200
(
	local bUpdate = true
	function GeometryFilter obj =
	(
		isKindOf obj GeometryClass
	)
	
	function IsEntity obj = 
	(
		if isKindOf obj GeometryClass then return true
		if isKindOf obj rctPlane then
		(
			return true
		)
		if isOpenGroupHead obj then 
		(
			if obj.children.count < 1 then return false
			for obj_child in obj.children do
			(
				if isKindOf obj_child GeometryClass and isGroupMember obj_child then return true
			) 
		)
		return false
	)
	
	radioButtons simGeoms "" pos:[23,8] width:124 height:112 labels:#("Bounding Box", "Bounding Sphere", "Mesh Convex Hull", "Proxy Convex Hull", "Concave Mesh", "Proxy Concave Mesh", "Not Shared") default:3 columns:1
	pickButton pickProxy "<None>" pos:[52,125] width:93 height:21 filter:GeometryFilter toolTip:"Pick Proxy Geometry"
	label proxyLabel "Proxy" pos:[17,127] width:31 height:16 enabled:true

	function enableAll = 
	(
		simGeoms.enabled = true
		pickProxy.enabled = true
		proxyLabel.enabled = true
	)

	function disableAll = 
	(
		bUpdate = false
		simGeoms.state = 3
		simGeoms.enabled = false
		pickProxy.enabled = false
		pickProxy.text = "<None>"
		proxyLabel.enabled = false
		bUpdate = true
	)

	function disableProxyBits =
	(
		pickProxy.enabled = false
		proxyLabel.enabled = false
	)
	
	function enableProxyBits =
	(
		pickProxy.enabled = true
		proxyLabel.enabled = true
	)	
	
	function updateProperties =
	(
		if (simGeoms.state != 4) and (simGeoms.state !=6) then
		(
			disableProxyBits()
		) 
		else enableProxyBits()
	
		if bUpdate then 
		(
			for obj in rctCurrentSelectionOfRigidBodies do
			(
				if (simGeoms.state ==6) or (simGeoms.state ==5) then
				(
					setUserProp	obj "Simulation_Geometry" (simGeoms.state)
				)
				else if simGeoms.state != 7 then
				(
					setUserProp	obj "Simulation_Geometry" (simGeoms.state-1)
				)				
			)--for
		)--if
	)

	function updateRollout = 
	(
		enableAll()
		
		if 0 == rctCurrentSelectionOfRigidBodies.count then 
		(
			disableAll()
			return false
		)
	
		local hasCommonGeometryType = true
		local hasCommonProxyObject = true
		
		if (undefined == (getUserProp rctCurrentSelectionOfRigidBodies[1] "Simulation_Geometry")) then 
		(
			--format "Simulation_Geometry" 
			setRCTProperties rctCurrentSelectionOfRigidBodies[1]
		)
		
		local initialSimGeom = getUserProp rctCurrentSelectionOfRigidBodies[1] "Simulation_Geometry"
		local initialProxyObject = getUserProp rctCurrentSelectionOfRigidBodies[1] "Proxy_Geometry"
		
		for o in rctCurrentSelectionOfRigidBodies do
		(
			----------------------------------------------------------------------
			---- The simulation geometry only applies to primitives and not 
			---- grouped rigidbodies so if there is a group present we must 
			---- disable this rollout
			----------------------------------------------------------------------

			if (isGroupHead o) then
			(
				disableAll()
				return false
			)

			if (not isKindOf o GeometryClass) then
			(
				disableAll()
				return false
			)
			
			if (undefined == (getUserProp o "Simulation_Geometry")) then
			(
				--format " Simulation_Geometry\n"
				
				setRCTProperties o
			)
			if (initialSimGeom != (getUserProp o "Simulation_Geometry")) then
			(
				hasCommonGeometryType = false
			)
			if (initialProxyObject != (getUserProp o "Proxy_Geometry")) then
			(
				hasCommonProxyObject = false
			)
		)
		bUpdate = false
		if hasCommonGeometryType then 
		(
			if (initialSimGeom == 5) or (initialSimGeom == 6) then simGeoms.state = initialSimGeom
			else simGeoms.state = (initialSimGeom + 1)
		)
		else if 1 == rctCurrentSelectionOfRigidBodies.count then simGeoms.state = 3 -- Assume in creation 
		else simGeoms.state = 7 			--Not Shared Value	
		--We still display the proxy node even if it's grayed out
		(
			if (hasCommonProxyObject) then
			(
				if (initialProxyObject != "<None>") then
				(
					temp_name = "$"+ initialProxyObject
					obj_node = readvalue (temp_name as stringStream) -- bit hacky but you can't get at it otherwise
					if((obj_node == undefined) or (not isKindOf obj_node GeometryClass)) then
					(
						for o in rctCurrentSelectionOfRigidBodies do
						(
							setUserProp	o "Proxy_Geometry" "<None>"
						)
						updateRollout()
					)
					else
					(
						pickProxy.text = initialProxyObject
					)
				)
				else
				(
					pickProxy.text = "<None>"
				)
			)
			else pickProxy.text = "NOT COMMON"	 
		)
		if (simGeoms.state != 4) and (simGeoms.state !=6) then
		(
			disableProxyBits()
		) 
			
		bUpdate = true
	)

	on simGeoms changed state do 
	(
		if (RCT_STUPID_BUG==true) then 
		(
			--format "why is stupid bug true?\n"
			return false
		)
		updateProperties()
		updateRollout()
	)

	on pickProxy picked obj do
	(
		for o in rctCurrentSelectionOfRigidBodies do 				
		(
 			setUserProp	o "Proxy_Geometry" obj.name
		)--for 		
		pickProxy.text=obj.name
	)
	
	on rctSimulationGeometry open do 
	(
		rctStudySelection()

		updateRollout()
	)
)

function rctUpdateRigidBodyRollout =
(	
	if (undefined == RCTPropertiesFloater) then 
	(		
		return false
	)

	--in max 5 you can check to see if a floater window is currently active in max
	--we don't want to update unless the user is using the rollout
	if ( RCTPropertiesFloater.open == false ) then
	(
		return false
	)

				
	rctStudySelection()

	--if ( rctAreAllRigidBodies == false ) then
	--(
--		RCTPropertiesFloater.size=[RCTPropertiesFloaterSize.x,0]	
--		return false
--	)
--	else
	(
			rctPhysicsProperties.open = true
			rctSimulationGeometry.open = true
			rctDisplayOptions.open = true

			rctPhysicsProperties.updateRollout()
			rctSimulationGeometry.updateRollout()
			rctDisplayOptions.updateRollout()
			RCT_STUPID_BUG = true
				RCTPropertiesFloater.size=[RCTPropertiesFloaterSize.x,RCTPropertiesFloaterSize.y]
			RCT_STUPID_BUG = false
	)	
)

--------------------------------------------------------------
---- Uncomment this to use this script as a stand alone script
---- as oppose to a component of the havok properties viewer
--------------------------------------------------------------
	
function rctMakeRBPropertiesUI = 
(	
	if undefined != RCTPropertiesFloater then
	(
		removeRollout rctPhysicsProperties RCTPropertiesFloater 
		removeRollout rctSimulationGeometry RCTPropertiesFloater 
		removeRollout rctDisplayOptions RCTPropertiesFloater 
		closeRolloutFloater RCTPropertiesFloater
	)
		
	RCTPropertiesFloater = newRolloutFloater "Rigid Body Properties" RCTPropertiesFloaterSize.x RCTPropertiesFloaterSize.y RCTPropertiesFloaterPos.x RCTPropertiesFloaterPos.y
	addRollout rctPhysicsProperties RCTPropertiesFloater 
	addRollout rctSimulationGeometry RCTPropertiesFloater 
	addRollout rctDisplayOptions RCTPropertiesFloater 
	
	if(RCTPropertiesFloaterScrollPos != undefined) then 
	(
		rctDisplayOptions.scrollPos = RCTPropertiesFloaterScrollPos 
	)	
	
	rctUpdateRigidBodyRollout()

	callbacks.removeScripts #selectionSetChanged id:#rct_rbproperties
	callbacks.addScript #selectionSetChanged "rctUpdateRigidBodyRollout()" id:#rct_rbproperties
)