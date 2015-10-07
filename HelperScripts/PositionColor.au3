HotKeySet("{F2}","HotKeyPressed")
HotKeySet("{ESC}", "Terminate")


Func HotKeyPressed()
    Switch @HotKeyPressed ; The last hotkey pressed.
        Case "{F2}"

			   $pos = MouseGetPos()
			   $color = PixelGetColor($pos[0],$pos[1])
			   ClipPut($pos[0]&","&$pos[1] & " - " & $color)
            Exit

    EndSwitch
 EndFunc   ;==>HotKeyPressed


While 1
   Sleep(100)
WEnd



Func Terminate()
    Exit
EndFunc   ;==>Terminate