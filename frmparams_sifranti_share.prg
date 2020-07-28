*****************************************************************
*!* Set of functions and settings for calling statistical views.
*!* Each function contain two arrays:
*!* 
*!* 1.  "SearchType" stores definition for all searchtypes supported by the form
*!*
*!*     Parameters:
*!*     1. SearchType: Number, provided by parameter of form open
*!*     2. Title:        Title of search type, later copied into Caption of form
*!*     3. SQL UDF:  Name of SQL UDF function which provides results for current SearchType
*!*     4. Panel:        Name of panel in result pane for additional information for results
*!*     5. OpenContract: Enables or Disabled Open Contract Button
*!*     6. OpenCustomer: Enables or Disabled Open Customer Button
*!*     7. Run Qwuery:      .T. or .F. to run query afeter init with default values
*!*     8. Hide criteria:   .T. or .F. to hide criteria after init
*!*     9. Run full screen. .F. of .T. for open window in full screen
*!*    10. Type of SQL UDF:	0 or .F. - User defined function, 1 or .T. - Stored procedure, 2 - Select stamtement
*!*    11. Connection name:	empty - default connection is used, !empty - extra connection is used
*!*     
*!* 2.  "CriteriaContainers" specifies which criteria is enabled for specific SearchType.
*!*     Each criteria is own object (container) and its name starts with "criteria_*"
*!*
*!*     Parameters:
*!*     1. SearchType: Number, provided by parameter of form open
*!*     2. Criteria:   Name of Class used in Criteria general container for getting search parameters
*!*     3. Sort Order: Sort order of criteria conzainers on a general container
*!*     4. Captiton:   Title of label called "lblCriteriaCaption"
*!*     5. Enabled:    Is criteria block enabled/disabled (True/False)
*!*     6. Checked:    Is criteria block checked by default (0/1)
*!*     7. Visible:    Is criteria block vidible (True/False)  
*!*     8. Default:     String to represent default value for default field in criteria
*!*     9. Print:       String for describing criteria on print report
*!*    10. SQL query:	Select statement, used as rowsource for criteria_combobox or criteria_multiselect
*!*    11. Use connection:	.F. or .T. for using connection, defined in SearchType array
*!*
*!* 3.  "GridSettings" contains fields and cosmetic properties for bounding and 
*!*     beutifying the grid with results
*!*     
*!*     Parameters:
*!*     1.  Številka recordsourca
*!*     2.  Vrstni red
*!*     3.  SQL Field Name
*!*     4.  Header Friendly name
*!*     5.  Control Type (textbox, checkbox)
*!*     6.  Width   
*!*     7.  Format
*!*     8.  Alighment
*!*     9.  Column BackColor
*!*     10. Column ForeColor
*!*     11. Font Bold
*!*     12. Column function (@Field is replaced with SQL Field Name)
*!*     13. Exist in SQL cursor (doda se kasneje)
*!*     14. SQL sort order (doda se kasneje)
*!*     15. Compute sum or average on column (0 - Auto, 1 - None, 2 - Sum, 3 - Avg, 4 - Both)
*!* 
*!* 
*!* History:
*!* 02.12.2009 MatjazB; MID 23107 - added function Strm_register
*!* 19.08.2010 Vilko; Bug ID 28517 - added function Obr_mere_register
*!* 16.11.2011 MatjazB; MID 32131 - modified function Obr_mere_register - added new filed calc_type_desc
*!* 01.02.2012 MatjazB; MID 33342- added function Akonplan_register
*!* 24.02.2012 Natasa; MID 29276- added field to select in function Akonplan_register
*!* 01.03.2012 MatjazB; MID 33342 - modified function Akonplan_register - remove field stros_mes
*!* 01.03.2012 Vilko; Task ID 6464 - modified function Obr_mere_register - added new field neaktiven
*!* 22.05.2012 MatjazB; Task 6819 - modified function Akonplan_register - added fields b2_id_kupca and naz_kr_kup
*!* 16.10.2012 Ziga; Task ID 7071 - modified function Akonplan_register - added new fields for_le, for_gl and for_fa
*!* 04.09.2013 Ales; Taks id 7581 - modified Akonplan_register - added column 'Obvezne vnos projekta'
*!* 19.02.2014 Ales; MID 44134 - modified Obr_mere_register - field 'Opis' width changed
*!* 09.04.2014 MatjazB; MID 44446 - modified Obr_mere_register - added field 'Odmik'
*!* 07.07.2014 Jelena; Bug ID 30986 - modified Strm_register - rename column from 'E-mail' to 'E-naslov' 
*!* 01.10.2014 Jelena; MID 47511- modified Akonplan_register - into grid added columns 'Tuj konto 6-9' 
*!* 27.11.2014 Jure; MID 48005 - Added expression field into table obresti
*!* 30.12.2016 MatjazB; Task 9809 - added Kategorije_tipi_sifranti_pregled
*!* 24.01.2017 MatjazB; Task 9888 - modified Kategorije_tipi_sifranti_pregled - rename view name
*!* 30.01.2017 MatjazB; Task 9900 - added Porocila_pregled
*!* 31.01.2017 MatjazB; Task 9900 - added Dod_rut_pregled
*!* 28.02.2017 MatjazB; Task 9953 - modified Porocila_pregled - added new fields
*!* 15.02.2018 Ales; TID 12773 - modified Porocila_pregled and Dod_rut_pregled - added field gdpr_relevant
*!* 14.06.2018 Janko; BID 33794 - modified Porocila_pregled and Dod_rut_pregled - changed Klièe se iz forma to Klièe se iz forme and Ime forma to Ime forme
*!* 02.11.2018 MatjazB; TID 14809 - modified Kategorije_tipi_sifranti_pregled - added id_register_gr
*!* 18.09.2019 MatjazB; MID 84952 - modified Kategorije_tipi_sifranti_pregled - edded entity PONUDBA
*!* 30.10.2019 MitjaM; BID 37783 - modified Obr_mere_register - changed Left to dbo.StringToFox
*!* 25.03.2020 Janko; MID 89965 - modified Akonplan_register- added criteria for inactive
******************************************************************

