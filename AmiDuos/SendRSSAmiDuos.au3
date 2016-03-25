#include <GUIConstantsEx.au3>
#include "GowConstantsAmiDuos.au3"
#include "GowActionsAmiDuos.au3"
#include <Date.au3>
#include <Array.au3>
#include "../MachineConfig.au3"
#include "../Email.au3"
Local $width = 250
Local $height = 130

Global $greyHelpCount = 0

Local $AlreadyLoggedIn = InputBox("Logged In", "Currently Open and Logged In (1/0):","1","",$width,$height)
Local $sendOffset = InputBox("Send Offset", "Send Offset:","1","",$width,$height)
Local $loginEmail = ""
Local $loginPWD = ""

If $AlreadyLoggedIn = 0 Then
   $loginEmail = InputBox("Username", "UserName:","","",$width,$height)
   $loginPWD =  InputBox("Password", "Password:","","",$width,$height)
EndIf

Local $stone =  0
Local $wood = 0
Local $ore =   0
Local $food =   0
Local $silver =   0
Local $MarchesAllowed = 6
Local $RoundTripTimeInMS =   35 * 1000
Local $RSSAmountPerSend = "5.9"

OpenSendWindow($stone,$wood,$ore,$food,$silver, $RoundTripTimeInMS, $MarchesAllowed, $RSSAmountPerSend)

Local $Tries = 1


Local $SendTimeInMS = 4500 ; it takes 3.5 seconds to send each march so we will remove that from the delay
Local $RSSRequests = [Number ($stone),Number ($wood),Number ($ore),Number ($food),Number ($silver)] ; stone, wood, ore, food,  silver (in millions)


;Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
HotKeySet("{F9}","HotKeyPressed")
HotKeySet("{F8}","HotKeyPressed")

WinActivate ("DuOS","")
Sleep(1000)
WinWaitActive ("DuOS","")
Sleep(1000)
   WinMove("DuOS","",$GOWVBHostWindow[0],$GOWVBHostWindow[1],$GOWWindowSize[0],$GOWWindowSize[1])
Sleep(1000)

If $AlreadyLoggedIn = 0 Then
   ;Open GOW
   OpenGOW(0)

   ;Login
   Login($loginEmail,$loginPWD)

   If Not CheckForCityScreen(0) Then
	  MsgBox(0,"Paused","Something went wrong....  Don't have a login")
   EndIf
Else
   MsgBox(0,"Paused","$AlreadyLoggedIn = " & $AlreadyLoggedIn)
   ;MouseClickDrag("left",650,600,905,290,20)
   ;Sleep(500)
EndIf

If $sendOffset < 1 or $sendOffset > 6 Then
   MsgBox(0,"Paused","Setting $sendOffset = 1 since it was < 1 or > 6")
   $sendOffset = 1
EndIf

;Login_RSSBank() = $sendOffset-1
;Login_SilverBank() = $sendOffset-1

;Click Market Place
SendMouseClick($MarketLocation[0],$MarketLocation[1])

MsgBox(0,"Paused","Scroll Market so desired City is the top of the list.")
WinActivate ("DuOS","")
Sleep(1000)
SendEmail("grayson@stuntz.org; than@stuntz.org; nyu@me.com", $MachineID & " just started", "Sending " &$stone &" stone. " &$wood& " wood." &$ore& " ore." &$food& " food." &$silver& " silver. Round Trip: " &$RoundTripTimeInMS& ". Marches: " &$MarchesAllowed&". March Size: " &$RSSAmountPerSend)
LogMEssage("Sending " &$stone &" stone. " &$wood& " wood." &$ore& " ore." &$food& " food." &$silver& " silver. Round Trip: " &$RoundTripTimeInMS& ". Marches: " &$MarchesAllowed&". March Size: " &$RSSAmountPerSend)

;Click the required text boxes and remove 3M from the amount each time
Local $Send = True
Local $marches = 0
Local $RSSSent = 0 ; food, wood, stone, ore, silver
Local $RssAmount = 0

