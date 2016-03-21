
#include "GowConstantsAmiDuos.au3"
#include "GowActionsAmiDuos.au3"
#include <Date.au3>
#include <Array.au3>
#include "../MachineConfig.au3"
Local $width = 250
Local $height = 130

Local $AlreadyLoggedIn = InputBox("Logged In", "Currently Open and Logged In (1/0):","1","",$width,$height)
Local $sendOffset = InputBox("Send Offset", "Send Offset:","1","",$width,$height)
Local $loginEmail = ""
Local $loginPWD = ""

If $AlreadyLoggedIn = 0 Then
   $loginEmail = InputBox("Username", "UserName:","","",$width,$height)
   $loginPWD =  InputBox("Password", "Password:","","",$width,$height)
EndIf

Local $stone =  InputBox("Stone", "Stone:","0","",$width,$height)
Local $wood =  InputBox("Wood", "Wood:","0","",$width,$height)
Local $ore =  InputBox("Ore", "Ore:","0","",$width,$height)
Local $food =  InputBox("Food", "Food:","0","",$width,$height)
Local $silver =  InputBox("Silver", "Silver:","0","",$width,$height)
Local $RoundTripTimeInMS =  InputBox("Round Trip Time", "Round Trip Time(ms):","37000","",$width,$height)

Local $MarchesAllowed = InputBox("Marches", "Marches:","8","",$width,$height)
Local $RSSAmountPerSend = InputBox("Amount Sent", "Amount Sent(m):","11.8","",$width,$height) ;this is in millions since the send string is millions and the requested is in millions
Local $Tries = 1


Local $SendTimeInMS = 3500 ; it takes 3.5 seconds to send each march so we will remove that from the delay
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

;Click the required text boxes and remove 3M from the amount each time
Local $Send = True
Local $marches = 0
Local $RSSSent = 0 ; food, wood, stone, ore, silver
Local $RssAmount

For $RSSId = 0 to UBound($RSSRequests)-1
   $RssAmount = $RSSRequests[$RSSId]
   $RSSSent = 0

   While $RssSent < $RssAmount

	  If (SendRSS($RSSId,-1,$sendOffset)) Then
		 $marches = $marches + 1

		 If $marches >= $MarchesAllowed Then
			if ($RoundTripTimeInMS - ($marches * $SendTimeInMS)) > 0 Then
			   Sleep ($RoundTripTimeInMS - ($marches * $SendTimeInMS * 2)) ; times two for the in and out
			EndIf
			$marches = 0
		 EndIf

		 $RssSent = $RssSent + $RSSAmountPerSend
	  else
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

