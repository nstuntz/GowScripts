#include-once
#include "MSConstantsBluestacks.au3"
#include "MSLocalConstantsBluestacks.au3"
#include "MachineConfig.au3"
#include "LoginObject.au3"
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <File.au3>
#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#include <Inet.au3>
#include "Email.au3"

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





Func RedeemCode()

   Return

   If StringLen(Login_RedeemCode()) = 0 Then
	  Return
   EndIf

   LogMessage("Redeeming Code = " & Login_RedeemCode(),2)

   ;Collect the Daily Quest
   SendMouseClick($MoreMenu[0],$MoreMenu[1])
   Sleep(2000)
   MouseClickDrag("left",941,410,555,418,20)
   Sleep(1000)
   SendMouseClick($RedeemButton[0],$RedeemButton[1])
   Sleep(1000)
   SendMouseClick(683,577)
   Sleep(1000)

   ;TypeCode
   Send(Login_RedeemCode())
   Sleep(2500)
   ;click done
   SendMouseClick(750,509)
   Sleep(3000)

   ;Ok button
   If CheckForColor(750,509,$BlueOKButton) Then
	  ;SendMouseClick(750,509)
   Else
	  ;MsgBox(0,"Bad Code","Bad Code")
	  ;SendMouseClick(668,530)
   EndIf
   Send("{ESC}")

   Sleep(2000)

   ;Type Escape to back out to the more menu
   Send("{ESC}")
   Sleep(2000)

   ;Reset the More menus so logout works
   MouseClickDrag("left",555,418,941,410,20)
   Sleep(1500)

   Login_RedeemCodeCollected()

   ;Return to City Screen
   ClickCityScreen()
EndFunc

Func CollectAllCityQuests()

   LogMessage("Collecting All Empire Quests",2)
   ;Open Quests screen
   SendMouseClick($QuestsMenu[0],$QuestsMenu[1])
   Sleep(2000)

   ;Open CIty Quests
   SendMouseClick($QuestsEmpire[0],$QuestsEmpire[1])
   Sleep(2000)

   Local $heroLevelCount = 0
   ;While PollForGreen at quest spot
   While PollForColor($QuestsEmpireCollect[0],$QuestsEmpireCollect[1], $GreenCollect, 5000)

	  ;Click it
	  SendMouseClick($QuestsEmpireCollect[0],$QuestsEmpireCollect[1])
	  Sleep(500)

	  ;Poll for hero upgrade
	  If PollForColor($QuestsHeroLeveledUpOkButton[0],$QuestsHeroLeveledUpOkButton[1], $QuestsHeroLeveledUpOkButtonColor, 3000) Then

		 SendMouseClick($QuestsHeroLeveledUpOkButton[0],$QuestsHeroLeveledUpOkButton[1])
		 Sleep(500)
		 $heroLevelCount += 1
		 ;click ok
	  EndIf

   WEnd

   If $heroLevelCount > 0 Then
	  Login_WriteHeroUpgradeNeeded()
   EndIf

   LogMessage("Collecting All Empire Quests - Hero levels gained = " & $heroLevelCount,2)

   ClickCityScreen()

EndFunc


Func CollectAllTokens()

   LogMessage("Collecting All Tokens",2)
   ;Open Items screen
   SendMouseClick($ItemsMenu[0],$ItemsMenu[1])
   Sleep(3000)

   ;Open My Items
   SendMouseClick($MyItemsMenu[0],$MyItemsMenu[1])
   Sleep(3000)

   ;Open Resouces
   SendMouseClick($ResoucesMenu[0],$ResoucesMenu[1])
   Sleep(3000)

   Local $haveToken = False
   Do

	  If PollForColor($FirstToken[0],$FirstToken[1], $GreenCollect, 5000) Then
		 ;Click it
		 SendMouseClick($FirstToken[0],$FirstToken[1])
		 Sleep(500)
		 $haveToken = True
	  Else
		If PollForColor($SecondToken[0],$SecondToken[1], $GreenCollect, 5000) Then
			;Click it
			SendMouseClick($SecondToken[0],$SecondToken[1])
			Sleep(500)
			$haveToken = True
		 Else
			$haveToken = False
		 EndIf
	  EndIf
   Until (Not $haveToken)

   LogMessage("Done collecting all tokens",2)

   ClickCityScreen()

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

