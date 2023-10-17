document.writeln('<br>');

//	if this is one of the error pages, there won't be any navigation information.
noNavigationPages = new Array (xmsgRTAuthEntryError, xmsgRTContactAutodesk, xmsgRT010203071213CannotCompErrA, 
								xmsgRTPurchaseError, xmsgRT09AlreadyReg, xmsgRT10ExceededAuths, 
								xmsgRT0015TempSysErr, xmsgRT18OldSNInvalid, xmsgRTSUNOldSNInvalid,
								xmsgRT20DataError, xmsgRT21CustIDTelErr, xmsgRT22NetworkInstallation,
								xmsgRT900SystemNotResponding, xmsgRTAuthEntryError, xmsgLicErrorHdr,
								xmsgRTLicFileSaveError, xmsgRTAuthError, xmsgRTPurchAuthFailed,
								xmsgRTPurchConnectionFailed, xmsgRTConnect, xmsgRT12StolenSN);
for (i = 0; i < noNavigationPages.length; i++) {
	if (document.title == noNavigationPages[i]) {
		navigationType = "0";
		break;
	}
}

switch (navigationType) {
	case "1" :	//	Slim package
//		SlimNavigation();
	case "2" :	//	Full package
		FullNavigation();
		break;
	case "3" :	//	Enter Authcode
		EnterAuthCodeNavigation();
		break;
	case "4" :	//	NLA Slim package
	case "5" :	//	NLA Full package
	case "6" :	//	NLA Disable Internet 
		NLANavigation();
		break;
	case "7" :	//	Buy online
		BuyNavigation();
		break;
	case "8" :	//	Volunteer registration
		VolNavigation();
		break;
	case "9" :	//	Multi-Seat Single Master Install
		MSSMNavigation();
		break;
	case "10" :	//	Multi-Seat Client install
		MSSCNavigation();
		break;
	case "11" :	//	Beta-Mode
		BetaNavigation();
		break;
}

//	End of the Navigation bar 
document.writeln('</td>');
document.writeln('<td>');
document.writeln('<table>');
document.writeln('<tr>');

//	Starting of the real page
document.writeln('<td>');

//	Starting of the "Before", "Next", and "Cancel" button section
function StartNavigationButtons() {
	document.writeln('<table width="600" border="0" cellpadding="0" cellspacing="0" ID="Table1">');
	document.writeln('<tr>');
	document.writeln('<td valign="top" align="center">');
}

//	End of the "Before", "Next", and "Cancel" button section
function EndNavigationButtons() {
	document.writeln('</td>');
	document.writeln('</tr>');
	document.writeln('</table>');
}

function SlimNavigation() {
	bar = new Array ( xmsgRTBeginReg, xmsgRTConfirm, xmsgRTAuthConfirmed);
	contents = new Array ( xmsgRegAuthInfo, xmsgConfirmInfo, xmsgRegAuthInfo1);
	
	for (i=0; i < bar.length; i++) {
		if (bar[i] == document.title) {
			document.writeln(">"+contents[i]+"<br>");
		} else {
			document.writeln("<font color=\""+ xmsgNavigationDisableColor +"\">"+contents[i]+"</font><br>");
		}
	}
}

