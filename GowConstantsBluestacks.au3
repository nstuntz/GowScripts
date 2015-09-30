#include-once

;7.17.2015.04 - Updated to handle dark energy conversion. Updated login logic around gold button searching
;7.22.2015.04 - Updated to include startup script variables
;8.14.2015.01 - Updated to decrypt the password
;8.30.2015.01 - Updated to have the new shielding logic
Global Const $VersionNumber = "8.30.2015.01"

;for when we need to kill bluestacks and restart. Happens when clicking the GoW Icon does nothing
;"C:\Program Files (x86)\BlueStacks\HD-StartLauncher.exe"

Global Const $GOWVBHostWindow[] = [100,0]
Global Const $GoW500by800IconLocation[] = [200,320]

;;;;;; MOVED TO GowLocalConstantsBluestacks
;Global Const $GOWIcon[] = [360,180]
;Global Const $GOWColor = 529681

;StartupScript
;Global Const $VBWindow[] = [100,5]
;Global Const $VBStartArrow[] =[225,80]
;Global Const $VBStartArrowColor = 7656765
;Global Const $GOWVBHostWindow[] = [431,77]


;These are from the MemDayFix
;Global Const $GOWIcon[] = [831,331]
;Global Const $GOWColor = 16384



;Login Set
;Global Const $UserNameTextBox = [735,540]
Global Const $UserNameTextBox = [340,305]
Global Const $UserNameTextBoxColor = 16777215
;Global Const $PasswordTextBox = [805,550]
Global Const $PasswordTextBox = [400,360]
;Global Const $LoginButton = [885,550]
Global Const $LoginButton = [425,425]
Global Const $LoginFailureButton = [430,271]
Global Const $FirstPinBox = [230,150]
Global Const $SecondPinBox = [315,150]
Global Const $PinBoxColor = 16777215

;Menus
Global Const $CityMenu = [165,725]
Global $CityScreenColor = 4993559 ;winter2014=1053712 ; Fall2014= 1050624 ; - Old standard one - 1051656     7377064
Global $MapMenuColor = 2246954 ;winter2014=4744320; fall2014 = 7888928 ; - Old Map Color 9471048   5788760

;;;;Connection Code Interupted Bluestacks only. Appears on every login it looks like
Global Const $ConnectionInteruptButton = [430,260]

;Items Menu
Global Const $ItemsMenu = [1150,480]
Global Const $MyItemsMenu = [590,350]
Global Const $TreasuresMenu = [650,200]
Global Const $ResoucesMenu = [655,535]
Global Const $FirstItem = [780,250]
Global Const $SecondItem = [940,250]
Global Const $ChestOpenBeige = [660,260]
Global Const $ChestOpenBeigeColor = 11576456

;Resources Menu
Global Const $FirstToken = [825,220]
Global Const $SecondToken = [990,220]

;Quit Game Dialog
Global Const $QuitGameDialogYesButton = [837,381]
Global Const $QuitGameDialogNoButton = [840,510]
Global Const $YesQuitWhite = 2631720 ;13684944 - old quit dialog box

;More Menu
Global Const $MoreMenu = [555,730]
Global Const $RedeemButton = [952,642]
Global Const $AccountButton = [410,230]
;Global Const $LogoutButton = [1010,550]
Global Const $LogoutButton = [435,510]
Global Const $LogoutYesButton = [300,285]
Global Const $MarchesButton = [1000,640]; 4th row Left/bottom ;[875,200] - 3rd row Right/Top
Global Const $MarchesButtonColor = 1050624; 4th row(1000,640) ;7362600 - 3rd row(875,200) ; ;6308896
;Global Const $MarchesButtonColor = 2102272
;Helps set
Global Const $AllianceMenu = [1145,370]
Global Const $AllianceHelpMenuDragStart = [1000,450]
Global Const $AllianceHelpMenuDragEnd = [850,450]
Global Const $AllianceHelpsMenu = [930,510]
Global Const $AllianceHelpHelpAllButton = [550,610]

Global Const $HelpButton = [560,585]
Global Const $HelpButtonColor = 14726291 ;6303776 ;4742248 ;3676168 ; 6303776       4221056
Global Const $NOHelpColor = 12663823
;Boucers
Global Const $AthenaGift = [265,565]
Global Const $NoAthenaGiftColor = 5933875
Global Const $AthenaGiftCollectButton = [411,460]
Global Const $SecretGift = [165,570]
Global Const $SecretGiftCollectButton = [411,430]

;Quests
Global Const $QuestsMenu = [1145,560]
Global Const $QuestsDaily = [750,500]
Global Const $QuestsAliaance = [860,500]
Global Const $QuestsEmpire = [620,500]
Global Const $QuestsCollect = [590,250]
Global Const $QuestsStart = [590,250]
Global Const $QuestsEmpireCollect = [695,250]
Global Const $QuestsHeroLeveledUpOkButton = [1020,620]
Global Const $NoQuestsColor = 2622464
Global Const $QuestChance = [1000,250]
Global Const $QuestChanceUseButton = [770,415]

