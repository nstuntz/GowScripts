#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <File.au3>
#include "GowConstantsBluestacks.au3"
#include "GowActionsBluestacks.au3"

HotKeySet("{F10}","HotKeyPressed")

;Delay the start of doing anything so that this script can start another instance and kill itself if it is updated
Sleep(15000) ; 15 seconds

;Find Git
Local $FirstTime = True
Local $BSRestarts = 0
Local $GitPath
Local $MyDate = ""
Local $gitExes = _FileListToArrayRec(@LocalAppDataDir, "Git.exe",$FLTAR_FILES ,$FLTAR_RECUR ,$FLTAR_NOSORT ,$FLTAR_FULLPATH)

For $i = 0 to UBound($gitExes)-1
   If (StringInStr (  $gitExes[$i], "cmd\Git.exe")) Then
	  $GitPath = $gitExes[$i]
	  ;MsgBox($MB_SYSTEMMODAL, "", "Found it: " &  $GitPath)
   EndIf
Next

;If WinGetState ("BlueStacks") < 1 Then
;   MsgBox($MB_SYSTEMMODAL, "", "BlueStacks isn't running.  Start BlueStacks first.  Quitting.")
;   Exit
;EndIf

;Set the start date to 6 hours ago so it gets the latest scripts when it starts
Local $oneRingLastRun = _DateAdd('h',-6,_NowCalc())

While 1

   ;Check every 4 hours for new scripts
   If (_DateDiff('h',$oneRingLastRun,_NowCalc())) > 4 Then
	  LogMessage("Getting latest scripts -  " & @ComputerName,5)
	  GetLatestScripts()
	  $oneRingLastRun = _NowCalc()
   EndIf

   ;Check that BS is running every 10 minutes
   If NOT IsMachineActive() Then
	  LogMessage("Restarting Bluestacks -  " & @ComputerName,5)
	  RestartBS()
   EndIf



   ;Check every 10 min
   Sleep(1000*60*10)
WEnd

Func GetLatestScripts()

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
   Run(@ComSpec & " /c """ & $GitPath & """ pull")

   Sleep(4000)
   ;Type user
   Send('gowscripts')
   Send("{ENTER}")
   Sleep(500)
   ;Type pwd
   Send('gowscripts12')
   Send("{ENTER}")
   Sleep(500)

   Sleep(4000)
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
;MsgBox($MB_SYSTEMMODAL, "", "Starting scripts - Get Latest Scripts")
	  Sleep(1000)
	  Run(@AutoItExe & " /AutoIt3ExecuteScript  TV_Popup_Remover.au3")
	  Sleep(1000)
	  Run(@AutoItExe & " /AutoIt3ExecuteScript  MousePosition.au3")
	  Sleep(1000)
	  Run(@AutoItExe & " /AutoIt3ExecuteScript  UpgradeBuildingsBluestacks.au3")
	  Sleep(1000)

	  ;Should we restart the master script
	  If ($MyDate <> FileGetTime(@ScriptName,0,1)) Then
		 LogMessage("Restarting OneRing because it is old -  " & @ComputerName,5)
		 Run(@AutoItExe & " /AutoIt3ExecuteScript  TheOneRing.au3")
		 Sleep(500)
		 ProcessClose(@AutoItPID)
	  EndIf
   EndIf

EndFunc


Func RestartBS()

   $BSRestarts = $BSRestarts + 1

   If $BSRestarts > 4 Then
	  LogMessage("Restarting Whole Machine -  " & @ComputerName,5)
	  Sleep(1000)
	  Shutdown(6)
	  Exit
   EndIf

;MsgBox($MB_SYSTEMMODAL, "", "Starting scripts - Restart BS")
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

   ;If they are kill all autoit except this one
   Local $aProcessList = ProcessList()
   For $i = 1 To $aProcessList[0][0]
	  If(StringLeft($aProcessList[$i][0],3) = "HD-" )Then
		 ProcessClose( $aProcessList[$i][1] )
	  EndIf
   Next

   ;Shrink everything
   WinMinimizeAll()
   Sleep(30000)

   ;double click the Icon
   SendMouseClick($GOWIcon[0],$GOWIcon[1])
   SendMouseClick($GOWIcon[0],$GOWIcon[1])

   ;Sleep 4 minutes for BS to restart
   Sleep(120000)

   Run(@AutoItExe & " /AutoIt3ExecuteScript  UpgradeBuildingsBluestacks.au3")
   Sleep(1000)
EndFunc
