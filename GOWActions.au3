#include-once
#include "GowConstants.au3"
#include "MachineConfig.au3"
#include "LoginObject.au3"
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <File.au3>
#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>

Global $isLoggedOut = 0
Global $isSessionTimeout = False

;1 = didn't build move to the Next
;2 = build, save it logout
;0 = done building, it really looks like we tried to speed one up
;-1 = Didn't get a building to upgrade
Func UpgradeBuilding($x,$y,$buildingNumber)

   ;Bail if we shouldn't be here
   If Login_Upgrade() = 0  Then
	  LogMessage("We are not supposed to upgrade this city")
	  return 0
   EndIf

   ;Click the desired building
   SendMouseClick($x,$y)
   Sleep(2000)

   ;CHeck if we got into a building
   If Not CheckForColor($BuildingUpgradeHelpButton[0],$BuildingUpgradeHelpButton[1], $Blue)  Then

	  ;Check if this is a maxed building,m if so move on.
	  If (PixelChecksum ($MaxedBuildingCoords[0], $MaxedBuildingCoords[1], $MaxedBuildingCoords[2], $MaxedBuildingCoords[3])) = $MaxedBuildingCheckSum Then
		 LogMessage("Maxed building at = " & $buildingNumber & "," & $x & "," & $y )
		 Send("{ESC}")
		 Sleep(500)
		 return -1
	  EndIf

	  LogMessage("*** Bad Building = " & $buildingNumber & "," & $x & "," & $y )
	  Send("{ESC}")
	  Sleep(500)
	  Send("{ESC}")
	  Sleep(500)
	  Send("{ESC}")
	  Sleep(500)
	  Send("{ESC}")
	  Sleep(500)

	  ;Check if we have the exit box, if so click no
	  If CheckForColor($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1], $YesQuitWhite)  Then
		 SendMouseClick($QuitGameDialogNoButton[0],$QuitGameDialogNoButton[1])
		 Sleep(1000)
	  EndIf

	  return -1
   EndIf

   ;Click Upgrade - It is a good one
   SendMouseClick($BuildingUpgradeButton[0],$BuildingUpgradeButton[1])
   Sleep(2000)

   ;Check if we can upgrade this building - If we can't, try the next one
   If Not CheckForColor($BuildingUpgradeHelpButton[0],$BuildingUpgradeHelpButton[1], $Blue)  Then
	  Send("{ESC}")
	  Sleep(500)
	  Send("{ESC}")
	  Sleep(500)
	  return 1
   EndIf

   ;Click Upgrade Again
   SendMouseClick($BuildingUpgradeButton[0],$BuildingUpgradeButton[1])
   Sleep(1000)

   ;If this is SH5 then click the teleports OK button
   If Login_StrongHoldLevel() = 5 Then
	  if CheckForColor($StrongHoldUpgradeBeginTeleYesButton[0],$StrongHoldUpgradeBeginTeleYesButton[1],$Blue) Then
		 SendMouseClick($StrongHoldUpgradeBeginTeleYesButton[0],$StrongHoldUpgradeBeginTeleYesButton[1])
	  EndIf
   EndIf
   Sleep(2500)

   ;Click the help/free button, no way to tell since the button is transparent
   ;First check if we got the speedup button
   If CheckForColor($SpeedupNoButton[0],$SpeedupNoButton[1],$RedNoButton) Then
	  LogMessage("We got the speedup button so we are already building")
	  ;For Paranoia hit escape alot to move back to the city screen and then the quit game dialog and then say no to that
	  Send("{ESC}")
	  Sleep(500)
	  Send("{ESC}")
	  Sleep(500)
	  Send("{ESC}")
	  Sleep(500)
	  return 0
   Else
	  Local $BuildingReturn = 2
	  ;If you got a purple free button move on to the next building too
	  If CheckForColor($BuildingUpgradeHelpButton[0],$BuildingUpgradeHelpButton[1],$Purple) Then
		 $BuildingReturn = 1
	  Endif

	  ;We dont' know what color this is because of the transparencey.  So probably any SH under 5 should try the next one or something
	  SendMouseClick($BuildingUpgradeHelpButton[0],$BuildingUpgradeHelpButton[1])
	  Sleep(3000)
	  LogMessage("Built Building Number = " & $buildingNumber & " at " & $x & "," & $y)
	  return $BuildingReturn
   EndIf

   return 0
EndFunc

