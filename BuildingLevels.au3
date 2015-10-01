#include-once
#include <Array.au3>
#include "GowActions.au3"

Global Const $CheckSumArray = [560, 595, 575, 708]

Func GetBuildingLevelCheckSum()
   return PixelChecksum ($CheckSumArray[0], $CheckSumArray[1], $CheckSumArray[2], $CheckSumArray[3])
EndFunc

Func GetBuildingLevel()

   Local $currBuilding = GetBuildingLevelCheckSum()

   local $foundLevel = -1

   $foundLevel = _ArraySearch($VillaCheckSum, $currBuilding)
   If ($foundLevel > 0) Then
	  LogMessage("Found a Villa, level " & $foundLevel)
	  Return $foundLevel
   EndIf

   $foundLevel = _ArraySearch($FarmCheckSum, $currBuilding)
   If ($foundLevel > 0) Then
	  LogMessage("Found a Farm, level " & $foundLevel)
	  Return $foundLevel
   EndIf

   $foundLevel = _ArraySearch($LogMillCheckSum, $currBuilding)
   If ($foundLevel > 0) Then
	  LogMessage("Found a Logging Camp, level " & $foundLevel)
	  Return $foundLevel
   EndIf

   $foundLevel = _ArraySearch($QuarryCheckSum, $currBuilding)
   If ($foundLevel > 0) Then
	  LogMessage("Found a Quarry, level " & $foundLevel)
	  Return $foundLevel
   EndIf

   $foundLevel = _ArraySearch($MineCheckSum, $currBuilding)
   If ($foundLevel > 0) Then
	  LogMessage("Found a Mine, level " & $foundLevel)
	  Return $foundLevel
   EndIf

   LogMessage("No building found, checksum = " & $currBuilding)
EndFunc


Global Const $VillaCheckSum = [3582546796, _
22523015, _
2541011723, _
1990051423, _
4181521007, _ ; lvl5
2642938686, _
2358182550, _
4264180414, _
1479167690, _ ; lvl9
1177586662, _
3387520002, _
2928913222, _
2354690174, _ ; lvl13
785692846, _
861987710, _
3672898498, _ ;lvl 16
752941122, _
1682189041, _
1317158965, _ ; lvl19
3287901745, _
773088375] ; lvl21


Global Const $FarmCheckSum = [1889235783, _
21889235783, _
2280967059, _
313379907, _
1085536347, _
2407141698, _
810289262, _
2917154954, _
843863242, _ ; lvl9
2198311442, _
1752726002, _
2420224326, _
3045310082, _
3580149458, _ ;lvl 14
1832905078, _
77005333, _
2826174014, _
3785240825, _
2581415469, _ ;lvl19
868707425, _
1515216835] ; lvl21

;log 21 = 2162319995
Global Const $LogMillCheckSum = [2517526627, _
549890815, _
2879897987, _
3023684743, _
3976589447, _ ; lvl5
4004907394, _
2580938902, _
3901569262, _
590302482, _
3979972998, _
3448142182, _
3094130858, _ ;lvl12
41336334, _
2776088114, _
3134056630, _ ;lvl15
2313814397, _
1239678350, _
190394449, _
3067823517, _
1759931333, _ ;lvl20
2162319995]

Global Const $QuarryCheckSum = [3370214871, _
1272883879, _
3208560951, _
226739411, _
1658450107, _
2714569158, _
3315859642, _ ; lvl7
3812899126, _
3806874954, _
2737736294, _
4227953254, _
1482467734, _
2925836014, _ ;lvl13
2929506070, _
2530271666, _
4023515710, _
623834762, _
4064356685, _ ; lvl18
1540308617, _
828138649, _
486364103] ;lvl21

;21 = 442592471
Global Const $MineCheckSum =[3108926043, _
2278732839, _
672320171, _
2719993379, _
881195623, _
3806335774, _
1232341602, _ ;lvl7
3005891222, _
3398915794, _
423597058, _
3664477126, _
3946033958, _ ;lvl12
2339422362, _
185843862, _
3943951166, _
2778989573, _
1734082609, _
4009505493, _ ;lvl18
3611641893, _
1420914289, _
442592471]