Func Chests()

   Local $openedChests = 0

   SendMouseClick($ItemsMenu[0], $ItemsMenu[1])
   Sleep(3000)
   SendMouseClick($MyItemsMenu[0], $MyItemsMenu[1])
   Sleep(3000)
   SendMouseClick($TreasuresMenu[0], $TreasuresMenu[1])
   Sleep(3000)

   Local $HaveChest = True

   While $HaveChest

	  ;If we can get or clear a gift, do it and keep looping
	  If PollForColor($FirstItem[0], $FirstItem[1],$GreenCollect,10000) Then
		 SendMouseClick($FirstItem[0],$FirstItem[1])
		 If PollForTwoColors($ChestOpenBeige[0], $ChestOpenBeige[1],$ChestOpenBeigeColor,$ChestOpenBeigeColorAlt,7000) Then
			Send("{ESC}")
			$openedChests +=1
		 EndIf
	  Else
		 If CheckForColor($SecondItem[0], $SecondItem[1],$GreenCollect) Then
			SendMouseClick($SecondItem[0],$SecondItem[1])

			If PollForTwoColors($ChestOpenBeige[0], $ChestOpenBeige[1],$ChestOpenBeigeColor,$ChestOpenBeigeColorAlt,7000) Then
			   Send("{ESC}")
			   $openedChests +=1
			EndIf

		 Else
			$HaveChest = False
		 EndIf
	  EndIf
   WEnd

   ;City Menu
   ClickCityScreen()

   Return $openedChests

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


;Assumes you are in the market place ready to send, and gets back to that point
Func SendRSS_TryTwo($type, $nonSilverType)

	  Local $helpOffsetX = (Login_RSSBank() - 1) * $HelpNumberOffsetX

	  If ($type = $eSilver) Then
		 $helpOffsetX = (Login_SilverBank() - 1) * $HelpNumberOffsetX
	  EndIf

	  ;Poll for first Help button
	  If PollForColor($HelpTopMember[0],$HelpTopMember[1], $Blue, 5000, "$Blue at $HelpTopMember(1)") Then
		 SendMouseClick($HelpTopMember[0] ,$HelpTopMember[1] + $helpOffsetX)
	  ElseIf PollForColor($RSSHelpButton[0],$RSSHelpButton[1], $Blue, 4000, "$Blue at $RSSHelpButton - If need be") Then
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
	  SendMouseClick($HelpRSSMax[$type][0],$HelpRSSMax[$type][1])
	  ;move the mouse then check and click
	  MouseMove($RSSHelpButton[0],$RSSHelpButton[1])
	  If PollForColor($RSSHelpButton[0],$RSSHelpButton[1], $Blue, 4000, "$Blue at $RSSHelpButton") Then
		 SendMouseClick($RSSHelpButton[0],$RSSHelpButton[1])
	  Endif

	  If PollForColor($HelpTopMember[0],$HelpTopMember[1], $Blue, 3000, "$Blue at $HelpTopMember(2)") Then
		 return True
	  EndIf


		 ;delay until the top help is back
	  If PollForColor($HelpTopMember[0],$HelpTopMember[1], $Blue, 3000, "$Blue at $HelpTopMember(3)") Then
		 ;Do nothing this is
	  Else
		 ;Should check if the help button didn't really get clicked
		 If PollForColor($RSSHelpButton[0],$RSSHelpButton[1], $Blue, 3000) Then
			SendMouseClick($RSSHelpButton[0],$RSSHelpButton[1])
			Sleep(1000)
		 EndIf
	  Endif

	  ;Check for max send
	  If CheckForColor($MaxMarchesExceeded[0],$MaxMarchesExceeded[1],$Blue) Then
		 SendMouseClick($MaxMarchesExceeded[0],$MaxMarchesExceeded[1])
		 return false
	  Endif

	  ;Check for Rally screen - Could do this using the check sum for Alliance War at the top of the screen
	  ;If neither the done button is there or the top help is there check for rally screen
	  ;If Not (CheckForColor($HelpTopMember[0],$HelpTopMember[1],$Blue) OR CheckForColor($RSSHelpButton[0],$RSSHelpButton[1],$Blue)) Then
	  IF (PollForColorTwoPlaces($HelpTopMember[0],$HelpTopMember[1],$RSSHelpButton[0],$RSSHelpButton[1],$Blue, 4000, "Polling for $Blue in both helps places")) Then
		 return true
	  Else
		 ;Couldnt find either button after 4 seconds. Probably on the rally screen
		 LogMessage("Seems like we are not in the marketplace anymore. Hitting ESC - nope")
		 ;Send("{ESC}")
		 Sleep(500)
		 If Not (CheckForColor($HelpTopMember[0],$HelpTopMember[1],$Blue) OR CheckForColor($RSSHelpButton[0],$RSSHelpButton[1],$Blue)) Then
			Return false
		 EndIf
	  EndIf


	  return true

