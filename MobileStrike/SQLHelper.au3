#include-once
; #INDEX# ========================================================================
; Title .........: _SQL.au3
; AutoIt Version : 3.2
; Language ......: English
; Description ...: Some SQL stuff to use with an MSDE database
; Author ........: Chris Lambert
; ================================================================================


; #VARIABLES# ====================================================================
Global $SQL_LastConnection ;  enables the use of -1 to access the last opened connection
Global $SQLErr ;  Plain text error message holder
Global $MSSQLObjErr ;  For COM error handler
Global Const $SQL_OK = 0 ;  Successful result
Global Const $SQL_ERROR = 1 ;  SQL error
; ==============================================================================

; #FUNCTION# ===================================================================
; Name ..........: _SQL_RegisterErrorHandler
; Description ...: Register COM error handler
; Syntax.........:  _SQL_RegisterErrorHandler($Func = "_SQL_ErrFunc")
; Parameters ....: $Func      - String variable with the name of a user-defined COM error handler defaults to the _SQL_ErrFunc()
; Return values .: On Success - Returns $SQL_OK
;                  On Failure - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......: AutoIt3 V3.2 or higher
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_RegisterErrorHandler($Func = "_SQL_ErrFunc")
    $SQLErr = ""
    If ObjEvent("AutoIt.Error") = "" Then
        $MSSQLObjErr = ObjEvent("AutoIt.Error", $Func)
        Return SetError($SQL_OK, 0, $SQL_OK)
    Else
        $SQLErr = "An Error Handler is already registered"
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

EndFunc   ;==>_SQL_RegisterErrorHandler

; #FUNCTION# ===================================================================
; Name ..........: _SQL_UnRegisterErrorHandler()
; Description ...: Disable a registered error handler
; Syntax.........: _SQL_UnRegisterErrorHandler()
; Parameters ....: None
; Return values .: On Success - Returns $SQL_OK
;                  On Failure - None
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......: AutoIt3 V3.2 or higher
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_UnRegisterErrorHandler()

    $SQLErr = ""
    $MSSQLObjErr = ""
    Return SetError($SQL_OK, 0, $SQL_OK)

EndFunc   ;==>_SQL_UnRegisterErrorHandler

; #FUNCTION# ===================================================================
; Name ..........: _SQL_Startup
; Description ...: Creates ADODB.Connection object
; Syntax.........:  _SQL_Startup()
; Parameters ....: None
; Return values .: On Success - Returns Object handle
;                  On Failure - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_Startup()

    $SQLErr = ""
	;SQLOLEDB
    Local $adCN = ObjCreate("ADODB.Connection")
    If IsObj($adCN) Then
        $SQL_LastConnection = $adCN
        Return SetError($SQL_OK, 0, $adCN)
    Else
        $SQLErr = "Failed to Create ADODB.Connection object"
		 LogMessage("-- _SQL_Startup  --  " & _SQL_GetErrMsg())
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

EndFunc   ;==>_SQL_Startup

; #FUNCTION# ===================================================================
; Name ..........: _SQL_Connect
; Description ...: Starts a Database Connection
; Syntax.........:  _SQL_Connect($ADODBHandle,$server, $db, $username, $password)
; Parameters ....: $ADODBHandle - ADODB.Connection handle.
;                  $server   - The server to connect to.
;                  $db    - The database to open.
;                  $username    - username for database access.
;                  $password    - password for database user.
; Return values .: On Success   - Returns $SQL_OK
;                  On Failure   - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_Connect($ADODBHandle, $server, $db, $username, $password)

    $SQLErr = ""
    If $ADODBHandle = -1 Then $ADODBHandle = $SQL_LastConnection

    If Not IsObj($ADODBHandle) Then
        $SQLErr = "Invalid ADODB.Connection object, use _SQL_Startup()"
		 LogMessage("-- SQL_Connect  --  " & _SQL_GetErrMsg())
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    $ADODBHandle.Open("DRIVER={SQL Server};SERVER=" & $server & ";DATABASE=" & $db & ";uid=" & $username & ";pwd=" & $password & ";") ;<==Connect with required credentials

    If Not @error Then
		 Return SetError($SQL_OK, 0, $SQL_OK)
    Else
		 $SQLErr = "Connection Error"
		 Sleep(60000)
		 LogMessage("-- SQL_Connect(1)  --  " & @error)
		 LogMessage("-- SQL_Connect(2)  --  " & _SQL_GetErrMsg())
		 LogMessage("-- Slept (1 Min) --")
		 Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf
