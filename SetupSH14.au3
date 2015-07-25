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

CollectAllCityQuests()

CollectAllTokens()

Local $totalChests = 0
;Loop to get all chests
Do
   $openedChests = Chests()
   $totalChests += $openedChests
Until ($openedChests = 0)


Login_SetInProcess($loginEmail,0)

MsgBox(0,"Success","Finished")