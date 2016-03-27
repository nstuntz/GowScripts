Local $tvHandle = 0
while True
   $tvHandle = WinWait("Sponsored session")
   if Not ($tvHandle = 0) Then
	  WinActivate("Sponsored session")
	  Send("{Enter}")
   EndIf
WEnd