EndFunc   ;==>_SQL_Connect

; #FUNCTION# ===================================================================
; Name ..........: _SQL_JetConnect
; Description ...: Starts a Database Connection to a Jet Database
; Syntax.........:  _SQL_JetConnect($ADODBHandle,$sFilePath1)
; Parameters ....: $ADODBHandle -  ADODB.Connection handle
;                  $sFilePath1  - Path to Jet Database file
; Return values .: On Success   - Returns $SQL_OK
;                  On Failure   - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_JetConnect($ADODBHandle, $sFilePath1)

    $SQLErr = ""
    If $ADODBHandle = -1 Then $ADODBHandle = $SQL_LastConnection

    If Not IsObj($ADODBHandle) Then
        $SQLErr = "Invalid ADODB.Connection object, use _SQL_Startup()"
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    $ADODBHandle.Open("Provider=Microsoft.Jet.OLEDB.4.0;" & _
            "Data Source=" & $sFilePath1 & ";")
    If @error Then
        $SQLErr = "Connection Error"
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf


    Return SetError($SQL_OK, 0, $SQL_OK)
EndFunc   ;==>_SQL_JetConnect

; #FUNCTION# ===================================================================
; Name ..........: _SQL_AccessConnect
; Description ...: Starts a Database Connection to an Access Database
; Syntax ........: _SQL_AccessConnect($ADODBHandle,$sFilePath1)
; Parameters ....: $ADODBHandle - ADODB.Connection handle - Optional
;                  $sFilePath1  - Path to an Access Database file
; Return values .: Success      - Returns $SQL_OK
;                  On Failure   - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......: no
; ================================================================================
Func _SQL_AccessConnect($ADODBHandle = -1, $sFilePath1 = "")
    $SQLErr = ""
    If $ADODBHandle = -1 Then $ADODBHandle = $SQL_LastConnection

    If Not IsObj($ADODBHandle) Then
        $SQLErr = "Invalid ADODB.Connection object, use _SQL_Startup()"
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    $ADODBHandle.Open("Driver={Microsoft Access Driver (*.mdb)};Dbq=" & $sFilePath1 & ";")
    If @error Then
        $SQLErr = "Connection Error"
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    Return SetError($SQL_OK, 0, $SQL_OK)

EndFunc   ;==>_SQL_AccessConnect

; #FUNCTION# ===================================================================
; Name ..........: _SQL_Close
; Description ...: Closes an open ADODB.Connection
; Syntax.........:  _SQL_Close ($ADODBHandle = -1)
; Parameters ....: $ADODBHandle - Optional Database Handle
; Return values .: On Success   - Returns $SQL_OK
;                  On Failure   - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_Close($ADODBHandle = -1)

    $SQLErr = ""

    If $ADODBHandle = -1 Then $ADODBHandle = $SQL_LastConnection

    If Not IsObj($ADODBHandle) Then
		 $SQLErr = "--  _SQL_Close  -- Invalid ADODB.Connection object, use _SQL_Startup()"
		 LogMessage(_SQL_GetErrMsg())
		 Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    $ADODBHandle.Close
    If $ADODBHandle = $SQL_LastConnection Then $SQL_LastConnection = ""

    Return SetError($SQL_OK, 0, $SQL_OK)

EndFunc   ;==>_SQL_Close

; #FUNCTION# ===================================================================
; Name ..........: _SQL_Execute()
; Description ...: Executes an SQL Query
; Syntax.........:  _SQL_Execute([ $hConHandle = -1[,$vQuery = "" ]])
; Parameters ....: $hConHandle - An Open Database, Use -1 To use Last Opened Database
;                  $vQuery     - SQL Statement to be executed
; Return values .: On Success  - Returns a query handle
;                  On Failure  - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_Execute($hConHandle = -1, $vQuery = "")

    $SQLErr = ""
    Local $hQuery

    If $hConHandle = -1 Then $hConHandle = $SQL_LastConnection

   If IsObj($hConHandle) Then
	  $hQuery = $hConHandle.Execute($vQuery)
   Else
	  $SQLErr = "--  _SQL_Execute  --  Invalid $hConHandle is NOT an object."
	  LogMessage(_SQL_GetErrMsg())
	  Return SetError($SQL_ERROR, 0, $SQL_ERROR)
   EndIf

   If @error Then
	  LogMessage(_SQL_GetErrMsg())
	  Return SetError($SQL_ERROR, 0, $SQL_ERROR)
   Else
	  Return SetError($SQL_OK, 0, $hQuery)
   EndIf
