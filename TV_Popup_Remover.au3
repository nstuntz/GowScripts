Local $tvHandle = 0
while True
	$tvHandle = WinWaitActive("Sponsored session")
	if Not ($tvHandle = 0) Then
		Send("{Enter}")
	EndIf
WEnd