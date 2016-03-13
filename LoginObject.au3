;FORMAT - email|password|resourceType("ore-wood-stone-food-All")|LastBuiltBuilding|SHLevel
#include-once
#include <SQLHelper.au3>
#include <Date.au3>
#include <Clipboard.au3>
#include <Crypt.au3>


Global $gSqlInstance = "ets-tfs.cloudapp.net,51710"
Global $gSqlDatabase = "GowTest"
Global $gSqlUser = "GowTest"
Global $gSqlPassword = "Th!son3ISok#"
Global $gSqlAuthMode = False

Local $_userName = ""
Local $_Password = ""
Local $rssType = ""
Local $LastBuiltBuilding = -1
Local $SHLevel = 6
Local $amountsToSend[] = [0,0,0,0,0] ;[food,wood,stone,ore,silver]
local $delimiter = "|"

;Test
Local $_CityID = 0
Local $_LoginID = 0
Local $_CityName = ""
Local $_Kingdom = 0
Local $_LocationX = 0
Local $_LocationY = 0
Local $_Created = 0
Local $_Placed = 0
Local $_AllianceID = 0
Local $_Bank = 0
Local $_Rally = 0
Local $_Tent = 0
Local $_RallyX = 0
Local $_RallyY = 0
Local $_TentX = 0
Local $_TentY = 0
Local $_LastRally = _Now()
Local $_LastBank = _Now()
Local $_LastUpgrade = _Now()
Local $_LastTreasury = _Now()
Local $_ProductionPerHour = 0
Local $_LastAthenaGift = _Now()
Local $_StrongHoldLevel = 0
Local $_TreasuryLevel = 0
Local $_TreasuryCollect = 0
Local $_Shield = 0
Local $_LastShield = _Now()
Local $_LastRun = 0
Local $_LastUpgradeBuilding = -1
Local $_CollectAthenaGift = 0
Local $_RedeemCode = ""
Local $_Upgrade = 0
Local $_PIN = ""
Local $_RSSBank = 1
Local $_SilverBank = 1
Local $_RssMarches = 1
Local $_SilveMarches = 1
Local $_HasGoldMine = 0
Local $_TimezoneOffsetMin = -240
Local $_LoginDelayMin = 180
Local $_LoginAttempts = 0
Local $_LoginActive = 0
Local $_UserEmail = 0

; create connection to MSSQL
Func _SqlConnect() ; connects to the database specified

   $oADODB = _SQL_Startup()
   If $oADODB = $SQL_ERROR then
	  LogMessage(_SQL_GetErrMsg())
   EndIf

   If $gSqlAuthMode Then
	 If _SQL_Connect(-1, $gSqlInstance, $gSqlDatabase, "", "") = $SQL_ERROR then
		 _SQL_Close()
		 LogMessage(_SQL_GetErrMsg())
	 EndIf
   Else
	 If _SQL_Connect(-1, $gSqlInstance, $gSqlDatabase, $gSqlUser, $gSqlPassword) = $SQL_ERROR then
		 _SQL_Close()
		 LogMessage(_SQL_GetErrMsg())
	 EndIf
   EndIf

EndFunc


Func Login_Load($_userNameToGet = "")
   ;Read from the specific File for this login
   _SqlConnect()

   If Not GetOldestActiveLogin() then
	  LogMessage("Getting Login Failed - " & _SQL_GetErrMsg())
	  _SQL_Close()
	  return False
   EndIf

   If Not Load_City(Login_LoginID()) Then
	  LogMessage("Loading Login Failed - " & _SQL_GetErrMsg())
	  _SQL_Close()
	  return False
   EndIf

   _SQL_Close()
   return True

EndFunc

