#include "LoginObject.au3"
#include "MachineConfig.au3"

Func HotKeyPressed()
    Switch @HotKeyPressed ; The last hotkey pressed.
        Case "{F1}" ; String is the {PAUSE} hotkey.
            MsgBox(0,"Paused", "Paused")
        Case "{F8}" ; String is the {PAUSE} hotkey.
            MsgBox(0,"Paused", "Paused")
        Case "{F9}" ; String is the {ESC} hotkey.
            Exit
        Case "{F10}" ; String is the {ESC} hotkey.
            Exit

    EndSwitch
 EndFunc   ;==>HotKeyPressed

;5 = critical, 4 = error, 3 = warning, 2 = information, 1 = debug
Func LogMessage($message, $severity = 1)

   FileWriteLine( $LogFileName,$message)

   Local $loginID = Login_LoginID()
   If $loginID = 0 Then
	  $loginID = "NULL"
   EndIf

   If StringInStr ($message,"'") Then
	  $message = StringReplace($message,"'","")
   Endif

   _SqlConnect()
   _SQL_Execute(-1,"Insert Into Log ([MachineID],[Severity],[LoginID],[Message]) Values ('" & $MachineID & "'," & $severity & "," & $loginID & ",'" & $message & "')" )
   _SQL_Close()

EndFunc

Func SendMouseClick($x,$y)

   MouseMove($x,$y)
   Sleep(100)
   MouseDown("left")
   Sleep(100)
   MouseUp("left")
   ;$success = MouseClick("left",$x,$y)

EndFunc

Func quit()
   Exit
EndFunc

Func GetNowUTCCalc()
   return _Date_Time_SystemTimeToDateTimeStr(_Date_Time_GetSystemTime(),1)
EndFunc

Func CheckForColor($x,$y,$color1, $color2 = -1)
   ;Local $pixelFound = PixelSearch($x-2,$y-2,$x+2,$y+2,$color)
   Local $pixelColor = PixelGetColor($x,$y)

   If $pixelColor = $color1 Then
	  Return True
   EndIf

   If $pixelColor = $color2 Then
	  Return True
   EndIf
   ;Sleep here to clean up
   Sleep(250)
   Return False
EndFunc

Func PollForPixelSearch($left, $top,$right, $bottom,$color,$timeout)
   ;LogMessage("Polling At (" & $x & "," & $y & ") expecting " & $color)
   Local $colorAt = 0
   Local $pixelColor = 0
   Local $waited = 0

   ;LogMessage(" " & $left & " " & $top &" " & $right &" " & $bottom)
   While $waited < $timeout

	  PixelSearch($left,$top,$right,$bottom, $color)
	  If (@error = 1) Then
		 ;If $pixelColor <>  $color Then
		 ;LogMessage("Color is wrong. At (" & $x & "," & $y & ") expected " & $color & " --- Got " &  $pixelColor)
		 ;MouseMove($x,$y)
		 ;LogMessage("Pixel Search Not found")
		 Sleep(1000)
		 $waited = $waited + 1000
	  Else
		 LogMessage("Pixel Search found")
		 Sleep(250)
		 return True
	  EndIf
   WEnd

   return False

EndFunc

Func PollForColor($x,$y,$color,$timeout, $message = "?")
   If Polling($x,$y,$x,$y,$color,$color,$timeout, $message) Then
	  return True
   Else
	  return False
   EndIf
EndFunc


Func PollForColorTwoPlaces($x,$y,$x2,$y2,$color,$timeout, $message = "?")
   If Polling($x,$y,$x2,$y2,$color,$color,$timeout, $message) Then
	  return True
   Else
	  return False
   EndIf
EndFunc

Func PollForTwoColors($x,$y,$color1,$color2,$timeout, $message = "?")
   If Polling($x,$y,$x,$y,$color1,$color2,$timeout,$message) Then
	  return True
   Else
	  return False
   EndIf
EndFunc

Func PollForColors($x,$y,$colors,$timeout,$message = "?")
   If PollingArray($x,$y,$x,$y,$colors,$timeout,$message) Then
	  return True
   Else
	  return False
   EndIf