EndFunc

Func ConvertToDarkEnergy()


   If(PollForColor($InitialConvert[0], $InitialConvert[1],$blue, 2000)) Then
	  LogMessage("We have the convert to dark energy popup", 1)
	  ; we have the convert button
	  SendMouseClick($InitialConvert[0], $InitialConvert[1])
	  If(PollForColor($ConvertConfirm[0], $ConvertConfirm[1],$blue,3000)) Then
		 SendMouseClick($ConvertConfirm[0], $ConvertConfirm[1])
		 If(PollForColor($ConvertAccept[0], $ConvertAccept[1],$blue,3000)) Then
			SendMouseClick($ConvertAccept[0], $ConvertAccept[1])
		 EndIf
	  EndIf
	  Sleep(2000)
   EndIf

EndFunc

Func Rally()

   If Login_Shield() = 1 OR Login_Rally() = 0 Then
	  Return
   EndIf

   If (Login_RallyX() < 1 or Login_RallyX() > 512 ) OR (Login_RallyY() < 1 OR Login_RallyY() > 1024) Then
	  LogMessage("Rally Coords are bad (" & Login_RallyX() & "," & Login_RallyY() & ")",4)
	  Return
   EndIf

   ;Check if we need to rally
   Local $minonRally = 480 ;1440= 24Hr ,  4320 = 3 day
   If ($minonRally - (_DateDiff('n',Login_LastRally(),GetNowUTCCalc()))) > (Login_LoginDelay()*1.2) Then
	  LogMessage("No Need to Rally, Minutes left = " & ($minonRally - (_DateDiff('n',Login_LastRally(),GetNowUTCCalc()))),2)
	  Return
   EndIf

   LogMessage("Starting Rally process",2)

   If Not CheckForCityScreen(0) Then
	  LogMessage("No city screen to start rallying, trying to get there")
	  ClickCityScreen()

	  If Not CheckForCityScreen(0) Then
		 LogMessage("No city screen to start rallying, Canceling Rally",3)
		 Return
	  EndIf
   EndIf

   ;Heal any troops in the hospital
   If PollForTwoColors($HospitalCross[0],$HospitalCross[1],$HospitalCrossColor,$HospitalCrossColorAlt, 1000,"$HospitalCrossColor at $HospitalCross" ) Then

	  SendMouseClick($HospitalBuilding[0],$HospitalBuilding[1])
	  Sleep(1000)
	  SendMouseClick($HospitalQueueAllButton[0],$HospitalQueueAllButton[1])
	  Sleep(1000)
	  SendMouseClick($HospitalHealButton[0],$HospitalHealButton[1])
	  Sleep(1000)

	  ClickCityScreen()
   EndIf

   ;Check for Rally to cancel
   SendMouseClick($MoreMenu[0],$MoreMenu[1])

   ;Added to handle the convert to dark energy on 7/17 - GS
   ;ConvertToDarkEnergy()

   If PollForTwoColors($MarchesButton[0],$MarchesButton[1],$MarchesButtonColor,$MarchesButtonColorAlt,4000,"$MarchesButtonColor at $MarchesButton") Then
	  SendMouseClick($MarchesButton[0],$MarchesButton[1])
	  Sleep(1000)
   ElseIf PollForTwoColors($MarchesButton2[0],$MarchesButton2[1],$MarchesButtonColor,$MarchesButtonColorAlt,4000,"$MarchesButtonColor at $MarchesButton") Then
	  SendMouseClick($MarchesButton2[0],$MarchesButton2[1])
	  Sleep(1000)
   EndIf

   Local $i = 0
   For $i = 0 to 2
	  If PollForColor($RallyAttackButton[0],$RallyAttackButton[1]+($RallyAttackButtonOffsetY*$i),$RallyAttachButtonColor, 500, "$RallyAttachButtonColor at $RallyAttackButton") Then
		 SendMouseClick($RallyCancelButton[0],$RallyCancelButton[1]+($RallyAttackButtonOffsetY*$i))
		 Sleep(1000)
		 SendMouseClick($RallyCancelConfirmButton[0],$RallyCancelConfirmButton[1])
		 Sleep(1000)
		 LogMessage("Rally Cancelled.",2)
		 ExitLoop
	  Else
		 LogMessage("No Rally  to Cancel.",2)
	  EndIf
   Next

   ;We are on the marches screen so click the city menu twice
   SendMouseClick($CityMenu[0],$CityMenu[1])
   Sleep(2000)
   SendMouseClick($CityMenu[0],$CityMenu[1])