For $RSSId = 0 to UBound($RSSRequests)-1
   $RssAmount = $RSSRequests[$RSSId]
   $RSSSent = 0
   
   While ($RssSent < $RssAmount)
   
	  If (SendRSS($RSSId,-1,$sendOffset)) Then
		 $marches = $marches + 1

		 If $marches >= $MarchesAllowed Then
			if ($RoundTripTimeInMS - ($marches * $SendTimeInMS)) > 0 Then
			   Sleep ($RoundTripTimeInMS - ($marches * $SendTimeInMS))
			EndIf
			$marches = 0
		 EndIf

		 $greyHelpCount = 0
		 $RssSent = $RssSent + $RSSAmountPerSend
	  else
		 If ($greyHelpCount >= 5) Then
			$greyHelpCount = 0
			;$RssSent = $RssSent + 50000000
			LogMessage("Done sending, in master send, RSSID - " & $RSSId)
			ExitLoop
		 EndIf
		 Sleep(2000)
	  endif

	  LogMessage("Total RSS(" & $RSSId & " - of " & $RssAmount & ")  Sent = " & $RssSent)
   WEnd

Next


;Logout
;Logout()
Sleep(2000)

;Paranoia to make sure we are closed out

;Check if the android home button is on the right or the bottom, bottom means we are out side means close out and then open and try logout
If CheckForColor( $AndroidHomeButton[0],$AndroidHomeButton[1], $Black) Then
   MsgBox(0,"Paused","Something went wrong....  Should be logged out but doesn't look like it")
EndIf

SendEmail("grayson@stuntz.org; than@stuntz.org; nyu@me.com", $MachineID & " finished", "Sent " &$stone &" stone. " &$wood& " wood." &$ore& " ore." &$food& " food." &$silver& " silver. Round Trip: " &$RoundTripTimeInMS& ". Marches: " &$MarchesAllowed&". March Size: " &$RSSAmountPerSend)

MsgBox(0,"Success","Finished")

;END IT ALL
Exit

Func SendEmail($messageTo, $subject, $messageLine1)
   ;_INetMail ( $messageTo, $subject, $message)
   ;MsgBox($MB_SYSTEMMODAL, 'E-Mail has been opened', 'The E-Mail has been opened and process identifier for the E-Mail client is' & _INetMail ( $messageTo, $subject, $message))

   $SmtpServer = "smtp.gmail.com"
   $FromName = "GoW Minion"
   $FromAddress = "support@gowminion.com"
   $ToAddress = $messageTo
   $Subject = $subject
   $Body = $messageLine1
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


