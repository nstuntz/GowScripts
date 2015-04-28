
; F10 triggers the coordinates message box.
HotKeySet("{F10}", "mouse_pos")

Func mouse_pos()
   $pos = MouseGetPos()
   MsgBox(0,"Your mouse pointer coordinate is:", $pos[0]&"x"&$pos[1])
EndFunc

;----------------------------------------------------------------------------------------------------

; Shows ToolTip with mouse position. F10 quits the scripts.
HotKeySet("{F10}", "quit")

While 1
   $pos = MouseGetPos()
   $color = PixelGetColor($pos[0],$pos[1])
ToolTip($pos[0]&"x"&$pos[1] & " - " & $color)
Sleep(100)
WEnd

Func quit()
Exit 0
EndFunc