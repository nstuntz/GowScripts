#include-once
#include "MSConstantsBluestacks.au3"
#include "MSLocalConstantsBluestacks.au3"
#include "../MachineConfig.au3"
#include "../LoginObject.au3"
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <File.au3>
#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#include <Inet.au3>
#include "MSFilePIN.au3"

Global $MSisLoggedOut = 0
Global $MSisSessionTimeout = False

Func LoginMS($MSemail, $MSpwd)

   If(Login_LoginAttempts() >= 5) Then
	  LogMessage("We have attempted to login 5 times and failed. Setting " & Login_CityName() & " to inactive.",5)
	  Login_UpdateLoginActive(0);
	  return false;
   EndIf

   If Not PollForColor( $MSUserNameTextBox[0],$MSUserNameTextBox[1], $MSUserNameTextBoxColor,1000, "$MSUserNameTextBoxColor at $MSUserNameTextBox") Then
	  LogMessage("No UsernameText box Checking if we are already logged in.")


	  ;Checking for PinPrompt


	  ;Check if you are already logged in Use the last attempt, don't do it lots
	  If CheckForCityScreenMS(4) Then
		 LogMessage("Ok, we are already logged in so just keep going")
		 Sleep(4000)
		 ClickGoldButtonMS()
		 If Not CheckForCityScreenMS(0) Then
			LogMessage("NO city screen after login, in login function")
			return False
		 EndIf

		 return True
	  Else
		 LogMessage("No UsernameText box and not logged in so login failed.")
		 Return False
	  EndIf
   EndIf

   ;UserName
   SendMouseClick($MSUserNameTextBox[0],$MSUserNameTextBox[1])
   Sleep(1000)
   SendMouseClick($MSUserNameTextBox[0],$MSUserNameTextBox[1])
   sleep(1000)

   Local $MSemailArray = StringToASCIIArray($MSemail)
   For $MSi = 0 to UBound($MSemailArray)-1
	  if(Chr($MSemailArray[$MSi]) = "!") Then
		 Send("{!}")
	  ElseIf (Chr($MSemailArray[$MSi]) = "+") Then
		 Send("{+}")
	  ElseIf (Chr($MSemailArray[$MSi]) = "#") Then
		 Send("{#}")
	  ElseIf (Chr($MSemailArray[$MSi]) = "^") Then
		 Send("{^}")
	  ElseIf (Chr($MSemailArray[$MSi]) = "{") Then
		 Send("{{}")
	  ElseIf (Chr($MSemailArray[$MSi]) = "}") Then
		 Send("{}}")
	  Else
		 Send(Chr($MSemailArray[$MSi]))
	  EndIf
	  Sleep(100)
   Next

   Sleep(2000)

   ;Password
   SendMouseClick($MSPasswordTextBox[0],$MSPasswordTextBox[1])
   Sleep(2000)

   Local $MSpwdArray = StringToASCIIArray($MSpwd)
	  For $MSi = 0 to UBound($MSpwdArray)-1
		 if(Chr($MSpwdArray[$MSi]) = "!") Then
			Send("{!}")
		 ElseIf (Chr($MSpwdArray[$MSi]) = "+") Then
			Send("{+}")
		 ElseIf (Chr($MSpwdArray[$MSi]) = "#") Then
			Send("{#}")
		 ElseIf (Chr($MSpwdArray[$MSi]) = "^") Then
			Send("{^}")
		 ElseIf (Chr($MSpwdArray[$MSi]) = "{") Then
			Send("{{}")
		 ElseIf (Chr($MSpwdArray[$MSi]) = "}") Then
			Send("{}}")
		 Else
			Send(Chr($MSpwdArray[$MSi]))
		 EndIf
		 Sleep(100)
	  Next
   ;Send($MSpwd)

   ;Check that the login button is there
   If Not PollForColor($MSLoginButton[0],$MSLoginButton[1],$MSLoginButtonReadyColor,3000, "$MSLoginButtonReadyColor at $MSLoginButton") Then
	  LogMessage("Login Failed.  Login button isn't the right color",5 )
	  LogMessage("Increasing Login Attempts to " & Login_LoginAttempts()+1,5 )
	  Login_UpdateLoginAttempts(Login_LoginAttempts() +1)
	  Return False
   EndIf

   ;Login Button
   SendMouseClick($MSLoginButton[0],$MSLoginButton[1])


   ;Now check for a Pin
   If Not CheckForPinPromptMS(StringToASCIIArray(Login_PINMS())) Then
	  LogMessage("Increasing Login Attempts to " & Login_LoginAttempts()+1,5 )
	  Login_UpdateLoginAttempts(Login_LoginAttempts() +1)
	  Return False
   EndIf

   ;Check if there was a login failure
   If PollForColor($MSLoginFailureButton[0],$MSLoginFailureButton[1],$MSLoginButtonFailueColor,3000, "$MSLoginButtonFailueColor at $MSLoginFailureButton") Then
	  LogMessage("Login Failed.  Bad Username/Pwd.",5 )
	  LogMessage("Increasing Login Attempts to " & Login_LoginAttempts()+1,5 )
	  Login_UpdateLoginAttempts(Login_LoginAttempts() +1)
	  Return False
   EndIf

   ;Check if the city is locked to a device
   If PollForColor($MSDeviceLockedLogoutButton[0],$MSDeviceLockedLogoutButton[1],$MSDeviceLockedLogoutButtonColor,3000, "$MSDeviceLockedLogoutButtonColor at $MSDeviceLockedLogoutButton") Then
	  LogMessage("Login Failed. City is locked to a device. Making city inactive.",5 )
	  Login_UpdateLoginActive(0);
	  SendMouseClick($MSDeviceLockedLogoutButton[0],$MSDeviceLockedLogoutButton[1])
	  ;;LogMessage("Increasing Login Attempts to " & Login_LoginAttempts()+1,5 )
	  ;;Login_UpdateLoginAttempts(Login_LoginAttempts() +1)
	  Return False
   EndIf

   ;Now exit the gold buy button
   Local $MSClickedGoldScreen = False
   $MSClickedGoldScreen = ClickGoldButtonMS()
   ;Not sleeping here because of the next two polls
   Sleep(1000) ;3 seconds because of the quest poping up

