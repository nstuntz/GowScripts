#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <File.au3>
#include "GowConstantsBluestacks.au3"
#include "GowActionsBluestacks.au3"
#include "LoginObject.au3"
#include "GowConstantsBluestacks.au3"


While 1

   ;If MachineBluestacksStopped() Then

   If 1 Then
	  $FirstTime = False

	  ;If they are kill all autoit except this one
	  Local $aProcessList = ProcessList("autoit3.exe")
	  For $i = 1 To $aProcessList[0][0]
		 If (@AutoItPID <> $aProcessList[$i][1] )Then
			ProcessClose (  $aProcessList[$i][1] )
		 EndIf
	  Next

	  ;If they are kill all autoit except this one
	  Local $aProcessList = ProcessList("autoit3.exe")
	  For $i = 1 To $aProcessList[0][0]
		 If(StringLeft($aProcessList[$i][0],3) = "HD-" )Then
			ProcessClose (  $aProcessList[$i][1] )

			MsgBox($MB_SYSTEMMODAL, "", "Killed an HD one")
		 EndIf
	  Next

	  ;Shrink everything
	  WinMinimizeAll()
	  Sleep(1000)

	  ;double click the Icon
	  SendMouseClick($GOWIcon[0],$GOWIcon[1])
	  SendMouseClick($GOWIcon[0],$GOWIcon[1])

	  ;Sleep 2 minutes for BS to restart
	  Sleep(120000)


	  ;Restart OneRing to start everything
	  ;Run(@AutoItExe & " /AutoIt3ExecuteScript  TheOneRing.au3")
	  Sleep(1000)
   EndIf

   ;Check every 10 min
   Sleep(1000*60*10)
WEnd
