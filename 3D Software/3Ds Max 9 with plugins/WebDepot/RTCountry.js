//=======================================================================
// State, Region, and Province Information
//=======================================================================

// Country State/Province Info
var ATStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="B">Burgenland </option>' +
						'<option value="K">Kärnten </option>' +
						'<option value="NÖ">Niederösterreich </option>' +
						'<option value="OÖ">Oberösterreich </option>' +
						'<option value="S">Salzburg </option>' +
						'<option value="ST">Steiermark </option>' +
						'<option value="T">Tirol </option>' +
						'<option value="V">Vorarlberg </option>' +
						'<option value="W">Wien </option>' +
						'</select>';

var AUStPrRegHTML = '	<br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="ACT">Aust Capital Terr </option>' +
						'<option value="NSW">New South Wales </option>' +
						'<option value="NT">Northern Territory </option>' +
						'<option value="QLD">Queensland </option>' +
						'<option value="SA">South Australia </option>' +
						'<option value="TAS">Tasmania </option>' +
						'<option value="VIC">Victoria </option>' +
						'<option value="WA">Western Australia </option>' +
						'</select>';

var USStPrRegHTML = '	<br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="AL">Alabama </option>' +
						'<option value="AK">Alaska </option>' +
						'<option value="AZ">Arizona </option>' +
						'<option value="AR">Arkansas </option>' +
						'<option value="CA">California </option>' +
						'<option value="CO">Colorado </option>' +
						'<option value="CT">Connecticut </option>' +
						'<option value="DE">Delaware </option>' +
						'<option value="DC">District of Columbia </option>' +
						'<option value="FL">Florida </option>' +
						'<option value="GA">Georgia </option>' +
						'<option value="HI">Hawaii </option>' +
						'<option value="ID">Idaho </option>' +
						'<option value="IL">Illinois </option>' +
						'<option value="IN">Indiana </option>' +
						'<option value="IA">Iowa </option>' +
						'<option value="KS">Kansas </option>' +
						'<option value="KY">Kentucky </option>' +
						'<option value="LA">Louisiana </option>' +
						'<option value="ME">Maine </option>' +
						'<option value="MD">Maryland </option>' +
						'<option value="MA">Massachusetts </option>' +
						'<option value="MI">Michigan </option>' +
						'<option value="MN">Minnesota </option>' +
						'<option value="MS">Mississippi </option>' +
						'<option value="MO">Missouri </option>' +
						'<option value="MT">Montana </option>' +
						'<option value="NE">Nebraska </option>' +
						'<option value="NV">Nevada </option>' +
						'<option value="NH">New Hampshire </option>' +
						'<option value="NJ">New Jersey </option>' +
						'<option value="NM">New Mexico </option>' +
						'<option value="NY">New York </option>' +
						'<option value="NC">North Carolina </option>' +
						'<option value="ND">North Dakota </option>' +
						'<option value="OH">Ohio </option>' +
						'<option value="OK">Oklahoma </option>' +
						'<option value="OR">Oregon </option>' +
						'<option value="PA">Pennsylvania </option>' +
						'<option value="RI">Rhode Island </option>' +
						'<option value="SC">South Carolina </option>' +
						'<option value="SD">South Dakota </option>' +
						'<option value="TN">Tennessee </option>' +
						'<option value="TX">Texas </option>' +
						'<option value="UT">Utah </option>' +
						'<option value="VT">Vermont </option>' +
						'<option value="VA">Virginia </option>' +
						'<option value="VI">Virgin Islands</option>' +
						'<option value="WA">Washington </option>' +
						'<option value="WV">West Virginia </option>' +
						'<option value="WI">Wisconsin </option>' +
						'<option value="WY">Wyoming </option>' +
						'<option value="AA">APOAmerica</option>' +
						'<option value="AE">APOEurope</option>' +
						'<option value="AP">APOPacific</option>' +
						'</select>';

var BRStPrRegHTML = '	<br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="AC">Acre </option>' +	
						'<option value="AL">Alagoas </option>' +	
						'<option value="AP">Amapa </option>' +	
						'<option value="AM">Amazonas </option>' +	
						'<option value="BA">Bahia </option>' +	
						'<option value="CE">Ceara </option>' +	
						'<option value="DF">Distrito Federal </option>' +	
						'<option value="ES">Espirito Santo </option>' +	
						'<option value="GO">Goias </option>' +	
						'<option value="MA">Maranhao </option>' +	
						'<option value="MT">Mato Grosso </option>' +	
						'<option value="MG">Minas Gerais </option>' +	
						'<option value="PA">Para </option>' +	
						'<option value="PB">Paraiba </option>' +	
						'<option value="PR">Parana </option>' +	
						'<option value="PE">Pernambuco </option>' +	
						'<option value="PI">Piaui </option>' +	
						'<option value="RJ">Rio de Janeiro </option>' +	
						'<option value="RN">Rio Grande do Norte </option>' +	
						'<option value="RS">Rio Grande do Sul </option>' +	
						'<option value="RO">Rondonia </option>' +	
						'<option value="RR">Roraima </option>' +	
						'<option value="SC">Santa Catarina </option>' +	
						'<option value="SP">Sao Paulo </option>' +	
						'<option value="SE">Sergipe </option>' +	
						'<option value="TO">Tocantins </option>' +	
						'</select>';
						