;;;;Bluestack connection code interupt. Poll for a few seconds then move on
   If PollForColor($MSConnectionInteruptButton[0],$MSConnectionInteruptButton[1],$MSBlue,1500, "$MSBlue at $MSConnectionInteruptButton") Then
	  SendMouseClick($MSConnectionInteruptButton[0],$MSConnectionInteruptButton[1])
	  Sleep(500)
   EndIf

#comments-start
;Removing this since it isn't needed any more
;;;;;Make sure we have accepted the terms and conditions. Poll for 2 seconds
   If PollForColor($MSTermsAndConditionsButton[0],$MSTermsAndConditionsButton[1],$MSBlue,1500, "$MSBlue at $MSTermsAndConditionsButton") Then
	  SendMouseClick($MSTermsAndConditionsButton[0],$MSTermsAndConditionsButton[1])
	  ;;;If we have the T&C button we then poll for gold screen for 5 seconds to esc out of that
	  If (PollForPixelSearch($MSGoldSearchLeft,$MSGoldSearchTop,$MSGoldSearchRight,$MSGoldSearchBottom, $MSBuyGoldColor, 5000)) Then
		 Send("{ESC}")
		 $MSClickedGoldScreen = True
	  EndIf
	  Sleep(500)
   EndIf
#comments-end

   ;Assume if there was a gold screen then we logged in ok and set the city/map colors
   If $MSClickedGoldScreen Then
	  If Not CheckForColor($MSCityMenu[0],$MSCityMenu[1],$MSMapMenuColor) Then
		 LogMessage("******************* Resetting City and Map Colors ***********************",5 )
		 LogMessage("Old City Color = " & $MSMapMenuColor,5  )
		 LogMessage("Old Map Color = " & $MSCityScreenColor,5  )
		 $MSMapMenuColor  = PixelGetColor($MSCityMenu[0],$MSCityMenu[1])
		 LogMessage("New City Color = " & $MSMapMenuColor,5  )
		 SendMouseClick($MSCityMenu[0],$MSCityMenu[1])
		 Sleep(1000)
		 $MSCityScreenColor = PixelGetColor($MSCityMenu[0],$MSCityMenu[1])
		 LogMessage("New Map Color = " & $MSCityScreenColor ,5 )
		 SendMouseClick($MSCityMenu[0],$MSCityMenu[1])
		 Sleep(1000)
	  EndIf
   EndIf

   ;If we didn't get the fity screen bailout
   If Not CheckForCityScreenMS(0) Then
	  LogMessage("NO city screen after login, in login function",5 )
	  LogMessage("Increasing Login Attempts to " & Login_LoginAttempts()+1,5 )
	  Login_UpdateLoginAttempts(Login_LoginAttempts() +1)
	  return False
   EndIf

   LogMessage("Resetting Login Attempts to 0",1 )
   Login_UpdateLoginAttempts(0)
   return True
EndFunc

Func CollectAthenaGiftMS($MScount = 0)

   ;Only collect 4 times
   If $MScount > 4 Then
	  Return
   EndIf

   ;We doing it this way incase of a bouncer, specifically checking twice
   If CheckForColor( $MSAthenaGift[0],$MSAthenaGift[1], $MSNoAthenaGiftColor) Then
	  Return
   EndIf
   Sleep(250)
   If CheckForColor( $MSAthenaGift[0],$MSAthenaGift[1], $MSNoAthenaGiftColor) Then
	  Return
   EndIf

   ;Check if this is bouncing
   Local $MSfirstColor = PixelGetColor($MSAthenaGift[0],$MSAthenaGift[1])

   If Not PollForNOTColor($MSAthenaGift[0],$MSAthenaGift[1],$MSfirstColor,2000) Then
	  LogMessage("We have an Athena Gift but it is not ready to collect",1)
	  Return
   EndIf

   LogMessage("Collecting Athena Gift",2)

   ;Collect the bouncer
   SendMouseClick($MSAthenaGift[0],$MSAthenaGift[1])
   ;Just a pause to speed it up
   PollForColor($MSAthenaGiftCollectButton[0],$MSAthenaGiftCollectButton[1],$MSSecretGiftCollectButtonColor,4000,"$MSSecretGiftCollectButtonColor at $MSSecretGiftCollectButton")
   SendMouseClick($MSAthenaGiftCollectButton[0],$MSAthenaGiftCollectButton[1])
   Sleep(3500) ; longer sleep because it pops stuff up

   CollectAthenaGiftMS($MScount+1)
   Login_AthenaGiftCollected()

EndFunc

Func CollectSecretGiftMS()
   ;Collect the bouncer
   SendMouseClick($MSSecretGift[0],$MSSecretGift[1])
   ;Just a pause to speed it up
   If PollForColor($MSSecretGiftCollectButton[0],$MSSecretGiftCollectButton[1],$MSSecretGiftCollectButtonColor,4000,"$MSSecretGiftCollectButtonColor at $MSSecretGiftCollectButton") Then
	  SendMouseClick($MSSecretGiftCollectButton[0],$MSSecretGiftCollectButton[1])
   Else
	  SendMouseClick($MSNoSecretGiftCollectButton[0],$MSNoSecretGiftCollectButton[1])
   EndIf
   Sleep(3500) ;Longer sleep because it pops up stuff

EndFunc

Func CollectQuestsMS()

   ;Collect the Daily Quest
   SendMouseClick($MSQuestsMenu[0],$MSQuestsMenu[1])
   Sleep(2000)

   SendMouseClick($MSQuestsDaily[0],$MSQuestsDaily[1])
   Sleep(2000)

   If Not CheckForColor($MSQuestsCollect[0],$MSQuestsCollect[1],$MSNoQuestsColor) Then
	  SendMouseClick($MSQuestsCollect[0],$MSQuestsCollect[1])
	  Sleep(2000)
	  SendMouseClick($MSQuestsStart[0],$MSQuestsStart[1])
	  Sleep(2000)
   Endif

   ;Added to loop on clicking Collect as long as the button is blue. Daily Quests
   While 1=1
		 If (PollForColor($MSQuestsCollect[0],$MSQuestsCollect[1],$MSQuestsCollectColor, 3000, "$MSQuestsCollectColor at $MSQuestsCollect")) Then
			SendMouseClick($MSQuestsCollect[0],$MSQuestsCollect[1])
		 Else
			ExitLoop;
		 EndIf

   WEnd

   ;Collect the Alliance Quest
   SendMouseClick($MSQuestsMenu[0],$MSQuestsMenu[1])
   Sleep(2000)
   SendMouseClick($MSQuestsAliaance[0],$MSQuestsAliaance[1])
   Sleep(2000)

   If Not CheckForColor($MSQuestsCollect[0],$MSQuestsCollect[1],$MSNoQuestsColor) Then
	  SendMouseClick($MSQuestsCollect[0],$MSQuestsCollect[1])
	  Sleep(2000)
	  SendMouseClick($MSQuestsStart[0],$MSQuestsStart[1])
	  Sleep(2000)
   Endif

   ;Added to loop on clicking Collect as long as the button is blue. Alliance Quests
   While 1=1
		 If (PollForColor($MSQuestsCollect[0],$MSQuestsCollect[1],$MSQuestsCollectColor, 3000)) Then
			SendMouseClick($MSQuestsCollect[0],$MSQuestsCollect[1])
		 Else
			ExitLoop;
		 EndIf

   WEnd

   ;Return to City Screen
   ClickCityScreenMS()