#comments-start
   ;Make sure we are on the world screen
   If Not CheckForWorldScreen(0) Then
	  SendMouseClick($CityMenu[0],$CityMenu[1])
	  Sleep(2000)

   Else

   EndIf

#comments-end

   ;Not needed since we are sure we are on the world screen
   ;Check that we have the search button
   If Not PollForColors($SearchKingdomButton[0],$SearchKingdomButton[1],$SearchKingdomButtonColors, 4000,"$SearchKingdomButtonColor at $SearchKingdomButton") Then
	  SendMouseClick($CityMenu[0],$CityMenu[1])
	  If Not PollForTwoColors($SearchKingdomButton[0],$SearchKingdomButton[1],$SearchKingdomButtonColor,$SearchKingdomButtonColorAlt,4000,"$SearchKingdomButtonColor at $SearchKingdomButton(2)") Then
		 LogMessage("Rally Failed.",4)
		 LogMessage("No World screen to search for rallying target, canceling process",5)
		 Login_UpdateLastRallyFAILED()
		 ClickCityScreen()
		 Return
	  EndIf
   EndIf

   Local $HaveRallyCity = 0
   While $HaveRallyCity < 4
	  ;click search button
	  SendMouseClick($SearchKingdomButton[0],$SearchKingdomButton[1])

	  If PollForColors($SearchKingdomX[0],$SearchKingdomX[1],$WhiteArray,3000 ,"$WhiteArray at $SearchKingdomX") Then
		 ;input X
		 SendMouseClick($SearchKingdomX[0],$SearchKingdomX[1])
		 Sleep(1000)
		 Send(Login_RallyX())
		 Sleep(1000)
	  Else
		 $HaveRallyCity += 1
		 ContinueLoop
	  EndIf

	  If PollForColors($SearchKingdomY[0],$SearchKingdomY[1],$WhiteArray,3000,"$WhiteArray at $SearchKingdomY") Then
		 ;input y
		 SendMouseClick($SearchKingdomY[0],$SearchKingdomY[1])
		 Sleep(1000)
		 Send(Login_RallyY())
		 Sleep(1000)
	  Else
		 $HaveRallyCity += 1
		 ContinueLoop
	  EndIf

	  SendMouseClick($SearchKingdomGoButton[0],$SearchKingdomGoButton[1])
	  Sleep(2000)

	  ;Any way to tell here if the screen is loaded?

	  ;Click on the city
	  SendMouseClick($WorldMapCityButton[0],$WorldMapCityButton[1])
	  Sleep(1000)

	  ;Check if we got an alliance city
	  If PollForColor($RallyRssHelpButton[0],$RallyRssHelpButton[1],$Blue,1000,"$Blue at $RallyRssHelpButton - should fail") Then
		 $HaveRallyCity += 1
	  Else
		 ;Not sure why this is needed but it seems to be
		 MouseMove($RallyButton[0],$RallyButton[1])
		 Sleep(250)

		 ;Make sure we got the city
		 If PollForColor($RallyButton[0],$RallyButton[1],$Blue,1000, "$Blue at $RallyButton - should fail") Then
			ExitLoop
		 Else
			$HaveRallyCity += 1
		 EndIf

	  EndIf
   WEnd

   If $HaveRallyCity >= 4  Then
	  LogMessage("Can not get city rallying target, cancelling process",4)
	  Login_UpdateLastRallyFAILED()
	  ClickCityScreen()
	  Return
   EndIf

	;No poll here since it is in the loop
   SendMouseClick($RallyButton[0],$RallyButton[1])

   ;Click the 8 Hour check mark
   If PollForColor($Rally8HourCheckBox[0],$Rally8HourCheckBox[1], $White, 2000, "$White at $Rally8HourCheckBox") Then
	SendMouseClick($Rally8HourCheckBox[0],$Rally8HourCheckBox[1])
   Endif

   ;Click the Set button
   If PollForColor($RallySetButton[0],$RallySetButton[1],$Blue,3000, "$Blue at $RallySetButton" ) Then
	  SendMouseClick($RallySetButton[0],$RallySetButton[1])
   Else
	  LogMessage("Can not rally find set button for rallying target, cancelling process",4)
	  Login_UpdateLastRallyFAILED()
	  ClickCityScreen()
	  Return
   EndIf

   ;Click the Queue Max button
   If PollForColor($RallyQueueMaxButton[0],$RallyQueueMaxButton[1],$Blue,2000, "$Blue at $RallyQueueMaxButton" ) Then
	SendMouseClick($RallyQueueMaxButton[0],$RallyQueueMaxButton[1])
   EndIf

   ;Click the Send button
   If PollForColor($RallySendButton[0],$RallySendButton[1],$Blue,2000, "$Blue at $RallySendButton") Then
	SendMouseClick($RallySendButton[0],$RallySendButton[1])
	Sleep(2000)
   EndIf

   ;Update Last Rally
   Login_UpdateLastRally()

   ;Click City Screen
   SendMouseClick($CityMenu[0],$CityMenu[1])
   Sleep(2000)
   LogMessage("Rally set",2)