;Log File Name
Global Const $LogFileName = "Log.txt"
Global $OpenFailureCount = 0

;SpeedupNoButton
Global Const $SpeedupNoButton = [795,590]

;Checking for Builds going on in the top list
Global Const $TimerOffsetX = 41
Global Const $TimerIcon = [528,696]
Global Const $TimerMoreIcon = [599,700]
Global Const $TimerIconBuildColor  = 5786696 ; 1575944 -with transparency ; 2099208 - before transparency
Global Const $TimerIconBuildColor2 = 5262408 ; 1574920 -with transparency ; 2099208 - before transparency

;Shielding
Global Const $BoostsIcon = [645,165]
Global Const $ShieldColor = 8947808
Global Const $ShieldSearchLeft = 500
Global Const $ShieldSearchTop = 675
Global Const $ShieldSearchRight = 1000
Global Const $ShieldSearchBottom = 675
Global Const $ShieldButton = [530,460]
Global Const $ShieldButton8Hr = [640,250]
Global Const $ShieldButton24Hr = [780,250]
Global Const $ShieldButton3Day = [960,250]
Global Const $ShieldReplaceButton = [700,360]
Global Const $ShieldVerifyMaxLength = [560,250]

;Banking
Global Const $HelpTopMember = [560,230] ; Blue Color
Global Const $HelpNumberOffsetX = 60
Global Const $HelpSecondMember = [590,310] ; Blue Color
Global Const $HelpRSSBoxes[][] = [[559,245], _ ;Stone
								   [623,245], _ ;Wood
								   [687,245], _ ;Ore
								   [751,245], _ ;Food
								   [815,245]] ; Silver
;Global Const $HelpRSSMax[][] = [[575,342], _ ;Stone
;								   [640,342], _ ;Wood
;								   [705,342], _ ;Ore
;								   [770,342], _ ;Food
;								   [835,342]] ; Silver      Stone - Wood - Ore - Food - Silver  64 px offset

Global Const $HelpRSSMax[][] = [[415,162], _ ;Stone
								   [415,216], _ ;Wood
								   [415,269], _ ;Ore
								   [415,322], _ ;Food
								   [415,375]] ; Silver      Stone - Wood - Ore - Food - Silver  64 px offset

Global Const $DoneAmountEntryButton = [1142,223] ; Blue color
Global Const $RSSHelpButton = [520,580] ; Blue
Global Const $RSSOKButton = [500,285] ; Blue
Global Const $MarketLocation = [200,435] ; this is after being zeroed on the screen
Global Enum $eStone,$eWood,$eOre,$eFood,$eSilver
Global Const $MaxMarchesExceeded = [400,255]

Global Const $SessionTimeoutButton = [650,480]

;Rallying
Global Const $HospitalCross = [880,265]
Global Const $HospitalCrossColor = 16317688
Global Const $HospitalBuilding = [930,250]
Global Const $HospitalQueueAllButton = [1000,555]
Global Const $HospitalHealButton = [995,295]
; Rally March screen
Global Const $RallyAttackButton = [660,530] ;815 ;970
Global Const $RallyAttackButtonOffsetX = 155
Global Const $RallyAttachButtonColor = 4211776
Global Const $RallyCancelButton = [660,670] ;815 ;970
Global Const $RallyCancelConfirmButton = [720,500]
;Rally - Actual rally
Global Const $RallyButton = [820,460] ; Blue
Global Const $Rally8HourCheckBox = [890,515]
Global Const $RallySetButton = [950,380]
Global Const $RallyQueueMaxButton = [700,510]
Global Const $RallySendButton = [690,377]
Global Const $SearchKingdomButton = [435,558]
Global Const $SearchKingdomButtonColor = 4740176
;Global Const $SearchKingdomButtonColor = 3682344
Global Const $SearchKingdomX = [636,423]
Global Const $SearchKingdomY = [636,284]
Global Const $SearchKingdomGoButton = [739,377]
Global Const $MarchCheck = [969,573]
Global Const $MarchCheckColor = 3088
Global Const $WorldMapCityButton = [755,435]