EndFunc

Func HelpsMS()
   If PollForColors($MSHelpButton[0], $MSHelpButton[1],$MSHelpButtonColorArray, 1000, "$MSHelpButtonColor at $MSHelpButton") Then
	  SendMouseClick($MSHelpButton[0], $MSHelpButton[1])
	  If(PollForColor($MSAllianceHelpHelpAllButton[0],$MSAllianceHelpHelpAllButton[1],$MSAllianceHelpHelpAllButtonColor,3000,"$MSAllianceHelpHelpAllButtonColor")) Then
		 SendMouseClick($MSAllianceHelpHelpAllButton[0],$MSAllianceHelpHelpAllButton[1])
		 Sleep(500)
	  EndIf
	  ;City Menu
	  ClickCityScreenMS()
   EndIf
EndFunc

Func GiftsMS()

   ;click into the alliance menu then check for gifts
   SendMouseClick($MSAllianceMenu[0], $MSAllianceMenu[1])
   Sleep(3000)

   If PollForColors($MSGiftBox[0], $MSGiftBox[1],$MSGiftBoxColorArray, 500, "$MSGiftBoxColor at $MSGiftBox") Then
   ;OLD - If PollForTwoColors($MSGiftBox[0], $MSGiftBox[1],$MSGiftBoxColor, $MSGiftBoxColorAlt, 500, "$MSGiftBoxColor at $MSGiftBox") Then
	  ;Alliance menu


	  ;Get Gifts button
	  SendMouseClick($MSGiftButton[0],$MSGiftButton[1])
	  Sleep(2000)

	  Local $MSHaveGift = True
	  Local $MSGiftCount = 1
	  While $MSHaveGift

		 ;If we can get or clear a gift, do it and keep looping
		 If PollForTwoColors($MSGiftGetClearButton[0], $MSGiftGetClearButton[1], $MSGiftGetClearButtonBlue, $MSGiftGetClearButtonRed, 3000, "$MSGiftGetClearButtonBlue or $MSGiftGetClearButtonRed at $MSGiftGetClearButton") Then
			SendMouseClick($MSGiftGetClearButton[0],$MSGiftGetClearButton[1])
		 ;If CheckForColor($MSGiftGetClearButton[0], $MSGiftGetClearButton[1],$MSGiftGetClearButtonBlue)  Or CheckForColor($MSGiftGetClearButton[0], $MSGiftGetClearButton[1],$MSGiftGetClearButtonRed) Then
			;SendMouseClick($MSGiftGetClearButton[0],$MSGiftGetClearButton[1])
			;Sleep(2000)
			$MSGiftCount= $MSGiftCount+1
			if $MSGiftCount > 200 Then
			   LogMessage("Hit gift count limit.")
			   ExitLoop
			EndIf
		 Else
			$MSHaveGift = False
		 EndIf
	  WEnd


   EndIf

   ;since we always goi into the alliance menu, always go back out
   ;City Menu
   ClickCityScreenMS()
EndFunc

;This needs to be before Upgrades
Func BankMS()

   If Login_Bank() = 0 Then
	  LogMessage("City Set to not bank")
	  Return
   EndIf

   ;Don't bother banking less than 12 not enough rss to bother
   ;If Login_StrongHoldLevel() < 12 Then
;	  Return
 ;  EndIf

   LogMessage("Banking ",2)


   ;MouseClickDrag("left",120,160,575,320,20)
   ;Click Market Place
   SendMouseClick($MSMarketLocation[0],$MSMarketLocation[1])

   For $MSi = 1 to Login_RssMarches() ; Send rss marches
		 SendRSSMS(Login_RSSType()-1,Login_RSSType()-1)
   Next

   For $MSi = 1 to Login_SilveMarches() ; Send silver marches
	  SendRSSMS($MSeSilver, Login_RSSType()-1)
   Next

   Login_UpdateLastBank()

   ;City Menu
   ClickCityScreenMS()
EndFunc

