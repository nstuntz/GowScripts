#include "GowConstants.au3"
#include "GowActions.au3"
#include <Date.au3>
#include <Array.au3>

Global $loginEmail = "nathaniel@stuntz.org"
Global $loginPWD = "stuntz1234"

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


Gifts()

Chests()


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