Func Load_City($loginID)
   Local $aData
   Local $iRows
   Local $iColumns
   Local $iRval

   $iRval = _SQL_GetTable2D(-1,"SELECT [CityID],[LoginID],[CityName],[Kingdom],[LocationX],[LocationY],[Created],[Placed],[ResourceTypeID],[AllianceID] FROM City where LoginID=" & $loginID ,$aData,$iRows,$iColumns)

   If $iRval = $SQL_ERROR Then
	  LogMessage("Load_City (City) -- " & _SQL_GetErrMsg())
	  return False
   EndIf

   $_CityID = $aData[1][0]
   $_LoginID = $aData[1][1]
   $_CityName = $aData[1][2]
   $_Kingdom = $aData[1][3]
   $_LocationX = $aData[1][4]
   $_LocationY = $aData[1][5]
   $_Created = $aData[1][6]
   $_Placed = $aData[1][7]
   $rssType = $aData[1][8]
   $_AllianceID = $aData[1][9]

   $iRval = _SQL_GetTable2D(-1,"SELECT ci.[CityID],[Bank],[Rally],[Tent],[RallyX],[RallyY],[TentX],[TentY],Convert(varchar(20),LastRally,120) as LastRallyConvert," & _
							  "Convert(varchar(20),LastBank,120) as LastBankConvert,Convert(varchar(20),LastUpgrade,120) as LastUpgradeConvert," & _
							  "[ProductionPerHour],[LastAthenaGift],[StrongHoldLevel],[TreasuryLevel],[Shield]," & _
							  "Convert(varchar(20),LastShield,120) as LastShieldConvert,Convert(varchar(20),LastUpgradeBuilding,120) as LastUpgradeBuildingConvert,CollectAthenaGift,RedeemCode,Upgrade, " & _
							  "RSSBankNum,SilverBankNum,RssMarches,SilverMarches,HasGoldMine," & _
							  "[Treasury],Convert(varchar(20),LastTreasury,120) as LastTreasuryConvert," & _
							  "DATEPART(TZ, SYSDATETIMEOFFSET()) as TimeZoneOffsetMin, [LoginDelayMin], [LoginAttempts], uc.Email FROM CityInfo ci " & _
							  "inner join City c on ci.CityID = c.CityID " & _
							  "inner join UserCity uc on uc.CityID = c.CityID " & _
							  "inner join Login l on c.LoginID = l.LoginID where ci.CityID=" & $_CityID,$aData,$iRows,$iColumns)

   If $iRval = $SQL_ERROR Then
	  LogMessage("Load_City (CityInfo) -- " & _SQL_GetErrMsg())
	  return False
   EndIf

   $_Bank = $aData[1][1]
   $_Rally = $aData[1][2]
   $_Tent = $aData[1][3]
   $_RallyY = $aData[1][5]
   $_TentX = $aData[1][6]
   $_TentY = $aData[1][7]
   $_LastRally = $aData[1][8]
   $_LastBank = $aData[1][9]
   $_LastUpgrade = $aData[1][10]
   $_RallyX = $aData[1][4]
   $_ProductionPerHour = $aData[1][11]
   $_LastAthenaGift = $aData[1][12]
   $_StrongHoldLevel = $aData[1][13]
   $_TreasuryLevel = $aData[1][14]
   $_Shield = $aData[1][15]
   $_LastShield = $aData[1][16]
   $_LastUpgradeBuilding = $aData[1][17]
   $_CollectAthenaGift = $aData[1][18]
   $_RedeemCode = $aData[1][19]
   $_Upgrade = $aData[1][20]

   $_RSSBank = $aData[1][21]
   $_SilverBank = $aData[1][22]
   $_RssMarches = $aData[1][23]
   $_SilveMarches = $aData[1][24]
   $_HasGoldMine = $aData[1][25]
   $_TreasuryCollect = $aData[1][26]
   $_LastTreasury = $aData[1][27]
   $_TimezoneOffsetMin = $aData[1][28]
   $_LoginDelayMin = $aData[1][29]
   $_LoginAttempts = $aData[1][30]
   $_UserEmail = $aData[1][31]


   ;Convert dates to UTC
   $_LastShield = _DateAdd('n',-1*$_TimezoneOffsetMin,$_LastShield)
   $_LastRally = _DateAdd('n',-1*$_TimezoneOffsetMin,$_LastRally)
   $_LastBank = _DateAdd('n',-1*$_TimezoneOffsetMin,$_LastBank)
   $_LastUpgrade = _DateAdd('n',-1*$_TimezoneOffsetMin,$_LastUpgrade)
   $_LastTreasury = _DateAdd('n',-1*$_TimezoneOffsetMin,$_LastTreasury)


   return True
EndFunc

Func ProactiveRestart()
   _SqlConnect()
   Local $iRval = _SQL_Execute(-1,"Exec ShouldRestartMachine '" & $MachineID & "'")

   Return $iRval