;Assumes you are in the market place ready to send, and gets back to that point
Func SendRSSMS($MStype, $MSnonSilverType)

	  Local $MShelpOffsetX = (Login_RSSBank() - 1) * $MSHelpNumberOffsetX

	  If ($MStype = $MSeSilver) Then
		 $MShelpOffsetX = (Login_SilverBank() - 1) * $MSHelpNumberOffsetX
	  EndIf

	  ;Poll for first Help button
	  If PollForColor($MSHelpTopMember[0],$MSHelpTopMember[1], $MSHelpTopMemberColor, 5000, "$MSHelpTopMemberColor at $MSHelpTopMember(1)") Then
		 SendMouseClick($MSHelpTopMember[0] ,$MSHelpTopMember[1] + $MShelpOffsetX)
	  ElseIf PollForColor($MSRSSHelpButton[0],$MSRSSHelpButton[1], $MSRSSHelpButtonColor, 4000, "$MSRSSHelpButtonColor at $MSRSSHelpButton - If need be") Then
		 MouseMove($MSRSSHelpButton[0],$MSRSSHelpButton[1])
		 SendMouseClick($MSRSSHelpButton[0],$MSRSSHelpButton[1])
		 return True
	  Else
		 LogMessage("Banking - No help button")
		 ;City Menu
		 return false
	  Endif

	  ;Max the food if we can by filling silver marches with it
	  Local $MScolorClick = 197379
	  If PollForTwoColors($MSHelpRSSMax[$MStype][0],$MSHelpRSSMax[$MStype][1], $MScolorClick, $MSBlack, 2000, "$MScolorClick or $MSBlack at $MSHelpRSSMax") Then
		 ;do nothing this is just to wait to see if we can send faster
	  EndIf

	  ;Removed the restriction to only add other rss on food.
	  If ($MStype = $MSeSilver And $MSnonSilverType >0) Then
		 LogMessage("Banking - Maxing silver march with rss",2)
		 ;SendMouseClick($MSHelpRSSMax[$MSeFood][0],$MSHelpRSSMax[$MSeFood][1])
		 SendMouseClick($MSHelpRSSMax[$MSnonSilverType][0],$MSHelpRSSMax[$MSnonSilverType][1])
		 Sleep(500)
	  EndIf

	  If ($MStype = $MSeSilver) Then
		 ;Scroll for silver
		 MouseClickDrag("left",390,300,390,140)
	  EndIf
	  SendMouseClick($MSHelpRSSMax[$MStype][0],$MSHelpRSSMax[$MStype][1])
	  ;move the mouse then check and click
	  MouseMove($MSRSSHelpButton[0],$MSRSSHelpButton[1])
	  If PollForColor($MSRSSHelpButton[0],$MSRSSHelpButton[1], $MSRSSHelpButtonColor, 4000, "$MSRSSHelpButtonColor at $MSRSSHelpButton") Then
		 SendMouseClick($MSRSSHelpButton[0],$MSRSSHelpButton[1])
	  Endif

	  ;Handle Donation confirmation. This assumes it cannot be turned off in the settings.
	  If PollForColor($MSRSSOKButton[0],$MSRSSOKButton[1], $MSRSSOKButtonColor, 3000, "$MSRSSOKButtonColor at $MSRSSOKButton") Then
		 SendMouseClick($MSRSSOKButton[0],$MSRSSOKButton[1])
	  Else
		 ;Should check if the help button didn't really get clicked
		 If PollForColor($MSRSSHelpButton[0],$MSRSSHelpButton[1], $MSRSSHelpButtonColor, 3000) Then
			SendMouseClick($MSRSSHelpButton[0],$MSRSSHelpButton[1])
			Sleep(1000)
			If PollForColor($MSRSSOKButton[0],$MSRSSOKButton[1], $MSRSSOKButtonColor, 3000, "$MSRSSOKButtonColor at $MSRSSOKButton") Then
			   SendMouseClick($MSRSSOKButton[0],$MSRSSOKButton[1])
			EndIf
		 EndIf

	  Endif
	  ;Endif

	  ;Check for max send
	  If CheckForColor($MSMaxMarchesExceeded[0],$MSMaxMarchesExceeded[1],$MSMaxMarchesExceededColor) Then
		 SendMouseClick($MSMaxMarchesExceeded[0],$MSMaxMarchesExceeded[1])
		 return false
	  Endif

	  ;Check for Rally screen - Could do this using the check sum for Alliance War at the top of the screen
	  ;If neither the done button is there or the top help is there check for rally screen
	  ;If Not (CheckForColor($MSHelpTopMember[0],$MSHelpTopMember[1],$MSBlue) OR CheckForColor($MSRSSHelpButton[0],$MSRSSHelpButton[1],$MSBlue)) Then
	  ;IF (PollForColorTwoPlaces($MSHelpTopMember[0],$MSHelpTopMember[1],$MSRSSHelpButton[0],$MSRSSHelpButton[1],$MSBlue, 4000, "Polling for $MSBlue in both helps places")) Then
	;	 return true
	;  Else
	;	 ;Couldnt find either button after 4 seconds. Probably on the rally screen
	;	 LogMessage("Seems like we are not in the marketplace anymore. Hitting ESC - nope")
	;	 ;Send("{ESC}")
	;	 Sleep(500)
	;	 If Not (CheckForColor($MSHelpTopMember[0],$MSHelpTopMember[1],$MSBlue) OR CheckForColor($MSRSSHelpButton[0],$MSRSSHelpButton[1],$MSBlue)) Then
	;		Return false
	;	 EndIf
	 ; EndIf


	  return true

EndFunc

;Will shield if the login information says to
Func ShieldMS($MSattempt)

   ;Check if we should shield
   If Login_Shield() <> 1 Then
	  return True
   EndIf

   LogMessage("Checking Shield.",2)

   ;Boosts menu
   SendMouseClick($MSBoostsIcon[0], $MSBoostsIcon[1])
   Sleep(2000)

   ;Get Shield button button
   ;;we poll here looking for a specific color on a one wide rectangle and click where we find it.
   Local $MSshieldError = 0
   Local $MSshieldCoord = PixelSearch($MSShieldSearchLeft,$MSShieldSearchTop,$MSShieldSearchRight,$MSShieldSearchBottom, $MSShieldColor)
   $MSshieldError = @error
   if($MSshieldError = 1) Then
	  $MSshieldCoord = PixelSearch($MSShieldSearchLeft,$MSShieldSearchTop,$MSShieldSearchRight,$MSShieldSearchBottom, $MSShieldColorAlt)
	  $MSshieldError = @error
   endif

   ;MsgBox($MSMB_SYSTEMMODAL,"","Left: " & $MSShieldTime[0]  + $MSshieldCoord[0] - $MSShieldButton[0] & " Top: " & $MSShieldTime[1] & " Right: " & $MSShieldTime[2]  + $MSshieldCoord[0] - $MSShieldButton[0]& " Bottom: " & $MSShieldTime[3])
   ;Save Shield Time
   ;SaveShieldTimeImage($MSShieldTime[0] + $MSshieldCoord[0] - $MSShieldButton[0],$MSShieldTime[1],$MSShieldTime[2]  + $MSshieldCoord[0] - $MSShieldButton[0],$MSShieldTime[3])
   SaveShieldTimeImage()
   LogMessage("$MSShieldColor at $MSShieldButton: " & PixelGetColor($MSShieldButton[0],$MSShieldButton[1]))

   Local $MSminonShield = 4320 ;1440= 24Hr ,  4320 = 3 day
   If ($MSminonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))) > (Login_LoginDelay()*1.2) Then
	  LogMessage("No Need to Shield, Minutes left = " & ($MSminonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))),2)

	  ;Back out
	  Send("{ESC}")
	  Sleep(1000)

	  Return
   EndIf

   If (($MSminonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))) > 300) Then
	  LogMessage("LastRun = " & Login_LastRun())
	  LogMessage("Login_LastShield = " & Login_LastShield())
	  LogMessage("GetNowUTCCalc = " & GetNowUTCCalc())
	  LogMessage("_DateDiff = " & _DateDiff('n',Login_LastShield(),GetNowUTCCalc()))
   EndIf


   LogMessage("Shielding, Minutes wasted = " & ($MSminonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))),1)
   LogMessage("Attempting to reshield")

