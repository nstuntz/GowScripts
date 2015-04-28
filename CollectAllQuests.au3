#include "GowConstants.au3"
#include "GowActions.au3"
#include <Date.au3>
#include <Array.au3>

Global $loginEmail = "gowgunt.ar@gmail.com" ;"tanielamelia@gmail.com"
Global $loginPWD = "gowguntar";"danmelia"

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

Login_SetInProcess($loginEmail,$MachineID)

CollectAllQuestsWithChances(1,1)

Login_SetInProcess($loginEmail,0)

MsgBox(0,"Success","Finished")