var CAStPrRegHTML = '	<br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="AB">Alberta </option>' +
						'<option value="BC">British Columbia </option>' +
						'<option value="MB">Manitoba </option>' +
						'<option value="NB">New Brunswick </option>' +
						'<option value="NF">Newfoundland </option>' +
						'<option value="NT">Northwest Territories </option>' +
						'<option value="NS">Nova Scotia </option>' +
						'<option value="NU">Nunavut </option>' +
						'<option value="ON">Ontario </option>' +
						'<option value="PE">Prince Edward Island </option>' +
						'<option value="QC">Quebec </option>' +
						'<option value="SK">Saskatchewan </option>' +
						'<option value="YT">Yukon </option>' +
						'</select>';

var CHStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="AG">Aargau </option>' +
						'<option value="AI">Appenzell Innerrhoden </option>' +
						'<option value="AR">Appenzell Ausserrhoden </option>' +
						'<option value="BE">Bern </option>' +
						'<option value="BL">Basel-Landschaft </option>' +
						'<option value="BS">Basel-Stadt </option>' +
						'<option value="FR">Fribourg </option>' +
						'<option value="GE">Genève </option>' +
						'<option value="GL">Glarus </option>' +
						'<option value="GR">Graubüenden </option>' +
						'<option value="JU">Jura </option>' +
						'<option value="LU">Luzern </option>' +
						'<option value="NE">Neuchâtel </option>' +
						'<option value="NW">Nidwalden </option>' +
						'<option value="OW">Obwalden </option>' +
						'<option value="SG">St.Gallen </option>' +
						'<option value="SH">Schaffhausen </option>' +
						'<option value="SO">Solothurn </option>' +
						'<option value="SZ">Schwyz </option>' +
						'<option value="TG">Thurgau </option>' +
						'<option value="TI">Ticino </option>' +
						'<option value="UR">Uri </option>' +
						'<option value="VD">Vaud </option>' +
						'<option value="VS">Valais </option>' +
						'<option value="ZG">Zug </option>' +
						'<option value="ZH">Zürich </option>' +
						'</select>';

var CNStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="110">Anhui </option>' +
						'<option value="010">Beijing </option>' +
						'<option value="320">Chongqing </option>' +
						'<option value="150">Fujian </option>' +
						'<option value="260">Gansu </option>' +
						'<option value="190">Guangdong </option>' +
						'<option value="210">Guangxi </option>' +
						'<option value="220">Guizhou </option>' +
						'<option value="200">Hainan </option>' +
						'<option value="060">Hebei </option>' +
						'<option value="090">Heilongjiang </option>' +
						'<option value="180">Henan </option>' +
						'<option value="170">Hubei </option>' +
						'<option value="160">Hunan </option>' +
						'<option value="100">Jiangsu </option>' +
						'<option value="140">Jiangxi </option>' +
						'<option value="080">Jilin </option>' +
						'<option value="070">Liaoning </option>' +
						'<option value="040">NeiMongol </option>' +
						'<option value="270">Ningxia </option>' +
						'<option value="280">Qinghai </option>' +
						'<option value="250">Shaanxi </option>' +
						'<option value="120">Shandong </option>' +
						'<option value="020">Shanghai </option>' +
						'<option value="050">Shanxi </option>' +
						'<option value="230">Sichuan </option>' +
						'<option value="030">Tianjin </option>' +
						'<option value="290">Xinjiang </option>' +
						'<option value="300">Xizang </option>' +
						'<option value="240">Yunnan </option>' +
						'<option value="130">Zhejiang </option>' +
						'</select>';

var DEStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="08">Baden-Württemberg </option>' +
						'<option value="09">Bayern </option>' +
						'<option value="11">Berlin </option>' +
						'<option value="12">Brandenburg </option>' +
						'<option value="04">Bremen </option>' +
						'<option value="02">Hamburg </option>' +
						'<option value="06">Hessen </option>' +
						'<option value="13">Mecklenburg-Vorpommern </option>' +
						'<option value="03">Niedersachsen </option>' +
						'<option value="05">Nordrhein-Westfalen </option>' +
						'<option value="07">Rheinland-Pfalz </option>' +
						'<option value="10">Saarland </option>' +
						'<option value="14">Sachsen </option>' +
						'<option value="15">Sachsen-Anhalt</option>' +
						'<option value="01">Schleswig-Holstein </option>' +
						'<option value="16">Thüringen </option>' +
						'</select>';

var ESStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="01">Álava </option>' +
						'<option value="02">Albacete </option>' +
						'<option value="03">Alicante </option>' +
						'<option value="04">Almería </option>' +
						'<option value="33">Asturias </option>' +
						'<option value="05">Ávila </option>' +
						'<option value="06">Badajoz </option>' +
						'<option value="07">Baleares </option>' +
						'<option value="08">Barcelona </option>' +
						'<option value="09">Burgos </option>' +
						'<option value="10">Cáceres </option>' +
						'<option value="11">Cádiz </option>' +
						'<option value="39">Cantabria </option>' +
						'<option value="12">Castellón </option>' +
						'<option value="13">CiudadReal </option>' +
						'<option value="14">Córdoba </option>' +
						'<option value="16">Cuenca </option>' +
						'<option value="17">Gerona </option>' +
						'<option value="18">Granada </option>' +
						'<option value="19">Guadalajara </option>' +
						'<option value="20">Guipúzcoa </option>' +
						'<option value="21">Huelva </option>' +
						'<option value="22">Huesca </option>' +
						'<option value="23">Jaén </option>' +
						'<option value="15">LaCoruña </option>' +
						'<option value="26">LaRioja </option>' +
						'<option value="35">LasPalmas </option>' +
						'<option value="24">León </option>' +
						'<option value="25">Lérida </option>' +
						'<option value="27">Lugo </option>' +
						'<option value="28">Madrid </option>' +
						'<option value="29">Málaga </option>' +
						'<option value="30">Murcia </option>' +
						'<option value="31">Navarra </option>' +
						'<option value="32">Orense </option>' +
						'<option value="34">Palencia </option>' +
						'<option value="36">Pontevedra </option>' +
						'<option value="37">Salamanca </option>' +
						'<option value="38">Santa Cruz de Tenerife </option>' +
						'<option value="40">Segovia </option>' +
						'<option value="41">Sevilla </option>' +
						'<option value="42">Soria </option>' +
						'<option value="43">Tarragona </option>' +
						'<option value="44">Teruel </option>' +
						'<option value="45">Toledo </option>' +
						'<option value="46">Valencia </option>' +
						'<option value="47">Valladolid </option>' +
						'<option value="48">Vizcaya </option>' +
						'<option value="49">Zamora </option>' +
						'<option value="50">Zaragoza </option>' +
						'</select>';

var HKStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="HK">Hong Kong Island </option>' +
						'<option value="KLN">Kowloon </option>' +
						'<option value="NT">New Territories </option>' +
						'</select>';

var IEStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="CK">Cork </option>' +
						'<option value="CL">Clare </option>' +
						'<option value="CW">Carlow </option>' +
						'<option value="DB">Dublin </option>' +
						'<option value="DG">Donegal </option>' +
						'<option value="GW">Galway </option>' +
						'<option value="KD">Kildare </option>' +
						'<option value="KK">Kilkenny </option>' +
						'<option value="KV">Cavan </option>' +
						'<option value="KY">Kerry </option>' +
						'<option value="LF">Longford </option>' +
						'<option value="LI">Limerick </option>' +
						'<option value="LM">Leitrim </option>' +
						'<option value="LS">Laois </option>' +
						'<option value="LT">Louth </option>' +
						'<option value="MH">Monaghan </option>' +
						'<option value="MT">Meath </option>' +
						'<option value="MY">Mayo </option>' +
						'<option value="OS">Offaly </option>' +
						'<option value="RC">Rosscommon </option>' +
						'<option value="SG">Sligo </option>' +
						'<option value="TP">Tipperary </option>' +
						'<option value="WF">Waterford </option>' +
						'<option value="WK">Wicklow </option>' +
						'<option value="WM">Westmeath </option>' +
						'<option value="WX">Wexford </option>' +
						'</select>';

var ITStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="AG">Agrigento </option>' +
						'<option value="AL">Alessandria </option>' +
						'<option value="AN">Ancona </option>' +
						'<option value="AO">Aosta </option>' +
						'<option value="AR">Arezzo </option>' +
						'<option value="AP">Ascoli Piceno </option>' +
						'<option value="AT">Asti </option>' +
						'<option value="AV">Avellino </option>' +
						'<option value="BA">Bari </option>' +
						'<option value="BL">Belluno </option>' +
						'<option value="BN">Benevento </option>' +
						'<option value="BG">Bergamo </option>' +
						'<option value="BI">Biella </option>' +
						'<option value="BO">Bologna </option>' +
						'<option value="BZ">Bolzano </option>' +
						'<option value="BS">Brescia </option>' +
						'<option value="BR">Brindisi </option>' +
						'<option value="CA">Cagliari </option>' +
						'<option value="CL">Caltanissetta </option>' +
						'<option value="CB">Campobasso </option>' +
						'<option value="CE">Caserta </option>' +
						'<option value="CT">Catania </option>' +
						'<option value="CZ">Catanzaro </option>' +
						'<option value="CH">Chieti </option>' +
						'<option value="CO">Como </option>' +
						'<option value="CS">Cosenza </option>' +
						'<option value="CR">Cremona </option>' +
						'<option value="KR">Crotone </option>' +
						'<option value="CN">Cuneo </option>' +
						'<option value="EN">Enna </option>' +
						'<option value="FE">Ferrara </option>' +
						'<option value="FI">Firenze </option>' +
						'<option value="FG">Foggia </option>' +
						'<option value="FO">Forlì </option>' +
						'<option value="FR">Frosinone </option>' +
						'<option value="GE">Genova </option>' +
						'<option value="GO">Gorizia </option>' +
						'<option value="GR">Grosseto </option>' +
						'<option value="IM">Imperia </option>' +
						'<option value="IS">Isernia </option>' +
						'<option value="AQ">L`Aquila </option>' +
						'<option value="SP">LaSpezia </option>' +
						'<option value="LT">Latina </option>' +
						'<option value="LE">Lecce </option>' +
						'<option value="LC">Lecco </option>' +
						'<option value="LI">Livorno </option>' +
						'<option value="LO">Lodi </option>' +
						'<option value="LU">Lucca </option>' +
						'<option value="MC">Macerata </option>' +
						'<option value="MN">Mantova </option>' +
						'<option value="MS">Massa Carrara </option>' +
						'<option value="MT">Matera </option>' +
						'<option value="ME">Messina </option>' +
						'<option value="MI">Milano </option>' +
						'<option value="MO">Modena </option>' +
						'<option value="NA">Napoli </option>' +
						'<option value="NO">Novara </option>' +
						'<option value="NU">Nuoro </option>' +
						'<option value="OR">Oristano </option>' +
						'<option value="PD">Padova </option>' +
						'<option value="PA">Palermo </option>' +
						'<option value="PR">Parma </option>' +
						'<option value="PV">Pavia </option>' +
						'<option value="PG">Perugia </option>' +
						'<option value="PS">Pesaro e Urbino </option>' +
						'<option value="PE">Pescara </option>' +
						'<option value="PC">Piacenza </option>' +
						'<option value="PI">Pisa </option>' +
						'<option value="PT">Pistoia </option>' +
						'<option value="PN">Pordenone </option>' +
						'<option value="PZ">Potenza </option>' +
						'<option value="PO">Prato </option>' +
						'<option value="RG">Ragusa </option>' +
						'<option value="RA">Ravenna </option>' +
						'<option value="RC">Reggio Calabria </option>' +
						'<option value="RE">Reggio Emilia </option>' +
						'<option value="RI">Rieti </option>' +
						'<option value="RN">Rimini </option>' +
						'<option value="RM">Roma </option>' +
						'<option value="RO">Rovigo </option>' +
						'<option value="SA">Salerno </option>' +
						'<option value="SS">Sassari </option>' +
						'<option value="SV">Savona </option>' +
						'<option value="SI">Siena </option>' +
						'<option value="SR">Siracusa </option>' +
						'<option value="SO">Sondrio </option>' +
						'<option value="TA">Taranto </option>' +
						'<option value="TE">Teramo </option>' +
						'<option value="TR">Terni </option>' +
						'<option value="TP">Trapani </option>' +
						'<option value="TN">Trento </option>' +
						'<option value="TV">Treviso </option>' +
						'<option value="TS">Trieste </option>' +
						'<option value="TO">Torino </option>' +
						'<option value="UD">Udine </option>' +
						'<option value="VA">Varese </option>' +
						'<option value="VE">Venice </option>' +
						'<option value="VB">Verbano-Cusio-Ossola </option>' +
						'<option value="VC">Vercelli </option>' +
						'<option value="VR">Verona </option>' +
						'<option value="VV">Vibo Valentia </option>' +
						'<option value="VI">Vicenza </option>' +
						'<option value="VT">Viterbo </option>' +
						'</select>';


var JPStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +					
						'<option value="01">Hokkaido </option>' +
						'<option value="02">Aomori </option>' +
						'<option value="03">Iwate </option>' +
						'<option value="04">Miyagi </option>' +
						'<option value="05">Akita </option>' +
						'<option value="06">Yamagata </option>' +
						'<option value="07">Fukushima </option>' +
						'<option value="08">Ibaraki </option>' +
						'<option value="09">Tochigi </option>' +
						'<option value="10">Gunma </option>' +
						'<option value="11">Saitama </option>' +
						'<option value="12">Chiba </option>' +
						'<option value="13">Tokyo </option>' +
						'<option value="14">Kanagawa </option>' +
						'<option value="15">Niigata </option>' +
						'<option value="16">Toyama </option>' +
						'<option value="17">Ishikawa </option>' +
						'<option value="18">Fukui </option>' +
						'<option value="19">Yamanashi </option>' +
						'<option value="42">Nagano </option>' +
						'<option value="21">Gifu </option>' +
						'<option value="22">Shizuoka </option>' +
						'<option value="23">Aichi </option>' +
						'<option value="24">Mie </option>' +
						'<option value="25">Shiga </option>' +
						'<option value="26">Kyoto </option>' +
						'<option value="27">Osaka </option>' +
						'<option value="28">Hyogo </option>' +
						'<option value="29">Nara </option>' +
						'<option value="30">Wakayama </option>' +
						'<option value="31">Tottori </option>' +
						'<option value="32">Shimane </option>' +
						'<option value="33">Okayama </option>' +
						'<option value="34">Hiroshima </option>' +
						'<option value="35">Yamaguchi </option>' +
						'<option value="36">Tokushima </option>' +
						'<option value="37">Kagawa </option>' +
						'<option value="38">Ehime </option>' +
						'<option value="39">Kochi </option>' +
						'<option value="40">Fukuoka </option>' +
						'<option value="41">Saga </option>' +
						'<option value="20">Nagasaki </option>' +
						'<option value="43">Kumamoto </option>' +
						'<option value="44">Oita </option>' +
						'<option value="45">Miyazaki </option>' +
						'<option value="46">Kagoshima </option>' +
						'<option value="47">Okinawa </option>' +
						'</select>';

var MXStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="AGS">Aguascalientes </option>' +
						'<option value="BCN">Baja CaliforniaN </option>' +
						'<option value="BCS">Baja CaliforniaS </option>' +
						'<option value="CMP">Campeche </option>' +
						'<option value="CHS">Chiapas </option>' +
						'<option value="CHI">Chihuahua </option>' +
						'<option value="COA">Coahuila </option>' +
						'<option value="COL">Colima </option>' +
						'<option value="DF">Distrito Federal </option>' +
						'<option value="DGO">Durango </option>' +
						'<option value="MEX">Estado de México </option>' +
						'<option value="GTO">Guanajuato </option>' +
						'<option value="GRO">Guerrero </option>' +
						'<option value="HGO">Hidalgo </option>' +
						'<option value="JAL">Jalisco </option>' +
						'<option value="MCH">Michoacán </option>' +
						'<option value="MOR">Morelos </option>' +
						'<option value="NL">NuevoLéon </option>' +
						'<option value="OAX">Oaxaca </option>' +
						'<option value="PUE">Puebla </option>' +
						'<option value="QRO">Querétaro </option>' +
						'<option value="QR">QuintanaRoo </option>' +
						'<option value="SLP">San Luis Potosí </option>' +
						'<option value="SIN">Sinaloa </option>' +
						'<option value="SON">Sonora </option>' +
						'<option value="TAB">Tabasco </option>' +
						'<option value="TMS">Tamaulipas </option>' +
						'<option value="TLX">Tlaxcala </option>' +
						'<option value="VER">Veracruz </option>' +
						'<option value="YUC">Yucatán </option>' +
						'<option value="ZAC">Zacatecas </option>' +
						'</select>';

var MYStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="JOH">Johor </option>' +
						'<option value="KED">Kedah </option>' +
						'<option value="KEL">Kelantan </option>' +
						'<option value="MEL">Melaka </option>' +
						'<option value="PAH">Pahang </option>' +
						'<option value="PEL">Perlis </option>' +
						'<option value="PER">Perak </option>' +
						'<option value="PIN">PulauPinang </option>' +
						'<option value="SAB">Sabah </option>' +
						'<option value="SAR">Sarawak </option>' +
						'<option value="SEL">Selangor </option>' +
						'<option value="SER">NegeriSembilan </option>' +
						'<option value="TRE">Terengganu </option>' +
						'</select>';

var PTStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="40">Alentejo </option>' +
						'<option value="50">Algarve </option>' +
						'<option value="24">Beira Interior </option>' +
						'<option value="15">Beira Litoral </option>' +
						'<option value="10">Entre Douro e Minho </option>' +
						'<option value="22">Estremadura e Ribatejo </option>' +
						'<option value="31">Lisboa e Setúbal </option>' +
						'<option value="70">Reg. Aut. da Madeira </option>' +
						'<option value="60">Reg. Aut. dos Açores </option>' +
						'<option value="16">Trás-os-Montes e Alto Douro </option>' +
						'</select>';

var TWStPrRegHTML = ' <br><select name="state" size="1">' +
						'<option value="select">'+xmsgPleaseSelect+'</option>' +
						'<option value="KSH">Kaoshung City </option>' +
						'<option value="TPE">Taipei City </option>' +
						'<option value="TWN">Taiwan Prov. </option>' +
						'</select>';


//=======================================================================
// Country Long Name Information
//=======================================================================

