#include "GowConstants.au3"
#include "GowActions.au3"
#include <Date.au3>
#include <Array.au3>

Local $width = 250
Local $height = 130
Local $loginEmail = InputBox("Username", "UserName:","","",$width,$height)
Local $loginPWD =  InputBox("Password", "Password:","","",$width,$height)

;Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
HotKeySet("{F9}","HotKeyPressed")
HotKeySet("{F8}","HotKeyPressed")


If FileExists($LogFileName) = 1 Then
   FileDelete($LogFileName)
EndIf

WinActivate ("GOw2 [Running] - Oracle VM VirtualBox","")
Sleep(1000)
WinWaitActive ("GOw2 [Running] - Oracle VM VirtualBox","")

;Dependant on window at 401x77
WinMove("GOw2 [Running] - Oracle VM VirtualBox","",$GOWVBHostWindow[0],$GOWVBHostWindow[1])

Local $StartTime = '2015/06/24 05:30:00'


;Open GOW
;OpenGOW(0)

;Login
;Login($loginEmail,$loginPWD)

;Logout
;Logout()
;Sleep(5000)

While (_DateDiff('n',_NowCalc(),$StartTime) > 0)
   Sleep(300000) ; Sleep 5 minutes

   MouseMove($LoginButton[0],$LoginButton[1])
   Sleep(1000)
   MouseMove($LoginFailureButton[0],$LoginFailureButton[1])
   Sleep(1000)
WEnd

;Open GOW
OpenGOW(0)

;Login
Login($loginEmail,$loginPWD)

Local $openedChests = 0

If Not CheckForCityScreen(0) Then
   MsgBox(0,"Paused","Something went wrong....  Don't have a login")
EndIf

;Gifts()
Local $totalChests = 0
;Loop to get all chests
Do
   $openedChests = Chests()
   $totalChests += $openedChests
Until ($openedChests = 0)

;Logout
;Logout()
Sleep(5000)

MsgBox(0,"Success","Total Chests opened: " & $totalChests)

;END IT ALL
Exit