* Šifrant STRM
FUNCTION Strm_register
LPARAMETERS tlRunQuery, tlHideContainer, tlRunFullScreen, taDefaultValues

    LOCAL lnSearchNo, i, lcSQL
    lnSearchNo = 1
    
    TEXT TO lcSQL NOSHOW
        SELECT
        	id_strm, strm_naz, ulica, mesto, email, direktor, telefon,
        	fax, kontakt, zr1, id_poste, neaktiven
        FROM
        	dbo.strm1
    ENDTEXT

    DIMENSION SearchType[1, 11]
    i = 0

    i = i + 1
    SearchType[i, 1] = lnSearchNo
    SearchType[i, 2] = "Stroškovna mesta"        && Caption
    SearchType[i, 3] = lcSQL
    SearchType[i, 4] = ""
    SearchType[i, 5] = .F.
    SearchType[i, 6] = .F.
    SearchType[i, 7] = tlRunQuery
    SearchType[i, 8] = tlHideContainer
    SearchType[i, 9] = tlRunFullScreen
    SearchType[i, 10] = 2
    SearchType[i, 11] = ""

    DIMENSION CriteriaContainers[1, 11]
    CriteriaContainers[1, 1] = 0

    DO GF_SetDefaultValueForCriteriaContainers WITH CriteriaContainers, taDefaultValues

    DIMENSION GridSettings[12, 15]
    i = 0

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "id_strm"
    GridSettings[i, 4] = "Šifra"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 60
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "strm_naz"
    GridSettings[i, 4] = "Naziv"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 250
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1    
    
    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "ulica"
    GridSettings[i, 4] = "Ulica"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 200
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "id_poste"
    GridSettings[i, 4] = "Pošta"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 80
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1
    
    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "mesto"
    GridSettings[i, 4] = "Kraj"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 100
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "telefon"
    GridSettings[i, 4] = "Telefon"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 100
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "fax"
    GridSettings[i, 4] = "Fax"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 90
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "direktor"
    GridSettings[i, 4] = "Direktor"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 150
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "email"
    GridSettings[i, 4] = "E-naslov"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 150
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1
    
    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "kontakt"
    GridSettings[i, 4] = "Kontakt"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 150
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1
    
    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "zr1"
    GridSettings[i, 4] = "TR"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 150
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1
    
    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "neaktiven"
    GridSettings[i, 4] = "Neaktiven"        && Caption
    GridSettings[i, 5] = "CheckBox"
    GridSettings[i, 6] = 80
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    DO FORM strm1_pregled WITH lnSearchNo, SearchType, CriteriaContainers, GridSettings, tlRunQuery, tlHideContainer, tlRunFullScreen

