-------------------------------------------------------------------------------
--   
--  File:		rc2mxs.ms		
--  Description:	Helper struct for generating Maxscript rollouts/dialogs from rc files
--  By:		Ravi Karra [Discreet] 			ravi.karra@discreet.com
--	
-- Version:		1.01
-- Note:		DO NOT LOCALIZE
-------------------------------------------------------------------------------


struct s_rc2mxs 
(
	fltStr, rW, rH, rc, fac, fc=1.5,
	fn dimStr i =
	(
		" pos:[" + fltStr[i] + fac + "," + fltStr[i+1] + fac + "] width:(" + fltStr[i+2] + fac + ") height:(" + fltStr[i+3] + fac + ") "
	),
 	fn isContinuation str =
	(
		(filterString (subString str 1 19) " ").count == 0
		--str[str.count] == ","
	),
	-- fills up "rc", an instance of rolloutCreator
	fn convertRC filename dlgID rTitle:"" = 
	(
		local ln, lbl_count = 0
		fac = "*" + fc as string
		f = openFile filename mode:"r"
		if f != undefined then
		(
			while not (eof f) do
			(
				ln = readLine f
				if (subString ln 1 3) != "IDD" then continue
				
				-- read the dialog properties
				fltStr = filterString ln " ,"
				if fltStr[1] != dlgID then continue
				rc = rolloutCreator fltStr[1] rTitle quote:""
				rc.begin()
					rW =  fltStr[fltStr.count - 1] as integer
					rH = fltStr[fltStr.count] as integer					
					
					-- skip till after BEGIN
					skipToString f "BEGIN"; readLine f
					local str = ""; ln = readLine f; type	
					while true do
					(
						str = readLine f						
						if isContinuation str then
						(
							ln += str					
						)
						else
						(
							--format "ln:%\n" ln
							fltStr = filterString ln " "
							type = fltStr[1]			
							fltStr = filterString (subString ln (findString ln fltStr[2]) ln.count) ","
							
							case type of
							(
								"LTEXT":
								(
									format "ln:%\n" ln
									lbl_count += 1
									rc.addControl #label ("label" + lbl_count as string) fltStr[1] paramStr:(dimStr 3)
								)
								"EDITTEXT":
								(
									rc.addControl #editText fltStr[1] "" paramStr:(dimStr 2)
								)
								"PUSHBUTTON":
								(
									rc.addControl #button fltStr[2] fltStr[1] paramStr:(dimStr 3)
								)
								"LISTBOX":
								(
									local h = ceil (((fltStr[5] as float)*fc)/(gettextextent "T")[2]) as string
									rc.addControl #listbox fltStr[1] "" paramStr:("height:" + h + dimStr 2)
								)
							)							
							if str == "END" then 
							(
								close f
								rc.end()
								return true
							)
							ln = str							
						)						
					)														
			)
			close f
			false
		)
	)
)

rc2mxs = s_rc2mxs()
--rc2mxs.convertRC "F:/devel/3dswin/src/maxsdk/Samples/SdkApWz/SdkApWz.rc" "IDD_CUSTOM2"
--rc2mxs.convertRC "D:/devel/3dswin/src/app/3dswin.rc" "IDD_ABOUT"
--createDialog rc2mxs.rc.def width:(rc2mxs.rW*rc2mxs.fc) height:(rc2mxs.rH*rc2mxs.fc)