var CountryCollection = 
				'<option selected value="select">'+xmsgPleaseSelect+'</option>' +
				'<option value="US">United States </option>' +
				'<option value="AF">Afghanistan </option>' +
				'<option value="AL">Albania </option>' +
				'<option value="DZ">Algeria </option>' +
				'<option value="AS">American Samoa </option>' +
				'<option value="AD">Andorra </option>' +
				'<option value="AO">Angola </option>' +
				'<option value="AI">Anguilla </option>' +
				'<option value="AG">Antigua and Barbuda </option>' +
				'<option value="AR">Argentina </option>' +
				'<option value="AM">Armenia </option>' +
				'<option value="AW">Aruba </option>' +
				'<option value="AU">Australia </option>' +
				'<option value="AT">Austria </option>' +
				'<option value="AZ">Azerbaijan </option>' +
				'<option value="BS">Bahamas </option>' +
				'<option value="BH">Bahrain </option>' +
				'<option value="BD">Bangladesh </option>' +
				'<option value="BB">Barbados </option>' +
				'<option value="BY">Belarus </option>' +
				'<option value="BE">Belgium </option>' +
				'<option value="BZ">Belize </option>' +
				'<option value="BJ">Benin </option>' +
				'<option value="BM">Bermuda </option>' +
				'<option value="BT">Bhutan </option>' +
				'<option value="BO">Bolivia </option>' +
				'<option value="BA">Bosnia and Herzegovina </option>' +
				'<option value="BW">Botswana </option>' +
				'<option value="BV">Bouvet Island </option>' +
				'<option value="BR">Brazil </option>' +
				'<option value="IO">British Indian Ocean Territory </option>' +
				'<option value="BN">Brunei Darussalam </option>' +
				'<option value="BG">Bulgaria </option>' +
				'<option value="BF">Burkina Faso </option>' +
				'<option value="BI">Burundi </option>' +
				'<option value="KH">Cambodia </option>' +
				'<option value="CM">Cameroon </option>' +
				'<option value="CA">Canada </option>' +
				'<option value="CV">Cape Verde </option>' +
				'<option value="KY">Cayman Islands </option>' +
				'<option value="CF">Central African Republic </option>' +
				'<option value="TD">Chad </option>' +
				'<option value="CL">Chile </option>' +
				'<option value="CN">China </option>' +
				'<option value="CX">Christmas Island (Australia) </option>' +
				'<option value="CC">Cocos (Keeling) Islands </option>' +
				'<option value="CO">Colombia </option>' +
				'<option value="KM">Comoros </option>' +
				'<option value="CG">Congo </option>' +
				'<option value="CK">Cook Islands (New Zealand) </option>' +
				'<option value="CR">Costa Rica </option>' +
				'<option value="CI">Cote d`Ivoire </option>' +
				'<option value="HR">Croatia (Hrvatska) </option>' +
				'<option value="CY">Cyprus </option>' +
				'<option value="CZ">Czech Republic </option>' +
				'<option value="CD">Democratic Republic of the Congo </option>' +
				'<option value="DK">Denmark </option>' +
				'<option value="DJ">Djibouti </option>' +
				'<option value="DM">Dominica </option>' +
				'<option value="DO">Dominican Republic </option>' +
				'<option value="TP">East Timor </option>' +
				'<option value="EC">Ecuador </option>' +
				'<option value="EG">Egypt </option>' +
				'<option value="SV">El Salvador </option>' +
				'<option value="GQ">Equatorial Guinea </option>' +
				'<option value="ER">Eritrea </option>' +
				'<option value="EE">Estonia </option>' +
				'<option value="ET">Ethiopia </option>' +
				'<option value="FK">Falkland Islands </option>' +
				'<option value="FO">Faroe Islands </option>' +
				'<option value="FJ">Fiji </option>' +
				'<option value="FI">Finland </option>' +
				'<option value="FR">France </option>' +
				'<option value="GF">French Guiana </option>' +
				'<option value="PF">French Polynesia </option>' +
				'<option value="GA">Gabon </option>' +
				'<option value="GM">Gambia </option>' +
				'<option value="GE">Georgia </option>' +
				'<option value="DE">Germany </option>' +
				'<option value="GH">Ghana </option>' +
				'<option value="GI">Gibraltar </option>' +
				'<option value="GR">Greece </option>' +
				'<option value="GL">Greenland </option>' +
				'<option value="GD">Grenada </option>' +
				'<option value="GP">Guadeloupe </option>' +
				'<option value="GU">Guam </option>' +
				'<option value="GT">Guatemala </option>' +
				'<option value="GN">Guinea </option>' +
				'<option value="GW">Guinea-Bissau </option>' +
				'<option value="GY">Guyana </option>' +
				'<option value="HT">Haiti </option>' +
				'<option value="HN">Honduras </option>' +
				'<option value="HK">Hong Kong </option>' +
				'<option value="HU">Hungary </option>' +
				'<option value="IS">Iceland </option>' +
				'<option value="IN">India </option>' +
				'<option value="ID">Indonesia </option>' +
				'<option value="IQ">Iraq </option>' +
				'<option value="IE">Ireland </option>' +
				'<option value="IL">Israel </option>' +
				'<option value="IT">Italy </option>' +
				'<option value="JM">Jamaica </option>' +
				'<option value="JP">Japan </option>' +
				'<option value="JO">Jordan </option>' +
				'<option value="KZ">Kazakhstan </option>' +
				'<option value="KE">Kenya </option>' +
				'<option value="KI">Kiribati </option>' +
				'<option value="KR">Korea, South </option>' +
				'<option value="KW">Kuwait </option>' +
				'<option value="KG">Kyrgyzstan </option>' +
				'<option value="LA">Laos </option>' +
				'<option value="LV">Latvia </option>' +
				'<option value="LB">Lebanon </option>' +
				'<option value="LS">Lesotho </option>' +
				'<option value="LR">Liberia </option>' +
				'<option value="LY">Libya </option>' +
				'<option value="LI">Liechtenstein </option>' +
				'<option value="LT">Lithuania </option>' +
				'<option value="LU">Luxembourg </option>' +
				'<option value="MO">Macau </option>' +
				'<option value="MK">Macedonia </option>' +
				'<option value="MG">Madagascar </option>' +
				'<option value="MW">Malawi </option>' +
				'<option value="MY">Malaysia </option>' +
				'<option value="MV">Maldives </option>' +
				'<option value="ML">Mali </option>' +
				'<option value="MT">Malta </option>' +
				'<option value="MH">Marshall Islands </option>' +
				'<option value="MQ">Martinique </option>' +
				'<option value="MR">Mauritania </option>' +
				'<option value="MU">Mauritius </option>' +
				'<option value="YT">Mayotte </option>' +
				'<option value="MX">Mexico </option>' +
				'<option value="FM">Micronesia </option>' +
				'<option value="MD">Moldova </option>' +
				'<option value="MC">Monaco </option>' +
				'<option value="MN">Mongolia </option>' +
				'<option value="MS">Montserrat </option>' +
				'<option value="MA">Morocco </option>' +
				'<option value="MZ">Mozambique </option>' +
				'<option value="MM">Myanmar </option>' +
				'<option value="NA">Namibia </option>' +
				'<option value="NR">Nauru </option>' +
				'<option value="NP">Nepal </option>' +
				'<option value="NL">Netherlands </option>' +
				'<option value="AN">Netherlands Antilles </option>' +
				'<option value="NC">New Caledonia </option>' +
				'<option value="NZ">New Zealand </option>' +
				'<option value="NI">Nicaragua </option>' +
				'<option value="NE">Niger </option>' +
				'<option value="NG">Nigeria </option>' +
				'<option value="NU">Niue </option>' +
				'<option value="NF">Norfolk Island </option>' +
				'<option value="KP">North Korea </option>' +
				'<option value="MP">Northern Mariana Islands </option>' +
				'<option value="NO">Norway </option>' +
				'<option value="OM">Oman </option>' +
				'<option value="PK">Pakistan </option>' +
				'<option value="PW">Palau </option>' +
				'<option value="PA">Panama </option>' +
				'<option value="PG">Papua New Guinea </option>' +
				'<option value="PY">Paraguay </option>' +
				'<option value="PE">Peru </option>' +
				'<option value="PH">Philippines </option>' +
				'<option value="PN">Pitcairn Islands </option>' +
				'<option value="PL">Poland </option>' +
				'<option value="PT">Portugal </option>' +
				'<option value="PR">Puerto Rico </option>' +
				'<option value="QA">Qatar </option>' +
				'<option value="RE">Reunion </option>' +
				'<option value="RO">Romania </option>' +
				'<option value="RU">Russian Federation </option>' +
				'<option value="RW">Rwanda </option>' +
				'<option value="KN">Saint Kitts and Nevis </option>' +
				'<option value="LC">Saint Lucia </option>' +
				'<option value="VC">Saint Vincent and the Grenadines </option>' +
				'<option value="SM">San Marino </option>' +
				'<option value="ST">Sao Tome and Principe </option>' +
				'<option value="SA">Saudi Arabia </option>' +
				'<option value="SN">Senegal </option>' +
				'<option value="YU">Serbia and Montengro </option>' +
				'<option value="SC">Seychelles </option>' +
				'<option value="SL">Sierra Leone </option>' +
				'<option value="SG">Singapore </option>' +
				'<option value="SK">Slovak Republic </option>' +
				'<option value="SI">Slovenia </option>' +
				'<option value="SB">Solomon Islands </option>' +
				'<option value="SO">Somalia </option>' +
				'<option value="ZA">South Africa </option>' +
				'<option value="ES">Spain </option>' +
				'<option value="LK">Sri Lanka </option>' +
				'<option value="SH">St Helena </option>' +
				'<option value="PM">St Pierre and Miquelon </option>' +
				'<option value="SR">Suriname </option>' +
				'<option value="SJ">Svalbard and Jan Mayen Islands </option>' +
				'<option value="SZ">Swaziland </option>' +
				'<option value="SE">Sweden </option>' +
				'<option value="CH">Switzerland </option>' +
				'<option value="TW">Taiwan </option>' +
				'<option value="TJ">Tajikistan </option>' +
				'<option value="TZ">Tanzania, United Republic of </option>' +
				'<option value="TH">Thailand </option>' +
				'<option value="TG">Togo </option>' +
				'<option value="TK">Tokelau </option>' +
				'<option value="TO">Tonga </option>' +
				'<option value="TT">Trinidad and Tobago </option>' +
				'<option value="TN">Tunisia </option>' +
				'<option value="TR">Turkey </option>' +
				'<option value="TM">Turkmenistan </option>' +
				'<option value="TC">Turks and Caicos Islands </option>' +
				'<option value="TV">Tuvalu </option>' +
				'<option value="UG">Uganda </option>' +
				'<option value="UA">Ukraine </option>' +
				'<option value="AE">United Arab Emirates </option>' +
				'<option value="GB">United Kingdom </option>' +
				'<option value="US">United States </option>' +
				'<option value="UY">Uruguay </option>' +
				'<option value="UM">US Minor Outlying Islands </option>' +
				'<option value="UZ">Uzbekistan </option>' +
				'<option value="VU">Vanuatu </option>' +
				'<option value="VA">Vatican City State </option>' +
				'<option value="VE">Venezuela </option>' +
				'<option value="VN">Vietnam </option>' +
				'<option value="VG">Virgin Islands (British) </option>' +
				'<option value="VI">Virgin Islands (US) </option>' +
				'<option value="WF">Wallis and Futuna Islands </option>' +
				'<option value="EH">Western Sahara </option>' +
				'<option value="WS">Western Samoa </option>' +
				'<option value="YE">Yemen </option>' +
				'<option value="ZM">Zambia </option>' +
				'<option value="ZW">Zimbabwe </option>' +
				'</select>';
				
