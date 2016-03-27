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

Global $isLoggedOut = 0
Global $isSessionTimeout = False

Func Login($email, $pwd)

   If(Login_LoginAttempts() >= 5) Then
	  LogMessage("We have attempted to login 5 times and failed. Setting " & Login_CityName() & " to inactive.",5)
	  Login_UpdateLoginActive(0);
	  return false;
   EndIf

   If Not PollForColor( $UserNameTextBox[0],$UserNameTextBox[1], $UserNameTextBoxColor,1000, "$UserNameTextBoxColor at $UserNameTextBox") Then
	  LogMessage("No UsernameText box Checking if we are already logged in.")


	  ;Checking for PinPrompt


	  ;Check if you are already logged in Use the last attempt, don't do it lots
	  If CheckForCityScreen(4) Then
		 LogMessage("Ok, we are already logged in so just keep going")
		 Sleep(4000)
		 ClickGoldButton()
		 If Not CheckForCityScreen(0) Then
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
   SendMouseClick($UserNameTextBox[0],$UserNameTextBox[1])
   Sleep(1000)
   SendMouseClick($UserNameTextBox[0],$UserNameTextBox[1])
   sleep(1000)

   Local $emailArray = StringToASCIIArray($email)
   For $i = 0 to UBound($emailArray)-1
	  if(Chr($emailArray[$i]) = "!") Then
		 Send("{!}")
	  ElseIf (Chr($emailArray[$i]) = "+") Then
		 Send("{+}")
	  ElseIf (Chr($emailArray[$i]) = "#") Then
		 Send("{#}")
	  ElseIf (Chr($emailArray[$i]) = "^") Then
		 Send("{^}")
	  ElseIf (Chr($emailArray[$i]) = "{") Then
		 Send("{{}")
	  ElseIf (Chr($emailArray[$i]) = "}") Then
		 Send("{}}")
	  Else
		 Send(Chr($emailArray[$i]))
	  EndIf
	  Sleep(100)
   Next

   Sleep(2000)

   ;Password
   SendMouseClick($PasswordTextBox[0],$PasswordTextBox[1])
   Sleep(2000)

   Local $pwdArray = StringToASCIIArray($pwd)
	  For $i = 0 to UBound($pwdArray)-1
		 if(Chr($pwdArray[$i]) = "!") Then
			Send("{!}")
		 ElseIf (Chr($pwdArray[$i]) = "+") Then
			Send("{+}")
		 ElseIf (Chr($pwdArray[$i]) = "#") Then
			Send("{#}")
		 ElseIf (Chr($pwdArray[$i]) = "^") Then
			Send("{^}")
		 ElseIf (Chr($pwdArray[$i]) = "{") Then
			Send("{{}")
		 ElseIf (Chr($pwdArray[$i]) = "}") Then
			Send("{}}")
		 Else
			Send(Chr($pwdArray[$i]))
		 EndIf
		 Sleep(100)
	  Next
   ;Send($pwd)

   ;Check that the login button is there
   If Not PollForColor($LoginButton[0],$LoginButton[1],$LoginButtonReadyColor,3000, "$LoginButtonReadyColor at $LoginButton") Then
	  LogMessage("Login Failed.  Login button isn't the right color",5 )
	  LogMessage("Increasing Login Attempts to " & Login_LoginAttempts()+1,5 )
	  Login_UpdateLoginAttempts(Login_LoginAttempts() +1)
	  Return False
   EndIf

   ;Login Button
   SendMouseClick($LoginButton[0],$LoginButton[1])


   ;Now check for a Pin
   If Not CheckForPinPrompt(StringToASCIIArray(Login_PIN())) Then
	  LogMessage("Increasing Login Attempts to " & Login_LoginAttempts()+1,5 )
	  Login_UpdateLoginAttempts(Login_LoginAttempts() +1)
	  Return False
   EndIf

   ;Check if there was a login failure
   If PollForColor($LoginFailureButton[0],$LoginFailureButton[1],$LoginButtonFailueColor,3000, "$LoginButtonFailueColor at $LoginFailureButton") Then
	  LogMessage("Login Failed.  Bad Username/Pwd.",5 )
	  LogMessage("Increasing Login Attempts to " & Login_LoginAttempts()+1,5 )
	  Login_UpdateLoginAttempts(Login_LoginAttempts() +1)
	  Return False
   EndIf

   ;Check if the city is locked to a device
   If PollForColor($DeviceLockedLogoutButton[0],$DeviceLockedLogoutButton[1],$DeviceLockedLogoutButtonColor,3000, "$DeviceLockedLogoutButtonColor at $DeviceLockedLogoutButton") Then
	  LogMessage("Login Failed. City is locked to a device. Making city inactive.",5 )
	  Login_UpdateLoginActive(0);
	  SendMouseClick($DeviceLockedLogoutButton[0],$DeviceLockedLogoutButton[1])
	  ;;LogMessage("Increasing Login Attempts to " & Login_LoginAttempts()+1,5 )
	  ;;Login_UpdateLoginAttempts(Login_LoginAttempts() +1)
	  Return False
   EndIf

   ;Now exit the gold buy button
   Local $ClickedGoldScreen = False
   $ClickedGoldScreen = ClickGoldButton()
   ;Not sleeping here because of the next two polls
   Sleep(1000) ;3 seconds because of the quest poping up

;;;;Bluestack connection code interupt. Poll for a few seconds then move on
   If PollForColor($ConnectionInteruptButton[0],$ConnectionInteruptButton[1],$Blue,1500, "$Blue at $ConnectionInteruptButton") Then
	  SendMouseClick($ConnectionInteruptButton[0],$ConnectionInteruptButton[1])
	  Sleep(500)
   EndIf