;MsgBox($MSMB_SYSTEMMODAL,"",
   If ($MSshieldError = 1) Then
	  LogMessage("Using default Shield location", 0)
	  $MSshieldCoord = $MSShieldButton
   Else
	  LogMessage("Using offset Shield location", 0)
   EndIf

   SendMouseClick($MSshieldCoord[0],$MSshieldCoord[1])
   Sleep(2000)

   ;Drag up so we can see the count for a picture
   ;MouseClickDrag("left",888,460,842,460,20)
   ;Sleep(500)

   ;Store the count image
   SaveShieldCountImage()

   ;Get Shield button button
   SendMouseClick($MSShieldButton3Day[0],$MSShieldButton3Day[1])
   Sleep(2000)

   ;Check for the replace button
   If PollForColor($MSShieldReplaceButton[0],$MSShieldReplaceButton[1], $MSShieldReplaceButtonColor, 6000, "$MSShieldReplaceButtonColor at $MSShieldReplaceButton") Then
	  SendMouseClick($MSShieldReplaceButton[0],$MSShieldReplaceButton[1])
	  Sleep(3500)
   EndIf

   ; after we have done or not done replace. If they dont have shields/or gold:
   IF PollForColor($MSShieldNotEnoughGoldButton[0],$MSShieldNotEnoughGoldButton[1],$MSShieldNotEnoughGoldButtonColor, 3000, "$MSRedNoButton at $MSShieldNotEnoughGoldButton") Then
	  SendMouseClick($MSShieldNotEnoughGoldButton[0],$MSShieldNotEnoughGoldButton[1])

	  SendEmail(Login_UserEmail(), "Not enough gold to shield in city: " & Login_Email(), "Hello " & Login_UserEmail() & ",", "It appears that your city does not have any 3d shields or enough gold to buy one. Shielding has been turned off for that city, please turn it back on once there are shields or enough gold.", "Thanks, MS Minion")
	  LogMessage("Not enough gold.  CITY MAY BE UNSHIELDED. Shielding has been turned OFF",4)
	  Login_UpdateShield(0)
   EndIf


   LogMessage("Verifying Shield")

   ;here we need to verify based on the offset where we found it.
   If PollForTwoColors($MSShieldVerifyMaxLength[0] + $MSshieldCoord[0] - $MSShieldButton[0],$MSShieldVerifyMaxLength[1] + $MSshieldCoord[1] - $MSShieldButton[1], $MSShieldCountDownBlue, $MSShieldCountDownBlueAlt, 5000, "$MSShieldCountDownBlue and $MSShieldCountDownBlueAlt at $MSShieldVerifyMaxLength") Then
	  LogMessage("Shield Verified",2)
	  Login_WriteShield()
   Else
	  If $MSattempt < 4 Then
		 LogMessage("Shield Not replaced, trying again",3)

		 ;Go back to the City screen to start again
		 ClickCityScreenMS()

		 Shield($MSattempt+1)
	  Else
		 $MSSleepOnLogout = 1
		 If(($MSminonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))) < 30) Then
		 SendEmail(Login_UserEmail(), "Failed to set shield on: " & Login_Email(), "Hello " & Login_UserEmail() & ",", "Your city has failed to reshield 5 times. There are " & ($MSminonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))) & " minutes left on the current shield. Our minions will try again shortly. We are looking into why, please reshield your city manually to keep it safe.", "Thanks, MS Minion")
		 EndIf
		 LogMessage("Max shield attempts.  CITY MAY BE UNSHIELDED. Shield expires in " & ($MSminonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))),1) & " minutes. Our minions will try and reshield again shortly.",4)

	  EndIf
   EndIf

   ;City Menu
   ClickCityScreenMS()

EndFunc

Func CheckShieldColorMS()
   ;Boosts menu
   SendMouseClick($MSBoostsIcon[0], $MSBoostsIcon[1])
   Sleep(2000)

   ;;
   LogMessage("$MSShieldColor at $MSShieldButton: " & PixelGetColor($MSShieldButton[0],$MSShieldButton[1]))

   ClickCityScreenMS()
EndFunc

Func LogoutMS()

   ;Logout Script
   If Not CheckForCityScreenMS(0) Then
	  ClickCityScreenMS()
   EndIf

   ;More panel
   SendMouseClick($MSMoreMenu[0],$MSMoreMenu[1])

   ;ConvertToDarkEnergy()

   ;Accounts
   If PollForColors($MSAccountButton[0],$MSAccountButton[1], $MSAccountButtonColors, 5000, "$MSAccountButtonColors at $MSAccountButton") Then
	  SendMouseClick($MSAccountButton[0],$MSAccountButton[1])
   Else
	  LogMessage("Dont have the account button to logout, clicking more again.")
	  SendMouseClick($MSMoreMenu[0],$MSMoreMenu[1])
	  If PollForColors($MSAccountButton[0],$MSAccountButton[1], $MSAccountButtonColors, 5000, "$MSAccountButtonColors at $MSAccountButton") Then
		 SendMouseClick($MSAccountButton[0],$MSAccountButton[1])
	  Else
		 ;Return False
		 SendMouseClick($MSAccountButton[0],$MSAccountButton[1])
	  EndIf
   EndIf

   ;Logout
   If PollForColor($MSLogoutButton[0],$MSLogoutButton[1], $MSLogoutButtonColor, 5000, "$MSLogoutButtonColor at $MSLogoutButton") Then
	  SendMouseClick($MSLogoutButton[0],$MSLogoutButton[1])
   Else
	  LogMessage("Dont have the logout button to logout")
	  Return False
   EndIf

   ;Yes Logout
   If PollForColor($MSLogoutYesButton[0],$MSLogoutYesButton[1], $MSLogoutYesButtonColor, 5000, "$MSLogoutYesButtonColor at $MSLogoutYesButton") Then
	  SendMouseClick($MSLogoutYesButton[0],$MSLogoutYesButton[1])
   Else
	  LogMessage("Dont have the account yes logout button")
	  Return False
   EndIf
   Sleep(1000)

