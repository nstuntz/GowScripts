

#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <File.au3>

#include "../GowConstantsBluestacks.au3"
#include "../GowActionsBluestacks.au3"
#include "../MachineConfig.au3"
#include "../LoginObject.au3"


Local $width = 250
Local $height = 130
Local $aData
Local $iRows
Local $iColumns
Local $iRval

local $tag =  InputBox("Alliance", "Alliance:","aoC","",$width,$height)
Local $sqlText = "select username, password, loginid from cityview where alliance='" & $tag & "' and loginid>39"
_SqlConnect()

$iRval = _SQL_GetTable2D(-1,$sqlText,$aData,$iRows,$iColumns)

_SQL_Close()

If $iRval = $SQL_ERROR Then
   MsgBox($MB_SYSTEMMODAL, "", _SQL_GetErrMsg())
   MsgBox($MB_SYSTEMMODAL, "", $SQL_ERROR)
   Exit
EndIf

local $i = 0
For $i = 1 to $iRows step 1


   ;; This will need to call the decrypt function on the data.
   local $userName = $aData[$i][0]
   local $password = Decrypt("0x" & $aData[$i][1])
   local $loginID = $aData[$i][2]

   _SqlConnect()
   _SQL_Execute(-1,"Update Login Set InProcess='" & @ComputerName & "' Where LoginID = " & $loginID)
   _SQL_Close()

   ;MsgBox($MB_SYSTEMMODAL, "", $userName & " - " & $password )

   ;Open GOW
   OpenGOW(0)

   Login($userName,$password)

   MsgBox($MB_SYSTEMMODAL, "", "Move City" )

   Logout()

   _SqlConnect()
   _SQL_Execute(-1,"Update Login Set InProcess=0 Where LoginID = " & $loginID)
   _SQL_Close()

Next