EndFunc


Func CollectAllQuestsWithChances($Daily, $Alliance)

   Local $ChancesCount = 0
   ;Start on the city Screen
   If $Daily Then
	  SendMouseClick($QuestsMenu[0],$QuestsMenu[1])
	  Sleep(2000)
	  SendMouseClick($QuestsDaily[0],$QuestsDaily[1])
	  Sleep(2000)
	  $ChancesCount += CollectAllQuestsFromScreen()
   EndIf

   If $Alliance Then
	  SendMouseClick($QuestsMenu[0],$QuestsMenu[1])
	  Sleep(2000)
	  SendMouseClick($QuestsAliaance[0],$QuestsAliaance[1])
	  Sleep(2000)
	  $ChancesCount += CollectAllQuestsFromScreen()
   EndIf

   Return $ChancesCount

EndFunc

Func CollectAllQuestsFromScreen()

   If Not CheckForColor($QuestsCollect[0],$QuestsCollect[1],$Blue) Then
	  ;MsgBox(0,"Paused","Looks like No VIP on, please put on at least a couple of hours, and start the first chance so a quest shows, then return here")
   EndIf

   Local $HaveChances = True
   Local $HaveQuests = True
   Local $ChancesCount = 0

   While ($HaveChances)
	  $ChancesCount += 1

	  While $HaveQuests
		 If (PollForColor($QuestsCollect[0],$QuestsCollect[1],$Blue, 3000)) Then
			SendMouseClick($QuestsCollect[0],$QuestsCollect[1])
			Sleep(250)

		 Else
			$HaveQuests = False
		 EndIf

	  WEnd

	  MouseMove($QuestChance[0],$QuestChance[1])
	  If (PollForColor($QuestChance[0],$QuestChance[1],$Orange, 4000)) Then
		 SendMouseClick($QuestChance[0],$QuestChance[1])
		 Sleep(500)

		 If CheckForColor($QuestChanceUseButton[0],$QuestChanceUseButton[1],$GreenCollect) Then
			SendMouseClick($QuestChanceUseButton[0],$QuestChanceUseButton[1])
			Sleep(1000)
			$HaveQuests = True
		 Else
			Send("{ESC}")
			$HaveChances = False
		 EndIf
	  Else
		 ;Check for hero upgrade
		 If PollForColor($QuestsHeroLeveledUpOkButton[0],$QuestsHeroLeveledUpOkButton[1], $Blue, 2000) Then
			SendMouseClick($QuestsHeroLeveledUpOkButton[0],$QuestsHeroLeveledUpOkButton[1])
			Sleep(500)
			$HaveQuests = True
		 Else
			;MsgBox(0,"Paused","No Chance button.  No clue where we are.")
			$HaveChances = False;
		 EndIf
	  EndIf
   Wend
   return $ChancesCount
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