EndFunc

Func OpenMS($MSattempts)

   ;Make sure the VB is open
   ;WinActivate ("BlueStacks","")
   ;WinMove("BlueStacks","",$MSVBHostWindow[0],$MSVBHostWindow[1])
   ;MsgBox($MB_SYSTEMMODAL, "", $MSattempts > 4)

   if($MSattempts > 4) Then
	  LogMessage("Tried to open MS 5 times without working. Returning False.")
	  return -1;
   EndIf
   WinMinimizeAll()
   Sleep(1000)

   LogMessage("Attempting to open MS: " & $MSattempts,1)
   ;Check if we have an Icon, if not try exiting MS or using the home button for Android
   If Not PollForColor( $MSIcon[0],$MSIcon[1], $MSColor, 5000) Then
	  LogMessage("***  We dont have the Icon trying to reset")
	  Local $MSTries = 1

	  ;Check if we have MS open
	  If CheckForColor($MSAndroidHomeButton[0],$MSAndroidHomeButton[1], $MSBlack) Then
		 While $MSTries < 5
			SendMouseClick($MSAndroidHomeButton[0],$MSAndroidHomeButton[1])
			Sleep(1000)
			If CheckForColor($MSQuitGameDialogYesButton[0],$MSQuitGameDialogYesButton[1], $MSYesQuitWhite) Then
			   SendMouseClick($MSQuitGameDialogYesButton[0],$MSQuitGameDialogYesButton[1])
			   Sleep(2000)
			   ExitLoop
			Else
			   $MSTries = $MSTries +1
			EndIf
		 WEnd

	  ElseIf CheckForColor($MSAndroidHomeButtonBottom[0],$MSAndroidHomeButtonBottom[1], $MSBlack) Then
		 LogMessage("Trying android bottom button")
		 SendMouseClick($MSAndroidHomeButtonBottom[0],$MSAndroidHomeButtonBottom[1])
		 Sleep(1000)
	  EndIf

	  ;Try using the android button again if we still don't have the icon
	  If Not CheckForColor( $MSIcon[0],$MSIcon[1], $MSColor) Then
		 $MSTries = 1
		 LogMessage("***  We STILL dont have the Icon, checking for android back button")
		 While $MSTries < 5
			If CheckForColor($MSAndroidHomeButtonBottom[0],$MSAndroidHomeButtonBottom[1], $MSBlack) Then
			   LogMessage("Trying android bottom button attempt = " + $MSTries)
			   SendMouseClick($MSAndroidHomeButtonBottom[0],$MSAndroidHomeButtonBottom[1])
			   Sleep(1000)
			EndIf

			$MSTries = $MSTries + 1
		 WEnd

	  EndIf
   EndIf

   ;double click the Icon
   SendMouseClick($MSIcon[0],$MSIcon[1])
   sleep(100)
   SendMouseClick($MSIcon[0],$MSIcon[1])
   sleep(10000)
   ;;;;; added to handle that the VM shifts to a new spot.

   If WinGetState ( "BlueStacks") = 0 Then
	  LogMessage("No bluestacks window to move.  Attempting to reopen Bluestacks.")
	  return OpenMS($MSattempts+1)
   EndIf


   WinMove("BlueStacks","",$MSVBHostWindow[0],$MSVBHostWindow[1],$MSWindowSize[0],$MSWindowSize[1])
   ;quit()

   Local $MSOpen = False
   Local $MS1 = 0
   Local $MSwinSize

   ;This shoudl check for the login screeen for 35 seconds and restart if it quits out before that by checking every 5 seconds for changed window size
   For $MS1 = 0 to 6 Step 1

	  ;Check for 5 seconds for the login button
	  If PollForColor($MSLoginButton[0],$MSLoginButton[1], $MSLoginButtonInitalColor, 5000, "$MSGreyedOutButton at $MSLoginButton") Then
		 ExitLoop
	  EndIf
	  $MSwinSize = WinGetClientSize("BlueStacks")
	  ;Check if the window reset to the launcher
	  If($MSwinSize[0] > $MSWindowSize[0]) Then
		 ;Here we have the wide window so try opening again.
		 LogMessage("Looks like we exited out of MS Screen back to Launcher")
		 return OpenMS($MSattempts+1)
	  EndIf
   Next


   If Not PollForColor($MSLoginButton[0],$MSLoginButton[1], $MSLoginButtonInitalColor, 5000, "$MSGreyedOutButton at $MSLoginButton") Then

	  LogMessage("Did not see login page")
	  ;Here we dont have a logout button. There are 3 scenarios
	  ;We black screened before the screen size changed. So move and resize the window and openMS Again

	  ;We black screened and went back to launcher after we moved the window
	  $MSwinSize = WinGetClientSize("BlueStacks")

	  If($MSwinSize[0] > $MSWindowSize[0]) Then
		 ;Here we have the wide window so try opening again.
		 LogMessage("Looks like we exited out of MS Screen back to Launcher")
		 return OpenMS($MSattempts+1)
	  Else
		 ;here we have the narrow window so check to see if it looks like we are in MS

		 If (CheckForColor($MSEmailPinCodeButton[0],$MSEmailPinCodeButton[1],$MSblue)) Then
			LogMessage("Looks like we are expecting a PIN")

			   ;Check for PIN Prompt using the stored PIN. Enter it and then sleep a bit and ESC the gold screen and logout.
			CheckForPinPromptMS(StringToASCIIArray($MSstoredPIN))
			Sleep(15000)

			Send("ESC")
			Sleep(2000)
			If PollForColor($MSConnectionInteruptButton[0],$MSConnectionInteruptButton[1],$MSBlue,3000, "$MSBlue at $MSConnectionInteruptButton") Then
			   SendMouseClick($MSConnectionInteruptButton[0],$MSConnectionInteruptButton[1])
			   Sleep(500)
			EndIf
			LogoutMS()
			Sleep(2000)
			return OpenMS($MSattempts+1)
		 Else
			If CheckForSessionTimeoutMS() Then
			   LogMessage("Writing Login from OpenMS function because of session timeout",1)
			   Login_Write()
			ElseIf (CheckForColor($MSRandomSpotForBlankScreenCheck[0],$MSRandomSpotForBlankScreenCheck[1],$MSblack)) Then
			   LogMessage("Looks like we black screened before resizing")
			   ;WinMove("BlueStacks","",$MSVBHostWindow[0],$MSVBHostWindow[1],1152,720)
			   return OpenMS($MSattempts+1)
			ElseIf (CheckForColor($MSRandomSpotForBlankScreenCheck[0],$MSRandomSpotForBlankScreenCheck[1],$MSExitAppErrorColor)) Then
			   LogMessage("Looks like we need to exit the game.")
			   ;WinMove("BlueStacks","",$MSVBHostWindow[0],$MSVBHostWindow[1],1152,720)
			   SendMouseClick($MSAndroidHomeButtonBottom[0],$MSAndroidHomeButtonBottom[1])
			   return OpenMS($MSattempts+1)
			Else
			   LogMessage("Looks like we are in MS")
			   Send("ESC")
			   Sleep(2000)
			   If PollForColor($MSConnectionInteruptButton[0],$MSConnectionInteruptButton[1],$MSBlue,3000, "$MSBlue at $MSConnectionInteruptButton") Then
				  SendMouseClick($MSConnectionInteruptButton[0],$MSConnectionInteruptButton[1])
				  Sleep(500)
			   EndIf
			   LogoutMS()
			   Sleep(2000)
			   return OpenMS($MSattempts+1)
			EndIf
		 EndIf
	  EndIf

   EndIf

