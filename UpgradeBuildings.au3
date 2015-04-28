#include "GowConstants.au3"
#include "GowActions.au3"
#include <Date.au3>
#include <Array.au3>

;Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
HotKeySet("{F9}","HotKeyPressed")
HotKeySet("{F8}","HotKeyPressed")
HotKeySet("{F1}","HotKeyPressed")

If FileExists($LogFileName) = 1 Then
   FileDelete($LogFileName)
EndIf

WinActivate ("GOw2 [Running] - Oracle VM VirtualBox","")
Sleep(1000)
WinWaitActive ("GOw2 [Running] - Oracle VM VirtualBox","")

;Dependant on window at 401x77
WinMove("GOw2 [Running] - Oracle VM VirtualBox","",$GOWVBHostWindow[0],$GOWVBHostWindow[1])

Local $badBuildings[1] = [-1]

For $k = 1 to 100000 ;go through them all lots

   WinActivate ("GOw2 [Running] - Oracle VM VirtualBox","")
   Sleep(1000)

   LogMessage("Logging IN New User -  "  &  _Now())

   ;Open GOW
   OpenGOW(0)

   ;Read the Login File
   If Not Login_Load() Then
	  LogMessage("-----Login Load Failed-----")
	  ContinueLoop
   EndIf
   LogMessage("Logging in for " & Login_Email())

   ;Login
   If Not Login(Login_Email(),Login_Pwd()) Then
	  LogMessage("Login Attempt Failed - 1")
	  CloseGOW()
	  ContinueLoop
   EndIf

   If Not CheckForCityScreen(0) Then
	  LogMessage("Check for city Failed - 2")
	  CloseGOW()
	  ContinueLoop
   EndIf

   ;Save the image resources
   SaveRSSImage()

   ;Save the City Image
   SaveCityImage()

   local $built = 0

   ;Check if we are building
   If CheckIfBuidlingFromTimers() Then
	  $built = 1
   EndIf

   CollectSecretGift()
   If Not CheckForCityScreen(0) Then
	  LogMessage("Collect Secret Gift Failed - 3")
	  CloseGOW()
	  ContinueLoop
   EndIf

   Helps()
   If Not CheckForCityScreen(0) Then
	  LogMessage("Helps Failed - 4")
	  CloseGOW()
	  ContinueLoop
   EndIf

   RedeemCode()

   CollectAthenaGift()

   CollectQuests()
   If Not CheckForCityScreen(0) Then
	  LogMessage("Collect Quests Failed - 5")
	  CloseGOW()
	  ContinueLoop
   EndIf

   Gifts()
   If Not CheckForCityScreen(0) Then
	  LogMessage("Collect Gifts Failed - 5")
	  CloseGOW()
	  ContinueLoop
   EndIf

   Shield()
   If Not CheckForCityScreen(0) Then
	  LogMessage("Shield Failed - 6")
	  CloseGOW()
	  ContinueLoop
   EndIf

   ;If it is purple speed it
   If CheckForColor($BuildingUpgradeHelpButton[0],$BuildingUpgradeHelpButton[1],$Purple) Then
	  SendMouseClick($BuildingUpgradeHelpButton[0],$BuildingUpgradeHelpButton[1])
	  Sleep(5000) ;sleep 5 seconds because of the damn quest popups
	  $built = 0
   EndIf

   ;If it is Oramge help it and move on to the next login
   If CheckForColor($BuildingUpgradeHelpButton[0],$BuildingUpgradeHelpButton[1],$Orange) Then
	  SendMouseClick($BuildingUpgradeHelpButton[0],$BuildingUpgradeHelpButton[1])
	  Sleep(3000)
	  $built = 2
   EndIf

   Local $scrolled = 0
   Local $previousBuildingType = 0

   Rally()
   If Not CheckForCityScreen(0) Then
	  LogMessage("Rally Failed- 6")
	  CloseGOW()
	  ContinueLoop
   EndIf

   If Login_Upgrade() = 1  Then

	  ;Try to do the SH upgrade if we can
	  If Login_StrongHoldLevel() < 14 Then

		 If Login_StrongHoldLevel() = 5 AND Login_Placed() <> 1 Then
			;Don't upgrade the SH
		 Else
			;Do the SH upgrade
			If CheckForColor($StrongHoldUpgrade[0],$StrongHoldUpgrade[1],$StrongholdUpgradeArrowColor) Then
			   $built = UpgradeBuilding($StrongHoldUpgrade[0],$StrongHoldUpgrade[1],-1)
			   Local $newSHLevel = Login_StrongHoldLevel() + 1
			   LogMessage("Stronghold Upgraded to : " & $newSHLevel)
			   Login_StrongHoldLevel_Set($newSHLevel)
			   Login_LastUpgradeBuilding_Set(-1)  ;reset the building to start at the first farms
			   Login_LastUpgrade_Set(_Now())

			   If Login_StrongHoldLevel() = 7 OR Login_StrongHoldLevel() = 10 OR Login_StrongHoldLevel() = 12 OR Login_StrongHoldLevel() = 13 Then
				  CollectAllCityQuests()
			   EndIf

			EndIf
		 EndIf
	  EndIf

	  If $built = 0 Then

		 Local $buildingCount = UBound($Buildings)-1

		 For $buildingLoop = 0 to  $buildingCount

			;Start at the last known building + 1
			$buildingNum = Login_LastUpgradeBuilding() + $buildingLoop + 1

			If ($buildingNum = $buildingCount) AND (Login_HasGoldMine() = 1) Then
			   LogMessage("City has gold mine, skipping trying to upgrade it.")
			   ContinueLoop
			EndIf


			;If this is more than the count start back at 0
			If $buildingNum > $buildingCount Then
			   $buildingNum = $buildingNum - $buildingCount-1
			EndIf

			;If this is a known bad building skip it
			;If _ArraySearch($badBuildings, $buildingNum) > -1 Then
			   ;LogMessage("----Building is in the naughty list ----- " & $buildingNum & " ----" & $Buildings[$buildingNum][0] & "," & $Buildings[$buildingNum][1] & "," & $Buildings[$buildingNum][2])
			   ;ContinueLoop
			;EndIf

			;LogMessage("-----Building-----")
			;LogMessage($Buildings[$buildingNum][0] & "  -  " & $Buildings[$buildingNum][1] & "x" & $Buildings[$buildingNum][2])

			;Setup the screen the first time.  Zero it essentially
			If $previousBuildingType = 0 Then
			   MouseClickDrag("left",650,600,905,290,20)
			   Sleep(500)
			EndIf

			;reset the scrolling to start if this isn't the same type of building
			If $scrolled = 1  And $previousBuildingType <> $Buildings[$buildingNum][0] Then
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

			   $scrolled = 0
			EndIf

			;check if we are on the same building type so we don't move if we don't have to
			If $previousBuildingType <> $Buildings[$buildingNum][0] Then
			   Switch $Buildings[$buildingNum][0]
				   Case 1
					   ; do nothing move nowhere
					 $scrolled = 1
					Case 2
					 MouseClickDrag("left",970,500,847,581)
					 $scrolled = 1
					 Sleep(1000)
				   Case 3
					 MouseClickDrag("left",705,255,740,700)
					 $scrolled = 1
					 Sleep(1000)
				   Case 4
					 MouseClickDrag("left",705,255,740,700)
					 Sleep(1000)
					 MouseClickDrag("left",920,200,770,670)
					 $scrolled = 1
					 Sleep(1000)
				  Case 5
					 MouseClickDrag("left",705,255,740,700)
					 Sleep(1000)
					 MouseClickDrag("left",920,200,770,670)
					 Sleep(1000)
					 MouseClickDrag("left",954,428,804,602)
					 Sleep(1000)
					 $scrolled = 1
					 Sleep(1000)
				  Case 6
					 MouseClickDrag("left",911,201,600,675)
					 Sleep(1000)
					 MouseClickDrag("left",715,235,545,675)
					 Sleep(1000)
					 MouseClickDrag("left",715,235,545,675)
					 $scrolled = 1
					 Sleep(1000)
				  Case 7
					 MouseClickDrag("left",911,201,600,675)
					 Sleep(1000)
					 MouseClickDrag("left",715,235,545,675)
					 Sleep(1000)
					 MouseClickDrag("left",715,235,545,675)
					 Sleep(1000)
					 MouseClickDrag("left",600,380,750,430)
					 $scrolled = 1
					 Sleep(1000)
				   Case Else
					  ; do nothing
				EndSwitch
			 EndIf


			$built = UpgradeBuilding($Buildings[$buildingNum][1],$Buildings[$buildingNum][2],$buildingNum)
			$previousBuildingType = $Buildings[$buildingNum][0]

			If $built = -1 Then
			   ;Done building this building it looks bad
			   ContinueLoop
			EndIf

			If $built = 2 Then
			   ;We just built this one
			   Login_LastUpgradeBuilding_Set($buildingNum)
			   Login_LastUpgrade_Set(_Now())

			   ;If this was a SH5 or lower that was probably a free upgrade so try it out
			   If Login_StrongHoldLevel() < 6 Then
				  ContinueLoop
			   EndIf

			   ExitLoop
			EndIf

			If $built = 0 Then
			   ;Done building, We got a speed up
			   ExitLoop
			EndIf
		 Next

		 ;Should we upgrade the stronghold if nothing was built
		 If $built = 1 Then
			LogMessage("Maybe should upgrade this SH. Got through all the buildings without upgrading")
			Login_WriteResourcesNeeded()
		 EndIf
	  EndIf

   EndIf

   If Not CheckForCityScreen(0) Then
	  LogMessage("Upgrade Failed - 7")
	  CloseGOW()
	  ContinueLoop
   EndIf

   Bank($scrolled,$previousBuildingType)
   If Not CheckForCityScreen(0) Then
	  LogMessage("Bank Failed - 8")
	  CloseGOW()
	  ContinueLoop
   EndIf


   ;Logout
   LogMessage("Attempting Logout from Main Loop")
   Logout()
   Sleep(3000)

   ;_FileWriteFromArray("logins.txt", $logins)
   Login_Write()

   ;Paranoia to make sure we are closed out

   ;Check if the android home button is on the right or the bottom, bottom means we are out side means close out and then open and try logout
   If CheckForColor( $AndroidHomeButton[0],$AndroidHomeButton[1], $Black) Then
	  LogMessage("Calling CloseGOW, from main loop becuase it still looks like we are in it")
	  CloseGOW()
   EndIf
Next

MsgBox(0,"Success","Finished")

;END IT ALL
Exit

