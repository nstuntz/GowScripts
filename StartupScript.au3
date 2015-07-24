#include "GowConstants.au3"
#include "GowActions.au3"
#include <File.au3>

;Sleep(300000)

;This should use the InstallDir from the registry to run VirtualBox.exe
local $VBDir = RegRead("HKEY_LOCAL_MACHINE64\SOFTWARE\Oracle\VirtualBox","InstallDir")
Run($VBDir & "\VirtualBox.exe")
;MsgBox($MB_SYSTEMMODAL, "", "Opened VB")
Sleep(100000)
WinActivate ("Oracle VM VirtualBox Manager","")
Sleep(1000)
WinWaitActive ("Oracle VM VirtualBox Manager","")
WinMove("Oracle VM VirtualBox Manager","",$VBWindow[0],$VBWindow[1])


If(PollForColor($VBStartArrow[0],$VBStartArrow[1],$VBStartArrowColor,30000)) Then
   SendMouseClick($VBStartArrow[0],$VBStartArrow[1])

   ;MsgBox($MB_SYSTEMMODAL, "", "Clicked start")
   Sleep(120000)
   Run(@AutoItExe & " /AutoIt3ExecuteScript  TheOneRing.au3")
   Sleep(1000)
Else

   LogMessage("Startup script failed to run",1)
EndIf