Func Login($email, $pwd)

   If Not CheckForColor( $UserNameTextBox[0],$UserNameTextBox[1], $UserNameTextBoxColor) Then
	  Sleep(1000) ;wait 1 more seconds

	  ;Check the color again
	  If Not CheckForColor( $UserNameTextBox[0],$UserNameTextBox[1], $UserNameTextBoxColor) Then
		 LogMessage("No UsernameText box Checking if we are already logged in ")

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
   EndIf

   ;UserName
   SendMouseClick($UserNameTextBox[0],$UserNameTextBox[1])
   Sleep(2000)

   If StringLen($email) > 15 Then

	  Local $emailArray = StringToASCIIArray($email)
	  For $i = 0 to UBound($emailArray)-1
		 Send(Chr($emailArray[$i]))
		 Sleep(200)
	  Next
   Else
	  Send($email)
   EndIf
   Sleep(4000)

   ;Password
   SendMouseClick($PasswordTextBox[0],$PasswordTextBox[1])
   Sleep(4500)

   Send($pwd)

   ;Check that the login button is there
   If Not PollForColor($LoginButton[0],$LoginButton[1],$Blue,5000) Then
	  return False
   EndIf

   ;Login Button
   SendMouseClick($LoginButton[0],$LoginButton[1])

   ;Now check for a Pin
   CheckForPinPrompt()

   ;Now exit the gold buy button
   Local $ClickedGoldScreen = False
   $ClickedGoldScreen = ClickGoldButton()
   Sleep(3000) ;3 seconds because of the quest poping up

   ;Assume if there was a gold screen then we logged in ok and set the city/map colors
   If $ClickedGoldScreen Then
	  If Not CheckForColor($CityMenu[0],$CityMenu[1],$MapMenuColor) Then
		 LogMessage("******************* Resetting City and Map Colors ***********************")
		 $MapMenuColor  = PixelGetColor($CityMenu[0],$CityMenu[1])
		 LogMessage("New City Color = " & $MapMenuColor )
		 SendMouseClick($CityMenu[0],$CityMenu[1])
		 Sleep(2000)
		 $CityScreenColor = PixelGetColor($CityMenu[0],$CityMenu[1])
		 LogMessage("New Map Color = " & $CityScreenColor )
		 SendMouseClick($CityMenu[0],$CityMenu[1])
		 Sleep(2000)
	  EndIf
   EndIf

   ;If we didn't get the fity screen bailout
   If Not CheckForCityScreen(0) Then
	  LogMessage("NO city screen after login, in login function")
	  return False
   EndIf

   return True
EndFunc

Func CollectAthenaGift()

   If Login_CollectAthenaGift() = 0 Then
	  Return
   EndIf

   LogMessage("Collecting Athena Gift")

   ;Collect the bouncer
   SendMouseClick($AthenaGift[0],$AthenaGift[1])
   Sleep(2000)
   SendMouseClick($AthenaGiftCollectButton[0],$AthenaGiftCollectButton[1])
   Sleep(3500) ; logner sleet because it pops stuff up

   Login_AthenaGiftCollected()

EndFunc

Func CollectSecretGift()
   ;Collect the bouncer
   SendMouseClick($SecretGift[0],$SecretGift[1])
   Sleep(2000)
   SendMouseClick($SecretGiftCollectButton[0],$SecretGiftCollectButton[1])
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

   ;Collect the Aliance Quest
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

   ;Return to City Screen
   ClickCityScreen()
EndFunc

Func RedeemCode()

   Return

   If StringLen(Login_RedeemCode()) = 0 Then
	  Return
   EndIf

   LogMessage("Redeeming Code = " & Login_RedeemCode())

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

Func Helps()

   If CheckForColor($HelpButton[0], $HelpButton[1],$HelpButtonColor) Then
	  SendMouseClick($HelpButton[0], $HelpButton[1])
	  Sleep(2000)
	  ;Help All
	  SendMouseClick($AllianceHelpHelpAllButton[0],$AllianceHelpHelpAllButton[1])
	  Sleep(2000)

	  ;City Menu
	  ClickCityScreen()
   EndIf
EndFunc

Func CollectAllCityQuests()

   LogMessage("Collecting All Empire Quests")
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
	  If PollForColor($QuestsHeroLeveledUpOkButton[0],$QuestsHeroLeveledUpOkButton[1], $Blue, 3000) Then

		 SendMouseClick($QuestsHeroLeveledUpOkButton[0],$QuestsHeroLeveledUpOkButton[1])
		 Sleep(500)
		 $heroLevelCount += 1
		 ;click ok
	  EndIf

   WEnd

   If $heroLevelCount > 0 Then
	  Login_WriteHeroUpgradeNeeded()
   EndIf

   LogMessage("Collecting All Empire Quests - Hero levels gained = " & $heroLevelCount)

   ClickCityScreen()

EndFunc

Func Gifts()

   If CheckForColor($GiftBox[0], $GiftBox[1],$GiftBoxColor) Then
	  ;Alliance menu
	  SendMouseClick($AllianceMenu[0], $AllianceMenu[1])
	  Sleep(3000)

	  ;Get Gifts button
	  SendMouseClick($GiftButton[0],$GiftButton[1])
	  Sleep(2000)

	  Local $HaveGift = True

	  While $HaveGift

		 ;If we can get or clear a gift, do it and keep looping
		 If CheckForColor($GiftGetClearButton[0], $GiftGetClearButton[1],$BlueOKButton)  Or CheckForColor($GiftGetClearButton[0], $GiftGetClearButton[1],$GiftGetClearButtonRed) Then
			SendMouseClick($GiftGetClearButton[0],$GiftGetClearButton[1])
			Sleep(2000)
		 Else
			$HaveGift = False
		 EndIf
	  WEnd

	  ;City Menu
	  ClickCityScreen()
   EndIf
EndFunc

Func Chests()

   SendMouseClick($ItemsMenu[0], $ItemsMenu[1])
   Sleep(2000)
   SendMouseClick($MyItemsMenu[0], $MyItemsMenu[1])
   Sleep(2000)
   SendMouseClick($TreasuresMenu[0], $TreasuresMenu[1])
   Sleep(2000)

   Local $HaveChest = True

   While $HaveChest

	  ;If we can get or clear a gift, do it and keep looping
	  If PollForColor($FirstItem[0], $FirstItem[1],$GreenCollect,4000) Then
		 SendMouseClick($FirstItem[0],$FirstItem[1])
		 Sleep(3000)
		 Send("{ESC}")
	  Else
		 If CheckForColor($SecondItem[0], $SecondItem[1],$GreenCollect) Then
			SendMouseClick($SecondItem[0],$SecondItem[1])
			Sleep(2000)
		 Else
			$HaveChest = False
		 EndIf
	  EndIf
   WEnd

   ;City Menu
   ClickCityScreen()