RETURN .T.


* Šifrant Obrestne mere
FUNCTION Obr_mere_register
LPARAMETERS tlRunQuery, tlHideContainer, tlRunFullScreen, taDefaultValues

    LOCAL lnSearchNo, i, lcSQL
    lnSearchNo = 1
    
    TEXT TO lcSQL NOSHOW
		SELECT 
		    o.*, r.naziv AS rtip_naziv,
		    dbo.gfn_StringToFox(CASE calc_type 
		        WHEN 0 THEN dbo.gfn_GetAppMessageByLang(null, 'CCalcTypeOMFromRegister')
		        WHEN 1 THEN dbo.gfn_GetAppMessageByLang(null, 'CCalcTypeOMFromContract')
		        ELSE ''
		    END) calc_type_desc
		FROM 
		    dbo.obresti o
		    INNER JOIN dbo.rtip r ON o.id_rtip = r.id_rtip
		ORDER BY o.vrstni_red
        
        SELECT * FROM dbo.obr_zgod
    ENDTEXT

    DIMENSION SearchType[1, 11]
    i = 0

    i = i + 1
    SearchType[i, 1] = lnSearchNo
    SearchType[i, 2] = "Obrestne mere"        && Caption
    SearchType[i, 3] = lcSQL
    SearchType[i, 4] = ""
    SearchType[i, 5] = .F.
    SearchType[i, 6] = .F.
    SearchType[i, 7] = tlRunQuery
    SearchType[i, 8] = tlHideContainer
    SearchType[i, 9] = tlRunFullScreen
    SearchType[i, 10] = 2
    SearchType[i, 11] = ""

    DIMENSION CriteriaContainers[1, 11]
    CriteriaContainers[1, 1] = 0

    DO GF_SetDefaultValueForCriteriaContainers WITH CriteriaContainers, taDefaultValues

    DIMENSION GridSettings[13, 15]
    i = 0

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "id_obr"
    GridSettings[i, 4] = "Šifra"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 45
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "opis"
    GridSettings[i, 4] = "Opis"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 500
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1    
    
    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "id_rtip"
    GridSettings[i, 4] = "Šif. rev."        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 60
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "rtip_naziv"
    GridSettings[i, 4] = "Revalorizacija"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 150
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "vrstni_red"
    GridSettings[i, 4] = "Vrstni red"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 75
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1
    
    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "za_vrsteos"
    GridSettings[i, 4] = "Vrste oseb"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 150
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1
    
    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "calc_type_desc"
    GridSettings[i, 4] = "Naèin izraèuna"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 150
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "neaktiven"
    GridSettings[i, 4] = "Neaktivna"        && Caption
    GridSettings[i, 5] = "CheckBox"
    GridSettings[i, 6] = 80
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo + 1
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "datum"
    GridSettings[i, 4] = "Datum"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 100
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = "TTOD(@Field)"
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo + 1
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "vrednost"
    GridSettings[i, 4] = "Obr. mera"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 90
    GridSettings[i, 7] = "gcOm"
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "zobr_linea"
    GridSettings[i, 4] = "Linearna metoda"        && Caption
    GridSettings[i, 5] = "CheckBox"
    GridSettings[i, 6] = 80
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "mdat_zobr"
    GridSettings[i, 4] = "Sprememba metode"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 100
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = "TTOD(@Field)"
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

	i = i + 1
    GridSettings[i, 1] = lnSearchNo
    GridSettings[i, 2] = i
    GridSettings[i, 3] = "expression"
    GridSettings[i, 4] = "Formula"        && Caption
    GridSettings[i, 5] = "TextBox"
    GridSettings[i, 6] = 200
    GridSettings[i, 7] = ""
    GridSettings[i, 8] = 3
    GridSettings[i, 9] = "255,255,255"
    GridSettings[i, 10] = "0,0,0"
    GridSettings[i, 11] = .F.
    GridSettings[i, 12] = ""
    GridSettings[i, 13] = 0
    GridSettings[i, 14] = 0
    GridSettings[i, 15] = 1

    DO FORM obr_mere WITH lnSearchNo, SearchType, CriteriaContainers, GridSettings, tlRunQuery, tlHideContainer, tlRunFullScreen