#comments-start
;Removing this since it isn't needed any more
;;;;;Make sure we have accepted the terms and conditions. Poll for 2 seconds
   If PollForColor($TermsAndConditionsButton[0],$TermsAndConditionsButton[1],$Blue,1500, "$Blue at $TermsAndConditionsButton") Then
	  SendMouseClick($TermsAndConditionsButton[0],$TermsAndConditionsButton[1])
	  ;;;If we have the T&C button we then poll for gold screen for 5 seconds to esc out of that
	  If (PollForPixelSearch($GoldSearchLeft,$GoldSearchTop,$GoldSearchRight,$GoldSearchBottom, $BuyGoldColor, 5000)) Then
		 Send("{ESC}")
		 $ClickedGoldScreen = True
	  EndIf
	  Sleep(500)
   EndIf
#comments-end

   ;Assume if there was a gold screen then we logged in ok and set the city/map colors
   If $ClickedGoldScreen Then
	  If Not CheckForColor($CityMenu[0],$CityMenu[1],$MapMenuColor) Then
		 LogMessage("******************* Resetting City and Map Colors ***********************",5 )
		 LogMessage("Old City Color = " & $MapMenuColor,5  )
		 LogMessage("Old Map Color = " & $CityScreenColor,5  )
		 $MapMenuColor  = PixelGetColor($CityMenu[0],$CityMenu[1])
		 LogMessage("New City Color = " & $MapMenuColor,5  )
		 SendMouseClick($CityMenu[0],$CityMenu[1])
		 Sleep(1000)
		 $CityScreenColor = PixelGetColor($CityMenu[0],$CityMenu[1])
		 LogMessage("New Map Color = " & $CityScreenColor ,5 )
		 SendMouseClick($CityMenu[0],$CityMenu[1])
		 Sleep(1000)
	  EndIf
   EndIf

   ;If we didn't get the fity screen bailout
   If Not CheckForCityScreen(0) Then
	  LogMessage("NO city screen after login, in login function",5 )
	  LogMessage("Increasing Login Attempts to " & Login_LoginAttempts()+1,5 )
	  Login_UpdateLoginAttempts(Login_LoginAttempts() +1)
	  return False
   EndIf

   LogMessage("Resetting Login Attempts to 0",1 )
   Login_UpdateLoginAttempts(0)
   return True
EndFunc

Func CollectAthenaGift($count = 0)

   ;Only collect 4 times
   If $count > 4 Then
	  Return
   EndIf

   ;We doing it this way incase of a bouncer, specifically checking twice
   If CheckForColor( $AthenaGift[0],$AthenaGift[1], $NoAthenaGiftColor) Then
	  Return
   EndIf
   Sleep(250)
   If CheckForColor( $AthenaGift[0],$AthenaGift[1], $NoAthenaGiftColor) Then
	  Return
   EndIf

   ;Check if this is bouncing
   Local $firstColor = PixelGetColor($AthenaGift[0],$AthenaGift[1])

   If Not PollForNOTColor($AthenaGift[0],$AthenaGift[1],$firstColor,2000) Then
	  LogMessage("We have an Athena Gift but it is not ready to collect",1)
	  Return
   EndIf

   LogMessage("Collecting Athena Gift",2)

   ;Collect the bouncer
   SendMouseClick($AthenaGift[0],$AthenaGift[1])
   ;Just a pause to speed it up
   PollForColor($AthenaGiftCollectButton[0],$AthenaGiftCollectButton[1],$SecretGiftCollectButtonColor,4000,"$SecretGiftCollectButtonColor at $SecretGiftCollectButton")
   SendMouseClick($AthenaGiftCollectButton[0],$AthenaGiftCollectButton[1])
   Sleep(3500) ; longer sleep because it pops stuff up

   CollectAthenaGift($count+1)
   Login_AthenaGiftCollected()

EndFunc

Func CollectSecretGift()
   ;Collect the bouncer
   SendMouseClick($SecretGift[0],$SecretGift[1])
   ;Just a pause to speed it up
   If PollForColor($SecretGiftCollectButton[0],$SecretGiftCollectButton[1],$SecretGiftCollectButtonColor,4000,"$SecretGiftCollectButtonColor at $SecretGiftCollectButton") Then
	  SendMouseClick($SecretGiftCollectButton[0],$SecretGiftCollectButton[1])
   Else
	  SendMouseClick($NoSecretGiftCollectButton[0],$NoSecretGiftCollectButton[1])
   EndIf
   Sleep(3500) ;Longer sleep because it pops up stuff

EndFunc

Func CollectQuests()

   ;Collect the Daily Quest
   SendMouseClick($QuestsMenu[0],$QuestsMenu[1])
   Sleep(2000)

   SendMouseClick($QuestsDaily[0],$QuestsDaily[1])
   Sleep(2000)

   If Not CheckForColor($QuestsCollect[0],$QuestsCollect[1],$NoQuestsColor) Then
	  SendMouseClick($QuestsCollect[0],$QuestsCollect[1])
	  Sleep(2000)
	  SendMouseClick($QuestsStart[0],$QuestsStart[1])
	  Sleep(2000)
   Endif

   ;Added to loop on clicking Collect as long as the button is blue. Daily Quests
   While 1=1
		 If (PollForColor($QuestsCollect[0],$QuestsCollect[1],$Blue, 3000, "$Blue at $QuestsCollect")) Then
			SendMouseClick($QuestsCollect[0],$QuestsCollect[1])
		 Else
			ExitLoop;
		 EndIf

   WEnd

   ;Collect the Alliance Quest
   SendMouseClick($QuestsMenu[0],$QuestsMenu[1])
   Sleep(2000)
   SendMouseClick($QuestsAliaance[0],$QuestsAliaance[1])
   Sleep(2000)

   If Not CheckForColor($QuestsCollect[0],$QuestsCollect[1],$NoQuestsColor) Then
	  SendMouseClick($QuestsCollect[0],$QuestsCollect[1])
	  Sleep(2000)
	  SendMouseClick($QuestsStart[0],$QuestsStart[1])
	  Sleep(2000)
   Endif

   ;Added to loop on clicking Collect as long as the button is blue. Alliance Quests
   While 1=1
		 If (PollForColor($QuestsCollect[0],$QuestsCollect[1],$Blue, 3000)) Then
			SendMouseClick($QuestsCollect[0],$QuestsCollect[1])
		 Else
			ExitLoop;
		 EndIf

   WEnd

   ;Return to City Screen
   ClickCityScreen()