Func OpenSendWindow(ByRef $stone,ByRef $wood,ByRef $ore,ByRef $food,ByRef $silver, ByRef $RoundTripTimeInMS, ByRef $MarchesAllowed, ByRef $RSSAmountPerSend)
   Local $taxRate = .08

   $MarchesAllowed = 6
   $RoundTripTimeInMS = 35 * 1000
   $RSSAmountPerSend = "5.9"

   $hGUI = GUICreate("Send Amounts", 450, 300) ; will create a dialog box that when displayed is centered
   Opt("GUICoordMode", 2)
   Local $iWidthCell = 100

   GUIStartGroup()
   GUICtrlCreateLabel("Send Type:", 10, 10, $iWidthCell)
   Local $idRadioNet = GUICtrlCreateRadio("Net", 0, -1)
   Local $idRadioGross = GUICtrlCreateRadio("Gross", 0, -1)
   GUICtrlSetState($idRadioGross, $GUI_CHECKED)

   GUICtrlCreateLabel("Tax Rate:", -3*$iWidthCell, 0, $iWidthCell)
   Local $taxRateUI = GUICtrlCreateInput("8", 0, -1)

   GUIStartGroup()
   GUICtrlCreateLabel("Send Per:", -2*$iWidthCell, 0, $iWidthCell)
   Local $idRadio59 = GUICtrlCreateRadio("5.932518", 0, -1)
   Local $idRadio56 = GUICtrlCreateRadio("5.626005", 0, -1)
   Local $idRadio79 = GUICtrlCreateRadio("7.965", 0, -1)

   Local $idRadio119 = GUICtrlCreateRadio("11.9", -3*$iWidthCell, 0)
   Local $idRadioCustom = GUICtrlCreateRadio("", 0, -1)
   Local $customSend = GUICtrlCreateInput("", 0, -1)
   GUICtrlSetState($idRadioCustom, $GUI_CHECKED)
   GUIStartGroup()

   GUICtrlCreateLabel("Marches:", -4*$iWidthCell,0)
   Local $marchesInput = GUICtrlCreateInput("5", 0, -1)

   GUICtrlCreateLabel("Round trip(Sec):", -2*$iWidthCell,0)
   Local $roundTripInput = GUICtrlCreateInput("30", 0, -1)

   GUICtrlCreateLabel("Stone:", -2*$iWidthCell,0)
   Local $stoneInput = GUICtrlCreateInput("0", 0, -1)

   GUICtrlCreateLabel("Wood:",-2*$iWidthCell, 0)
   Local $woodInput = GUICtrlCreateInput("0", 0, -1)

   GUICtrlCreateLabel("Ore:",  -2*$iWidthCell, 0)
   Local $oreInput = GUICtrlCreateInput("0", 0, -1)

   GUICtrlCreateLabel("Food:", -2*$iWidthCell, 0)
   Local $foodInput = GUICtrlCreateInput("0", 0, -1)

   GUICtrlCreateLabel("Silver:", -2*$iWidthCell,0)
   Local $silverInput = GUICtrlCreateInput("0", 0, -1)

   Local $idBtn = GUICtrlCreateButton("Ok", -2*$iWidthCell, 1)

   GUISetState(@SW_SHOW) ; will display an  dialog box

   Local $idMsg
   ; Loop until the user exits.
   While 1
	  $idMsg = GUIGetMsg()
	  Select
		 Case $idMsg = $GUI_EVENT_CLOSE
			 Exit
		  Case  $idMsg = $idBtn

			$stone =   GUICtrlRead($stoneInput)
			$wood =  GUICtrlRead($woodInput)
			$ore =   GUICtrlRead($oreInput)
			$food =   GUICtrlRead($foodInput)
			$silver =   GUICtrlRead($silverInput)

			$MarchesAllowed =  GUICtrlRead($marchesInput)
			$RoundTripTimeInMS =   GUICtrlRead($roundTripInput) * 1000
			$RSSAmountPerSend = GUICtrlRead($customSend)

			if (BitAND(GUICtrlRead($idRadio56), $GUI_CHECKED) = $GUI_CHECKED) Then
			   $RSSAmountPerSend = "5.626005"
			ElseIf (BitAND(GUICtrlRead($idRadio59), $GUI_CHECKED) = $GUI_CHECKED) Then
			   $RSSAmountPerSend = "5.932518"
			ElseIf (BitAND(GUICtrlRead($idRadio79), $GUI_CHECKED) = $GUI_CHECKED) Then
			   $RSSAmountPerSend = "7.965"
			ElseIf (BitAND(GUICtrlRead($idRadio119), $GUI_CHECKED) = $GUI_CHECKED) Then
			   $RSSAmountPerSend = "11.9"
			EndIf

			If (BitAND(GUICtrlRead($idRadioGross), $GUI_CHECKED) = $GUI_CHECKED) Then
			   $taxRate = GUICtrlRead($taxRateUI)
			   $stone = Round ($stone*(1-($taxRate/100)),1)
			   $wood = Round ($wood*(1-($taxRate/100)),1)
			   $ore = Round ($ore*(1-($taxRate/100)),1)
			   $food = Round ($food*(1-($taxRate/100)),1)
			   $silver = Round ($silver*(1-($taxRate/100)),1)
			EndIf

			ExitLoop
	  EndSelect
   WEnd

   ; Delete the previous GUI and all controls.
   GUIDelete($hGUI)