EndFunc

Func PollForNOTColor($x,$y,$color,$timeout)
   Local $colorAt = 0
   Local $pixelColor = 0
   Local $waited = 0

   While $waited < $timeout
	  $pixelColor = PixelGetColor($x,$y)
	  If $pixelColor = $color Then
		 Sleep(250)
		 $waited = $waited + 250
	  Else
		 ExitLoop
	  EndIf
   WEnd
   If $pixelColor <>  $color Then
	  Sleep(250)
	  return True
   Else
	  return False
   EndIf
EndFunc

Func PollingArray($x1,$y1,$x2,$y2,$colors,$timeout, $message)
   Local $pixelColor = 0
   Local $waited = 0

   While $waited < $timeout
	  $pixelColor = PixelGetColor($x1,$y1)
	  $pixelColor2 = PixelGetColor($x2,$y2)
	  If Not (_ArraySearch($colors,$pixelColor) > -1 or _ArraySearch($colors,$pixelColor2) > -1) Then

		 If $waited = 0 Then
			MouseMove($x1,$y1)
		 EndIf

		 Sleep(250)
		 $waited = $waited + 250
	  Else
		 ExitLoop
	  EndIf
   WEnd
   If (_ArraySearch($colors,$pixelColor) > -1 or _ArraySearch($colors,$pixelColor2) > -1) Then
	  Sleep(250)
	  return True
   Else
	  LogMessage("Polling for " & $message & " At (" & $x1 & "," & $y1 & " or " & $x2 & "," & $y2 & " - " & _ArrayToString($colors) & ") Failed, found color: " & $pixelColor & " and " & $pixelColor2)
	  return False
   EndIf
EndFunc

Func Polling($x1,$y1,$x2,$y2,$color1,$color2,$timeout, $message)
	If ($color1 = $color2) Then
		Local $colors1[1]
	   $colors1[0] = $color1
		Return PollingArray($x1,$y1,$x2,$y2,$colors1,$timeout, $message)
	Else
	   Local $colors[2]
	   $colors[0] = $color1
	   $colors[1] = $color2
	   Return PollingArray($x1,$y1,$x2,$y2,$colors,$timeout, $message)
	Endif
EndFunc

Func SendEmail($messageTo, $subject, $messageLine1, $messageLine2, $messageLine3)
   ;_INetMail ( $messageTo, $subject, $message)
   ;MsgBox($MB_SYSTEMMODAL, 'E-Mail has been opened', 'The E-Mail has been opened and process identifier for the E-Mail client is' & _INetMail ( $messageTo, $subject, $message))

   $SmtpServer = "smtp.gmail.com"
   $FromName = "GoW Minion"
   $FromAddress = "support@gowminion.com"
   $ToAddress = $messageTo
   $Subject = $subject
   $Body = $messageLine1 & @CRLF & $messageLine2 & @CRLF & $messageLine3
   $AttachFiles = ""
   $CcAddress = ""
   $BccAddress = ""
   $Importance="Normal"
   $Username = "gameofwarminion@gmail.com"                ; username for the account used from where the mail gets sent - REQUIRED
   $Password = "gowminion!2"                ; password for the account used from where the mail gets sent - REQUIRED
   $IPPort=465                     ; GMAIL port used for sending the mail
   $ssl=1
   Global $oMyRet[2]
   Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
   ;$Response = _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Importance="Normal", $Username, $Password, $IPPort, $ssl)
   $rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
   If @error Then
	   MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
   EndIf
EndFunc

