 #include <Array.au3>
 #include <Clipboard.au3>

Global Const $ShieldColor = 16514042
Global Const $ShieldColorAlt = 15658214
Global Const $ShieldSearchLeft = 155
Global Const $ShieldSearchTop = 130
Global Const $ShieldSearchRight = 155
Global Const $ShieldSearchBottom = 310

local $count=0
local $tempColor = 0
local $colors1[100]
local $colors2[100]
local $colors3[100]

For $i = 120 to 150
   $tempColor = PixelGetColor($ShieldSearchLeft, $i)
   _ArraySearch($colors1,$tempColor)
   If @error=6 Then ; not found
	  $colors1[$count] = $tempColor
	  $count+=1
   EndIf

Next

$count=0
For $i = 170 to 200
   $tempColor = PixelGetColor($ShieldSearchLeft, $i)

   _ArraySearch($colors2,$tempColor)
   If @error=6 Then ; not found
	  $colors2[$count] = $tempColor
	  $count+=1
   EndIf
Next

Local $distinct[100]

$count=0
For $one In $colors1
   _ArraySearch($colors2,$one)
   If @error=6 Then ; not found
	  $distinct[$count] = $one
	  $count+=1
   EndIf
Next

For $two In $colors2
   _ArraySearch($colors1,$two)
   If @error=6 Then ; not found
	  $distinct[$count] = $two
	  $count+=1
   EndIf
Next

   _ArrayDisplay($distinct)
   _ClipBoard_SetData($distinct,$CF_TEXT)
Exit

   PixelGetColor
   ;;we poll here looking for a specific color on a one wide rectangle and click where we find it.
   Local $shieldError = 0
   Local $shieldCoord = PixelSearch($ShieldSearchLeft,$ShieldSearchTop,$ShieldSearchRight,$ShieldSearchBottom, $ShieldColor)
   $shieldError = @error
   if($shieldError = 1) Then
	  $shieldCoord = PixelSearch($ShieldSearchLeft,$ShieldSearchTop,$ShieldSearchRight,$ShieldSearchBottom, $ShieldColorAlt)
	  $shieldError = @error
   endif