EndFunc

Func GetOldestActiveLogin()
   Local $aData
   Local $iRows
   Local $iColumns

   Local $iRval = _SQL_GetTable2D(-1,"Exec GetOldestLogin3 '" & $MachineID & "'",$aData,$iRows,$iColumns)

   If $iRval = $SQL_ERROR Then
	  LogMessage("GetOldestLogin2 -- " & _SQL_GetErrMsg())
	  return False
   EndIf

   $_userName = $aData[1][0]

   ;; This will need to call the decrypt function on the data.
   if( StringLen($aData[1][1]) > 15) Then
	  $_Password = Decrypt("0x" & $aData[1][1])
   Else
	  $_Password = $aData[1][1]
   EndIf

   $_LastRun = $aData[1][4]
   $_LoginID = $aData[1][3]
   $_PIN = $aData[1][5]
   $_TimezoneOffsetMin = $aData[1][6]

   $_LastRun = _DateAdd('n',-1*$_TimezoneOffsetMin,$_LastRun)

   return True
EndFunc

Func Decrypt($EncryptData)
   ;MsgBox(0, "", $EncryptData) ;Results in "This is Plain Text"
   Local $stringDecrypt
   $stringDecrypt = BinaryToString(_Crypt_DecryptData($EncryptData, "April May Blue Red Key for th3 encypt1on", $CALG_RC2))
   ;MsgBox(0, "", $stringDecrypt) ;Results in "This is Plain Text"
   return $stringDecrypt
EndFunc


Func Login_WritePerformanceLog($ElapsedTime, $ScriptFunction)
   _SqlConnect()
   _SQL_Execute(-1,"Exec InsertPerformanceLog '" & $MachineID & "', " & $ElapsedTime & ", '" & $ScriptFunction & "', '" & Login_Email() & "'" ) ; & Login_CityID())
   _SQL_Close()
EndFunc

Func Login_WriteShield()
   ;Read from the specific File for this login
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set LastShield = GetDate() Where CityID = " & Login_CityID())

   _SQL_Close()

EndFunc


Func Login_AthenaGiftCollected()
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set CollectAthenaGift = 0 Where CityID = " & Login_CityID())
   _SQL_Close()
EndFunc


Func Login_RedeemCodeCollected()
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set RedeemCode = '' Where CityID = " & Login_CityID())
   _SQL_Close()
EndFunc



Func Login_WriteHeroUpgradeNeeded()
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set HeroUpgradeNeeded = 1 Where CityID = " & Login_CityID())
   _SQL_Close()
EndFunc


Func Login_WriteResourcesNeeded()
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set NeedRSS = 1 Where CityID = " & Login_CityID())
   _SQL_Close()
EndFunc

Func Login_WriteResourcesNotNeeded()
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set NeedRSS = 0 Where CityID = " & Login_CityID())
   _SQL_Close()
EndFunc


Func Login_WriteResourcesImage($image)
   _ClipBoard_SetData("Exec SetResourceImage 9,'" & $image & "'" )

   _SqlConnect()
   _SQL_Execute(-1,"Exec SetResourceImage 9,'" & $image & "'") ; & Login_CityID())
   _SQL_Close()
EndFunc


Func Login_UpdateLastRally()
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set LastRally = GetDate() Where CityID = " & Login_CityID())
   _SQL_Close()
EndFunc

Func Login_UpdateLastRallyFAILED()
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set LastRally = '2015-01-01' Where CityID = " & Login_CityID())
   _SQL_Close()
EndFunc


Func Login_UpdateLastBank()
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set LastBank = GetDate() Where CityID = " & Login_CityID())
   _SQL_Close()
EndFunc

Func Login_UpdateShield($Shield)
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set Shield = " & $Shield & " Where CityID = " & Login_CityID())
   _SQL_Close()
EndFunc

Func Login_UpdateLastTreasury()
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set LastTreasury = GetDate() Where CityID = " & Login_CityID())
   _SQL_Close()
EndFunc

Func Login_UpdateLoginAttempts($Attempts)
   _SqlConnect()
   _SQL_Execute(-1,"Update Login Set LoginAttempts = " & $Attempts & " Where LoginID = " & Login_LoginID())
   _SQL_Close()
EndFunc

