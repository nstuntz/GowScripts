#include "../GowConstantsBluestacks.au3"
#include "../GowActionsBluestacks.au3"
#include "../LoginObject.au3"
#include <Date.au3>
#include <Array.au3>

Local $width = 250
Local $height = 130

Local $AlreadyLoggedIn = InputBox("Logged In", "Currently Open and Logged In (1/0):","0","",$width,$height)
Local $loginEmail = InputBox("Username", "UserName:","","",$width,$height)
Local $loginPWD =  InputBox("Password", "Password:","","",$width,$height)

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
Else
   MsgBox(0,"Paused","$AlreadyLoggedIn = " & $AlreadyLoggedIn)
EndIf
Local $startRunTime = _NowCalc()


Login_SetInProcess($loginEmail,$MachineID)

Local $openedChests = 0

;Gifts()

Local $totalChests = 0
;Loop to get all chests
Do
   $openedChests = Chests()
   $totalChests += $openedChests
Until ($openedChests = 0)


Login_SetInProcess($loginEmail,0)

MsgBox(0,"Success","Total Chests opened: " & $totalChests & " -- Time = " & _DateDiff('n',$startRunTime,_NowCalc()))

;END IT ALL
Exit