Func SendMouseClick($x,$y)

   MouseMove($x,$y)
   Sleep(100)
   MouseDown("left")
   Sleep(100)
   MouseUp("left")
   ;$success = MouseClick("left",$x,$y)

EndFunc

Func OpenGOW($attempts)

   ;Make sure the VB is open
   ;WinActivate ("BlueStacks","")
   ;WinMove("BlueStacks","",$GOWVBHostWindow[0],$GOWVBHostWindow[1])

   WinMinimizeAll()
   Sleep(1000)

   LogMessage("Attempting to open GOW",1)
   ;Check if we have an Icon, if not try exiting GOW or using the home button for Android
   If Not PollForColor( $GOWIcon[0],$GOWIcon[1], $GOWColor, 5000) Then
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
	  If Not CheckForColor( $GOWIcon[0],$GOWIcon[1], $GOWColor) Then
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
   SendMouseClick($GOWIcon[0],$GOWIcon[1])
   sleep(100)
   SendMouseClick($GOWIcon[0],$GOWIcon[1])
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

;Func SaveShieldTimeImage($ShieldTimeL,$ShieldTimeT,$ShieldTimeR,$ShieldTimeB)
;   SaveImage('ShieldTime',$ShieldTimeL,$ShieldTimeT,$ShieldTimeR,$ShieldTimeB)
;EndFunc

Func SaveShieldTimeImage()
   SaveImage('ShieldTime',$ShieldTime[0],$ShieldTime[1],$ShieldTime[2],$ShieldTime[3])
EndFunc



Func SaveRSSProductionImage()
   SaveImage('RSSProduction',$RssProduction[0],$RssProduction[1],$RssProduction[2],$RssProduction[3])
EndFunc
Func SaveSilverProductionImage()
   SaveImage('SilverProduction',$SilverProduction[0],$SilverProduction[1],$SilverProduction[2],$SilverProduction[3])
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

Func quit()
   Exit
EndFunc

Func GetNowUTCCalc()
   return _Date_Time_SystemTimeToDateTimeStr(_Date_Time_GetSystemTime(),1)
EndFunc

