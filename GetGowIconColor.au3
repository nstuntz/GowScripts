

Global Const $Icon[] = [40,130]
local $gowcolor = PixelGetColor(40,130)
ClipPut("Global Const $GOWIcon[] = [40,130]   /n Global Const $GOWColor =" & $gowcolor)

Local $LogFileName = "GowLocalConstantsBluestacks.au3"
If FileExists($LogFileName) = 1 Then
   FileDelete($LogFileName)
EndIf

FileWriteLine($LogFileName,"#include-once")
FileWriteLine($LogFileName,"Global Const $GOWIcon[] = [40,130]")
FileWriteLine($LogFileName,"Global Const $GOWColor = " & $gowcolor)