EndFunc   ;==>_SQL_Execute

; #FUNCTION# ===================================================================
; Name ..........: _SQL_GetErrMsg
; Description ...: Get SQL error as text
; Syntax.........:  _SQL_GetErrMsg()
; Parameters ....:                None
; Return values .: On Success - Returns the text string from $SQLErr
;                  On Failure - None
; Author ........: Chris Lambert
; Modified ......: Stephen Podhajecki (eltorro)
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_GetErrMsg()
    ;added temp var to return and clear $SQLErr
    ;returns the current errmsg and clears it.
    Local $SQLErr_TMP = $SQLErr
    $SQLErr = ""
    Return SetError($SQL_OK, 0, $SQLErr_TMP)
EndFunc   ;==>_SQL_GetErrMsg

; #FUNCTION# ===================================================================
; Name ..........: _SQL_GetTable2d()
; Description ...: Passes Out a 2Dimensional Array Containing Tablenames and Data of Executed Query
; Syntax.........:  _SQL_GetTable2D($hConHandle, $vQuery, ByRef $aResult, ByRef $iRows, ByRef $iColumns)
; Parameters ....: $hConHandle - An Open Database, Use -1 To use Last Opened Database
;                  $vQuery     - SQL Statement to be executed
;                  $aResult    - Passes out the Result
;                  $iRows      - Passes out the amount of 'data' Rows
;                  $iColumns   - Passes out the amount of Columns
; Return values .: On Success  - Returns $SQL_OK
;                  On Failure  - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......: Stephen Podhajecki (eltorro)
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_GetTable2D($hConHandle, $vQuery, ByRef $aResult, ByRef $iRows, ByRef $iColumns)

    $SQLErr = ""
    Local $i, $x, $y, $objquery

    $iRows = 0
    $iColumns = 0
    ;sp mod removed handle check here use function.
    $objquery = _SQL_Execute($hConHandle, $vQuery)
    ;end mod
    If @error Then
        $SQLErr = "Query Error"
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    If $objquery.eof Then
        $SQLErr = "Query has no data"
        $objquery = 0 ;sp mod
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    With $objquery

        $aResult = .GetRows()

        If IsArray($aResult) Then
            $iColumns = UBound($aResult, 2)
            $iRows = UBound($aResult)

            ReDim $aResult[$iRows + 1][$iColumns];Adjust the array to fit the column names and move all data down 1 row

            For $x = $iRows To 1 Step -1
                For $y = 0 To $iColumns - 1
                    $aResult[$x][$y] = $aResult[$x - 1][$y]
                Next
            Next
            ;Add the coloumn names
            For $i = 0 To $iColumns - 1 ;get the column names and put into 0 array element
                $aResult[0][$i] = .Fields($i).Name
            Next

        Else
            $SQLErr = "Unable to retreive data"
            $objquery = 0 ;sp mod
            Return SetError($SQL_ERROR, 0, $SQL_ERROR)
        EndIf;IsArray()

    EndWith
    $objquery = 0
    Return SetError($SQL_OK, 0, $SQL_OK)
EndFunc   ;==>_SQL_GetTable2D

; #FUNCTION# ===================================================================
; Name ..........: _SQL_FetchNames()
; Description ...: Read out the Tablenames of a _SQL_Query() based query
; Syntax.........:  _SQL_FetchNames($hQuery,ByRef $aNames)
; Parameters ....: $hQuery    - Query Handle Generated by _SQL_Execute()
;                  $aNames    - variable to store the Table Names
; Return values .: On Success - Returns $SQL_OK
;                  On Failure - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_FetchNames($hQuery, ByRef $aNames)

    Local $i, $SQL_Delim = "�&~"
    Local $iDelLen = StringLen($SQL_Delim)
    $SQLErr = ""

    If Not IsObj($hQuery) Then
        $SQLErr = "Invalid Query Handle"
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    $aNames = ""
    For $i = 0 To $hQuery.Fields.Count - 1 ;get the column names and put into 0 array element
        $aNames &= $hQuery.Fields($i).Name & $SQL_Delim
    Next

    If StringRight($aNames, $iDelLen) = $SQL_Delim Then $aNames = StringTrimRight($aNames, $iDelLen)

    $aNames = StringSplit($aNames, $SQL_Delim, 3)

    Return SetError($SQL_OK, 0, $SQL_OK)