EndFunc

;Will shield if the login information says to
Func Shield($attempt)

   ;Check if we should shield
   If Login_Shield() <> 1 Then
	  return True
   EndIf

   LogMessage("Checking Shield.  Attempt " & $attempt)

   Local $minonShield = 4320 ;1440= 24Hr ,  4320 = 3 day
   If ($minonShield - (_DateDiff('n',Login_LastShield(),_NowCalc()))) > (_DateDiff('n',Login_LastRun(),_NowCalc())*1.5) Then

	  LogMessage("LastRun = " & Login_LastRun())
	  LogMessage("Login_LastShield = " & Login_LastShield())
	  LogMessage("_NowCalc = " & _NowCalc())
	  LogMessage("_DateDiff = " & _DateDiff('n',Login_LastShield(),_NowCalc()))

	  LogMessage("No Need to Shield, Minutes left = " & ($minonShield - (_DateDiff('n',Login_LastShield(),_NowCalc()))))
	  Return
   EndIf

   LogMessage("Shielding, Minutes wasted = " & ($minonShield - (_DateDiff('n',Login_LastShield(),_NowCalc()))))

   ;Boosts menu
   SendMouseClick($BoostsIcon[0], $BoostsIcon[1])
   Sleep(3000)

   ;Get Shield button button
   SendMouseClick($ShieldButton[0],$ShieldButton[1])
   Sleep(2000)

   ;Get Shield button button
   SendMouseClick($ShieldButton3Day[0],$ShieldButton3Day[1])
   Sleep(2000)

   ;Check for the replace button
   If PollForColor($ShieldReplaceButton[0],$ShieldReplaceButton[1], $BlueOKButton, 5000) Then
	  SendMouseClick($ShieldReplaceButton[0],$ShieldReplaceButton[1])
	  Sleep(2000)
   EndIf

   LogMessage("Verifying Shield")

   If PollForColor($ShieldVerifyMaxLength[0],$ShieldVerifyMaxLength[1], $ShieldCountDownBlue, 5000) Then
	  LogMessage("Shield Verified")
	  Login_WriteShield()
   Else
	  If $attempt < 4 Then
		 LogMessage("Shield Not replaced, trying again")
		 Shield($attempt+1)
	  Else
		 LogMessage("Max shield attempts.  CITY MAY BE UNSHIELDED")
	  EndIf
   EndIf

   ;City Menu
   ClickCityScreen()

EndFunc

;This needs to be before Upgrades
Func Bank($scrolled,$previousBuildingType)

   If Login_Bank() = 0 Then
	  LogMessage("City Set to not bank")
	  Return
   EndIf

   ;Don't bother banking less than 12 not enough rss to bother
   If Login_StrongHoldLevel() < 12 Then
	  Return
   EndIf

   LogMessage("Banking ")

   ;reset the scrolling to start if this isn't the same type of building
   If $scrolled = 1  And $previousBuildingType <> 1 Then
	  MouseClickDrag("left",650,600,905,290,20)
	  Sleep(500)
	  MouseClickDrag("left",650,600,905,290,20)
	  Sleep(500)
	  MouseClickDrag("left",650,600,905,290,20)
	  Sleep(500)
	  MouseClickDrag("left",650,600,905,290,20)
	  Sleep(500)
	  MouseClickDrag("left",650,600,905,290,20)
	  Sleep(500)
   Else
	  If $previousBuildingType = 0 Then
		 MouseClickDrag("left",650,600,905,290,20)
		 Sleep(500)
	  EndIf
   EndIf


   ;Click Market Place
   SendMouseClick($MarketLocation[0],$MarketLocation[1])

   For $i = 1 to Login_RssMarches() ; Send rss marches
		 SendRSS(Login_RSSType()-1)
   Next

   For $i = 1 to Login_SilveMarches() ; Send silver marches
	  SendRSS($eSilver)
   Next

   Login_UpdateLastBank()

   ;City Menu
   ClickCityScreen()
EndFunc

