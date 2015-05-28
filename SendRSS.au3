#include "GowConstants.au3"
#include "GowActions.au3"
#include <Date.au3>
#include <Array.au3>

Global $loginEmail = "gowgunta.r@gmail.com" ;"tanielamelia@gmail.com"
Global $loginPWD = "gowguntar";"danmelia"

Global $MarchesAllowed = 5
Local $RSSAmountPerSend = 3 ;this is in millions since the send string is millions and the requested is in millions
Local $RSSAmountPerSendString = "7000000"
Local $Tries = 1

Global $SendToX = "482";"482"
Global $SendToY = "30";"30"
Global $RoundTripTimeInMS = 55000
Global $SendTimeInMS = 3500 ; it takes 3.5 seconds to send each march so we will remove that from the delay
Local $RSSRequests = [0,0,0,0,200] ; stone, wood, ore, food,  silver (in millions)

Global $ResourceButton = [776,424]
;Local $RSSBoxes[][] = [[559,245],[623,245],[687,245],[751,245],[815,245]] ; Stone - Wood - Ore - Food - Silver  64 px offset



;Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
HotKeySet("{F9}","HotKeyPressed")
HotKeySet("{F8}","HotKeyPressed")

WinActivate ("GOw2 [Running] - Oracle VM VirtualBox","")
Sleep(1000)
WinWaitActive ("GOw2 [Running] - Oracle VM VirtualBox","")

;Dependant on window at 401x77
WinMove("GOw2 [Running] - Oracle VM VirtualBox","",$GOWVBHostWindow[0],$GOWVBHostWindow[1])

;Open GOW
OpenGOW(0)

;Login
Login($loginEmail,$loginPWD)

If Not CheckForCityScreen(0) Then
   MsgBox(0,"Paused","Something went wrong....  Don't have a login")
EndIf

MouseClickDrag("left",650,600,905,290,20)
Sleep(500)

;Click Market Place
SendMouseClick($MarketLocation[0],$MarketLocation[1])


MsgBox(0,"Paused","Scroll Market so desired City is the top of the list.")
WinActivate ("GOw2 [Running] - Oracle VM VirtualBox","")
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

	  If (SendRSS($RSSId)) Then
		 $marches = $marches + 1

		 If $marches >= $MarchesAllowed Then
			if ($RoundTripTimeInMS - ($marches * $SendTimeInMS)) > 0 Then
			   Sleep ($RoundTripTimeInMS - ($marches * $SendTimeInMS *2)) ; times two for the in and out
			EndIf
			$marches = 0
		 EndIf

		 $RssSent = $RssSent + $RSSAmountPerSend
	  else
		 Sleep(2000)
	  endif
   WEnd
Next


;Logout
Logout()
Sleep(5000)

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