RETURN .T.

* Konti plan - akonplan
FUNCTION Akonplan_register
LPARAMETERS tlRunQuery, tlHideContainer, tlRunFullScreen, taDefaultValues

	LOCAL lnSearchNo, i
	lnSearchNo = 1
	

	DIMENSION SearchType[1, 11]
	i = 0

	i = i + 1
	SearchType[i, 1] = lnSearchNo
	SearchType[i, 2] = "Analitièni kontni plan"        && Caption
	SearchType[i, 3] = "grp_akonplan_register_view"
	SearchType[i, 4] = ""
	SearchType[i, 5] = .F.
	SearchType[i, 6] = .F.
	SearchType[i, 7] = tlRunQuery
	SearchType[i, 8] = tlHideContainer
	SearchType[i, 9] = tlRunFullScreen
	SearchType[i, 10] = 1
	SearchType[i, 11] = ""

	DIMENSION CriteriaContainers[1, 11]	
	i = 0
	
	i = i + 1
    CriteriaContainers(i,1) = lnSearchNo
    CriteriaContainers(i,2) = "criteria_bit"
    CriteriaContainers(i,3) = i
    CriteriaContainers(i,4) = "Tudi neaktivne"  && Caption
    CriteriaContainers(i,5) = .T.   
    CriteriaContainers(i,6) = 0
    CriteriaContainers(i,7) = .T.
    CriteriaContainers(i,8) = ""
    CriteriaContainers(i,9) = "INACTIVE"
    CriteriaContainers(i,10) = ""
	CriteriaContainers(i,11) = .F.

	DO GF_SetDefaultValueForCriteriaContainers WITH CriteriaContainers, taDefaultValues

	DIMENSION GridSettings[33, 15]
	i = 0

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "konto"
	GridSettings[i, 4] = "Konto"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "naziv"
	GridSettings[i, 4] = "Naziv konta"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 400
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1    

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "oznaka"
	GridSettings[i, 4] = "Oznaka"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 50
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "ali_kupec"
	GridSettings[i, 4] = "Konto aktive"        && Caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 60
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "predp_tec"
	GridSettings[i, 4] = "Teèajnica"        && Caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 70
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "prk_dvrac"
	GridSettings[i, 4] = "Preh. konto DDV"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "stran_knj"
	GridSettings[i, 4] = "Stran knjiženja"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 60
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "knj_na_pog"
	GridSettings[i, 4] = "Na pogodbo"        && Caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 60
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "tuj_konto"
	GridSettings[i, 4] = "Tuj konto"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 90
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "prenesi"
	GridSettings[i, 4] = "Prenos"        && Caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 60
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "neaktiven"
	GridSettings[i, 4] = "Neaktiven"        && Caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 70
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "naziv_tuj1"
	GridSettings[i, 4] = "Naziv tuj 1"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 250
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "naziv_tuj2"
	GridSettings[i, 4] = "Naziv tuj 2"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 250
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "naziv_tuj3"
	GridSettings[i, 4] = "Naziv tuj 3"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 250
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "b2_konto"
	GridSettings[i, 4] = "B2 konto"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "ias_konto"
	GridSettings[i, 4] = "IAS konto"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "konto_presl"
	GridSettings[i, 4] = "Presl. konto"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "vnos_int_veza"
	GridSettings[i, 4] = "Obvezen vnos int. veze"        && Caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "vnos_id_project"
	GridSettings[i, 4] = "Obvezen vnos projekta"        && Caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "tuj_konto1"
	GridSettings[i, 4] = "Tuj konto 1"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 90
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "tuj_konto2"
	GridSettings[i, 4] = "Tuj konto 2"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 90
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "tuj_konto3"
	GridSettings[i, 4] = "Tuj konto 3"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 90
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "tuj_konto4"
	GridSettings[i, 4] = "Tuj konto 4"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 90
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "tuj_konto5"
	GridSettings[i, 4] = "Tuj konto 5"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 90
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
		
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "tuj_konto6"
	GridSettings[i, 4] = "Tuj konto 6"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 90
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
			
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "tuj_konto7"
	GridSettings[i, 4] = "Tuj konto 7"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 90
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "tuj_konto8"
	GridSettings[i, 4] = "Tuj konto 8"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 90
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
		
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "tuj_konto9"
	GridSettings[i, 4] = "Tuj konto 9"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 90
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "b2_id_kupca"
	GridSettings[i, 4] = "Šif. part."        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 70
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "naz_kr_kup"
	GridSettings[i, 4] = "Naziv partnerja"        && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 250
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "for_le"
	GridSettings[i, 4] = "Za LE"        && Caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 60
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "for_gl"
	GridSettings[i, 4] = "Za GL"        && Caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 60
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "for_fa"
	GridSettings[i, 4] = "Za FA"        && Caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 60
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	DO FORM akonplan_pregled WITH lnSearchNo, SearchType, CriteriaContainers, GridSettings, tlRunQuery, tlHideContainer, tlRunFullScreen