EndFunc

Func Helps()
   If PollForColors($HelpButton[0], $HelpButton[1],$HelpButtonColorArray, 1000, "$HelpButtonColor at $HelpButton") Then
	  SendMouseClick($HelpButton[0], $HelpButton[1])
	  If(PollForColor($AllianceHelpHelpAllButton[0],$AllianceHelpHelpAllButton[1],$AllianceHelpHelpAllButtonColor,3000,"$AllianceHelpHelpAllButtonColor")) Then
		 SendMouseClick($AllianceHelpHelpAllButton[0],$AllianceHelpHelpAllButton[1])
		 Sleep(500)
	  EndIf
	  ;City Menu
	  ClickCityScreen()
   EndIf
EndFunc

Func Gifts()

   ;click into the alliance menu then check for gifts
   SendMouseClick($AllianceMenu[0], $AllianceMenu[1])
   Sleep(3000)

   If PollForColors($GiftBox[0], $GiftBox[1],$GiftBoxColorArray, 500, "$GiftBoxColor at $GiftBox") Then
   ;OLD - If PollForTwoColors($GiftBox[0], $GiftBox[1],$GiftBoxColor, $GiftBoxColorAlt, 500, "$GiftBoxColor at $GiftBox") Then
	  ;Alliance menu


	  ;Get Gifts button
	  SendMouseClick($GiftButton[0],$GiftButton[1])
	  Sleep(2000)

	  Local $HaveGift = True

	  While $HaveGift

		 ;If we can get or clear a gift, do it and keep looping
		 If CheckForColor($GiftGetClearButton[0], $GiftGetClearButton[1],$GiftGetClearButtonBlue)  Or CheckForColor($GiftGetClearButton[0], $GiftGetClearButton[1],$GiftGetClearButtonRed) Then
			SendMouseClick($GiftGetClearButton[0],$GiftGetClearButton[1])
			Sleep(2000)
		 Else
			$HaveGift = False
		 EndIf
	  WEnd


   EndIf

   ;since we always goi into the alliance menu, always go back out
   ;City Menu
   ClickCityScreen()
EndFunc

;This needs to be before Upgrades
Func Bank()

   If Login_Bank() = 0 Then
	  LogMessage("City Set to not bank")
	  Return
   EndIf

   ;Don't bother banking less than 12 not enough rss to bother
   ;If Login_StrongHoldLevel() < 12 Then
;	  Return
 ;  EndIf

   LogMessage("Banking ",2)

   ;Click Market Place
   SendMouseClick($MarketLocation[0],$MarketLocation[1])

   For $i = 1 to Login_RssMarches() ; Send rss marches
		 SendRSS(Login_RSSType()-1,Login_RSSType()-1)
   Next

   For $i = 1 to Login_SilveMarches() ; Send silver marches
	  SendRSS($eSilver, Login_RSSType()-1)
   Next

   Login_UpdateLastBank()

   ;City Menu
   ClickCityScreen()
EndFunc

;Assumes you are in the market place ready to send, and gets back to that point
Func SendRSS($type, $nonSilverType)

	  Local $helpOffsetX = (Login_RSSBank() - 1) * $HelpNumberOffsetX

	  If ($type = $eSilver) Then
		 $helpOffsetX = (Login_SilverBank() - 1) * $HelpNumberOffsetX
	  EndIf

	  ;Poll for first Help button
	  If PollForColor($HelpTopMember[0],$HelpTopMember[1], $HelpTopMemberColor, 5000, "$HelpTopMemberColor at $HelpTopMember(1)") Then
		 SendMouseClick($HelpTopMember[0] ,$HelpTopMember[1] + $helpOffsetX)
	  ElseIf PollForColor($RSSHelpButton[0],$RSSHelpButton[1], $RSSHelpButtonColor, 4000, "$RSSHelpButtonColor at $RSSHelpButton - If need be") Then
		 MouseMove($RSSHelpButton[0],$RSSHelpButton[1])
		 SendMouseClick($RSSHelpButton[0],$RSSHelpButton[1])
		 return True
	  Else
		 LogMessage("Banking - No help button")
		 ;City Menu
		 return false
	  Endif

	  ;Max the food if we can by filling silver marches with it
	  Local $colorClick = 197379
	  If PollForTwoColors($HelpRSSMax[$type][0],$HelpRSSMax[$type][1], $colorClick, $Black, 2000, "$colorClick or $Black at $HelpRSSMax") Then
		 ;do nothing this is just to wait to see if we can send faster
	  EndIf

	  ;Removed the restriction to only add other rss on food.
	  If ($type = $eSilver And $nonSilverType >0) Then
		 LogMessage("Banking - Maxing silver march with rss",2)
		 ;SendMouseClick($HelpRSSMax[$eFood][0],$HelpRSSMax[$eFood][1])
		 SendMouseClick($HelpRSSMax[$nonSilverType][0],$HelpRSSMax[$nonSilverType][1])
		 Sleep(500)
	  EndIf

	  If ($type = $eSilver) Then
		 ;Scroll for silver
		 MouseClickDrag("left",390,300,390,140)
	  EndIf
	  SendMouseClick($HelpRSSMax[$type][0],$HelpRSSMax[$type][1])
	  ;move the mouse then check and click
	  MouseMove($RSSHelpButton[0],$RSSHelpButton[1])
	  If PollForColor($RSSHelpButton[0],$RSSHelpButton[1], $RSSHelpButtonColor, 4000, "$RSSHelpButtonColor at $RSSHelpButton") Then
		 SendMouseClick($RSSHelpButton[0],$RSSHelpButton[1])
	  Endif

	  ;Handle Donation confirmation. This assumes it cannot be turned off in the settings.
	  If PollForColor($RSSOKButton[0],$RSSOKButton[1], $RSSOKButtonColor, 3000, "$RSSOKButtonColor at $RSSOKButton") Then
		 SendMouseClick($RSSOKButton[0],$RSSOKButton[1])
	  Else
		 ;Should check if the help button didn't really get clicked
		 If PollForColor($RSSHelpButton[0],$RSSHelpButton[1], $RSSHelpButtonColor, 3000) Then
			SendMouseClick($RSSHelpButton[0],$RSSHelpButton[1])
			Sleep(1000)
			If PollForColor($RSSOKButton[0],$RSSOKButton[1], $RSSOKButtonColor, 3000, "$RSSOKButtonColor at $RSSOKButton") Then
			   SendMouseClick($RSSOKButton[0],$RSSOKButton[1])
			EndIf
		 EndIf

	  Endif
	  ;Endif

	  ;Check for max send
	  If CheckForColor($MaxMarchesExceeded[0],$MaxMarchesExceeded[1],$MaxMarchesExceededColor) Then
		 SendMouseClick($MaxMarchesExceeded[0],$MaxMarchesExceeded[1])
		 return false
	  Endif

	  ;Check for Rally screen - Could do this using the check sum for Alliance War at the top of the screen
	  ;If neither the done button is there or the top help is there check for rally screen
	  ;If Not (CheckForColor($HelpTopMember[0],$HelpTopMember[1],$Blue) OR CheckForColor($RSSHelpButton[0],$RSSHelpButton[1],$Blue)) Then
	  ;IF (PollForColorTwoPlaces($HelpTopMember[0],$HelpTopMember[1],$RSSHelpButton[0],$RSSHelpButton[1],$Blue, 4000, "Polling for $Blue in both helps places")) Then
	;	 return true
	;  Else
	;	 ;Couldnt find either button after 4 seconds. Probably on the rally screen
	;	 LogMessage("Seems like we are not in the marketplace anymore. Hitting ESC - nope")
	;	 ;Send("{ESC}")
	;	 Sleep(500)
	;	 If Not (CheckForColor($HelpTopMember[0],$HelpTopMember[1],$Blue) OR CheckForColor($RSSHelpButton[0],$RSSHelpButton[1],$Blue)) Then
	;		Return false
	;	 EndIf
	 ; EndIf


	  return true

