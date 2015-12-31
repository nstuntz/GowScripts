
#include "../GowConstantsBluestacks.au3"
#include "../GowActionsBluestacks.au3"
#include <Date.au3>
#include <Array.au3>
Local $width = 250
Local $height = 130

Local $AlreadyLoggedIn = InputBox("Logged In", "Currently Open and Logged In (1/0):","0","",$width,$height)
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

Local $MarchesAllowed = InputBox("Marches", "Marches:","6","",$width,$height)
Local $RSSAmountPerSend = InputBox("Amount Sent", "Amount Sent(m):","7.9","",$width,$height) ;this is in millions since the send string is millions and the requested is in millions
Local $Tries = 1


Local $SendTimeInMS = 3500 ; it takes 3.5 seconds to send each march so we will remove that from the delay
Local $RSSRequests = [Number ($stone),Number ($wood),Number ($ore),Number ($food),Number ($silver)] ; stone, wood, ore, food,  silver (in millions)


;Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
HotKeySet("{F9}","HotKeyPressed")
HotKeySet("{F8}","HotKeyPressed")

WinActivate ("BlueStacks","")
Sleep(1000)
WinWaitActive ("BlueStacks","")
Sleep(1000)
   WinMove("BlueStacks","",$GOWVBHostWindow[0],$GOWVBHostWindow[1],$GOWWindowSize[0],$GOWWindowSize[1])
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

Login_RSSBank() = $sendOffset-1
Login_SilverBank() = $sendOffset-1

;Click Market Place
SendMouseClick($MarketLocation[0],$MarketLocation[1])

MsgBox(0,"Paused","Scroll Market so desired City is the top of the list.")
WinActivate ("BlueStacks","")
Sleep(1000)

;Click the required text boxes and remove 3M from the amount each time
Local $Send = True
Local $marches = 0
Local $RSSSent = 0 ; food, wood, stone, ore, silver
Local $RssAmount

For $RSSId = 0 to UBound($RSSRequests)-1
   $RssAmount = $RSSRequests[$RSSId]
   $RSSSent = 0

   While $RssSent < $RssAmount

	  If (SendRSS($RSSId,-1)) Then
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


MsgBox(0,"Success","Finished")

;END IT ALL
Exit

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