function FullNavigation() {
	bar = new Array ( xmsgRTBeginReg, xmsgRTCountryPage, xmsgRTUserInfo, xmsgRTConfirm, xmsgRTAuthConfirmed);
	contents = new Array ( xmsgRegAuthInfo, xmsgCountryHdr, xmsgRegInfo, xmsgConfirmInfo, xmsgRegAuthInfo1);
	
	//	Change User Info to Customer ID if it's necessary
	if (document.title == xmsgRTCustID ||
		document.title == xmsgRTCustIDConfirm) {
		bar[2] = xmsgRTCustID;
		contents[2] = xmsgCustIDMainTitle;
		bar[3] = xmsgRTCustIDConfirm;
		contents[3] = xmsgRTCustIDConfirm;
	} 

	otherMethodItems = new Array (xmsgRTEmail, xmsgRTFaxUS, xmsgRTMailUS);
	otherMethodContents = new Array (xmsgRegmethod9, xmsgRegmethod7, xmsgRegmethod5);
	//	switch "Confirmation" to "Email", "Fax", or "Mail"
	var confirmIndex = bar.length - 1;
	for (i = 0; i < 3; i++) {
		if (document.title == otherMethodItems[i]) {
			bar[confirmIndex] = otherMethodItems[i];
			contents[confirmIndex] = otherMethodContents[i];
			break;
		}
	}
		
	for (i=0; i < bar.length; i++) {
		if (bar[i] == document.title) {
			document.writeln(">"+contents[i]+"<br>");
		} else {
			document.writeln("<font color=\""+ xmsgNavigationDisableColor +"\">"+contents[i]+"</font><br>");
		}
	}
}

function EnterAuthCodeNavigation() {
	bar = new Array ( xmsgRTBeginReg, xmsgRTAuthNow, xmsgRTAuthConfirmed);
	contents = new Array ( xmsgRegAuthInfo, xmsgRegAuthInfo3, xmsgRegAuthInfo1);
	
	for (i=0; i < bar.length; i++) {
		if (bar[i] == document.title) {
			document.writeln(">"+contents[i]+"<br>");
		} else {
			document.writeln("<font color=\""+ xmsgNavigationDisableColor +"\">"+contents[i]+"</font><br>");
		}
	}
}

function BetaNavigation() {
	bar = new Array ( xmsgRTBeginReg, xmsgRTAuthNow, xmsgRTConfirm);
	contents = new Array ( xmsgRegAuthInfo, xmsgRegAuthInfo3, xmsgConfirmInfo);
	
	for (i=0; i < bar.length; i++) {
		if (bar[i] == document.title) {
			document.writeln(">"+contents[i]+"<br>");
		} else {
			document.writeln("<font color=\""+ xmsgNavigationDisableColor +"\">"+contents[i]+"</font><br>");
		}
	}
}

function MSSMNavigation() {
	bar = new Array ( xmsgRTSUNServer, xmsgRTCountryPage, xmsgRTUserInfo, xmsgRTSUNDataConfirm);
	contents = new Array ( xmsgRegSunData5, xmsgCountryHdr, xmsgRegInfo, xmsgRegSunData1);
	
	//	Change User Info to Customer ID if it's necessary
	if (document.title == xmsgRTCustID ||
		document.title == xmsgRTCustIDConfirm) {
		bar[2] = xmsgRTCustID;
		contents[2] = xmsgCustIDMainTitle;
		bar[3] = xmsgRTCustIDConfirm;
		contents[3] = xmsgRTCustIDConfirm;
	} 

	for (i=0; i < bar.length; i++) {
		if (bar[i] == document.title) {
			document.writeln(">"+contents[i]+"<br>");
		} else {
			document.writeln("<font color=\""+ xmsgNavigationDisableColor +"\">"+contents[i]+"</font><br>");
		}
	}
}

function MSSCNavigation() {
	bar = new Array ( xmsgRTBeginReg, xmsgRTSUNSubmit, xmsgRTAuthConfirmed);
	contents = new Array ( xmsgRegAuthInfo, xmsgInformation, xmsgRegAuthInfo1);
	
	otherMethodItems = new Array (xmsgRTEmail, xmsgRTFaxUS, xmsgRTMailUS);
	otherMethodContents = new Array (xmsgRegmethod9, xmsgRegmethod7, xmsgRegmethod5);
	//	switch "Confirmation" to "Email", "Fax", or "Mail"
	var confirmIndex = bar.length - 1;
	for (i = 0; i < 3; i++) {
		if (document.title == otherMethodItems[i]) {
			bar[confirmIndex] = otherMethodItems[i];
			contents[confirmIndex] = otherMethodContents[i];
			break;
		}
	}
	
	for (i=0; i < bar.length; i++) {
		if (bar[i] == document.title) {
			document.writeln(">"+contents[i]+"<br>");
		} else {
			document.writeln("<font color=\""+ xmsgNavigationDisableColor +"\">"+contents[i]+"</font><br>");
		}
	}
}