EndFunc

;Will shield if the login information says to
Func Shield($attempt)

   ;Check if we should shield
   If Login_Shield() <> 1 Then
	  return True
   EndIf

   LogMessage("Checking Shield.",2)

   ;Boosts menu
   SendMouseClick($BoostsIcon[0], $BoostsIcon[1])
   Sleep(2000)

   ;Get Shield button button
   ;;we poll here looking for a specific color on a one wide rectangle and click where we find it.
   Local $shieldError = 0
   Local $shieldCoord = PixelSearch($ShieldSearchLeft,$ShieldSearchTop,$ShieldSearchRight,$ShieldSearchBottom, $ShieldColor)
   $shieldError = @error
   if($shieldError = 1) Then
	  $shieldCoord = PixelSearch($ShieldSearchLeft,$ShieldSearchTop,$ShieldSearchRight,$ShieldSearchBottom, $ShieldColorAlt)
	  $shieldError = @error
   endif

   ;MsgBox($MB_SYSTEMMODAL,"","Left: " & $ShieldTime[0]  + $shieldCoord[0] - $ShieldButton[0] & " Top: " & $ShieldTime[1] & " Right: " & $ShieldTime[2]  + $shieldCoord[0] - $ShieldButton[0]& " Bottom: " & $ShieldTime[3])
   ;Save Shield Time
   ;SaveShieldTimeImage($ShieldTime[0] + $shieldCoord[0] - $ShieldButton[0],$ShieldTime[1],$ShieldTime[2]  + $shieldCoord[0] - $ShieldButton[0],$ShieldTime[3])
   SaveShieldTimeImage()
   LogMessage("$ShieldColor at $ShieldButton: " & PixelGetColor($ShieldButton[0],$ShieldButton[1]))

   Local $minonShield = 4320 ;1440= 24Hr ,  4320 = 3 day
   If ($minonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))) > (Login_LoginDelay()*1.2) Then
	  LogMessage("No Need to Shield, Minutes left = " & ($minonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))),2)

	  ;Back out
	  Send("{ESC}")
	  Sleep(1000)

	  Return
   EndIf

   If (($minonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))) > 300) Then
	  LogMessage("LastRun = " & Login_LastRun())
	  LogMessage("Login_LastShield = " & Login_LastShield())
	  LogMessage("GetNowUTCCalc = " & GetNowUTCCalc())
	  LogMessage("_DateDiff = " & _DateDiff('n',Login_LastShield(),GetNowUTCCalc()))
   EndIf


   LogMessage("Shielding, Minutes wasted = " & ($minonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))),1)
   LogMessage("Attempting to reshield")

