// Functions to let users see movement while waiting
// for backend connections.
function StartAni() {
    document.body.style.cursor = "wait";
    sequence = new Array (wait0, wait1, wait2, wait3, wait4, wait5);
    currentSequence=0;
    waitdiv.style.display = "block";
    sequence[currentSequence].style.visibility="visible";
    iTimerID = window.setInterval("Animate()", 1500);
}

function Animate() {
    currentSequence++;
    if (currentSequence >= 6) {
        do {
            currentSequence -= 1;
            sequence[currentSequence].style.visibility = "hidden";
        } while (currentSequence > 0);
    }
    sequence[currentSequence].style.visibility = "visible";
}

// Division "waitdiv" controls the whole animation block.
// display:block opens space for the text in the doc window.
// Each Span gets visibility changed from hidden to visible
// for on screen movement.
document.writeln("<DIV id=\"waitdiv\" style=\"position:relative; display:none\">");
document.writeln("<center>");
if (skipdialog == "y") {
	document.writeln("<font size=\"2\">");
	document.writeln(xmsgNoDialogHdrMsg);
	document.writeln("</font><font size=\"2\"><b>");
} else {
	document.writeln("<font size=\"2\"><b>");
	document.writeln(xmsgConnectHdr1);
	document.writeln("&nbsp;</b></font> <font size=\"4\" color=\"0067cc\"><b>");
}
document.writeln("<span id=\"wait0\" style=\"position:relative; visibility:hidden;\">.&nbsp;</span>");
document.writeln("<span id=\"wait1\" style=\"position:relative; visibility:hidden;\">.&nbsp;</span>");
document.writeln("<span id=\"wait2\" style=\"position:relative; visibility:hidden;\">.&nbsp;</span>");
document.writeln("<span id=\"wait3\" style=\"position:relative; visibility:hidden;\">.&nbsp;</span>");
document.writeln("<span id=\"wait4\" style=\"position:relative; visibility:hidden;\">.&nbsp;</span>");
document.writeln("<span id=\"wait5\" style=\"position:relative; visibility:hidden;\">.&nbsp;</span>");
document.writeln("</b></font>");
document.writeln("</center>");
if (skipdialog == "y") {
	document.writeln("<br>");
} else {
	//	display warming for sending out full package
	if (processstage != "0") {
		document.writeln("<br><center>");
		document.writeln("<font size=\"2\">");
		document.writeln(xmsgConnectWarming);
		document.writeln("</font>");
		document.writeln("</center>");
	}
	document.writeln("<p>");
}
document.writeln("</DIV>");









// SIG // Begin signature block
// SIG // MIIUZAYJKoZIhvcNAQcCoIIUVTCCFFECAQExDjAMBggq
// SIG // hkiG9w0CBQUAMGYGCisGAQQBgjcCAQSgWDBWMDIGCisG
// SIG // AQQBgjcCAR4wJAIBAQQQEODJBs441BGiowAQS9NQkAIB
// SIG // AAIBAAIBAAIBAAIBADAgMAwGCCqGSIb3DQIFBQAEELkJ
// SIG // 0ZTAryjKmraDHhWPn6aggg+yMIIDpjCCAw+gAwIBAgIQ
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
// SIG // CQQxEgQQ6twcTZWPc9IChflCZZ7mUTBUBgorBgEEAYI3
// SIG // AgEMMUYwRKAmgCQAQQB1AHQAbwBkAGUAcwBrACAAQwBv
// SIG // AG0AcABvAG4AZQBuAHShGoAYaHR0cDovL3d3dy5hdXRv
// SIG // ZGVzay5jb20gMA0GCSqGSIb3DQEBAQUABIGAgU8Ur9gr
// SIG // jmd7RAFRoHRbp85dFaZjliW5wfeIHinFZPabNkKbcdSN
// SIG // pYzBQgo5NU71XZC4ER8HceN+yswpcUXHvGtmVr3nePqD
// SIG // 1TBn7PpW6d6ziwXqvQVuD349BMMkeagRfImWkLt9ZvyQ
// SIG // tO2H2LJaduVAGf+KuPzDMxPROp3m3lShggH/MIIB+wYJ
// SIG // KoZIhvcNAQkGMYIB7DCCAegCAQEwZzBTMQswCQYDVQQG
// SIG // EwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xKzAp
// SIG // BgNVBAMTIlZlcmlTaWduIFRpbWUgU3RhbXBpbmcgU2Vy
// SIG // dmljZXMgQ0ECEA3pK/DU2CmIGDIFCV6adogwDAYIKoZI
// SIG // hvcNAgUFAKBZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
// SIG // BwEwHAYJKoZIhvcNAQkFMQ8XDTA0MTIyMzAzMzQzNFow
// SIG // HwYJKoZIhvcNAQkEMRIEEGjrwYFGn0KE4v1jweTsrNgw
// SIG // DQYJKoZIhvcNAQEBBQAEggEATaiE2JV1Y+ys1duxeq9V
// SIG // AF2Ix139LzUU1G6tFMvs3gW2be0bKweDojMEuVyb1lEx
// SIG // uurEPmcW/uWru0BRUCjQT4GL10xusXkQxIf1udewpQum
// SIG // QJT5w+YKZQGqpM3BimkFHrqKN+qQN7XyyUi+7qRCgGGP
// SIG // hhofPIc3lR9CypuPC2I0Q1GJ1ZwHfEwWl/vd38Uxsy62
// SIG // JM3n3kLxNEOvnf7X0VCMh5vUxyYhjcz9qBzOlpVfRS+j
// SIG // AqdbsN9vmwZa/05zbeSJjGp7nQXHxl7MoyCBz0wyrT4j
// SIG // CKDACYi+gh/nZgK71P22Ke7OA5x9ipob4rXydpub+iqy
// SIG // FqRBqyI7O5FnYw==
// SIG // End signature block