EndFunc   ;==>_SQL_FetchNames

; #FUNCTION# ===================================================================
; Name ..........: _SQL_GetTable()
; Description ...: Passes Out a 1Dimensional Array Containing Tablenames and Data of Executed Query
; Syntax.........:  _SQL_GetTable($hConHandle, $vQuery, ByRef $aData, ByRef $iRows, ByRef $iColumns)
; Parameters ....: $hConHandle - An Open Database, Use -1 To use Last Opened Database
;                  $vQuery     - SQL Statement to be executed
;                  $aResult    - Passes out the Result
;                  $iRows      - Passes out the amount of 'data' Rows
;                  $iColumns   - Passes out the amount of Columns
; Return values .: On Success  - Returns $SQL_OK
;                  On Failure  - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......: Stephen Podhajecki (eltorro)
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_GetTable($hConHandle, $vQuery, ByRef $aData, ByRef $iRows, ByRef $iColumns)

    Local $i, $objquery, $aNames
    $SQLErr = ""
    $iRows = 0
    $iColumns = 0

    $objquery = _SQL_Execute($hConHandle, $vQuery)

    If @error Then
        $SQLErr = "Query Error"
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    If $objquery.eof Then
        $SQLErr = "Query has no data"
        $objquery = 0 ;sp mod
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    _SQL_FetchNames($objquery, $aNames)

    $iColumns = UBound($aNames)
    ReDim $aData[$iColumns + 1]

    $aData[0] = $iColumns

    For $i = 0 To $iColumns - 1
        $aData[$i + 1] = $aNames[$i]
    Next

    $aNames = 0

    While Not $objquery.eof
        $iRows += 1
        For $i = 0 To $objquery.Fields.Count - 1
            ReDim $aData[$aData[0] + 2]
            $aData[0] += 1
            $aData[$aData[0]] = $objquery.Fields($i).Value
        Next
        $objquery.MoveNext; Move to next row
    WEnd
    $objquery = 0 ;sp mod
    Return SetError($SQL_OK, 0, $SQL_OK)

EndFunc   ;==>_SQL_GetTable

; #FUNCTION# ===================================================================
; Name ..........: _SQL_FetchData()
; Description ...: Fetches 1 Row of Data from an _SQL_Execute() based query
; Syntax.........:  _SQL_FetchData($hQuery,ByRef $aRow)
; Parameters ....: $hQuery    - Queryhandle passed out by _SQL_Execute()
;                  $aRow      - A 1 dimensional Array containing a Row of Data
; Return values .: On Success - Returns $SQL_OK
;                  On Failure - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_FetchData($hQuery, ByRef $aRow)

    Local $i, $SQL_Delim = "�&~"
    Local $iDelLen = StringLen($SQL_Delim)
    $SQLErr = ""

    If Not IsObj($hQuery) Then
        $SQLErr = "Invalid Query Handle"
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    If $hQuery.EOF Then
        $SQLErr = "End of Data Stream"
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    $aRow = ""
    For $i = 0 To $hQuery.Fields.Count - 1
        $aRow &= $hQuery.Fields($i).Value & $SQL_Delim
    Next

    If StringRight($aRow, $iDelLen) = $SQL_Delim Then $aRow = StringTrimRight($aRow, $iDelLen)
    $hQuery.MoveNext; Move to next row
    $aRow = StringSplit($aRow, $SQL_Delim, 3)
    Return SetError($SQL_OK, 0, $SQL_OK)

EndFunc   ;==>_SQL_FetchData

; #FUNCTION# ===================================================================
; Name ..........: _SQL_QuerySingleRow()
; Description ...: Read out the first Row of the Result from the Specified query
; Syntax.........:  _SQL_QuerySingleRow($hConHandle, $sSQL, ByRef $aRow)
; Parameters ....: $hConHandle - An Open Database, Use -1 To use Last Opened Database.
;                  $sSQL       - SQL Statement to be executed.
;                  $aRow       - Array to hold return results.
; Return values .: On Success  - Returns $SQL_OK
;                  On Failure  - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......:
; Remarks .......: $SQLErr will already be set by _SQL_GetTable2D
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================
Func _SQL_QuerySingleRow($hConHandle, $sSQL, ByRef $aRow)

    Local $aResult, $iRows, $iColumns, $Ret, $i
    $aRow = ""
    Dim $aRow[1]
    $Ret = _SQL_GetTable2D($hConHandle, $sSQL, $aResult, $iRows, $iColumns)
    If $Ret = $SQL_ERROR Then SetError($SQL_ERROR, 0, $SQL_ERROR) ;$SQLErr will already be set by _SQL_GetTable2D

    If $Ret = $SQL_OK And UBound($aResult, 0) > 0 Then
        ReDim $aRow[UBound($aResult, 2)]
        For $i = 0 To UBound($aResult, 2) - 1
            $aRow[$i] = $aResult[1][$i]
        Next
    EndIf

    Return SetError($SQL_OK, 0, $SQL_OK)