RETURN .T.

* Šifrant Kategorije entitet
FUNCTION Kategorije_tipi_sifranti_pregled
LPARAMETERS tlRunQuery, tlHideContainer, tlRunFullScreen, taDefaultValues 

	LOCAL lnSearchNo, i, lcSql, lcText1, lcText2, lcText3, lcText4, lcText5, lcText6
	lnSearchNo = 1

	DIMENSION SearchType[1, 11]
	i = 0

	i = i + 1
	SearchType[i, 1] = lnSearchNo
	SearchType[i, 2] = "Poljubne kategorije entitet - šifrant"        && Caption
	SearchType[i, 3] = "dbo.grp_Kategorije_tipi_sifranti_View"
	SearchType[i, 4] = "cnt_Header"
	SearchType[i, 5] = .F.
	SearchType[i, 6] = .F.
	SearchType[i, 7] = tlRunQuery
	SearchType[i, 8] = tlHideContainer
	SearchType[i, 9] = tlRunFullScreen
	SearchType[i, 10] = 1
	SearchType[i, 11] = ""

	DIMENSION CriteriaContainers[2, 11]
	i = 0

	i = i + 1
	TEXT TO lcSql NOSHOW
		SELECT '{1}' as naziv, 'PARTNER' as id
		UNION
		SELECT '{2}' as naziv, 'POGODBA' as id
		UNION
		SELECT '{3}' as naziv, 'P_EVAL' as id
		UNION
		SELECT '{4}' as naziv, 'DOKUMENT' as id
		UNION
		SELECT '{5}' as naziv, 'ZAVAROVA' as id
		UNION
		SELECT '{6}' as naziv, 'PONUDBA' as id
	ENDTEXT
	lcText1 = "Partner" && caption
	lcText2 = "Pogodba" && caption
	lcText3 = "Evaluacija partnerja" && caption
	lcText4 = "Dokument" && caption
	lcText5 = "Zavarovalnica" && caption
	lcText6 = "Ponudba" && caption
	lcSql = STRTRAN(lcSql, "{1}", lcText1)
	lcSql = STRTRAN(lcSql, "{2}", lcText2)
	lcSql = STRTRAN(lcSql, "{3}", lcText3)
	lcSql = STRTRAN(lcSql, "{4}", lcText4)
	lcSql = STRTRAN(lcSql, "{5}", lcText5)
	lcSql = STRTRAN(lcSql, "{6}", lcText6)

	CriteriaContainers[i, 1] = lnSearchNo
	CriteriaContainers[i, 2] = "criteria_combobox"
	CriteriaContainers[i, 3] = i
	CriteriaContainers[i, 4] = "Entiteta"  && Caption
	CriteriaContainers[i, 5] = .T.   
	CriteriaContainers[i, 6] = 0
	CriteriaContainers[i, 7] = .T.
	CriteriaContainers[i, 8] = ""
	CriteriaContainers[i, 9] = "TIP"
	CriteriaContainers[i, 10] = lcSql
	CriteriaContainers[i, 11] = .F.

	i = i + 1 
	CriteriaContainers[i, 1] = lnSearchNo
	CriteriaContainers[i, 2] = "criteria_bit"
	CriteriaContainers[i, 3] = i
	CriteriaContainers[i, 4] = "Tudi neaktivne"  && Caption
	CriteriaContainers[i, 5] = .T.   
	CriteriaContainers[i, 6] = 0
	CriteriaContainers[i, 7] = .T.
	CriteriaContainers[i, 8] = ""
	CriteriaContainers[i, 9] = "INACTIV"
	CriteriaContainers[i, 10] = ""
	CriteriaContainers[i, 11] = .F.

	DO GF_SetDefaultValueForCriteriaContainers WITH CriteriaContainers, taDefaultValues

	DIMENSION GridSettings[12, 15]
	i = 0

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "entiteta"
	GridSettings[i, 4] = "Entiteta" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 70
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "sifra"
	GridSettings[i, 4] = "Šifra" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 200
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "naziv"
	GridSettings[i, 4] = "Naziv" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 300
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "tip_polja_opis"
	GridSettings[i, 4] = "Tip polja" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 200
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "id_register_gr"
	GridSettings[i, 4] = "Poljubni šifranti" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 200
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "maska"
	GridSettings[i, 4] = "Maska" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 100
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "prosti_vnos"
	GridSettings[i, 4] = "Poljubna dolžina" && caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 60
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "obvezen"
	GridSettings[i, 4] = "Obvezen" && caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 60
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "povezava"
	GridSettings[i, 4] = "Povezava iz entitete / šifre" && caption
	GridSettings[i, 5] = "Textbox"
	GridSettings[i, 6] = 250
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "neaktiven"
	GridSettings[i, 4] = "Neaktiven" && caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 70
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	** za šifrant
	i = i + 1
	GridSettings[i, 1] = lnSearchNo + 1
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "vrednost"
	GridSettings[i, 4] = "Vrednost" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 300
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo + 1
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "neaktiven"
	GridSettings[i, 4] = "Neaktiven" && caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 70
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	DO FORM kategorije_tip_pregled WITH lnSearchNo, SearchType, CriteriaContainers, GridSettings, tlRunQuery, tlHideContainer, tlRunFullScreen
RETURN .T.