;MsgBox($MB_SYSTEMMODAL,"",
   If ($shieldError = 1) Then
	  LogMessage("Using default Shield location", 0)
	  $shieldCoord = $ShieldButton
   Else
	  LogMessage("Using offset Shield location", 0)
   EndIf

   SendMouseClick($shieldCoord[0],$shieldCoord[1])
   Sleep(2000)

   ;Drag up so we can see the count for a picture
   ;MouseClickDrag("left",888,460,842,460,20)
   ;Sleep(500)

   ;Store the count image
   SaveShieldCountImage()

   ;Get Shield button button
   SendMouseClick($ShieldButton3Day[0],$ShieldButton3Day[1])
   Sleep(2000)

   ;Check for the replace button
   If PollForColor($ShieldReplaceButton[0],$ShieldReplaceButton[1], $BlueOKButton, 6000, "$BlueOKButton at $ShieldReplaceButton") Then
	  SendMouseClick($ShieldReplaceButton[0],$ShieldReplaceButton[1])
	  Sleep(3500)
   EndIf

   ; after we have done or not done replace. If they dont have shields/or gold:
   IF PollForColor($ShieldNotEnoughGoldButton[0],$ShieldNotEnoughGoldButton[1],$RedNoButton, 3000, "$RedNoButton at $ShieldNotEnoughGoldButton") Then
	  SendMouseClick($ShieldNotEnoughGoldButton[0],$ShieldNotEnoughGoldButton[1])

	  SendEmail(Login_UserEmail(), "Not enough gold to shield in city: " & Login_Email(), "Hello " & Login_UserEmail() & ",", "It appears that your city does not have any 3d shields or enough gold to buy one. Shielding has been turned off for that city, please turn it back on once there are shields or enough gold.", "Thanks, GoW Minion")
	  LogMessage("Not enough gold.  CITY MAY BE UNSHIELDED. Shielding has been turned OFF",4)
	  Login_UpdateShield(0)
   EndIf


   LogMessage("Verifying Shield")

   ;here we need to verify based on the offset where we found it.
   If PollForTwoColors($ShieldVerifyMaxLength[0] + $shieldCoord[0] - $ShieldButton[0],$ShieldVerifyMaxLength[1] + $shieldCoord[1] - $ShieldButton[1], $ShieldCountDownBlue, $ShieldCountDownBlueAlt, 5000, "$ShieldCountDownBlue and $ShieldCountDownBlueAlt at $ShieldVerifyMaxLength") Then
	  LogMessage("Shield Verified",2)
	  Login_WriteShield()
   Else
	  If $attempt < 4 Then
		 LogMessage("Shield Not replaced, trying again",3)

		 ;Go back to the City screen to start again
		 ClickCityScreen()

		 Shield($attempt+1)
	  Else
		 $SleepOnLogout = 1
		 If(($minonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))) < 30) Then
		 SendEmail(Login_UserEmail(), "Failed to set shield on: " & Login_Email(), "Hello " & Login_UserEmail() & ",", "Your city has failed to reshield 5 times. There are " & ($minonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))) & " minutes left on the current shield. Our minions will try again shortly. We are looking into why, please reshield your city manually to keep it safe.", "Thanks, GoW Minion")
		 EndIf
		 LogMessage("Max shield attempts.  CITY MAY BE UNSHIELDED. Shield expires in " & ($minonShield - (_DateDiff('n',Login_LastShield(),GetNowUTCCalc()))),1) & " minutes. Our minions will try and reshield again shortly.",4)

	  EndIf
   EndIf

   ;City Menu
   ClickCityScreen()

EndFunc

Func CheckShieldColor()
   ;Boosts menu
   SendMouseClick($BoostsIcon[0], $BoostsIcon[1])
   Sleep(2000)

   ;;
   LogMessage("$ShieldColor at $ShieldButton: " & PixelGetColor($ShieldButton[0],$ShieldButton[1]))

   ClickCityScreen()
EndFunc

;This will attempt to collect and restart treasury if login says to.
Func Treasury()
   ;Check to see if the city is set to Rally
   If Login_Treasury() = 0 Then
	  LogMessage("City not set to collect Treasury",1)
	  Return
   EndIf

   LogMessage("City set to collect Treasury",1)

   ;Check to see if we should check the treasury
   Local $minonTreasury = 43200 ;30 days. We only invest for 30d for now
   If ((($minonTreasury - (_DateDiff('n',Login_LastTreasury(),GetNowUTCCalc()))) < 0) OR (Login_LastTreasury() = 0)) Then
	  ;It has been more than 30 days since last treasury collection. Or they have never collected.
	  LogMessage("Attempting to collect Treasury or make deposit",1)
	  ;Click on the treasury
	  SendMouseClick($TreasuryLocation[0],$TreasuryLocation[1])
	  Sleep(2000)

	  ;If last login is 0 (null in db) then check 7 and 14 as well.
	  If(Login_LastTreasury() = 0) Then
		 ;Check Treasury Level 7
		 Local $collected = 0
		 SendMouseClick($Treasury7[0],$Treasury7[1])
		 If PollForColor($TreasuryCollectButton[0],$TreasuryCollectButton[1],$TreasuryCollectColor, 2000) Then
			SendMouseClick($TreasuryCollectButton[0],$TreasuryCollectButton[1])
			Sleep(2000)
			$collected = 1
			LogMessage("Treasury 7d Collected",2)
		 Else
			;if we went it but did not collect we have to go back out again
			SendMouseClick($TreasuryBack[0],$TreasuryBack[1])
			Sleep(2000)
		 EndIf

		 ;we did not collect the 7d one, so try a 14d
		 If ($collected = 0) Then
			SendMouseClick($Treasury14[0],$Treasury14[1])
			If PollForColor($TreasuryCollectButton[0],$TreasuryCollectButton[1],$TreasuryCollectColor, 2000) Then
			   SendMouseClick($TreasuryCollectButton[0],$TreasuryCollectButton[1])
			   Sleep(2000)
			   LogMessage("Treasury 14d Collected",2)
			Else
			   ;if we went it but did not collect we have to go back out again
			   SendMouseClick($TreasuryBack[0],$TreasuryBack[1])
			   Sleep(2000)
			EndIf
		 EndIf

	  EndIf

	  SendMouseClick($Treasury30[0],$Treasury30[1])
	  ;Check to see if I can collect
	  If PollForColor($TreasuryCollectButton[0],$TreasuryCollectButton[1],$TreasuryCollectColor, 2000) Then
		 SendMouseClick($TreasuryCollectButton[0],$TreasuryCollectButton[1])
		 Sleep(2000)
		 SendMouseClick($Treasury30[0],$Treasury30[1])
		 Sleep(2000)
		 LogMessage("Treasury Collected",1)
	  EndIf

	  ;Check to see if we can make a deposit
	  If PollForColor($TreasuryDepositButton[0],$TreasuryDepositButton[1],$Blue, 2000) Then
		 MouseClickDrag("left",$TreasuryDragCoords[0],$TreasuryDragCoords[1],$TreasuryDragCoords[2],$TreasuryDragCoords[3],20)
		 SendMouseClick($TreasuryDepositButton[0],$TreasuryDepositButton[1])

		 ;Check to see if the black bar is there before setting LastTreasury
		 If PollForColor($TreasuryRunningCheck[0],$TreasuryRunningCheck[1],$Black,3000) Then
			LogMessage("Treasury Deposit Made",2)
			Login_UpdateLastTreasury()
		 EndIf
		 ;If it doesn't appear to be accruing, then leave the LastTreasury date so it tries again next login.
		 ;There doesnt seem like a lot of potential to not work, if it looks like it is failing we can trying to invest again.
	  EndIf

   EndIf

   ClickCityScreen()