;Assumes you are in the market place ready to send, and gets back to that point
Func SendRSS($type)

	  Local $helpOffsetX = (Login_RSSBank() - 1) * $HelpNumberOffsetX

	  If ($type = $eSilver) Then
		 $helpOffsetX = (Login_SilverBank() - 1) * $HelpNumberOffsetX
	  EndIf

	  ;Poll for first Help button
	  If PollForColor($HelpTopMember[0],$HelpTopMember[1], $Blue, 10000) Then
		 SendMouseClick($HelpTopMember[0] + $helpOffsetX,$HelpTopMember[1])
		 Sleep(2000)
	  Else
		 LogMessage("Banking - No help button")
		 ;City Menu
		 return false
	  Endif

	  ;Max the food if we can by filling silver marches with it

	  If ($type = $eSilver) AND ((Login_RSSType()-1) = $eFood) Then
		 LogMessage("Banking - Maxing silver march with food")
		 SendMouseClick($HelpRSSMax[$eFood][0],$HelpRSSMax[$eFood][1])
	  EndIf


	  SendMouseClick($HelpRSSMax[$type][0],$HelpRSSMax[$type][1])

	  Sleep(1000)
	  MouseMove($RSSHelpButton[0],$RSSHelpButton[1])
	  If PollForColor($RSSHelpButton[0],$RSSHelpButton[1], $Blue, 3000) Then
		 SendMouseClick($RSSHelpButton[0],$RSSHelpButton[1])
	  Endif

	  Sleep(1000)

	  ;If Not (IsDeclared($DonationConfirmation)) Then

		 ;LogMessage("$DonationConfirmation - Not Declared")
		 ;If PollForColor($RSSOKButton[0],$RSSOKButton[1], $Blue, 3000) Then
		;	SendMouseClick($RSSOKButton[0],$RSSOKButton[1])
		 ;EndIf

		 ;Sleep(1000)
	  ;Else
		 If ($DonationConfirmation = 1) Then
			If PollForColor($RSSOKButton[0],$RSSOKButton[1], $Blue, 3000) Then
			   SendMouseClick($RSSOKButton[0],$RSSOKButton[1])
			EndIf
			Sleep(1000)
		 Else
			;delay until the top help is back
			If PollForColor($HelpTopMember[0],$HelpTopMember[1], $Blue, 3000) Then
			   ;Do nothing this is
			Endif
		 Endif
	  ;Endif

	  ;Check for max send
	  If CheckForColor($MaxMarchesExceeded[0],$MaxMarchesExceeded[1],$Blue) Then
		 SendMouseClick($MaxMarchesExceeded[0],$MaxMarchesExceeded[1])
		 return false
	  Endif

	  ;Check for Rally screen - Could do this using the check sum for Alliance War at the top of the screen
	  ;If neither the done button is there or the top help is there check for rally screen
	  If Not (CheckForColor($HelpTopMember[0],$HelpTopMember[1],$Blue) OR CheckForColor($RSSHelpButton[0],$RSSHelpButton[1],$Blue)) Then
		 ;Probably on the rally screen
		 Send("{ESC}")
		 Sleep(500)
		 If Not (CheckForColor($HelpTopMember[0],$HelpTopMember[1],$Blue) OR CheckForColor($RSSHelpButton[0],$RSSHelpButton[1],$Blue)) Then
			Return false
		 EndIf
	  EndIf


	  return true

EndFunc