EndFunc

Func CloseMS()

   If CheckForSessionTimeoutMS() Then
	  LogMessage("Writing Login from CloseMS function because of session time out",1)
	  Login_Write()
   Else

	  ;Check if we have MS open
	  If CheckForColor($MSAndroidHomeButton[0],$MSAndroidHomeButton[1],$MSBlack) Then

		 ;Attempt Logout
		 LogoutMS()

		 ;If that didn't work quit
		 If CheckForColor($MSAndroidHomeButton[0],$MSAndroidHomeButton[1],$MSBlack) Then
			SendMouseClick($MSAndroidHomeButton[0],$MSAndroidHomeButton[1])
			Sleep(1000)
			SendMouseClick($MSQuitGameDialogYesButton[0],$MSQuitGameDialogYesButton[1])
			Sleep(1000)
		 EndIf
	  Else
		 LogMessage("----- Looks like we arent in MS -----",1)
	  EndIf

	  ;Make sure we release this city
	  ;Login_Write()
	  ;Making this not set the last login because we didn't always get all through it
	  Login_ResetInProcess()
   EndIf

   ;sleep 5 seconds to get everything cleaned up
   Sleep(5000)
EndFunc

Func CheckForPinPromptMS($MSpinArray)
   ;LogMessage("Checking for PIN")
   ;Local $MSpinArray = StringToASCIIArray(Login_PINMS())
   If PollForColor($MSFirstPinBox[0],$MSFirstPinBox[1],$MSPinBoxColor,3000, "$MSPinBoxColor at $MSFirstPinBox") Then
	  If CheckForColor($MSSecondPinBox[0],$MSSecondPinBox[1],$MSPinBoxColor) Then

		 LogMessage("PIN is needed",2)
		 Sleep(500)

		 If UBound($MSpinArray) < 4 Then
			LogMessage("PIN is needed, and not supplied.  Failed to login.",5)
			Return False
		 EndIf

		 SendMouseClick($MSFirstPinBox[0],$MSFirstPinBox[1])
		 For $MSi = 0 to UBound($MSpinArray)-1
			Send(Chr($MSpinArray[$MSi]))
			Sleep(500)
		 Next
		 Return True
	  Else
		 LogMessage("Pin Spot1 passed, spot 2 did not.")
		 LogMessage("Pin Spot2 is - " & PixelGetColor($MSSecondPinBox[0],$MSSecondPinBox[1]))
		 Return True ;Don't know why we are here but don't fail out
	  EndIf
   EndIf

   Return True

EndFunc

;Check for session timeout and if so click ok
Func CheckForSessionTimeoutMS()
   If CheckForColor($MSCityMenu[0],$MSCityMenu[1],$MSBlack) And PollForColor($MSSessionTimeoutButton[0],$MSSessionTimeoutButton[1],$MSSessionTimeoutButtonColor,500, "$MSBlue at $MSSessionTimeoutButton")  Then
	  SendMouseClick($MSSessionTimeoutButton[0],$MSSessionTimeoutButton[1])
	  LogMessage("Have Session Timeout",1)
	  WinMinimizeAll()
	  $SleepOnLogout = 1
	  ;Sleeps for 1 minutes on session timeout.
	  Sleep(60000)
	  Return True
   EndIf

   Return False
EndFunc

Func ClickCityScreenMS()

   ;LogMessage("----- Checking for CityScreenColor: " & $MSCityScreenColor)
   If Not CheckForColor($MSCityMenu[0],$MSCityMenu[1],$MSCityScreenColor) Then
	  LogMessage("*** Got the wrong color for the city screen")
   Else
	  SendMouseClick($MSCityMenu[0],$MSCityMenu[1])
	  Sleep(2000)
   EndIf
EndFunc

Func ClickGoldButtonMS()

   ;Sleep until the gold screen has come up
   ;Sleep(30000)

   LogMessage("Starting Gold Button search")
   ;Do a pixel search so that we find the gold button every? time.
   ;PollForPixelSearch($MSGoldSearchLeft,$MSGoldSearchTop,$MSGoldSearchRight,$MSGoldSearchBottom, $MSBuyGoldColor, 30000)
   ;LogMessage("Pixel Search Result: " & @error)
   For $MSi = 0 To 8 Step 1
      If CheckForColor($MSConnectionInteruptButton[0],$MSConnectionInteruptButton[1],$MSConnectionInteruptButtonColor) Then
		 SendMouseClick($MSConnectionInteruptButton[0],$MSConnectionInteruptButton[1])
		 Sleep(1000)
	  EndIf
	  Sleep(500)
	  If (PollForPixelSearch($MSGoldSearchLeft,$MSGoldSearchTop,$MSGoldSearchRight,$MSGoldSearchBottom, $MSBuyGoldColor, 3000)) Then
		 Send("{ESC}")
		 Return True
	  EndIf
   Next

   Sleep(15000)
   LogMessage("*** Never got the gold button")
   Return False


