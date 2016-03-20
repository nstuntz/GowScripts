
#include "GowConstantsAmiDuos.au3"
#include "GowActionsAmiDuos.au3"

WinActivate ("DuOS","")
Sleep(1000)
WinWaitActive ("DuOS","")
Sleep(1000)
   WinMove("DuOS","",$GOWVBHostWindow[0],$GOWVBHostWindow[1],$GOWWindowSize[0],$GOWWindowSize[1])
Sleep(1000)