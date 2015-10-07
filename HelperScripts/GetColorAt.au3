HotKeySet("{F2}","HotKeyPressed")
HotKeySet("{F3}","HotKeyPressed")
HotKeySet("{F1}", "Terminate")


Local $width = 250
Local $height = 130
local $color
Func HotKeyPressed()
    Switch @HotKeyPressed ; The last hotkey pressed.
        Case "{F2}"

				Local $X =  InputBox("X", "X:","0","",$width,$height)
				Local $Y =  InputBox("Y", "Y:","0","",$width,$height)
			   $color = PixelGetColor($X,$Y)
			   MouseMove($X,$Y)
			   ClipPut($X & "," & $Y & " - " & $color)
            ;Exit
        Case "{F3}"

			   local $pos = MouseGetPos()
			   $color = PixelGetColor($pos[0],$pos[1])
			   ClipPut($pos[0]&","&$pos[1] & " - " & $color)
            
    EndSwitch
 EndFunc   ;==>HotKeyPressed


While 1
   Sleep(100)
WEnd



Func Terminate()
    Exit
EndFunc   ;==>Terminate