;Buildings
Global Const $BuildingUpgradeButton = [560,275]
Global Const $BuildingUpgradeHelpButton = [540,320]
Global Const $MaxedBuildingCoords = [475, 175, 570, 280]
Global Const $MaxedBuildingCheckSum = 3964102995
Global $Buildings[][] =[ _
    [5,922,525], _ ;First 4 farms first
    [5,885,456], _
    [5,845,379], _
    [5,979,413], _
    [1,869,538], _ ;under treasury
    [1,832,426], _
    [1,808,331], _ ;[1,730,189], _ ; This is that villa across the river
    [1,967,549], _
    [1,897,421], _
    [1,971,359], _
    [1,960,222], _
    [4,905,540], _ ; Walls
    [2,963,599], _
    [2,971,481], _
    [2,966,350], _
    [2,912,285], _
    [2,876,198], _
    [5,936,349], _
    [5,903,287], _
    [5,944,216], _
    [3,719,539], _
    [3,641,469], _
    [3,681,374], _
    [3,700,221], _
    [3,739,313], _
    [3,836,341], _
    [3,861,278], _
    [4,650,577], _
    [4,608,500], _
    [4,702,512], _
    [4,662,434], _
    [4,764,434], _
    [4,726,356], _
    [6,797,498], _
    [6,839,431], _
    [6,893,362], _
    [6,916,255], _
    [6,840,266], _
    [6,787,344], _
    [6,753,417], _
    [6,701,342], _
    [6,665,262], _
    [6,672,447], _
    [6,621,354], _
    [6,617,512], _
    [6,581,441], _
	[6,751,272], _
    [7,723,307], _
    [7,676,402], _
    [7,642,336], _
    [7,612,402] ]

Global Const $StrongHold = [1,710,445]
Global Const $StrongHoldUpgrade = [663,370]
Global Const $StrongHoldUpgradeBeginTeleYesButton = [690,360]

Global Const $BuildingCheck[] = [900,450]

;Colors
Global Const $White = 16317688
Global Const $Orange = 11230223
Global Const $Blue = 16711
Global Const $GreenCollect = 11264
Global Const $Purple = 3672136
Global Const $Black = 0
Global Const $RedNoButton = 3737603
Global Const $BuildingBeige = 10521720
Global Const $StrongholdUpgradeArrowColor = 13663240
Global Const $BlueOKButton = 16711
Global Const $AccountButtonColor = 16777215
Global Const $GreyedOutButton = 4670530
Global Const $ShieldCountDownBlue = 1074272

;Paused?
Global $g_bPaused = false

Global Const $GoldExitButton = [485,50]
Global Const $GoldExitButton1 = [435,160]
Global Const $GoldExitButton2 = [583,183]
Global Const $GoldExitButton3 = [523,168]

;Global Const $GoldBuyButton = [1140,340]
;Global Const $GoldBuyButton2 = [1140,540]

;Global Const $GoldBuyButton = [1145,340]
;Global Const $GoldBuyButton2 = [1145,540]

Global Const $GoldSearchLeft = 266
Global Const $GoldSearchTop = 600
Global Const $GoldSearchBottom = 700
Global Const $GoldSearchRight = 270

Global Const $GoldBuyButton = [1135,340]
Global Const $GoldBuyButton2 = [1135,540]
Global Const $BuyGoldColor = 11230223
Global Const $GetGoldButton = 6962190
;Global Const $GetGoldButton = 3672064

;; Than Updated for my machine
;Global Const $AndroidHomeButton  = [1186,560]
;Global Const $AndroidHomeButtonBottom  = [690,711]
Global Const $AndroidHomeButton  = [1190,420]
Global Const $AndroidHomeButtonBottom  = [807,725]

;Gift retrieval
Global Const $GiftBox[] = [1124,390]
Global Const $GiftBoxColor = 11568136
Global Const $GiftButton[] = [644,210]
Global Const $GiftGetClearButton[] = [665,185] ; [608,208]
Global Const $GiftGetClearButtonRed = 3672064

;Treasury Collection
Global Const $TreasuryLocation[] = [750,580]
Global Const $Treasury7[] = [660,375]
Global Const $Treasury14[] = [760,375]
Global Const $Treasury30[] = [845,375]
Global Const $TreasuryBack[] = [444,681]
Global Const $TreasuryCollectButton[] = [840,520]
Global Const $TreasuryCollectColor = 11033608
Global Const $TreasuryDepositButton[] = [890,180]
Global Const $TreasuryRunningCheck[] = [877,191]

;Image Positions
Global Const $RssImage[] = [470,185,505,655]
Global Const $CityImage[] = [409,128,1169,727]
Global Const $GoldImage[] = [410,185,460,295]
Global Const $HeroImage[] = [410,650,480,725]
Global Const $TreasuryImage[] = [665,545,785,655]

Global Const $ShieldTime[] = [500,235,570,625]
Global Const $ShieldCount[] = [910,590,1045,700]
Global Const $RssProduction[] = [1111,1111,1111,1111]
Global Const $SilverProduction[] = [1111,1111,1111,1111]

;Convert to Dark Energy buttons
Global Const $InitialConvert[] = [1000,525]
Global Const $ConvertConfirm[] = [725,525]
Global Const $ConvertAccept[] = [800,525]