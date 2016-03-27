
;;;; This assumed MS is the second icon down. GoW is the first one
Global Const $Icon[] = [40,240]
local $mscolor = PixelGetColor(40,240)
ClipPut("Global Const $GOWIcon[] = [40,130]   /n Global Const $GOWColor =" & $mscolor)

Local $LogFileName = "MSLocalConstantsBluestacks.au3"
If FileExists($LogFileName) = 1 Then
   FileDelete($LogFileName)
EndIf

FileWriteLine($LogFileName,"#include-once")
FileWriteLine($LogFileName,"Global Const $MSIcon[] = [40,240]")
FileWriteLine($LogFileName,"Global Const $MSColor = " & $mscolor)