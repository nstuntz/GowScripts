#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <File.au3>
#include "GowConstants.au3"
#include "GowActions.au3"

HotKeySet("{F10}","HotKeyPressed")

;Delay the start of doing anything so that this script can start another instance and kill itself if it is updated
Sleep(15000) ; 15 seconds

;Find Git
Local $FirstTime = True
Local $GitPath
Local $MyDate
Local $gitExes = _FileListToArrayRec(@LocalAppDataDir, "Git.exe",$FLTAR_FILES ,$FLTAR_RECUR ,$FLTAR_NOSORT ,$FLTAR_FULLPATH)

For $i = 0 to UBound($gitExes)-1
   If (StringInStr (  $gitExes[$i], "Bin\Git.exe")) Then
	  $GitPath = $gitExes[$i] ; MsgBox($MB_SYSTEMMODAL, "", "Found it: " &  )
   EndIf
Next

If WinGetState ("GOw2 [Running] - Oracle VM VirtualBox") < 1 Then
   MsgBox($MB_SYSTEMMODAL, "", "GOW Virtual Machine isn't running.  Start Virtual box and the Gow2 host first.  Quitting.")
   Exit
EndIf


While 1
   ;Make array of files and dates
   Local $aFileList = _FileListToArray(@ScriptDir, "*")

   Local $FileDates[UBound($aFileList)][2]

   For $i = 0 to UBound($aFileList)-1
	  $FileDates[$i][0] = $aFileList[$i]
	  $FileDates[$i][1] = FileGetTime($aFileList[$i],0,1)

	  If @ScriptName = $aFileList[$i] Then
		 $MyDate = FileGetTime($aFileList[$i],0,1)
	  EndIf
   Next

   ;Sync Git
   RunWait(@ComSpec & " /c " & $GitPath & " pull")

   ;Check if any files are updated
   Local $UpdatedFileList = _FileListToArrayRec (@ScriptDir, "*.au3")
   Local $fileChanged = False
   For $i = 0 to UBound($UpdatedFileList)-1

	  ;Check the scripts to see if anything updated
	  For $k = 0 to UBound($FileDates)-1
		 If $FileDates[$k][0] = $UpdatedFileList[$i] Then
			If ($FileDates[$k][1] <> FileGetTime($UpdatedFileList[$i],0,1)) Then
			   $fileChanged = True
			EndIf
			ExitLoop
		 EndIf

		 ;If we have anything changed we restart the scripts
		 If $fileChanged Then
			ExitLoop
		 EndIf

	  Next
   Next


   If $fileChanged OR $FirstTime Then

	  $FirstTime = False

	  ;If they are kill all autoit except this one
	  Local $aProcessList = ProcessList("autoit3.exe")
	  For $i = 1 To $aProcessList[0][0]
		 If (@AutoItPID <> $aProcessList[$i][1] )Then
			ProcessClose (  $aProcessList[$i][1] )
		 EndIf
	  Next

	  Sleep(1000)
	  Run(@AutoItExe & " /AutoIt3ExecuteScript  TV_Popup_Remover.au3")
	  Sleep(1000)
	  Run(@AutoItExe & " /AutoIt3ExecuteScript  MousePosition.au3")
	  Sleep(1000)
	  Run(@AutoItExe & " /AutoIt3ExecuteScript  UpgradeBuildings.au3")
	  Sleep(1000)

	  ;Should we restart the master script
	  If $MyDate <> FileGetTime(@ScriptName,0,1)) Then
		 Run(@AutoItExe & " /AutoIt3ExecuteScript  TheOneRing.au3")
		 ProcessClose(@AutoItPID)
	  EndIf
   EndIf

   ;Check every 4 hours
   Sleep(1000*60*60*4)
WEnd