EndFunc

Func Logout()

   ;Logout Script
   If Not CheckForCityScreen(0) Then
	  ClickCityScreen()
   EndIf

   ;More panel
   SendMouseClick($MoreMenu[0],$MoreMenu[1])

   ;ConvertToDarkEnergy()

   ;Accounts
   If PollForColors($AccountButton[0],$AccountButton[1], $AccountButtonColors, 5000, "$AccountButtonColors at $AccountButton") Then
	  SendMouseClick($AccountButton[0],$AccountButton[1])
   Else
	  LogMessage("Dont have the account button to logout, clicking more again.")
	  SendMouseClick($MoreMenu[0],$MoreMenu[1])
	  If PollForColors($AccountButton[0],$AccountButton[1], $AccountButtonColors, 5000, "$AccountButtonColors at $AccountButton") Then
		 SendMouseClick($AccountButton[0],$AccountButton[1])
	  Else
		 ;Return False
		 SendMouseClick($AccountButton[0],$AccountButton[1])
	  EndIf
   EndIf

   ;Logout
   If PollForColor($LogoutButton[0],$LogoutButton[1], $LogoutButtonColor, 5000, "$LogoutButtonColor at $LogoutButton") Then
	  SendMouseClick($LogoutButton[0],$LogoutButton[1])
   Else
	  LogMessage("Dont have the logout button to logout")
	  Return False
   EndIf

   ;Yes Logout
   If PollForColor($LogoutYesButton[0],$LogoutYesButton[1], $LogoutYesButtonColor, 5000, "$LogoutYesButtonColor at $LogoutYesButton") Then
	  SendMouseClick($LogoutYesButton[0],$LogoutYesButton[1])
   Else
	  LogMessage("Dont have the account yes logout button")
	  Return False
   EndIf
   Sleep(1000)

EndFunc

Func OpenGOW($attempts)

   ;Make sure the VB is open
   ;WinActivate ("BlueStacks","")
   ;WinMove("BlueStacks","",$GOWVBHostWindow[0],$GOWVBHostWindow[1])

   WinMinimizeAll()
   Sleep(1000)

   LogMessage("Attempting to open GOW",1)
   ;Check if we have an Icon, if not try exiting GOW or using the home button for Android
   If Not PollForColor( $MSIcon[0],$MSIcon[1], $MSColor, 5000) Then
	  LogMessage("***  We dont have the Icon trying to reset")
	  Local $Tries = 1

	  ;Check if we have GOW open
	  If CheckForColor($AndroidHomeButton[0],$AndroidHomeButton[1], $Black) Then
		 While $Tries < 5
			SendMouseClick($AndroidHomeButton[0],$AndroidHomeButton[1])
			Sleep(1000)
			If CheckForColor($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1], $YesQuitWhite) Then
			   SendMouseClick($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1])
			   Sleep(2000)
			   ExitLoop
			Else
			   $Tries = $Tries +1
			EndIf
		 WEnd

	  ElseIf CheckForColor($AndroidHomeButtonBottom[0],$AndroidHomeButtonBottom[1], $Black) Then
		 LogMessage("Trying android bottom button")
		 SendMouseClick($AndroidHomeButtonBottom[0],$AndroidHomeButtonBottom[1])
		 Sleep(1000)
	  EndIf

	  ;Try using the android button again if we still don't have the icon
	  If Not CheckForColor( $MSIcon[0],$MSIcon[1], $MSColor) Then
		 $Tries = 1
		 LogMessage("***  We STILL dont have the Icon, checking for android back button")
		 While $Tries < 5
			If CheckForColor($AndroidHomeButtonBottom[0],$AndroidHomeButtonBottom[1], $Black) Then
			   LogMessage("Trying android bottom button attempt = " + $Tries)
			   SendMouseClick($AndroidHomeButtonBottom[0],$AndroidHomeButtonBottom[1])
			   Sleep(1000)
			EndIf

			$Tries = $Tries + 1
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
	  OpenGOW($attempts+1)
   EndIf


   WinMove("BlueStacks","",$GOWVBHostWindow[0],$GOWVBHostWindow[1],$GOWWindowSize[0],$GOWWindowSize[1])
   ;quit()

   Local $GOWOpen = False
   Local $1 = 0
   Local $winSize

   ;This shoudl check for the login screeen for 35 seconds and restart if it quits out before that by checking every 5 seconds for changed window size
   For $1 = 0 to 6 Step 1

	  ;Check for 5 seconds for the login button
	  If PollForColor($LoginButton[0],$LoginButton[1], $LoginButtonInitalColor, 5000, "$GreyedOutButton at $LoginButton") Then
		 ExitLoop
	  EndIf
	  $winSize = WinGetClientSize("BlueStacks")
	  ;Check if the window reset to the launcher
	  If($winSize[0] > $GOWWindowSize[0]) Then
		 ;Here we have the wide window so try opening again.
		 LogMessage("Looks like we exited out of GoW Screen back to Launcher")
		 OpenGOW($attempts+1)
	  EndIf
   Next


   If Not PollForColor($LoginButton[0],$LoginButton[1], $LoginButtonInitalColor, 5000, "$GreyedOutButton at $LoginButton") Then

	  LogMessage("Did not see login page")
	  ;Here we dont have a logout button. There are 3 scenarios
	  ;We black screened before the screen size changed. So move and resize the window and openGoW Again

	  ;We black screened and went back to launcher after we moved the window
	  $winSize = WinGetClientSize("BlueStacks")

	  If($winSize[0] > $GOWWindowSize[0]) Then
		 ;Here we have the wide window so try opening again.
		 LogMessage("Looks like we exited out of GoW Screen back to Launcher")
		 OpenGOW($attempts+1)
	  Else
		 ;here we have the narrow window so check to see if it looks like we are in GoW

		 If (CheckForColor($EmailPinCodeButton[0],$EmailPinCodeButton[1],$blue)) Then
			LogMessage("Looks like we are expecting a PIN")

			   ;Check for PIN Prompt using the stored PIN. Enter it and then sleep a bit and ESC the gold screen and logout.
			CheckForPinPrompt(StringToASCIIArray($storedPIN))
			Sleep(15000)

			Send("ESC")
			Sleep(2000)
			If PollForColor($ConnectionInteruptButton[0],$ConnectionInteruptButton[1],$Blue,3000, "$Blue at $ConnectionInteruptButton") Then
			   SendMouseClick($ConnectionInteruptButton[0],$ConnectionInteruptButton[1])
			   Sleep(500)
			EndIf
			Logout()
			Sleep(2000)
			OpenGOW($attempts+1)
		 Else
			If CheckForSessionTimeout() Then
			   LogMessage("Writing Login from OpenGOW function because of session timeout",1)
			   Login_Write()
			ElseIf (CheckForColor($GOWRandomSpotForBlankScreenCheck[0],$GOWRandomSpotForBlankScreenCheck[1],$black)) Then
			   LogMessage("Looks like we black screened before resizing")
			   ;WinMove("BlueStacks","",$GOWVBHostWindow[0],$GOWVBHostWindow[1],1152,720)
			   OpenGOW($attempts+1)
			ElseIf (CheckForColor($GOWRandomSpotForBlankScreenCheck[0],$GOWRandomSpotForBlankScreenCheck[1],$ExitAppErrorColor)) Then
			   LogMessage("Looks like we need to exit the game.")
			   ;WinMove("BlueStacks","",$GOWVBHostWindow[0],$GOWVBHostWindow[1],1152,720)
			   SendMouseClick($AndroidHomeButtonBottom[0],$AndroidHomeButtonBottom[1])
			   OpenGOW($attempts+1)
			Else
			   LogMessage("Looks like we are in GoW")
			   Send("ESC")
			   Sleep(2000)
			   If PollForColor($ConnectionInteruptButton[0],$ConnectionInteruptButton[1],$Blue,3000, "$Blue at $ConnectionInteruptButton") Then
				  SendMouseClick($ConnectionInteruptButton[0],$ConnectionInteruptButton[1])
				  Sleep(500)
			   EndIf
			   Logout()
			   Sleep(2000)
			   OpenGOW($attempts+1)
			EndIf
		 EndIf
	  EndIf

   EndIf