Func Login_UpdateLoginActive($Active)
   _SqlConnect()
   _SQL_Execute(-1,"Update Login Set Active = " & $Active & " Where LoginID = " & Login_LoginID())
   _SQL_Close()
EndFunc

Func Login_SetInProcess($Email, $Machine)
   _SqlConnect()
   _SQL_Execute(-1,"Update Login Set InProcess = '" & $Machine & "' Where username = '" & $Email & "'")
   _SQL_Close()
EndFunc

Func Login_ResetInProcess()
   _SqlConnect()
   _SQL_Execute(-1,"Update Login Set InProcess='0' Where LoginID = " & Login_LoginID() & " and InProcess = '" & $MachineID & "'")
   _SQL_Close()
EndFunc


Func Login_Write()
   ;Read from the specific File for this login
   _SqlConnect()

   _SQL_Execute(-1,"Update Login Set InProcess=0, LastRun = GetDate() Where LoginID = " & Login_LoginID())
   _SQL_Close()

   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set LastUpgrade='" & Login_LastUpgrade() & "', LastUpgradeBuilding=" & Login_LastUpgradeBuilding() & ", StrongHoldLevel=" & Login_StrongHoldLevel() & " Where CityID = " & Login_CityID())
   _SQL_Close()

EndFunc


Func Login_UpgradeWrite()
   ;Read from the specific File for this login
   _SqlConnect()
   _SQL_Execute(-1,"Update CityInfo Set LastUpgrade='" & Login_LastUpgrade() & "', LastUpgradeBuilding=" & Login_LastUpgradeBuilding() & ", StrongHoldLevel=" & Login_StrongHoldLevel() & " Where CityID = " & Login_CityID())
   _SQL_Close()
EndFunc


Func Login_Write_Old()
   ;Read from the specific File for this login
   local $loginFile = "logins/" & $_userName & ".txt"

   Local $loginLine[][] = [["","","",-1,-1]]
   $loginLine[0][0] = $_userName
   $loginLine[0][1] = $_Password
   $loginLine[0][2] = $rssType
   $loginLine[0][3] = $LastBuiltBuilding
   $loginLine[0][4] = $SHLevel

   _FileWriteFromArray ( $loginFile, $loginLine )

   return True
EndFunc


Func Login_Email()
   return $_userName
EndFunc

Func Login_UserEmail()
   return $_UserEmail
   ;return "grayson@stuntz.org"
EndFunc

Func Login_Pwd()
   return $_Password
EndFunc
Func Login_PIN()

   Local $PINFileName = "FilePIN.au3"
   If FileExists($PINFileName) = 1 Then
	  FileDelete($PINFileName)
   EndIf

   FileWriteLine($PINFileName,"#include-once")
   FileWriteLine($PINFileName,'Global $filePIN = "' & $_PIN & '"')

   $storedPIN = $_PIN
   return $_PIN
EndFunc

Func Set_Login_PIN($newPin)
   $_PIN = $newPin
EndFunc

; 1 = stone, 2 = wood, 3 = ore, 4 = food, 5 = all
Func Login_RSSType()
   return $rssType
EndFunc

Func Login_CityID()
	return $_CityID
EndFunc
Func Login_LoginID()
	return $_LoginID
EndFunc
Func Login_CityName()
	return $_CityName
EndFunc
Func Login_Kingdom()
	return $_Kingdom
EndFunc
Func Login_LocationX()
	return $_LocationX
EndFunc
Func Login_LocationY()
	return $_LocationY
EndFunc
Func Login_Created()
	return $_Created
EndFunc
Func Login_Placed()
	return $_Placed
EndFunc
Func Login_AllianceID()
	return $_AllianceID
EndFunc
Func Login_Bank()
	return $_Bank
EndFunc
Func Login_Rally()
	return $_Rally
EndFunc
Func Login_Shield()
	return $_Shield
EndFunc
Func Login_Treasury()
	return $_TreasuryCollect
EndFunc
Func Login_Tent()
	return $_Tent
EndFunc
Func Login_RallyX()
	return $_RallyX
EndFunc
Func Login_RallyY()
	return $_RallyY
EndFunc
Func Login_TentX()
	return $_TentX
EndFunc
Func Login_TentY()
	return $_TentY
