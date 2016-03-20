
#include "../GowConstantsBluestacks.au3"
#include "../GowActionsBluestacks.au3"
#include <Date.au3>
#include <Array.au3>

Local $width = 250
Local $height = 130
Local $loginEmail = InputBox("Username", "UserName:","","",$width,$height)
Local $loginPWD =  InputBox("Password", "Password:","","",$width,$height)


;Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
HotKeySet("{F9}","HotKeyPressed")
HotKeySet("{F8}","HotKeyPressed")

WinActivate ("BlueStacks","")
Sleep(1000)
WinWaitActive ("BlueStacks","")
Sleep(1000)
WinMove("BlueStacks","",$GOWVBHostWindow[0],$GOWVBHostWindow[1])

LogMessage("Starting All Tokens",2)

;Open GOW
OpenGOW(0)

;Login
Login($loginEmail,$loginPWD)

Login_SetInProcess($loginEmail,$MachineID)

CollectAllTokens()

Login_SetInProcess($loginEmail,0)

LogMessage("Ending All Tokens",2)

MsgBox(0,"Finished","Finished")