EndFunc

Func CloseGOW()

   If CheckForSessionTimeout() Then
	  LogMessage("Writing Login from CloseGOW function because of session time out",1)
	  Login_Write()
   Else

	  ;Check if we have GOW open
	  If CheckForColor($AndroidHomeButton[0],$AndroidHomeButton[1],$Black) Then

		 ;Attempt Logout
		 Logout()

		 ;If that didn't work quit
		 If CheckForColor($AndroidHomeButton[0],$AndroidHomeButton[1],$Black) Then
			SendMouseClick($AndroidHomeButton[0],$AndroidHomeButton[1])
			Sleep(1000)
			SendMouseClick($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1])
			Sleep(1000)
		 EndIf
	  Else
		 LogMessage("----- Looks like we arent in GOW -----",1)
	  EndIf

	  ;Make sure we release this city
	  ;Login_Write()
	  ;Making this not set the last login because we didn't always get all through it
	  Login_ResetInProcess()
   EndIf

   ;sleep 5 seconds to get everything cleaned up
   Sleep(5000)
EndFunc

Func CheckForPinPrompt($pinArray)
   ;LogMessage("Checking for PIN")
   ;Local $pinArray = StringToASCIIArray(Login_PIN())
   If PollForColor($FirstPinBox[0],$FirstPinBox[1],$PinBoxColor,3000, "$PinBoxColor at $FirstPinBox") Then
	  If CheckForColor($SecondPinBox[0],$SecondPinBox[1],$PinBoxColor) Then

		 LogMessage("PIN is needed",2)
		 Sleep(500)

		 If UBound($pinArray) < 4 Then
			LogMessage("PIN is needed, and not supplied.  Failed to login.",5)
			Return False
		 EndIf

		 SendMouseClick($FirstPinBox[0],$FirstPinBox[1])
		 For $i = 0 to UBound($pinArray)-1
			Send(Chr($pinArray[$i]))
			Sleep(500)
		 Next
		 Return True
	  Else
		 LogMessage("Pin Spot1 passed, spot 2 did not.")
		 LogMessage("Pin Spot2 is - " & PixelGetColor($SecondPinBox[0],$SecondPinBox[1]))
		 Return True ;Don't know why we are here but don't fail out
	  EndIf
   EndIf

   Return True

EndFunc

;Check for session timeout and if so click ok
Func CheckForSessionTimeout()
   If CheckForColor($CityMenu[0],$CityMenu[1],$Black) And PollForColor($SessionTimeoutButton[0],$SessionTimeoutButton[1],$SessionTimeoutButtonColor,500, "$Blue at $SessionTimeoutButton")  Then
	  SendMouseClick($SessionTimeoutButton[0],$SessionTimeoutButton[1])
	  LogMessage("Have Session Timeout",1)
	  $SleepOnLogout = 1
	  ;Sleeps for 1 minutes on session timeout.
	  Sleep(60000)
	  Return True
   EndIf

   Return False
EndFunc

Func ClickCityScreen()

   ;LogMessage("----- Checking for CityScreenColor: " & $CityScreenColor)
   If Not CheckForColor($CityMenu[0],$CityMenu[1],$CityScreenColor) Then
	  LogMessage("*** Got the wrong color for the city screen")
   Else
	  SendMouseClick($CityMenu[0],$CityMenu[1])
	  Sleep(2000)
   EndIf
EndFunc