* Poroèila
FUNCTION Porocila_pregled
LPARAMETERS tlFromProduction, tlRunQuery, tlHideContainer, tlRunFullScreen, taDefaultValues 

	LOCAL lnSearchNo, i 
	lnSearchNo = 1

	DIMENSION SearchType[1, 11]
	i = 0

	i = i + 1
	SearchType[i, 1] = lnSearchNo
	if tlFromProduction then
	SearchType[i, 2] = "Poroèila iz produkcije" && Caption
	else
	SearchType[i, 2] = "Poroèila iz posnetka stanja" && Caption
	endif
	SearchType[i, 3] = "dbo.grp_Porocila_View"
	SearchType[i, 4] = "cnt_Header"
	SearchType[i, 5] = .F.
	SearchType[i, 6] = .F.
	SearchType[i, 7] = tlRunQuery
	SearchType[i, 8] = tlHideContainer
	SearchType[i, 9] = tlRunFullScreen
	SearchType[i, 10] = 1
	SearchType[i, 11] = ""

	DIMENSION CriteriaContainers[4, 11]
	i = 0

	i = i + 1 
	CriteriaContainers[i, 1] = lnSearchNo
	CriteriaContainers[i, 2] = "criteria_bit"
	CriteriaContainers[i, 3] = i
	CriteriaContainers[i, 4] = "Tudi neaktivne"  && Caption
	CriteriaContainers[i, 5] = .T.   
	CriteriaContainers[i, 6] = 0
	CriteriaContainers[i, 7] = .T.
	CriteriaContainers[i, 8] = ""
	CriteriaContainers[i, 9] = "INACTIV"
	CriteriaContainers[i, 10] = ""
	CriteriaContainers[i, 11] = .F.

	i = i + 1
	CriteriaContainers[i, 1] = lnSearchNo
	CriteriaContainers[i, 2] = "criteria_text"
	CriteriaContainers[i, 3] = i
	CriteriaContainers[i, 4] = "Uporabnik"  && Caption
	CriteriaContainers[i, 5] = .F.   
	CriteriaContainers[i, 6] = 1
	CriteriaContainers[i, 7] = .F.
	CriteriaContainers[i, 8] = GOBJ_Comm.UserData.GetUserName()
	CriteriaContainers[i, 9] = "USER"
	CriteriaContainers[i, 10] = ""
	CriteriaContainers[i, 11] = .F.

	i = i + 1
	CriteriaContainers[i, 1] = lnSearchNo
	CriteriaContainers[i, 2] = "criteria_text"
	CriteriaContainers[i, 3] = i
	CriteriaContainers[i, 4] = "Modul"  && Caption
	CriteriaContainers[i, 5] = .F.   
	CriteriaContainers[i, 6] = 1
	CriteriaContainers[i, 7] = .F.
	CriteriaContainers[i, 8] = LEFT(GOBJ_Settings.GetAppName(), 2)
	CriteriaContainers[i, 9] = "MODUL"
	CriteriaContainers[i, 10] = ""
	CriteriaContainers[i, 11] = .F.

	i = i + 1
	CriteriaContainers[i, 1] = lnSearchNo
	CriteriaContainers[i, 2] = "criteria_bit"
	CriteriaContainers[i, 3] = i
	CriteriaContainers[i, 4] = "Povezava"  && Caption
	CriteriaContainers[i, 5] = .F.   
	CriteriaContainers[i, 6] = IIF(tlFromProduction, 1, 0)
	CriteriaContainers[i, 7] = .F.
	CriteriaContainers[i, 8] = IIF(tlFromProduction, "1", "")
	CriteriaContainers[i, 9] = "CONNECTION"
	CriteriaContainers[i, 10] = ""
	CriteriaContainers[i, 11] = .F.

	DO GF_SetDefaultValueForCriteriaContainers WITH CriteriaContainers, taDefaultValues

	DIMENSION GridSettings[15, 15]
	i = 0

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "opis"
	GridSettings[i, 4] = "Opis" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 350
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "report_num"
	GridSettings[i, 4] = "Št. poroèila" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "gfn_name"
	GridSettings[i, 4] = "Ime funkcije" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 200
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "form_name"
	GridSettings[i, 4] = "Ime forme" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 200
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "open_from"
	GridSettings[i, 4] = "Klièe se iz forme" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 200
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "criteria_con_ima"
	GridSettings[i, 4] = "Pogoji" && caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "grid_settings_ima"
	GridSettings[i, 4] = "Rezultat" && caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "code_after_ima"
	GridSettings[i, 4] = "Dodatna rutina" && caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "connection_name"
	GridSettings[i, 4] = "Ime povezave" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 150
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "module_name"
	GridSettings[i, 4] = "Modul" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 40
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "neaktiven"
	GridSettings[i, 4] = "Neaktiven" && caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 70
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "skrbnik_desc"
	GridSettings[i, 4] = "Skrbnik" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 150
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "frekvenca"
	GridSettings[i, 4] = "Frekvenca" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 60
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "datum_potrditve"
	GridSettings[i, 4] = "Datum potrditve" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = "TTOD(@Field)"
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "gdpr_relevant"
	GridSettings[i, 4] = "Relevantno za GDPR"  && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 130
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	DO FORM porocila_pregled WITH lnSearchNo, SearchType, CriteriaContainers, GridSettings, tlRunQuery, tlHideContainer, tlRunFullScreen
RETURN .T.