EndFunc

;This also tries to return to the city screen
Func CheckForCityScreenMS($MSattempts)

   ;Check for the gold button
   Local $MSHasGoldButton = CheckForColor($MSGoldExitButton[0],$MSGoldExitButton[1],$MSGetGoldButton)
   ;Check for the map menu item
   Local $MSHasMapButton = CheckForColor($MSCityMenu[0],$MSCityMenu[1],$MSMapMenuColor)

   If $MSHasGoldButton AND $MSHasMapButton Then
	  ;LogMessage("Got City screen. Attempt=" & $MSattempts)
	  return True
   Else

	  ;Fourth atempt we don't know where we are, and couldn't get a city screen
	  If $MSattempts > 4 Then
		 Return False
	  EndIf

	  LogMessage("NO City screen. Attempt=" & $MSattempts)
	  ;LogMessage("Gold button color is " & PixelGetColor($MSGoldExitButton[0],$MSGoldExitButton[1]) & " - " & $MSGetGoldButton)
	  ;LogMessage("Map Menu color is " & PixelGetColor($MSCityMenu[0],$MSCityMenu[1]) & " - " & $MSMapMenuColor)
	  ;If this isn't the city screen try hitting escape, 4 times though recursion
	  Send("{ESC}")
	  Sleep(1000)

	  If PollForColor($MSQuitGameDialogYesButton[0],$MSQuitGameDialogYesButton[1],$MSYesQuitWhite, 500, "$MSYesQuitWhite at $MSQuitGameDialogYesButton in Check for City Screen") Then
		 ;Say No then try again
		 SendMouseClick($MSQuitGameDialogNoButton[0],$MSQuitGameDialogNoButton[1])
		 Sleep(1000)
		 Return CheckForCityScreenMS($MSattempts+1)
	  EndIf

	  ;If we are on the map click into the city
	  If CheckForColor($MSCityMenu[0],$MSCityMenu[1],$MSCityScreenColor) Then
		 SendMouseClick($MSCityMenu[0],$MSCityMenu[1])
		 Sleep(1000)
	  EndIf

	  ;Fourth atempt we don't know where we are, and couldn't get a city screen
	  If $MSattempts < 4 Then
		 Return CheckForCityScreenMS($MSattempts+1)
	  Else
		 ;All done here
		 Return False
	  EndIf

   EndIf

EndFunc

Func CheckForWorldScreenMS($MSattempts)

   If CheckForColor($MSCityMenu[0],$MSCityMenu[1],$MSCityScreenColor) Then
	  ;LogMessage("Got City screen. Attempt=" & $MSattempts)
	  return True
   Else

	  ;Fourth atempt we don't know where we are, and couldn't get a city screen
	  If $MSattempts > 4 Then
		 Return False
	  EndIf

	  LogMessage("NO Map screen. Attempt=" & $MSattempts & " Color found - " & PixelGetColor($MSCityMenu[0],$MSCityMenu[1]) & " not " & $MSCityScreenColor )
	  ;LogMessage("NO Map screen. Attempt=" & $MSattempts)
	  Send("{ESC}")
	  Sleep(1000)

	  If PollForColor($MSQuitGameDialogYesButton[0],$MSQuitGameDialogYesButton[1],$MSYesQuitWhite, 500, "$MSYesQuitWhite at $MSQuitGameDialogYesButton in Check for World Screen") Then
		 ;Say No then try again
		 SendMouseClick($MSQuitGameDialogNoButton[0],$MSQuitGameDialogNoButton[1])
		 Sleep(1000)
		 Return CheckForWorldScreen($MSattempts+1)
	  EndIf

	  ;If we are on the City click into the city
	  If CheckForColor($MSCityMenu[0],$MSCityMenu[1],$MSMapMenuColor) Then
		 SendMouseClick($MSCityMenu[0],$MSCityMenu[1])
		 Sleep(1000)
	  EndIf

	  ;Fourth atempt we don't know where we are, and couldn't get a city screen
	  If $MSattempts < 4 Then
		 Return CheckForWorldScreen($MSattempts+1)
	  Else
		 ;All done here
		 Return False
	  EndIf

   EndIf

EndFunc

Func SaveCityImageMS()
   SaveImage('CityImage',$MSCityImage[0],$MSCityImage[1],$MSCityImage[2],$MSCityImage[3])
EndFunc

Func SaveRSSImageMS()
   SaveImage('RSSImage',$MSRssImage[0],$MSRssImage[1],$MSRssImage[2],$MSRssImage[3])
EndFunc

Func SaveGoldImageMS()
   SaveImage('GoldImage',$MSGoldImage[0],$MSGoldImage[1],$MSGoldImage[2],$MSGoldImage[3])
EndFunc

Func SaveHeroImageMS()
   SaveImage('HeroImage',$MSHeroImage[0],$MSHeroImage[1],$MSHeroImage[2],$MSHeroImage[3])
EndFunc

Func SaveTreasuryImageMS()
   SaveImage('TreasuryImage',$MSTreasuryImage[0],$MSTreasuryImage[1],$MSTreasuryImage[2],$MSTreasuryImage[3])
EndFunc

Func SaveShieldCountImageMS()
   SaveImage('ShieldCount',$MSShieldCount[0],$MSShieldCount[1],$MSShieldCount[2],$MSShieldCount[3])
EndFunc

Func SaveShieldTimeImageMS()
   SaveImage('ShieldTime',$MSShieldTime[0],$MSShieldTime[1],$MSShieldTime[2],$MSShieldTime[3])
EndFunc

Func SaveRSSProductionImageMS()
   SaveImage('RSSProduction',$MSRssProduction[0],$MSRssProduction[1],$MSRssProduction[2],$MSRssProduction[3])
EndFunc

Func SaveSilverProductionImageMS()
   SaveImage('SilverProduction',$MSSilverProduction[0],$MSSilverProduction[1],$MSSilverProduction[2],$MSSilverProduction[3])
EndFunc

