
#include "CommonActions.au3"
Global Const $LogFileName = "Log.txt"
for $i = 120 to 310
   LogMessage("pixel at " & $i & " is: " & PixelGetColor(155,$i))

Next