EndFunc
Func Login_LastRally()
	return $_LastRally
EndFunc
Func Login_LastBank()
	return $_LastBank
EndFunc
Func Login_LastUpgrade()
	return $_LastUpgrade
 EndFunc

Func Login_Upgrade()
	return $_Upgrade
 EndFunc

Func Login_LastUpgrade_Set($lastUpgrade)
   $_LastUpgrade = $lastUpgrade
EndFunc
Func Login_LastUpgradeBuilding()
	return $_LastUpgradeBuilding
EndFunc
Func Login_LastUpgradeBuilding_Set($lastUpgradeBuilding)
   $_LastUpgradeBuilding = $lastUpgradeBuilding
EndFunc
Func Login_ProductionPerHour()
	return $_ProductionPerHour
EndFunc
Func Login_LastAthenaGift()
	return $_LastAthenaGift
EndFunc
Func Login_StrongHoldLevel()
	return $_StrongHoldLevel
EndFunc
Func Login_StrongHoldLevel_Set($newSHLevel)
   $_StrongHoldLevel = $newSHLevel
EndFunc
Func Login_TreasuryLevel()
	return $_TreasuryLevel
EndFunc
Func Login_LastShield()
	return $_LastShield
EndFunc
Func Login_LastTreasury()
	return $_LastTreasury
EndFunc
Func Login_LastRun()
	return $_LastRun
EndFunc
Func Login_CollectAthenaGift()
   return $_CollectAthenaGift
EndFunc
Func Login_RedeemCode()
   return $_RedeemCode
EndFunc

Func Login_RSSBank()
   return $_RSSBank
EndFunc
Func Login_SilverBank()
   return $_SilverBank
EndFunc
Func Login_RssMarches()
   return $_RssMarches
EndFunc
Func Login_SilveMarches()
   return $_SilveMarches
EndFunc
Func Login_HasGoldMine()
   return $_HasGoldMine
EndFunc
Func Login_TimezoneOffsetMin()
   return $_TimezoneOffsetMin
EndFunc

Func Login_LoginDelay()
	return $_LoginDelayMin
 EndFunc

Func Login_LoginAttempts()
	return $_LoginAttempts
EndFunc

Func Login_SetBanks($rSSBank, $silverBank)
   $_RSSBank = $rSSBank
   $_SilverBank = $silverBank
EndFunc



;Other DB Functions
Func IsMachineActive()
   Local $aData
   Local $iRows
   Local $iColumns
   Local $iRval

   Local $sqlText = "select DATEPART(TZ, SYSDATETIMEOFFSET()) as TimeZoneOffsetMin, Convert(varchar(20),LoginDate,120) as LoginDateConvert from MachineLoginTracker where MachineID = '" & $MachineID  & "'"

   ;Open the connection up
   _SqlConnect()

   $iRval = _SQL_GetTable2D(-1,$sqlText,$aData,$iRows,$iColumns)

   If $iRval = $SQL_ERROR Then
	  LogMessage("ERROR IsMachineActive Error -- " & _SQL_GetErrMsg(),5)
	  _SQL_Close()
	  return False
   EndIf

   Local $_TimezoneOffsetMin =  $aData[1][0]
   Local $logDate = $aData[1][1]

   ;Convert dates to UTC
   Local $logDateLocal = _DateAdd('n',-1*$_TimezoneOffsetMin,$logDate)

   ;Tear the  connection down
   _SQL_Close()

   If (_DateDiff('n',$logDateLocal,GetNowUTCCalc())) > 20 Then
	  Return False
   EndIf

   Return True
EndFunc














Func Login_Load_OLD($_userNameToGet)
   ;Read from the specific File for this login
   local $loginFile = "logins/" & $_userNameToGet & ".txt"

   If FileExists("logins/" & $_userNameToGet & ".txt") = 0 Then
	  FileWriteLine($loginFile & " does not exist")
	  return False
   EndIf

   Local $loginLine

   _FileReadToArray ($loginFile, $loginLine ,$FRTA_NOCOUNT ,$delimiter )

   $_userName = $loginLine[0][0]
   $_Password = $loginLine[0][1]
   $rssType = $loginLine[0][2]
   $LastBuiltBuilding = $loginLine[0][3]
   $SHLevel = $loginLine[0][4]

   return True
EndFunc