EndFunc

#comments-start one


	  ;Poll for first Help button
	  If PollForColor($HelpTopMember[0],$HelpTopMember[1], $Blue, 20000) Then
		 SendMouseClick($HelpTopMember[0],$HelpTopMember[1])
		 Sleep(2000)
	  Else
		 ;If we still have the rss ok button we hit out march limit
		 If PollForColor($RSSHelpButton[0],$RSSHelpButton[1], $Blue, 10000) Then
			SendMouseClick($RSSHelpButton[0],$RSSHelpButton[1])
			Sleep(500)

			If PollForColor($RSSOKButton[0],$RSSOKButton[1], $Blue, 10000) Then
			   SendMouseClick($RSSOKButton[0],$RSSOKButton[1])
			   Sleep(500)
			EndIf

			;Poll for first Help button
			If PollForColor($HelpTopMember[0],$HelpTopMember[1], $Blue, 10000) Then
			   SendMouseClick($HelpTopMember[0],$HelpTopMember[1])
			   Sleep(2000)
			EndIf
		 Else

			If PollForColor($RSSOKButton[0],$RSSOKButton[1], $Blue, 10000) Then
			   SendMouseClick($RSSOKButton[0],$RSSOKButton[1])
			   Sleep(500)

			;Poll for first Help button
			   If PollForColor($HelpTopMember[0],$HelpTopMember[1], $Blue, 10000) Then
				  SendMouseClick($HelpTopMember[0],$HelpTopMember[1])
				  Sleep(2000)
			   EndIf
			Else

			   MsgBox(0,"Paused","Something went wrong....  Should be on the SendRSS screen")
			EndIf

		 EndIf
	  Endif

	  ;Click the rss position
	  SendMouseClick($HelpRSSMax[$RSSId][0],$HelpRSSMax[$RSSId][1])
	  Sleep(1000)

	  ;click the done button
	  MouseMove($DoneAmountEntryButton[0],$DoneAmountEntryButton[1])

	  SendMouseClick($DoneAmountEntryButton[0],$DoneAmountEntryButton[1])
	  Sleep(2000)

	  ;Click the Help button
	  If PollForColor($RSSHelpButton[0],$RSSHelpButton[1], $Blue, 20000) Then
		 SendMouseClick($RSSHelpButton[0],$RSSHelpButton[1])
		 Sleep(500)
	  Else

		 ;Try the previous step
		 If PollForColor($DoneAmountEntryButton[0],$DoneAmountEntryButton[1], $Blue, 2000) Then
			SendMouseClick($DoneAmountEntryButton[0],$DoneAmountEntryButton[1])
			Sleep(500)

			If PollForColor($RSSHelpButton[0],$RSSHelpButton[1], $Blue, 20000) Then
			   SendMouseClick($RSSHelpButton[0],$RSSHelpButton[1])
			   Sleep(500)
			EndIf
		 Else
			MsgBox(0,"Paused","Something went wrong....  RSS Help Button")
		 EndIf
	  EndIf

	  ;Click the Ok Button
	  If PollForColor($RSSOKButton[0],$RSSOKButton[1], $Blue, 20000) Then
		 SendMouseClick($RSSOKButton[0],$RSSOKButton[1])
		 Sleep(500)
	  Else

		 If PollForColor($RSSHelpButton[0],$RSSHelpButton[1], $Blue, 2000) Then
			SendMouseClick($RSSHelpButton[0],$RSSHelpButton[1])
			Sleep(500)

			If PollForColor($RSSOKButton[0],$RSSOKButton[1], $Blue, 20000) Then
			   SendMouseClick($RSSOKButton[0],$RSSOKButton[1])
			   Sleep(500)
			EndIf
		 Else
			MsgBox(0,"Paused","Something went wrong....  RSS OK Button")
		 EndIf

	  EndIf
#comments-end