EndFunc   ;==>_SQL_QuerySingleRow

; #FUNCTION# ===================================================================
; Name ..........: _SQL_GetTableAsString
; Description ...: Passes Out a string of results
; Syntax.........:  _SQL_GetTableAsString( $hConHandle, $vQuery, ByRef $vStr[, $delim= "|"[, $ReturnColumnNames = 1]])
; Parameters ....: $hConHandle        - An Open Database, Use -1 To use Last Opened Database
;                  $vQuery            - SQL Statement to be executed
;                  $vStr              - Passes out the Result
;                  $delim= "|"        - The deliminator to use between columns
;                  $ReturnColumnNames - Use 1 to show column names and 0 without
; Return values .: On Success         - Returns $SQL_OK
;                  On Failure         - Returns $SQL_ERROR and $SQLErr is set.
;                  .Use _SQL_GetErrMsg() to get text error information
; Author ........: Chris Lambert
; Modified ......: Stephen Podhajecki (eltorro)
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; no
; ==============================================================================

Func _SQL_GetTableAsString($hConHandle, $vQuery, ByRef $vStr, $delim = "|", $ReturnColumnNames = 1)

    $SQLErr = ""
    Local $i, $objquery

    $objquery = _SQL_Execute($hConHandle, $vQuery)

    If @error Then
        $SQLErr = "Query Error"
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    If $objquery.eof Then
        $SQLErr = "Query has no data"
        $objquery = 0 ;sp mod
        Return SetError($SQL_ERROR, 0, $SQL_ERROR)
    EndIf

    With $objquery
        If $ReturnColumnNames Then
            For $i = 0 To .Fields.Count - 1 ;get the column names and put into 0 array element
                $vStr &= .Fields($i).Name & $delim
            Next
            If StringRight($vStr, 1) = $delim Then $vStr = StringTrimRight($vStr, 1)
            $vStr &= @CRLF
        EndIf

        While Not .EOF
            For $i = 0 To .Fields.Count - 1
                $vStr &= .Fields($i).Value & $delim
            Next
            If StringRight($vStr, 1) = $delim Then $vStr = StringTrimRight($vStr, 1)
            $vStr &= @CRLF
            .MoveNext; Move to next row
        WEnd
    EndWith
    $objquery = 0 ;sp mod
    Return SetError($SQL_OK, 0, $SQL_OK)
EndFunc   ;==>_SQL_GetTableAsString

; #FUNCTION# ===================================================================
; Name ..........: _SQL_ErrFunc
; Description ...: Autoit Error handler function
; Syntax ........: _SQL_ErrFunc()
; Parameters ....: None.
; Return values .: $SQLErr and @error set to $SQL_ERROR
; Author ........:
; Modified.......:
; Remarks .......: COM error handler function.
; Related .......:
; Link ..........:
; Example .......: no
; ================================================================================
Func _SQL_ErrFunc()
    Local $HexNumber = Hex($MSSQLObjErr.number, 8)
    $SQLErr = "err.description is: " & @TAB & $MSSQLObjErr.description & @CRLF & _
            "err.windescription:" & @TAB & $MSSQLObjErr.windescription & @CRLF & _
            "err.number is: " & @TAB & $HexNumber & @CRLF & _
            "err.lastdllerror is: " & @TAB & $MSSQLObjErr.lastdllerror & @CRLF & _
            "err.scriptline is: " & @TAB & $MSSQLObjErr.scriptline & @CRLF & _
            "err.source is: " & @TAB & $MSSQLObjErr.source & @CRLF & _
            "err.helpfile is: " & @TAB & $MSSQLObjErr.helpfile & @CRLF & _
            "err.helpcontext is: " & @TAB & $MSSQLObjErr.helpcontext
    ConsoleWrite("###############################" & @CRLF & $SQLErr & "###############################" & @CRLF)
    SetError($SQL_ERROR, 0, $SQLErr)
EndFunc   ;==>_SQL_ErrFunc