Func ClickGoldButton()

   ;Sleep until the gold screen has come up
   ;Sleep(30000)

   LogMessage("Starting Gold Button search")
   ;Do a pixel search so that we find the gold button every? time.
   ;PollForPixelSearch($GoldSearchLeft,$GoldSearchTop,$GoldSearchRight,$GoldSearchBottom, $BuyGoldColor, 30000)
   ;LogMessage("Pixel Search Result: " & @error)
   For $i = 0 To 8 Step 1
      If CheckForColor($ConnectionInteruptButton[0],$ConnectionInteruptButton[1],$ConnectionInteruptButtonColor) Then
		 SendMouseClick($ConnectionInteruptButton[0],$ConnectionInteruptButton[1])
		 Sleep(1000)
	  EndIf
	  Sleep(500)
	  If (PollForPixelSearch($GoldSearchLeft,$GoldSearchTop,$GoldSearchRight,$GoldSearchBottom, $BuyGoldColor, 3000)) Then
		 Send("{ESC}")
		 Return True
	  EndIf
   Next

   Sleep(15000)
   LogMessage("*** Never got the gold button")
   Return False


EndFunc

;This also tries to return to the city screen
Func CheckForCityScreen($attempts)

   ;Check for the gold button
   Local $HasGoldButton = CheckForColor($GoldExitButton[0],$GoldExitButton[1],$GetGoldButton)
   ;Check for the map menu item
   Local $HasMapButton = CheckForColor($CityMenu[0],$CityMenu[1],$MapMenuColor)

   If $HasGoldButton AND $HasMapButton Then
	  ;LogMessage("Got City screen. Attempt=" & $attempts)
	  return True
   Else

	  ;Fourth atempt we don't know where we are, and couldn't get a city screen
	  If $attempts > 4 Then
		 Return False
	  EndIf

	  LogMessage("NO City screen. Attempt=" & $attempts)
	  ;LogMessage("Gold button color is " & PixelGetColor($GoldExitButton[0],$GoldExitButton[1]) & " - " & $GetGoldButton)
	  ;LogMessage("Map Menu color is " & PixelGetColor($CityMenu[0],$CityMenu[1]) & " - " & $MapMenuColor)
	  ;If this isn't the city screen try hitting escape, 4 times though recursion
	  Send("{ESC}")
	  Sleep(1000)

	  If PollForColor($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1],$YesQuitWhite, 500, "$YesQuitWhite at $QuitGameDialogYesButton in Check for City Screen") Then
		 ;Say No then try again
		 SendMouseClick($QuitGameDialogNoButton[0],$QuitGameDialogNoButton[1])
		 Sleep(1000)
		 Return CheckForCityScreen($attempts+1)
	  EndIf

	  ;If we are on the map click into the city
	  If CheckForColor($CityMenu[0],$CityMenu[1],$CityScreenColor) Then
		 SendMouseClick($CityMenu[0],$CityMenu[1])
		 Sleep(1000)
	  EndIf

	  ;Fourth atempt we don't know where we are, and couldn't get a city screen
	  If $attempts < 4 Then
		 Return CheckForCityScreen($attempts+1)
	  Else
		 ;All done here
		 Return False
	  EndIf

   EndIf

EndFunc

Func CheckForWorldScreen($attempts)

   If CheckForColor($CityMenu[0],$CityMenu[1],$CityScreenColor) Then
	  ;LogMessage("Got City screen. Attempt=" & $attempts)
	  return True
   Else

	  ;Fourth atempt we don't know where we are, and couldn't get a city screen
	  If $attempts > 4 Then
		 Return False
	  EndIf

	  LogMessage("NO Map screen. Attempt=" & $attempts & " Color found - " & PixelGetColor($CityMenu[0],$CityMenu[1]) & " not " & $CityScreenColor )
	  ;LogMessage("NO Map screen. Attempt=" & $attempts)
	  Send("{ESC}")
	  Sleep(1000)

	  If PollForColor($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1],$YesQuitWhite, 500, "$YesQuitWhite at $QuitGameDialogYesButton in Check for World Screen") Then
		 ;Say No then try again
		 SendMouseClick($QuitGameDialogNoButton[0],$QuitGameDialogNoButton[1])
		 Sleep(1000)
		 Return CheckForWorldScreen($attempts+1)
	  EndIf

	  ;If we are on the City click into the city
	  If CheckForColor($CityMenu[0],$CityMenu[1],$MapMenuColor) Then
		 SendMouseClick($CityMenu[0],$CityMenu[1])
		 Sleep(1000)
	  EndIf

	  ;Fourth atempt we don't know where we are, and couldn't get a city screen
	  If $attempts < 4 Then
		 Return CheckForWorldScreen($attempts+1)
	  Else
		 ;All done here
		 Return False
	  EndIf

   EndIf

EndFunc

Func SaveCityImage()
   SaveImage('CityImage',$CityImage[0],$CityImage[1],$CityImage[2],$CityImage[3])
EndFunc

Func SaveRSSImage()
   SaveImage('RSSImage',$RssImage[0],$RssImage[1],$RssImage[2],$RssImage[3])
EndFunc

Func SaveGoldImage()
   SaveImage('GoldImage',$GoldImage[0],$GoldImage[1],$GoldImage[2],$GoldImage[3])
EndFunc

Func SaveHeroImage()
   SaveImage('HeroImage',$HeroImage[0],$HeroImage[1],$HeroImage[2],$HeroImage[3])
EndFunc

Func SaveTreasuryImage()
   SaveImage('TreasuryImage',$TreasuryImage[0],$TreasuryImage[1],$TreasuryImage[2],$TreasuryImage[3])
EndFunc

Func SaveShieldCountImage()
   SaveImage('ShieldCount',$ShieldCount[0],$ShieldCount[1],$ShieldCount[2],$ShieldCount[3])
EndFunc

Func SaveShieldTimeImage()
   SaveImage('ShieldTime',$ShieldTime[0],$ShieldTime[1],$ShieldTime[2],$ShieldTime[3])
EndFunc

Func SaveRSSProductionImage()
   SaveImage('RSSProduction',$RssProduction[0],$RssProduction[1],$RssProduction[2],$RssProduction[3])
EndFunc

Func SaveSilverProductionImage()
   SaveImage('SilverProduction',$SilverProduction[0],$SilverProduction[1],$SilverProduction[2],$SilverProduction[3])
EndFunc