* Dodatne rutine
FUNCTION Dod_rut_pregled
LPARAMETERS tlRunQuery, tlHideContainer, tlRunFullScreen, taDefaultValues 

	LOCAL lnSearchNo, i 
	lnSearchNo = 1
	
	DIMENSION SearchType[1, 11]
	i = 0

	i = i + 1
	SearchType[i, 1] = lnSearchNo
	SearchType[i, 2] = "Dodatne rutine"        && Caption
	SearchType[i, 3] = "dbo.gfn_DodRut_view"
	SearchType[i, 4] = "cnt_Header"
	SearchType[i, 5] = .F.
	SearchType[i, 6] = .F.
	SearchType[i, 7] = tlRunQuery
	SearchType[i, 8] = tlHideContainer
	SearchType[i, 9] = tlRunFullScreen
	SearchType[i, 10] = 0
	SearchType[i, 11] = ""

	DIMENSION CriteriaContainers[2, 11]
	i = 0

	i = i + 1 
	CriteriaContainers[i, 1] = lnSearchNo
	CriteriaContainers[i, 2] = "criteria_bit"
	CriteriaContainers[i, 3] = i
	CriteriaContainers[i, 4] = "Tudi neaktivne"  && Caption
	CriteriaContainers[i, 5] = .T.   
	CriteriaContainers[i, 6] = 0
	CriteriaContainers[i, 7] = .T.
	CriteriaContainers[i, 8] = ""
	CriteriaContainers[i, 9] = "INACTIV"
	CriteriaContainers[i, 10] = ""
	CriteriaContainers[i, 11] = .F.

	i = i + 1
	CriteriaContainers[i, 1] = lnSearchNo
	CriteriaContainers[i, 2] = "criteria_text"
	CriteriaContainers[i, 3] = i
	CriteriaContainers[i, 4] = "Modul"  && Caption
	CriteriaContainers[i, 5] = .F.   
	CriteriaContainers[i, 6] = 1
	CriteriaContainers[i, 7] = .F.
	CriteriaContainers[i, 8] = LEFT(GOBJ_Settings.GetAppName(), 2)
	CriteriaContainers[i, 9] = "MODUL"
	CriteriaContainers[i, 10] = ""
	CriteriaContainers[i, 11] = .F.

	DO GF_SetDefaultValueForCriteriaContainers WITH CriteriaContainers, taDefaultValues

	DIMENSION GridSettings[7, 15]
	i = 0

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "opis"
	GridSettings[i, 4] = "Opis" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 350
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "open_from"
	GridSettings[i, 4] = "Klièe se iz forme" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 250
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "grid_settings_ima"
	GridSettings[i, 4] = "Rezultat" && caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "code_after_ima"
	GridSettings[i, 4] = "Dodatna rutina" && caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 80
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "module_name"
	GridSettings[i, 4] = "Modul" && caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 40
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "neaktiven"
	GridSettings[i, 4] = "Neaktiven" && caption
	GridSettings[i, 5] = "CheckBox"
	GridSettings[i, 6] = 70
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1
	
	i = i + 1
	GridSettings[i, 1] = lnSearchNo
	GridSettings[i, 2] = i
	GridSettings[i, 3] = "gdpr_relevant"
	GridSettings[i, 4] = "Relevantno za GDPR"  && Caption
	GridSettings[i, 5] = "TextBox"
	GridSettings[i, 6] = 130
	GridSettings[i, 7] = ""
	GridSettings[i, 8] = 3
	GridSettings[i, 9] = "255,255,255"
	GridSettings[i, 10] = "0,0,0"
	GridSettings[i, 11] = .F.
	GridSettings[i, 12] = ""
	GridSettings[i, 13] = 0
	GridSettings[i, 14] = 0
	GridSettings[i, 15] = 1

	DO FORM dod_rut_pregled WITH lnSearchNo, SearchType, CriteriaContainers, GridSettings, tlRunQuery, tlHideContainer, tlRunFullScreen
RETURN .T.