function BuyNavigation() {
	bar = new Array ( xmsgRTBuyInformation, xmsgRTCountryPage, xmsgRTUserInfo, xmsgRTConfirm, xmsgRTPurchConfirmOther);
	contents = new Array ( xmsgPuchaseInfo1, xmsgCountryHdr, xmsgRegInfo, xmsgConfirmInfo, " ");
	
	//	Change User Info to Customer ID if it's necessary
	if (document.title == xmsgRTCustID ||
		document.title == xmsgRTCustIDConfirm) {
		bar[2] = xmsgRTCustID;
		contents[2] = xmsgCustIDMainTitle;
		bar[3] = xmsgRTCustIDConfirm;
		contents[3] = xmsgRTCustIDConfirm;
	} 

	otherMethodItems = new Array (xmsgRTPurchaseOffline, xmsgRTEmail, xmsgRTFaxUS, xmsgRTMailUS);
	otherMethodContents = new Array (xmsgFormPurchHdr, xmsgRegmethod9, xmsgRegmethod7, xmsgRegmethod5);
	//	switch "Confirmation" to "Email", "Fax", or "Mail"
	var confirmIndex = bar.length - 1;
	for (i = 0; i < 3; i++) {
		if (document.title == otherMethodItems[i]) {
			bar[confirmIndex] = otherMethodItems[i];
			contents[confirmIndex] = otherMethodContents[i];
			break;
		}
	}
	
	for (i=0; i < bar.length; i++) {
		if (bar[i] == document.title) {
			document.writeln(">"+contents[i]+"<br>");
		} else {
			document.writeln("<font color=\""+ xmsgNavigationDisableColor +"\">"+contents[i]+"</font><br>");
		}
	}
}

function VolNavigation() {
	bar = new Array ( xmsgRTRegVol, xmsgRTCountryPage, xmsgRTUserInfo, xmsgRTConfirm, xmsgRTRegConfirmed);
	contents = new Array ( xmsgRegVol1, xmsgCountryHdr, xmsgRegInfo, xmsgConfirmInfo, xmsgRegAuthInfo1);

	//	Change User Info to Customer ID if it's necessary
	if (document.title == xmsgRTCustID ||
		document.title == xmsgRTCustIDConfirm) {
		bar[2] = xmsgRTCustID;
		contents[2] = xmsgCustIDMainTitle;
		bar[3] = xmsgRTCustIDConfirm;
		contents[3] = xmsgRTCustIDConfirm;
	} 

	otherMethodItems = new Array (xmsgRTEmail, xmsgRTFaxUS, xmsgRTMailUS);
	otherMethodContents = new Array (xmsgRegmethod9, xmsgRegmethod7, xmsgRegmethod5);
	//	switch "Confirmation" to "Email", "Fax", or "Mail"
	var confirmIndex = bar.length - 1;
	for (i = 0; i < 3; i++) {
		if (document.title == otherMethodItems[i]) {
			bar[confirmIndex] = otherMethodItems[i];
			contents[confirmIndex] = otherMethodContents[i];
			break;
		}
	}
		
	for (i=0; i < bar.length; i++) {
		if (bar[i] == document.title) {
			document.writeln(">"+contents[i]+"<br>");
		} else {
			document.writeln("<font color=\""+ xmsgNavigationDisableColor +"\">"+contents[i]+"</font><br>");
		}
	}
}