Func Rally()

   If Login_Shield() = 1 OR Login_Rally() = 0 Then
	  Return
   EndIf

   If (Login_RallyX() < 1 or Login_RallyX() > 512 ) OR (Login_RallyY() < 1 OR Login_RallyY() > 1024) Then
	  LogMessage("Rally Coords are bad (" & Login_RallyX() & "," & Login_RallyY() & ")")
	  Return
   EndIf

   ;Check if we need to rally
   Local $minonRally = 480 ;1440= 24Hr ,  4320 = 3 day
   If ($minonRally - (_DateDiff('n',Login_LastRally(),_NowCalc()))) > (_DateDiff('n',Login_LastRun(),_NowCalc())*1.5) Then
	  LogMessage("No Need to Rally, Minutes left = " & ($minonRally - (_DateDiff('n',Login_LastRally(),_NowCalc()))))
	  Return
   EndIf

   LogMessage("Starting Rally process")

   If Not CheckForCityScreen(0) Then
	  LogMessage("No city screen to start rallying, trying to get there")
	  ClickCityScreen()

	  If Not CheckForCityScreen(0) Then
		 LogMessage("No city screen to start rallying, Canceling Rally")
		 Return
	  EndIf
   EndIf

   ;Heal any troops in the hospital
   If CheckForColor($HospitalCross[0],$HospitalCross[1],$HospitalCrossColor) Then

	  SendMouseClick($HospitalBuilding[0],$HospitalBuilding[1])
	  Sleep(1500)
	  SendMouseClick($HospitalQueueAllButton[0],$HospitalQueueAllButton[1])
	  Sleep(1500)
	  SendMouseClick($HospitalHealButton[0],$HospitalHealButton[1])
	  Sleep(1500)

	  ClickCityScreen()
   EndIf

   ;Check for Rally to cancel
   SendMouseClick($MoreMenu[0],$MoreMenu[1])
   If PollForColor($MarchesButton[0],$MarchesButton[1],$MarchesButtonColor, 4000) Then
	  SendMouseClick($MarchesButton[0],$MarchesButton[1])
	  Sleep(1000)
   EndIf

   Local $i = 0
   For $i = 0 to 2
	  If CheckForColor($RallyAttackButton[0]+($RallyAttackButtonOffsetX*$i),$RallyAttackButton[1],$RallyAttachButtonColor) Then
		 SendMouseClick($RallyCancelButton[0]+($RallyAttackButtonOffsetX*$i),$RallyCancelButton[1])
		 Sleep(1000)
		 SendMouseClick($RallyCancelConfirmButton[0],$RallyCancelConfirmButton[1])
		 Sleep(1000)
		 LogMessage("Rally Canceled.")
		 ExitLoop
	  EndIf
   Next

   ;We are on the marches screen so click the city menu twice
   SendMouseClick($CityMenu[0],$CityMenu[1])
   Sleep(1000)
   SendMouseClick($CityMenu[0],$CityMenu[1])

   ;Check that we have the search button
   If Not PollForColor($SearchKingdomButton[0],$SearchKingdomButton[1],$SearchKingdomButtonColor, 4000) Then
	  SendMouseClick($CityMenu[0],$CityMenu[1])
	  If Not PollForColor($SearchKingdomButton[0],$SearchKingdomButton[1],$SearchKingdomButtonColor,4000) Then
		 LogMessage("No World screen to search for rallying target, canceling process")
		 Login_UpdateLastRallyFAILED()
		 ClickCityScreen()
		 Return
	  EndIf
   EndIf

   Local $HaveRallyCity = 0
   While $HaveRallyCity < 4
	  ;click search button
	  SendMouseClick($SearchKingdomButton[0],$SearchKingdomButton[1])

	  If PollForColor($SearchKingdomX[0],$SearchKingdomX[1],$White,5000) Then
		 ;input X
		 SendMouseClick($SearchKingdomX[0],$SearchKingdomX[1])
		 Sleep(1000)
		 Send(Login_RallyX())
		 Sleep(2000)
	  EndIf

	  If PollForColor($SearchKingdomY[0],$SearchKingdomY[1],$White,5000) Then
		 ;input y
		 SendMouseClick($SearchKingdomY[0],$SearchKingdomY[1])
		 Sleep(2000)
		 Send(Login_RallyY())
		 Sleep(2000)
	  EndIf

	  SendMouseClick($SearchKingdomGoButton[0],$SearchKingdomGoButton[1])
	  Sleep(4000)

	  ;Any way to tell here if the screen is loaded?

	  ;Click on the city
	  SendMouseClick($WorldMapCityButton[0],$WorldMapCityButton[1])
	  Sleep(1500)

	  ;Check if we got a march
	  If CheckForColor($MarchCheck[0],$MarchCheck[1],$MarchCheckColor) Then
		 $HaveRallyCity += 1
	  Else
		 ;Not sure why this is needed but it seems to be
		 MouseMove($RallyButton[0],$RallyButton[1])
		 Sleep(500)

		 ;Make sure we got the city
		 If PollForColor($RallyButton[0],$RallyButton[1],$Blue,5000) Then
			ExitLoop
		 Else
			$HaveRallyCity += 1
		 EndIf

	  EndIf
   WEnd

   If $HaveRallyCity >= 4  Then
	  LogMessage("Can not get city rallying target, canceling process")
	  Login_UpdateLastRallyFAILED()
	  ClickCityScreen()
	  Return
   EndIf

   SendMouseClick($RallyButton[0],$RallyButton[1])
   Sleep(1000)

   ;Click the 8 Hour check mark
   SendMouseClick($Rally8HourCheckBox[0],$Rally8HourCheckBox[1])
   Sleep(1000)

   ;Click the Set button
   If PollForColor($RallySetButton[0],$RallySetButton[1],$Blue,3000) Then
	  SendMouseClick($RallySetButton[0],$RallySetButton[1])
	  Sleep(500)
   Else
	  LogMessage("Can not rally find set button for rallying target, canceling process")
	  Login_UpdateLastRallyFAILED()
	  ClickCityScreen()
	  Return
   EndIf

   ;Click the Queue Max button
   SendMouseClick($RallyQueueMaxButton[0],$RallyQueueMaxButton[1])
   Sleep(1000)

   ;Click the Send button
   SendMouseClick($RallySendButton[0],$RallySendButton[1])
   Sleep(1500)

   ;Update Last Rally
   Login_UpdateLastRally()

   ;Click City Screen
   SendMouseClick($CityMenu[0],$CityMenu[1])
   Sleep(1000)

   LogMessage("Ending Rally process")

EndFunc


Func CollectAllQuestsWithChances($Daily, $Alliance)

   ;Start on the city Screen
   If $Daily Then
	  SendMouseClick($QuestsMenu[0],$QuestsMenu[1])
	  Sleep(2000)
	  SendMouseClick($QuestsDaily[0],$QuestsDaily[1])
	  Sleep(2000)
	  CollectAllQuestsFromScreen()
   EndIf

   If $Alliance Then
	  SendMouseClick($QuestsMenu[0],$QuestsMenu[1])
	  Sleep(2000)
	  SendMouseClick($QuestsAliaance[0],$QuestsAliaance[1])
	  Sleep(2000)
	  CollectAllQuestsFromScreen()
   EndIf

EndFunc

Func CollectAllQuestsFromScreen()

   If Not CheckForColor($QuestsCollect[0],$QuestsCollect[1],$Blue) Then
	  MsgBox(0,"Paused","Looks like No VIP on, please put on at least a couple of hours, and start the first chance so a quest shows, then return here")
   EndIf

   Local $HaveChances = True
   Local $HaveQuests = True

   While ($HaveChances)

	  While $HaveQuests
		 If (PollForColor($QuestsCollect[0],$QuestsCollect[1],$Blue, 3000)) Then
			SendMouseClick($QuestsCollect[0],$QuestsCollect[1])
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
			Sleep(500)
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
			MsgBox(0,"Paused","No Chance button.  No clue where we are.")
			$HaveChances = False;
		 EndIf
	  EndIf
   Wend

EndFunc


