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
Local $GitPath
Local $MyDate = ""
Local $gitExes = _FileListToArrayRec(@LocalAppDataDir, "Git.exe",$FLTAR_FILES ,$FLTAR_RECUR ,$FLTAR_NOSORT ,$FLTAR_FULLPATH)

For $i = 0 to UBound($gitExes)-1
   If (StringInStr (  $gitExes[$i], "Bin\Git.exe")) Then
	  $GitPath = $gitExes[$i] ; MsgBox($MB_SYSTEMMODAL, "", "Found it: " &  )
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
	  ;MsgBox($MB_SYSTEMMODAL, "", "Getting Latest")
	  GetLatestScripts()
	  $oneRingLastRun = _NowCalc()
   EndIf

   ;Check that BS is running every 10 minutes
   If IsMachineActive() Then
	  ;MsgBox($MB_SYSTEMMODAL, "", "Restarting BS")
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
   RunWait(@ComSpec & " /c """ & $GitPath & """ pull")

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
	  Run(@AutoItExe & " /AutoIt3ExecuteScript  UpgradeBuildingsBluestacks.au3")
	  Sleep(1000)

	  ;Should we restart the master script
	  If ($MyDate <> FileGetTime(@ScriptName,0,1)) Then
		 Run(@AutoItExe & " /AutoIt3ExecuteScript  TheOneRing.au3")
		 ProcessClose(@AutoItPID)
	  EndIf
   EndIf

EndFunc


Func RestartBS()

   ;If they are kill all autoit except this one
   Local $aProcessList = ProcessList()
   For $i = 1 To $aProcessList[0][0]
	  If(StringLeft($aProcessList[$i][0],3) = "HD-" )Then
		 ProcessClose( $aProcessList[$i][1] )
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
EndFunc