function NLANavigation() {
	bar = new Array ( xmsgNSARTBegin, xmsgNSARTLocateLicense, xmsgNSARTConfirmServerAndSeat, xmsgRTCountryPage, xmsgRTUserInfo, xmsgRTConfirm, xmsgSaveLicenseHdr, xmsgRTAuthConfirmed);
	contents = new Array ( xmsgNSARTBeginTitle, xmsgEditServerHdrMsg1, xmsgNSARTConfirmServerAndSeat, xmsgNSACountryHdr, xmsgRegInfo, xmsgConfirmInfo, xmsgSaveLicenseHdr, xmsgLicAuthConfirmHdr1);

	//	Change User Info to Customer ID if it's necessary
	if (document.title == xmsgRTCustID ||
		document.title == xmsgRTCustIDConfirm) {
		bar[4] = xmsgRTCustID;
		contents[4] = xmsgCustIDMainTitle;
		bar[5] = xmsgRTCustIDConfirm;
		contents[5] = xmsgRTCustIDConfirm;
	} 

	otherMethodItems = new Array (xmsgRTEmail, xmsgRTFaxUS, xmsgRTMailUS);
	otherMethodContents = new Array (xmsgRegmethod9, xmsgRegmethod7, xmsgRegmethod5);
	
	//	switch "Confirmation" to "Email", "Fax", or "Mail" 
	//	and remove "license recive" too.
	var confirmIndex = bar.length - 2;
	for (i = 0; i < 3; i++) {
		if (document.title == otherMethodItems[i]) {
			bar[confirmIndex] = otherMethodItems[i];
			contents[confirmIndex] = otherMethodContents[i];
			contents[confirmIndex+1] = " ";
			break;
		}
	}
		
	for (i=0; i < bar.length; i++) {
		if (bar[i] == document.title) {
			document.writeln(">"+contents[i]+"<br>");
		} else {
			document.writeln("<font color=\""+ xmsgNavigationDisableColor +"\">"+contents[i]+"</font><br>");
		}
	}
}