Func Logout()

   ;Logout Script
   If Not CheckForCityScreen(0) Then
	  ClickCityScreen()
   EndIf

   ;More panel
   SendMouseClick($MoreMenu[0],$MoreMenu[1])

   ;Accounts
   If PollForColor($AccountButton[0],$AccountButton[1], $AccountButtonColor, 5000) Then
	  SendMouseClick($AccountButton[0],$AccountButton[1])
   Else
	  LogMessage("Dont have the account button to logout")
	  Return False
   EndIf

   ;Logout
   If PollForColor($LogoutButton[0],$LogoutButton[1], $RedNoButton, 8000) Then
	  SendMouseClick($LogoutButton[0],$LogoutButton[1])
   Else
	  LogMessage("Dont have the logout button to logout")
	  Return False
   EndIf

   ;Yes Logout
   If PollForColor($LogoutYesButton[0],$LogoutYesButton[1], $Blue, 5000) Then
	  SendMouseClick($LogoutYesButton[0],$LogoutYesButton[1])
   Else
	  LogMessage("Dont have the account yes logout button")
	  Return False
   EndIf
   Sleep(500)

EndFunc


Func SendMouseClick($x,$y)

   MouseMove($x,$y)
   Sleep(100)
   $success = MouseClick("left",$x,$y)

EndFunc

Func OpenGOW_OLD()
   ;Make sure the window is active
   WinActivate ("GOw2 [Running] - Oracle VM VirtualBox","")

   ;Open GOW
   Local $IsThisGowIcon = PixelGetColor($GOWIcon[0],$GOWIcon[1])
   While $IsThisGowIcon <> $GOWColor
	  LogMessage("***  We dont have the Icon trying to reset")
	  Send("{ESC}")
	  Sleep(250)
	  Send("{ESC}")
	  Sleep(250)
	  Send("{ESC}")
	  Sleep(250)
	  Send("{ESC}")
	  Sleep(250)

	  $IsThisGowIcon = PixelGetColor($GOWIcon[0],$GOWIcon[1])
	  If $IsThisGowIcon <> $GOWColor Then
		 LogMessage("***  We STILL dont have the Icon trying to reset.  Attempt = " & $OpenFailureCount)
		 LogMessage("***  Color is  = " & $IsThisGowIcon)
		 LogMessage("***  Color should be  = " & $GOWColor)
		 WinActivate ("GOw2 [Running] - Oracle VM VirtualBox","")
		 Sleep(60000)
		 $OpenFailureCount = $OpenFailureCount+1

		 $mouseColor = PixelGetColor($AndroidHomeButton[0],$AndroidHomeButton[1])
		 If $mouseColor = $Black Then
			SendMouseClick($AndroidHomeButton[0],$AndroidHomeButton[1])
			Sleep(1000)
			SendMouseClick($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1])
			Sleep(1000)
		 EndIf

	  EndIf

	  If $OpenFailureCount > 100 Then
		 quit()
	  EndIf
   WEnd


   ;Click the Icon
   SendMouseClick($GOWIcon[0],$GOWIcon[1])
   Sleep(20000)
EndFunc

Func OpenGOW($attempts)

   ;Make sure the VB is open
   WinActivate ("GOw2 [Running] - Oracle VM VirtualBox","")

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

   ;Click the Icon
   SendMouseClick($GOWIcon[0],$GOWIcon[1])

   If Not PollForColor($LoginButton[0],$LoginButton[1], $GreyedOutButton, 45000) Then

	  ;Sleep another 25 seconds in case this is just a really slow login/connect
	  ;If Not CheckForColor( $LoginButton[0],$LoginButton[1], $GreyedOutButton) Then
	   ;  LogMessage("Not the login screen waiting another 25 seconds")
	   ;  Sleep(25000)
	  ;EndIf

	  ;Check for black Screen at both the login button and the buy Gold Button
	  If CheckForColor($LoginButton[0],$LoginButton[1], $Black) And CheckForColor($GoldBuyButton2[0],$GoldBuyButton2[1], $Black)  Then
		 LogMessage("----- We have a black screen so close and restart.  Attempt " & $attempts)

		 SendMouseClick($AndroidHomeButton[0],$AndroidHomeButton[1])
		 Sleep(3000)
		 SendMouseClick($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1])
		 Sleep(3000)

		 OpenGOW($attempts+1)
	  Else

		 ;We are not on the login screen
		 LogMessage("----- Exited without logging out previously. Logging out -----")
		 ClickGoldButton()
		 Sleep(2000)
		 Logout()
		 Sleep(2000)
		 If($attempts > 2) Then
			LogMessage("----- Attempted to logout and back in twice. Quitting -----")
			quit()
		 EndIf
		 OpenGOW(1)
	  EndIf

   EndIf

EndFunc

Func CloseGOW()

   If CheckForSessionTimeout() Then
	  LogMessage("Writing Login from CloseGOW function")
	  Login_Write()
   Else

	  ;Check if we have GOW open
	  If CheckForColor($AndroidHomeButton[0],$AndroidHomeButton[1],$Black) Then

		 ;Attempt Logoug
		 Logout()

		 ;If that didn't work quit
		 If CheckForColor($AndroidHomeButton[0],$AndroidHomeButton[1],$Black) Then
			SendMouseClick($AndroidHomeButton[0],$AndroidHomeButton[1])
			Sleep(1000)
			SendMouseClick($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1])
			Sleep(1000)
		 EndIf
	  Else
		 LogMessage("----- Looks like we arent in GOW -----")
	  EndIf
   EndIf

   ;sleep 5 seconds to get everything cleaned up
   Sleep(5000)
EndFunc

