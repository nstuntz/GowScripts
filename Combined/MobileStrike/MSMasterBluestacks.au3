;#include "GowConstants.au3"
#include "MSConstantsBluestacks.au3"
#include "MSActionsBluestacks.au3"
#include <Date.au3>
#include <Array.au3>


Func RunMSCity()

   ;Sleep for 5 minutes because we think that we need another city to pick up the one we just did.
;   if($MSSleepOnLogout = 1) Then
;	  Sleep(300000)
;	  $MSSleepOnLogout = 0
;  EndIf

   Sleep(500)

   LogMessage("Script Version -  "  &  $VersionNumber)
   LogMessage("Logging IN New User -  "  &  _Now())

   ;Open GOW
   local $openRet = OpenMS(0)
   ;MsgBox($MB_SYSTEMMODAL, "", $openRet )
   LogMessage("Opening game returned: " & $openRet)
   if  ($openRet = -1) Then
	  LogMessage("Tried to open MS 5 times without working. Leaving to get a new city type and check restart timers.")
	  Return
   EndIf

   ;Read the Login File
   If Not Login_LoadMS() Then
	  LogMessage("-----Login Load Failed-----",5)
	  CloseMS()
	  LogMessage("-----Sleeping 1 minutes-----",5)
	  Sleep(60000)
	  Return
   EndIf
   LogMessage("Logging in for " & Login_Email(),2)

   Local $MStimerLogin = TimerInit()
   ;Login
   If Not LoginMS(Login_Email(),Login_Pwd()) Then
	  LogMessage("Login Attempt Failed",5)
	  ;CloseMS()

	  Login_WritePerformanceLog(TimerDiff($MStimerLogin), "Login Failed")
	  ;Set the last run so this city doesn't keep getting processed
	  ;Login_Write()
	  ;Updated logic to set InProcess to 0 and not update LastRun. The real fix to what Than did the line above. GS -07062015
	  Login_ResetInProcess()

	  ;Log out.
	  Send("{ESC}")
	  Sleep(2000)
	  If CheckForColor($MSQuitGameDialogYesButton[0],$MSQuitGameDialogYesButton[1], $MSYesQuitWhite) Then
		 SendMouseClick($MSQuitGameDialogYesButton[0],$MSQuitGameDialogYesButton[1])
	  EndIf

	  CloseMS()

	  LogMessage("-----Sleeping 30 seconds-----",5)
	  Sleep(30000)
	  Return
   EndIf

   If Not CheckForCityScreenMS(0) Then
	  LogMessage("Check for city Failed - 2",5)
	  Login_WritePerformanceLog(TimerDiff($MStimerLogin), "Login Failed")
	  CloseMS()
	  Return
   EndIf

   Login_WritePerformanceLog(TimerDiff($MStimerLogin), "Login")
   ;Save the image resources
   ;SaveRSSImageMS()

   ;Save the City Image
  ; SaveCityImageMS()
   ;SaveGoldImageMS()
  ; SaveHeroImageMS()
   ;Only get Treasury image if the SH can use it
   If Login_Treasury() = 1 Then
	  SaveTreasuryImageMS()
   EndIf

   local $MSbuilt = 0

   ;Local $MStimerAthenaGift = TimerInit()
   CollectAthenaGiftMS()
   ;Login_WritePerformanceLog(TimerDiff($MStimerAthenaGift), "Athena")

   ;Local $MStimerSecretGift = TimerInit()
   CollectSecretGiftMS()
   ;Login_WritePerformanceLog(TimerDiff($MStimerSecretGift), "Collect Secret Gift")

   If Not CheckForCityScreenMS(0) Then
	  LogMessage("Collect Secret Gift Failed - 3",5)
	  CloseMS()
	  Return
   EndIf

   ;Local $MStimerHelps = TimerInit()
   HelpsMS()
   ;Login_WritePerformanceLog(TimerDiff($MStimerHelps), "Helps")

   If Not CheckForCityScreenMS(0) Then
	  LogMessage("Helps Failed - 4",5)
	  CloseMS()
	  Return
   EndIf

   Local $MStimerShield = TimerInit()
   ;CheckShieldColor()
   ShieldMS(1)
   Login_WritePerformanceLog(TimerDiff($MStimerShield), "Shield")

   If Not CheckForCityScreenMS(0) Then
	  LogMessage("Shield Failed - 6",5)
	  CloseMS()
	  Return
   EndIf

   ;Local $MStimerTreasury = TimerInit()
   TreasuryMS()
   ;Login_WritePerformanceLog(TimerDiff($MStimerTreasury), "Treasury")

   If Not CheckForCityScreenMS(0) Then
	  LogMessage("Treasury Failed - 7",5)
	  CloseMS()
	  Return
   EndIf

   ;Local $MStimerBank = TimerInit()
   BankMS()
   ;Login_WritePerformanceLog(TimerDiff($MStimerBank), "Bank")

   If Not CheckForCityScreenMS(0) Then
	  LogMessage("Bank Failed - 8",5)
	  CloseMS()
	  Return
   EndIf

   CollectQuestsMS()
   If Not CheckForCityScreenMS(0) Then
	  LogMessage("Collect Quests Failed - 5",5)
	  CloseMS()
	  Return
   EndIf


   GiftsMS()
   If Not CheckForCityScreenMS(0) Then
	  LogMessage("Collect Gifts Failed - 5",5)
	  CloseMS()
	  Return
   EndIf
   ;Logout
   LogMessage("Logging out",2)
   LogoutMS()
   Sleep(3000)

   ;_FileWriteFromArray("logins.txt", $MSlogins)
   Login_Write()

   ;Paranoia to make sure we are closed out

   ;Check if the android home button is on the right or the bottom, bottom means we are out side means close out and then open and try logout
	;If CheckForColor( $MSAndroidHomeButton[0],$MSAndroidHomeButton[1], $MSBlack) Then

	;Checking the size of the window
	Local $MSwinSize = WinGetClientSize("BlueStacks")
	If($MSwinSize[0] <= $MSWindowSize[0]) Then
	  LogMessage("Calling CloseGOW, from main loop because it still looks like we are in it",5)
	  CloseMS()
   EndIf

EndFunc

