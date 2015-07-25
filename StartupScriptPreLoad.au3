;The last field should be changed to the correct gowscripts directory.
;This only needs to be run once.
RegWrite("HKEY_LOCAL_MACHINE64\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "GoWStartupScript", "REG_SZ", "C:\Personal\GitHub\Startup.bat")