Func CheckForPinPrompt()
   ;LogMessage("Checking for PIN")
   Local $pinArray = StringToASCIIArray(Login_PIN())
   If PollForColor($FirstPinBox[0],$FirstPinBox[1],$PinBoxColor,5000) Then
	  If CheckForColor($SecondPinBox[0],$SecondPinBox[1],$PinBoxColor) Then

		 LogMessage("PIN is needed")
		 Sleep(500)
		 SendMouseClick($FirstPinBox[0],$FirstPinBox[1])
		 For $i = 0 to UBound($pinArray)-1
			Send(Chr($pinArray[$i]))
			Sleep(1000)
		 Next
	  Else

		 LogMessage("Pin Spot1 passed, spot 2 did not.")
		 LogMessage("Pin Spot2 is - " & PixelGetColor($SecondPinBox[0],$SecondPinBox[1]))
	  EndIf
   Else

	  ;LogMessage("Pin Spot1 is - " & PixelGetColor($FirstPinBox[0],$FirstPinBox[1]))
   EndIf
EndFunc

;Check for session timeout and if so click ok
Func CheckForSessionTimeout()
   If CheckForColor($CityMenu[0],$CityMenu[1],$Black) And  CheckForColor($SessionTimeoutButton[0],$SessionTimeoutButton[1],$Blue)  Then
	  SendMouseClick($SessionTimeoutButton[0],$SessionTimeoutButton[1])

	  LogMessage("Have Session Timeout")
	  Return True
   EndIf

   Return False
EndFunc

;Only Check the first two
Func CheckIfBuidlingFromTimers()

   Local $iconX = $TimerIcon[0]
   If (CheckForColor($iconX, $TimerIcon[1], $TimerIconBuildColor) or CheckForColor($iconX, $TimerIcon[1], $TimerIconBuildColor2)) Then
	  LogMessage("We are already Building based on the First timer")
	  return true
   EndIf

   $iconX = $TimerIcon[0] + ($TimerOffsetX)
   If (CheckForColor($iconX, $TimerIcon[1], $TimerIconBuildColor) or CheckForColor($iconX, $TimerIcon[1], $TimerIconBuildColor2)) Then
	  LogMessage("We are already Building based on the Second timer")
	  return true
   EndIf

   return False

EndFunc

Func CheckIfBuidlingFromTimers_OLD()

   Local $built = 0
   Local $TimerNum = 0
   Local $MoreClicked = False

   ;Check if we are building something already
   For $TimerNum = 0 to 7

	  Local $iconX = $TimerIcon[0] + ($TimerOffsetX * $TimerNum)
	  Local $moreX = $TimerMoreIcon[0] + ($TimerOffsetX * ($TimerNum-1))
	  If CheckForColor($iconX, $TimerIcon[1], $TimerIconBuildColor) or CheckForColor($iconX, $TimerIcon[1], $TimerIconBuildColor2) Then
		 LogMessage("&&&&&&&&&&&  We are already Building based on the timers   &&&&&&&&&&&&")
		 $built = 1
		 If ($MoreClicked) Then

			LogMessage("&&&&&&&&&&&  Clicked CLOSE More Button   &&&&&&&&&&&&")
			SendMouseClick($moreX, $TimerMoreIcon[1])
			Sleep(1000)
			$MoreClicked = False
		 EndIf

		 ExitLoop
	  EndIf

	  If $TimerNum = 1 Then
		 ;We ahave a more button so keep going
		 If CheckForColor($moreX, $TimerMoreIcon[1], $Black) Then
			LogMessage("&&&&&&&&&&&  Clicked More Button   &&&&&&&&&&&&")
			SendMouseClick($moreX, $TimerMoreIcon[1])
			Sleep(1000)
			$MoreClicked = True;
		 Else
			;We dont' so stop
			LogMessage("&&&&&&&&&&&  There isnt a More Button we are done   &&&&&&&&&&&& ")
			;MsgBox(0,"Paused", $moreX)
			ExitLoop
		 EndIf
	  EndIf

	  LogMessage("&&&&&&&&&&&  Checking The Next one   &&&&&&&&&&&&")
	  ;MsgBox(0,"Paused", $TimerNum)
   Next

   ;MsgBox(0,"Paused", $MoreClicked & " - " & $built)

   If ($MoreClicked) Then

	  LogMessage("&&&&&&&&&&&  Clicked CLOSE More Button   &&&&&&&&&&&&")
	  SendMouseClick($moreX, $TimerMoreIcon[1])
	  Sleep(1000)
	  $MoreClicked = False
   EndIf

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

   If PollForColorTwoPlaces($GoldBuyButton[0],$GoldBuyButton[1],$GoldBuyButton2[0],$GoldBuyButton2[1], $BuyGoldColor, 40000) Then
	  Send("{ESC}")
	  Sleep(2000)
	  return True
   Else
	  LogMessage("*** Never got the gold button")
	  return False
   EndIf

#comments-start
   If Not CheckForColor($GoldExitButton1[0],$GoldExitButton1[1],$GetGoldButton) Then
	  ;LogMessage("Clicking on second gold exit button.")
	  SendMouseClick($GoldExitButton1[0],$GoldExitButton1[1])
	  Sleep(3000)
   Else
	  Return
   EndIf

   If Not CheckForColor($GoldExitButton1[0],$GoldExitButton1[1],$GetGoldButton) Then
	  LogMessage("Clicking on Third gold exit button.")
	  SendMouseClick($GoldExitButton3[0],$GoldExitButton3[1])
	  Sleep(3000)
   Else
	  Return
   EndIf

   If Not CheckForColor($GoldExitButton1[0],$GoldExitButton1[1],$GetGoldButton) Then
	  LogMessage("Clicking on second gold exit button.")
	  SendMouseClick($GoldExitButton2[0],$GoldExitButton2[1])
	  Sleep(3000)
   Else
	  Return
   EndIf