Func SaveImage($imageName,$left,$top,$right,$bottom)

   Local $sFilePath = @ScriptDir & '\' & $imageName & '.jpg'
   ;Local $URL = "http://localhost:52417/api/Upload"
   ;Local $URL = "https://ets-tfs.cloudapp.net/api/Upload"

   _ScreenCapture_SetJPGQuality (25)


   _GDIPlus_Startup()
   Local $hHBmp = _ScreenCapture_Capture("", $left,$top,$right,$bottom)
   Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBmp) ;convert GDI bitmap to GDI+ bitmap
   _WinAPI_DeleteObject($hHBmp) ;release GDI bitmap resource because not needed anymore

   ;_GDIPlus_ImageRotateFlip($hBitmap, 1) ;rotate image by 90 degrees without flipping

   _GDIPlus_ImageSaveToFile($hBitmap,$sFilePath)

   ;_GDIPlus_BitmapDispose($hBitmap)
   _GDIPlus_ImageDispose($hBitmap)

   _GDIPlus_Shutdown()

   Local $sFile = FileOpen($sFilePath, 16)

   $sFileRead = BinaryToString(FileRead($sFile))
   FileClose($sFile)
#comments-start
   $sBoundary = "mymultipartboundary"

   $sPD = '--' & $sBoundary & @CRLF & _
		   'Content-Type: application/json; charset=UTF-8' & @CRLF & @CRLF & _
		   '{ "text": "9"}' & @CRLF & _
		   '--' & $sBoundary & @CRLF & _
		   'Content-Type: image/jpeg' & @CRLF & _
		   'Content-Disposition: form-data; name="file"; filename="' & $imageName & '_' & Login_CityID() & '.jpg"' & @CRLF & _
		   'Content-Transfer-Encoding: binary' & @CRLF & @CRLF & _
		   $sFileRead & @CRLF & '--' & $sBoundary & '--' & @CRLF

   $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
   $oHTTP.Open("POST", $URL, False)
   $oHTTP.SetRequestHeader("Content-Type", 'multipart/form-data; boundary="' & $sBoundary & '"')
   $oHTTP.SetRequestHeader("From", 'GowScript')
   $oHTTP.SetRequestHeader("CityID", Login_CityID())
   $oHTTP.Send(StringToBinary($sPD))
   $oReceived = $oHTTP.ResponseText
   $oStatusCode = $oHTTP.Status

   If $oReceived <> """Success""" Then
	  LogMessage("Image(ets) Saved - Name = " & $imageName,1)
	  LogMessage("Image(ets) Saved - Status = " & $oStatusCode,1)
	  LogMessage("Image(ets) Saved - Response = " & $oReceived,1)
   Else
   #comments-end

	  ;Save to the new server too
	  SaveImageMinion($imageName,$sFileRead,$left,$top,$right,$bottom)
   ;EndIf


EndFunc

Func SaveImageMinion($imageName,$sFileRead,$x1,$y1,$x2,$y2)

   Local $URL = "https://www.gowminion.com/api/Upload"

   $sBoundary = "mymultipartboundary"

   $sPD = '--' & $sBoundary & @CRLF & _
		   'Content-Type: application/json; charset=UTF-8' & @CRLF & @CRLF & _
		   '{ "text": "9"}' & @CRLF & _
		   '--' & $sBoundary & @CRLF & _
		   'Content-Type: image/jpeg' & @CRLF & _
		   'Content-Disposition: form-data; name="file"; filename="' & $imageName & '_' & Login_CityID() & '.jpg"' & @CRLF & _
		   'Content-Transfer-Encoding: binary' & @CRLF & @CRLF & _
		   $sFileRead & @CRLF & '--' & $sBoundary & '--' & @CRLF

   $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
   $oHTTP.Open("POST", $URL, False)
   $oHTTP.SetRequestHeader("Content-Type", 'multipart/form-data; boundary="' & $sBoundary & '"')
   $oHTTP.SetRequestHeader("From", 'GowScript')
   $oHTTP.SetRequestHeader("CityID", Login_CityID())
   $oHTTP.Send(StringToBinary($sPD))
   $oReceived = $oHTTP.ResponseText
   $oStatusCode = $oHTTP.Status

   If $oReceived <> """Success""" Then
	  LogMessage("Image Saved - Name = " & $imageName,1)
	  LogMessage("Image Saved - Status = " & $oStatusCode,1)
	  LogMessage("Image Saved - Response = " & $oReceived,1)
   EndIf

EndFunc