var CountryHTML= xmsgRedStar + xmsgSelectCountry +'<br>' +
				'<select name="country" size="1">' +
				CountryCollection;

function ChangeCountry() {
	if (document.RTForm.country.selectedIndex == 0) {
		document.RTForm.country.selectedIndex = 1;
	}
	country = document.RTForm.country.options[document.RTForm.country.selectedIndex].value;
	SetCountryContactInfo();
}

var CountryDHTML= xmsgSelectCountry2+'<br>' +
				'<select name="country" size="1" onchange="ChangeCountry()">' +
				CountryCollection;














// SIG // Begin signature block
// SIG // MIIUZAYJKoZIhvcNAQcCoIIUVTCCFFECAQExDjAMBggq
// SIG // hkiG9w0CBQUAMGYGCisGAQQBgjcCAQSgWDBWMDIGCisG
// SIG // AQQBgjcCAR4wJAIBAQQQEODJBs441BGiowAQS9NQkAIB
// SIG // AAIBAAIBAAIBAAIBADAgMAwGCCqGSIb3DQIFBQAEEOsp
// SIG // OiIiNlepdeZq48bFacuggg+yMIIDpjCCAw+gAwIBAgIQ
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
// SIG // CQQxEgQQhE8ulPFXNIdOAw3Yqbj+8DBUBgorBgEEAYI3
// SIG // AgEMMUYwRKAmgCQAQQB1AHQAbwBkAGUAcwBrACAAQwBv
// SIG // AG0AcABvAG4AZQBuAHShGoAYaHR0cDovL3d3dy5hdXRv
// SIG // ZGVzay5jb20gMA0GCSqGSIb3DQEBAQUABIGAoOs26pHH
// SIG // EZ0oq1OxGLHEpQ2+futCROM3654jimTviXvMLNfKFl86
// SIG // K8icZ+dzBVyfiXYdXM4Tjzdbhs6VVnh30ntXT5trM5+u
// SIG // 7K2iUM0zRPyZem/XvVpkH3V4NGRxUc4czRJZNp6taNbv
// SIG // AjH5FcH9OtwNACvyOZ0Ua+4n/K1aBhShggH/MIIB+wYJ
// SIG // KoZIhvcNAQkGMYIB7DCCAegCAQEwZzBTMQswCQYDVQQG
// SIG // EwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xKzAp
// SIG // BgNVBAMTIlZlcmlTaWduIFRpbWUgU3RhbXBpbmcgU2Vy
// SIG // dmljZXMgQ0ECEA3pK/DU2CmIGDIFCV6adogwDAYIKoZI
// SIG // hvcNAgUFAKBZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
// SIG // BwEwHAYJKoZIhvcNAQkFMQ8XDTA1MDEyMzIzMjUyM1ow
// SIG // HwYJKoZIhvcNAQkEMRIEEJzYSrpQCfbQB1/RmsY1Wi4w
// SIG // DQYJKoZIhvcNAQEBBQAEggEAjms4drZ5vEghF8o5bBRZ
// SIG // wNFOwpd9RfAb/0/QlR3+ENwbPhh4vk5GBAfVtR4FdJqY
// SIG // LLP9lhXiGzLSpa7fNiUI6BfgG7POJCaR2OL3Gjl9S84q
// SIG // Rwtect05+OcrHlLDOZYlO+T9J2ERxJFYOiIv4LTE5G/O
// SIG // B29bAt0DP9w2N3btaNWeqsM7zcTocJOTTknp7YNuJLIS
// SIG // SZOoVcJaqURKQy7w+6FfOl3e0fw+gZx1JEpILShT6qvp
// SIG // LOqHsWB7NQL6qDgHWQQETLMMDjERxzOr+Yxk7RcQCUDg
// SIG // zfhs1BZvzEcu96PyfhY1ihjCPInpC5j36hcbGai5linh
// SIG // gONtljZ1t2evUQ==
// SIG // End signature block