#comments-end


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

	  If CheckForColor($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1],$YesQuitWhite) Then
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

Func SaveCityImage()
   SaveImage('CityImage',409,128,1169,727)
EndFunc

Func SaveRSSImage()
   SaveImage('RSSImage',470,185,505,655)
EndFunc

Func SaveImage($imageName,$x1,$y1,$x2,$y2)

   Local $sFilePath = @ScriptDir & '\' & $imageName & '.jpg'
   ;Local $URL = "http://localhost:52417/api/Upload"
   Local $URL = "http://ets-tfs.cloudapp.net:9090/api/Upload"

   _ScreenCapture_SetJPGQuality (25)


   _GDIPlus_Startup()
   Local $hHBmp = _ScreenCapture_Capture("", $x1,$y1, $x2,$y2)
   Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBmp) ;convert GDI bitmap to GDI+ bitmap
   _WinAPI_DeleteObject($hHBmp) ;release GDI bitmap resource because not needed anymore

   _GDIPlus_ImageRotateFlip($hBitmap, 1) ;rotate image by 90 degrees without flipping

   _GDIPlus_ImageSaveToFile($hBitmap,$sFilePath)

   ;_GDIPlus_BitmapDispose($hBitmap)
   _GDIPlus_ImageDispose($hBitmap)

   _GDIPlus_Shutdown()

   Local $sFile = FileOpen($sFilePath, 16)

   $sFileRead = BinaryToString(FileRead($sFile))
   FileClose($sFile)

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
   $oHTTP.Send(StringToBinary($sPD))
   $oReceived = $oHTTP.ResponseText
   $oStatusCode = $oHTTP.Status

   LogMessage("Image Saved - Status = " & $oStatusCode)
   LogMessage("Image Saved - Response = " & $oReceived)

EndFunc

Func CheckForColor($x,$y,$color)
   ;Local $pixelFound = PixelSearch($x-2,$y-2,$x+2,$y+2,$color)
   Local $pixelColor = PixelGetColor($x,$y)
   If $pixelColor <>  $color Then
	  ;LogMessage("Color is wrong. At (" & $x & "," & $y & ") expected " & $color & " --- Got " &  $pixelColor)
	  ;MouseMove($x,$y)
	  Sleep(500)
	  return False
   EndIf
   return True
EndFunc

Func PollForColor($x,$y,$color,$timeout)
   ;LogMessage("Polling At (" & $x & "," & $y & ") expecting " & $color)
   Local $colorAt = 0
   Local $pixelColor = 0
   Local $waited = 0

   While $waited < $timeout
	  $pixelColor = PixelGetColor($x,$y)
	  If $pixelColor <>  $color Then
		 ;LogMessage("Color is wrong. At (" & $x & "," & $y & ") expected " & $color & " --- Got " &  $pixelColor)
		 ;MouseMove($x,$y)
		 Sleep(500)
		 $waited = $waited + 500
	  Else
		 ExitLoop
	  EndIf
   WEnd
   If $pixelColor =  $color Then
	  ;LogMessage("Polling At (" & $x & "," & $y & ") worked.")
	  Sleep(250)
	  return True
   Else
	  LogMessage("Polling At (" & $x & "," & $y & ") Failed: " & $pixelColor)
	  return False
   EndIf
EndFunc

Func PollForColorTwoPlaces($x,$y,$x2,$y2,$color,$timeout)
   ;LogMessage("Polling At (" & $x & "," & $y & ") expecting " & $color)
   Local $colorAt = 0
   Local $pixelColor = 0
   Local $waited = 0

   While $waited < $timeout
	  $pixelColor = PixelGetColor($x,$y)
	  $pixelColor2 = PixelGetColor($x2,$y2)
	  If $pixelColor <> $color AND $pixelColor2 <> $color Then
		 ;LogMessage("Color is wrong. At (" & $x & "," & $y & ") expected " & $color & " --- Got " &  $pixelColor)
		 ;MouseMove($x,$y)
		 Sleep(500)
		 $waited = $waited + 500
	  Else
		 ExitLoop
	  EndIf
   WEnd
   If $pixelColor = $color OR $pixelColor2 = $color Then
	  ;LogMessage("Polling At (" & $x & "," & $y & ") worked.")
	  Sleep(250)
	  return True
   Else
	  LogMessage("Polling At (" & $x & "," & $y & ") OR (" & $x2 & "," & $y2 & ") Failed: " & $pixelColor)
	  return False
   EndIf
EndFunc

Func LogMessage($message)

   FileWriteLine( $LogFileName,$message)

   Local $loginID = Login_LoginID()
   If $loginID = 0 Then
	  $loginID = "NULL"
   EndIf

   ;FileWriteLine( $LogFileName,"Insert Into Log ([MachineID],[Severity],[LoginID],[Message]) Values (" & $MachineID & ",0," & $loginID & ",'" & $message & "')")

   If StringInStr ($message,"'") Then
	  $message = StringReplace($message,"'","")
   Endif

   ;Read from the specific File for this login
   _SqlConnect()
   _SQL_Execute(-1,"Insert Into Log ([MachineID],[Severity],[LoginID],[Message]) Values ('" & $MachineID & "',0," & $loginID & ",'" & $message & "')" )
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