// SIG // Begin signature block
// SIG // MIIUZAYJKoZIhvcNAQcCoIIUVTCCFFECAQExDjAMBggq
// SIG // hkiG9w0CBQUAMGYGCisGAQQBgjcCAQSgWDBWMDIGCisG
// SIG // AQQBgjcCAR4wJAIBAQQQEODJBs441BGiowAQS9NQkAIB
// SIG // AAIBAAIBAAIBAAIBADAgMAwGCCqGSIb3DQIFBQAEEO12
// SIG // KtjOk5PitGoSL4vlQ8qggg+yMIIDpjCCAw+gAwIBAgIQ
// SIG // baJ66Skutt3AqAAdR247aTANBgkqhkiG9w0BAQUFADBf
// SIG // MQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24s
// SIG // IEluYy4xNzA1BgNVBAsTLkNsYXNzIDMgUHVibGljIFBy
// SIG // aW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcN
// SIG // MDExMjAzMDAwMDAwWhcNMTExMjAyMjM1OTU5WjCBpzEX
// SIG // MBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsT
// SIG // FlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOzA5BgNVBAsT
// SIG // MlRlcm1zIG9mIHVzZSBhdCBodHRwczovL3d3dy52ZXJp
// SIG // c2lnbi5jb20vcnBhIChjKTAxMS4wLAYDVQQDEyVWZXJp
// SIG // U2lnbiBDbGFzcyAzIENvZGUgU2lnbmluZyAyMDAxIENB
// SIG // MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEEet1
// SIG // 7eeYhJtwl3ZisWLB3nM/Uaa/oNEpjo/sHBfa44OJA2Ip
// SIG // 0hBY7d1lCTzixMdnF4ut3F1NxV5nGJZBNkS6+EQRL7Of
// SIG // fnh/sioWHmzIBQDZCSNsKM0FzB7bbmVq0Y8C6Qwdbodv
// SIG // ZayH3QZGi6BdtWJLFPsu7SyMvEDA3k5sNQIDAQABo4IB
// SIG // GDCCARQwEgYDVR0TAQH/BAgwBgEB/wIBADBEBgNVHSAE
// SIG // PTA7MDkGC2CGSAGG+EUBBxcDMCowKAYIKwYBBQUHAgEW
// SIG // HGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvbS9ycGEwHQYD
// SIG // VR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMDMA4GA1Ud
// SIG // DwEB/wQEAwIBBjARBglghkgBhvhCAQEEBAMCAAEwJAYD
// SIG // VR0RBB0wG6QZMBcxFTATBgNVBAMTDENsYXNzM0NBMS0x
// SIG // MjAdBgNVHQ4EFgQUNSv0ZHOQnANtAw1nYGvdCxA8u2Ew
// SIG // MQYDVR0fBCowKDAmoCSgIoYgaHR0cDovL2NybC52ZXJp
// SIG // c2lnbi5jb20vcGNhMy5jcmwwDQYJKoZIhvcNAQEFBQAD
// SIG // gYEAIlhtOmR6nQz2YFKC7bCzxJYqxTOpAXRvs3bXhAos
// SIG // ZCeXMLoqsrqBmbsjh8UzkYAtN6fctIvOujmUdDuQfrYm
// SIG // EmNwIRb8OfaZb9ifGCUTiSREaeCUbxMsj+ewV5SRmv6j
// SIG // 9d0VA/eBGRMN9xdQJSRfruCThNYDLZBxNxXaMdJaxfgw
// SIG // ggPEMIIDLaADAgECAhBHvxmV341SRkP3221IDTGkMA0G
// SIG // CSqGSIb3DQEBBQUAMIGLMQswCQYDVQQGEwJaQTEVMBMG
// SIG // A1UECBMMV2VzdGVybiBDYXBlMRQwEgYDVQQHEwtEdXJi
// SIG // YW52aWxsZTEPMA0GA1UEChMGVGhhd3RlMR0wGwYDVQQL
// SIG // ExRUaGF3dGUgQ2VydGlmaWNhdGlvbjEfMB0GA1UEAxMW
// SIG // VGhhd3RlIFRpbWVzdGFtcGluZyBDQTAeFw0wMzEyMDQw
// SIG // MDAwMDBaFw0xMzEyMDMyMzU5NTlaMFMxCzAJBgNVBAYT
// SIG // AlVTMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5jLjErMCkG
// SIG // A1UEAxMiVmVyaVNpZ24gVGltZSBTdGFtcGluZyBTZXJ2
// SIG // aWNlcyBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
// SIG // AQoCggEBAKnKsqTMzSCvCn2JrId18LRO8d/BD79nYb2j
// SIG // ZBzau/nKM6uEMIlYfozba902ng+/0ex48nemfm88v5Ov
// SIG // Dbpo9GyUyr1SLatIPfW21V1fGwKf+i9rHqT3o5qmGsgC
// SIG // 4X9MUuMOYOxAHH65Dd4/x7Tfh71femoxLgOZgROoRyDO
// SIG // MXMNVy3NeDQzlRKZErneaC+q5uPCiowqw4shh2a9g1hX
// SIG // b3W/PKomh13KEBU8n4TqVMEKbsT+xUrduQcRlyJ82z4n
// SIG // 0R547J8xyfHmIhnbxLNHQ5oaX6AekORe9e588X2rYgGP
// SIG // 9U0L3tAiVqiVza6Idq7uug3z5E3ZoPtooK4UO7OHwbsC
// SIG // AwEAAaOB2zCB2DA0BggrBgEFBQcBAQQoMCYwJAYIKwYB
// SIG // BQUHMAGGGGh0dHA6Ly9vY3NwLnZlcmlzaWduLmNvbTAS
// SIG // BgNVHRMBAf8ECDAGAQH/AgEAMEEGA1UdHwQ6MDgwNqA0
// SIG // oDKGMGh0dHA6Ly9jcmwudmVyaXNpZ24uY29tL1RoYXd0
// SIG // ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggr
// SIG // BgEFBQcDCDAOBgNVHQ8BAf8EBAMCAQYwJAYDVR0RBB0w
// SIG // G6QZMBcxFTATBgNVBAMTDFRTQTIwNDgtMS01MzANBgkq
// SIG // hkiG9w0BAQUFAAOBgQBKa/nqWMJEHDGJeZkrlr+CrAHW
// SIG // HEzNsIpYbt8IKaNeyMqTE+cEUg3vRycvADiw5MmTTprU
// SIG // ImIV9z83IU9wMYDxiziHs+jolwD+z1WWTiTSqSdOeq63
// SIG // YUHzKs7nydle3bsrhT61nbXZ4Vf/vrTFfvXPDJ7wl/4r
// SIG // 0ztSGxs4J/c/SjCCA/8wggLnoAMCAQICEA3pK/DU2CmI
// SIG // GDIFCV6adogwDQYJKoZIhvcNAQEFBQAwUzELMAkGA1UE
// SIG // BhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMSsw
// SIG // KQYDVQQDEyJWZXJpU2lnbiBUaW1lIFN0YW1waW5nIFNl
// SIG // cnZpY2VzIENBMB4XDTAzMTIwNDAwMDAwMFoXDTA4MTIw
// SIG // MzIzNTk1OVowVzELMAkGA1UEBhMCVVMxFzAVBgNVBAoT
// SIG // DlZlcmlTaWduLCBJbmMuMS8wLQYDVQQDEyZWZXJpU2ln
// SIG // biBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lcjCC
// SIG // ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALJQ
// SIG // KEjd02h6hBhEZnVdfsS4n2Mm/z1DnHwROBAlVXPZdSdp
// SIG // /U65IFzTCvmgGyrtVVYhYdge2+S8M2vH792jN2WOG5MM
// SIG // tlMeXHxmNV8FikX+dk7fU4CigSCdrohcogj35TD57iI3
// SIG // TEIKzt/GH8TWVemBP7VSoyyqAXryoqqNNf6f5l1qBZ89
// SIG // a+O/lsD+zGD5QOcHoETrgVFupSrytooQKO2P3AaghlCa
// SIG // e0oIDTAdyhCea/fpWK4EqUCZsijojxasPONTb0vTNZ21
// SIG // b2Qds5Ysuz3neettevkW5iatr++ZU7dALJW4ear+1FKr
// SIG // KXR+Quw5HqJqFuZZuyRo2ACAQxCHgGsCAwEAAaOByjCB
// SIG // xzA0BggrBgEFBQcBAQQoMCYwJAYIKwYBBQUHMAGGGGh0
// SIG // dHA6Ly9vY3NwLnZlcmlzaWduLmNvbTAMBgNVHRMBAf8E
// SIG // AjAAMDMGA1UdHwQsMCowKKAmoCSGImh0dHA6Ly9jcmwu
// SIG // dmVyaXNpZ24uY29tL3Rzcy1jYS5jcmwwFgYDVR0lAQH/
// SIG // BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQDAgbAMCQG
// SIG // A1UdEQQdMBukGTAXMRUwEwYDVQQDEwxUU0EyMDQ4LTEt
// SIG // NTQwDQYJKoZIhvcNAQEFBQADggEBAId4cNpOUgEgW+B5
// SIG // yYIwxP25GZa9kQDDvc3NxvQO2P/5TcAzYjARxfV0G9SS
// SIG // 3l+cIBOxfEW+UM2D54AXg6cnk2cTRvvKuJhBA8ybUVsF
// SIG // i3+ob/MbUBskLvJpjWwi97vKFpXtDHTAaHfZ65lih8Fz
// SIG // kPiJdHojq6OYe5ex948pcU0udRtIQdrwtQ0gVNZ3oJeC
// SIG // Y2n9Cc+K8HW7CZvZ+RFVJpphMr56ArB7hr6iw4siLHjR
// SIG // NXa8knNc+bnmTBUKI8zk0tQ0LklAFTwPYHokxqVm75bP
// SIG // cOs+5/QNftzRfKN2cWnBnE9HMDUhsaKvGmI8K9mOqioH
// SIG // e9gYs1x74p2lb/48ia0wggQ5MIIDoqADAgECAhBAU7/3
// SIG // oT3i6cb+Q5PT8f23MA0GCSqGSIb3DQEBBQUAMIGnMRcw
// SIG // FQYDVQQKEw5WZXJpU2lnbiwgSW5jLjEfMB0GA1UECxMW
// SIG // VmVyaVNpZ24gVHJ1c3QgTmV0d29yazE7MDkGA1UECxMy
// SIG // VGVybXMgb2YgdXNlIGF0IGh0dHBzOi8vd3d3LnZlcmlz
// SIG // aWduLmNvbS9ycGEgKGMpMDExLjAsBgNVBAMTJVZlcmlT
// SIG // aWduIENsYXNzIDMgQ29kZSBTaWduaW5nIDIwMDEgQ0Ew
// SIG // HhcNMDQwOTE1MDAwMDAwWhcNMDUwOTE1MjM1OTU5WjCB
// SIG // yDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3Ju
// SIG // aWExEzARBgNVBAcTClNhbiBSYWZhZWwxFjAUBgNVBAoU
// SIG // DUF1dG9kZXNrLCBJbmMxPjA8BgNVBAsTNURpZ2l0YWwg
// SIG // SUQgQ2xhc3MgMyAtIE1pY3Jvc29mdCBTb2Z0d2FyZSBW
// SIG // YWxpZGF0aW9uIHYyMR8wHQYDVQQLFBZEZXNpZ24gU29s
// SIG // dXRpb25zIEdyb3VwMRYwFAYDVQQDFA1BdXRvZGVzaywg
// SIG // SW5jMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCz
// SIG // e6dyK7e/BDi05M60HCDhhSv+NofESBDR8IkIb0hvgN5Y
// SIG // czCvZu2s2K0ZiqgwudAJPbi2aR+6EWywKixjq+alVdZe
// SIG // bs2vKPWYcNg815az9azwrP31U2JhbXA0V83F+pp/fAGv
// SIG // 5r8EHkd1/GNj/jak35mZ8plpXjdWvnn9Bmlj1wIDAQAB
// SIG // o4IBQTCCAT0wCQYDVR0TBAIwADAOBgNVHQ8BAf8EBAMC
// SIG // B4AwQgYDVR0fBDswOTA3oDWgM4YxaHR0cDovL2NybC52
// SIG // ZXJpc2lnbi5jb20vQ2xhc3MzQ29kZVNpZ25pbmcyMDAx
// SIG // LmNybDBEBgNVHSAEPTA7MDkGC2CGSAGG+EUBBxcDMCow
// SIG // KAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LnZlcmlzaWdu
// SIG // LmNvbS9ycGEwEwYDVR0lBAwwCgYIKwYBBQUHAwMwNQYI
// SIG // KwYBBQUHAQEEKTAnMCUGCCsGAQUFBzABhhlodHRwczov
// SIG // L29jc3AudmVyaXNpZ24uY29tMB8GA1UdIwQYMBaAFDUr
// SIG // 9GRzkJwDbQMNZ2Br3QsQPLthMBEGCWCGSAGG+EIBAQQE
// SIG // AwIEEDAWBgorBgEEAYI3AgEbBAgwBgEBAAEB/zANBgkq
// SIG // hkiG9w0BAQUFAAOBgQBMi/4INj2lli2iYJelA7hF5sHF
// SIG // I4yX4IyAASdiTjRw2DGfKOgrtCCRpiYOT8U+Sz1IT+ea
// SIG // Mt1mfkqkegWfkw0PQIp2iQoSKP0BuDVca7PUHAUAWAmt
// SIG // YUDDgPLTGMZMgypBHN7eFZmyq0wK4bmXB4NZ9/DG+hQ0
// SIG // cw9fFO8Nn8ytxTGCBBwwggQYAgEBMIG8MIGnMRcwFQYD
// SIG // VQQKEw5WZXJpU2lnbiwgSW5jLjEfMB0GA1UECxMWVmVy
// SIG // aVNpZ24gVHJ1c3QgTmV0d29yazE7MDkGA1UECxMyVGVy
// SIG // bXMgb2YgdXNlIGF0IGh0dHBzOi8vd3d3LnZlcmlzaWdu
// SIG // LmNvbS9ycGEgKGMpMDExLjAsBgNVBAMTJVZlcmlTaWdu
// SIG // IENsYXNzIDMgQ29kZSBTaWduaW5nIDIwMDEgQ0ECEEBT
// SIG // v/ehPeLpxv5Dk9Px/bcwDAYIKoZIhvcNAgUFAKCBsDAZ
// SIG // BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
// SIG // AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAfBgkqhkiG9w0B
// SIG // CQQxEgQQs8Jpj+6kmD25Hw1O97OIhDBUBgorBgEEAYI3
// SIG // AgEMMUYwRKAmgCQAQQB1AHQAbwBkAGUAcwBrACAAQwBv
// SIG // AG0AcABvAG4AZQBuAHShGoAYaHR0cDovL3d3dy5hdXRv
// SIG // ZGVzay5jb20gMA0GCSqGSIb3DQEBAQUABIGArZi5GBzh
// SIG // qV0j/0IalHnoTTKE2jCbHIEBXAh7+w3CSPJMI2zEtuJl
// SIG // jYE2kHQCOlhOS1ap7+6yEcbZEQEOfWI7G5Zyt8hj8wl2
// SIG // rf7Nd9e8B/Ewx1ZFXS3Mp6Iumy3gwnhtw1e/FDlvLuZn
// SIG // wH2wdj4OIMYvseHEe7pLl+YsqL7XbuyhggH/MIIB+wYJ
// SIG // KoZIhvcNAQkGMYIB7DCCAegCAQEwZzBTMQswCQYDVQQG
// SIG // EwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xKzAp
// SIG // BgNVBAMTIlZlcmlTaWduIFRpbWUgU3RhbXBpbmcgU2Vy
// SIG // dmljZXMgQ0ECEA3pK/DU2CmIGDIFCV6adogwDAYIKoZI
// SIG // hvcNAgUFAKBZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
// SIG // BwEwHAYJKoZIhvcNAQkFMQ8XDTA0MTEyMTA1NDcyN1ow
// SIG // HwYJKoZIhvcNAQkEMRIEEODBC7mbfRNMwzSKeRU3094w
// SIG // DQYJKoZIhvcNAQEBBQAEggEAR9/oHGi7MQSPUR6jF7j7
// SIG // x0X2kkRPA/nvlVRPA5RSKfRxEZuaOVpywXvvn8UKE2H/
// SIG // w0bWF4q2SgtoWQ+D0A9TNu4kDxLtbqDBjRVI89fyWkEP
// SIG // f7HsCO2tFwbXUkM98ytARjoDQhSWEttloTwXO7WMqXWM
// SIG // 2wlS/c21h9ia09dWce9HTc/CGBNc8WA31JI8EdNWnnIW
// SIG // QvfVINlT0GEQz2OXJ4f+hVeSG+hcqm8oS0WpkPqW56iG
// SIG // +oIWOHYhU6rOVmaBMLc2MWGahQF39XJDMWnwrfcs8nYR
// SIG // ai7TE8vjq/5pEv85g7TXHOVIXfVyn8htJPElwIj5vCVv
// SIG // 0c1rZnEfsNn0gw==
// SIG // End signature block
