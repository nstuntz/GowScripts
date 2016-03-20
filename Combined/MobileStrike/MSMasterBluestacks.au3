;#include "GowConstants.au3"
#include "MSConstantsBluestacks.au3"
#include "MSActionsBluestacks.au3"
#include <Date.au3>
#include <Array.au3>

;;Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
HotKeySet("{F9}","HotKeyPressed")
HotKeySet("{F8}","HotKeyPressed")
HotKeySet("{F1}","HotKeyPressed")

If FileExists($LogFileName) = 1 Then
   FileDelete($LogFileName)
EndIf
Opt("WinTitleMatchMode", 1) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
sleep(5000)

;WinMinimizeAll()

;WinActivate ("BlueStacks","")
Sleep(1000)
;WinWaitActive ("BlueStacks","")

;Dependant on window at 401x77
;WinMove("BlueStacks","",$GOWVBHostWindow[0],$GOWVBHostWindow[1])

;THIS REQUIRES Andy to be in portrait mode and Active
;Sleep(1000)
;quit()
Local $badBuildings[1] = [-1]

For $k = 1 to 100000 ;go through them all lots

   ;Sleep for 5 minutes because we think that we need another city to pick up the one we just did.
   if($SleepOnLogout = 1) Then
	  Sleep(300000)
	  $SleepOnLogout = 0
   EndIf

   Sleep(500)

   LogMessage("Script Version -  "  &  $VersionNumber)
   LogMessage("Logging IN New User -  "  &  _Now())

   ;window moves on closing of GoW
;   WinMove("BlueStacks","",$GOWVBHostWindow[0],$GOWVBHostWindow[1])

   ;Open GOW
   OpenGOW(0)

   ;Read the Login File
   If Not Login_Load() Then
	  LogMessage("-----Login Load Failed-----",5)
	  CloseGOW()
	  LogMessage("-----Sleeping 1 minutes-----",5)
	  Sleep(60000)
	  ContinueLoop
   EndIf
   LogMessage("Logging in for " & Login_Email(),2)

   Local $timerLogin = TimerInit()
   ;Login
   If Not Login(Login_Email(),Login_Pwd()) Then
	  LogMessage("Login Attempt Failed",5)
	  ;CloseGOW()

	  Login_WritePerformanceLog(TimerDiff($timerLogin), "Login Failed")
	  ;Set the last run so this city doesn't keep getting processed
	  ;Login_Write()
	  ;Updated logic to set InProcess to 0 and not update LastRun. The real fix to what Than did the line above. GS -07062015
	  Login_ResetInProcess()

	  ;Log out.
	  Send("{ESC}")
	  Sleep(2000)
	  If CheckForColor($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1], $YesQuitWhite) Then
		 SendMouseClick($QuitGameDialogYesButton[0],$QuitGameDialogYesButton[1])
	  EndIf

	  CloseGOW()

	  LogMessage("-----Sleeping 30 seconds-----",5)
	  Sleep(30000)
	  ContinueLoop
   EndIf

   If Not CheckForCityScreen(0) Then
	  LogMessage("Check for city Failed - 2",5)
	  Login_WritePerformanceLog(TimerDiff($timerLogin), "Login Failed")
	  CloseGOW()
	  ContinueLoop
   EndIf

   Login_WritePerformanceLog(TimerDiff($timerLogin), "Login")
   ;Save the image resources
   SaveRSSImage()

   ;Save the City Image
   SaveCityImage()
   SaveGoldImage()
   SaveHeroImage()
   ;Only get Treasury image if the SH can use it
   If Login_StrongHoldLevel() > 14 Then
	  SaveTreasuryImage()
   EndIf

   local $built = 0

   ;Check if we are building
   ;If CheckIfBuidlingFromTimers() Then
	;  $built = 1
   ;EndIf

   ;Local $timerAthenaGift = TimerInit()
   CollectAthenaGift()
   ;Login_WritePerformanceLog(TimerDiff($timerAthenaGift), "Athena")

   ;Local $timerSecretGift = TimerInit()
   CollectSecretGift()
   ;Login_WritePerformanceLog(TimerDiff($timerSecretGift), "Collect Secret Gift")

   If Not CheckForCityScreen(0) Then
	  LogMessage("Collect Secret Gift Failed - 3",5)
	  CloseGOW()
	  ContinueLoop
   EndIf

   ;Local $timerHelps = TimerInit()
   Helps()
   ;Login_WritePerformanceLog(TimerDiff($timerHelps), "Helps")

   If Not CheckForCityScreen(0) Then
	  LogMessage("Helps Failed - 4",5)
	  CloseGOW()
	  ContinueLoop
   EndIf

   ;Local $timerShield = TimerInit()
   ;CheckShieldColor()
   ;Shield(1)
   ;Login_WritePerformanceLog(TimerDiff($timerShield), "Shield")

   If Not CheckForCityScreen(0) Then
	  LogMessage("Shield Failed - 6",5)
	  CloseGOW()
	  ContinueLoop
   EndIf

   ;Local $timerTreasury = TimerInit()
   ;Treasury()
   ;Login_WritePerformanceLog(TimerDiff($timerTreasury), "Treasury")

   If Not CheckForCityScreen(0) Then
	  LogMessage("Treasury Failed - 7",5)
	  CloseGOW()
	  ContinueLoop
   EndIf

   ;Local $timerBank = TimerInit()
   Bank()
   ;Login_WritePerformanceLog(TimerDiff($timerBank), "Bank")

   If Not CheckForCityScreen(0) Then
	  LogMessage("Bank Failed - 8",5)
	  CloseGOW()
	  ContinueLoop
   EndIf

   CollectQuests()
   If Not CheckForCityScreen(0) Then
	  LogMessage("Collect Quests Failed - 5",5)
	  CloseGOW()
	  ContinueLoop
   EndIf


   Gifts()
   If Not CheckForCityScreen(0) Then
	  LogMessage("Collect Gifts Failed - 5",5)
	  CloseGOW()
	  ContinueLoop
   EndIf
   ;Logout
   LogMessage("Logging out",2)
   Logout()
   Sleep(3000)

   ;_FileWriteFromArray("logins.txt", $logins)
   Login_Write()

   ;Paranoia to make sure we are closed out

   ;Check if the android home button is on the right or the bottom, bottom means we are out side means close out and then open and try logout
	;If CheckForColor( $AndroidHomeButton[0],$AndroidHomeButton[1], $Black) Then

	;Checking the size of the window
	Local $winSize = WinGetClientSize("BlueStacks")
	If($winSize[0] <= $GOWWindowSize[0]) Then
	  LogMessage("Calling CloseGOW, from main loop because it still looks like we are in it",5)
	  CloseGOW()
   EndIf
Next

MsgBox(0,"Success","Finished")

;END IT ALL
Exit

