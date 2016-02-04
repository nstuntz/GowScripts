#include-once

;7.17.2015.04 - Updated to handle dark energy conversion. Updated login logic around gold button searching
;7.22.2015.04 - Updated to include startup script variables
;8.14.2015.01 - Updated to decrypt the password
;8.30.2015.01 - Updated to have the new shielding logic
Global Const $VersionNumber = "2.1.2016.01"

;for when we need to kill bluestacks and restart. Happens when clicking the GoW Icon does nothing
;"C:\Program Files (x86)\BlueStacks\HD-StartLauncher.exe"

Global Const $GOWVBHostWindow[] = [100,0]
Global Const $GoW500by800IconLocation[] = [200,320]
Global Const $GOWWindowSize[] = [300,700]
Global Const $GOWRandomSpotForBlankScreenCheck = [340,700]

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

Global Const $EmailPinCodeButton = [540,260]

;Menus
Global Const $CityMenu = [165,725]
Global $CityScreenColor = 4993559 ;winter2014=1053712 ; Fall2014= 1050624 ; - Old standard one - 1051656     7377064
Global $MapMenuColor = 2246954 ;winter2014=4744320; fall2014 = 7888928 ; - Old Map Color 9471048   5788760
Global $SleepOnLogout = 0

Global $storedPIN = ""

;;;;Connection Code Interupted Bluestacks only. Appears on every login it looks like
Global Const $ConnectionInteruptButton = [430,260]
Global Const $TermsAndConditionsButton = [250,450]
;Items Menu
Global Const $ItemsMenu = [328,710]
Global Const $MyItemsMenu = [408,191]
Global Const $TreasuresMenu = [533,253] ; 533,253 - 2888465
Global Const $ResoucesMenu = [265,250] ; 265,250 - 14934240
Global Const $FirstItem = [541,372] ; 541,372 - 11264
Global Const $SecondItem = [546,509] ; 546,509 - 11264
Global Const $ChestOpenBeige = [516,262] ; 516,262 - 11510152 ; 516,262 - 11575689
Global Const $ChestOpenBeigeColor = 11510152
Global Const $ChestOpenBeigeColorAlt = 11575689

;Resources Menu
Global Const $FirstToken = [518,532] ; 541,372 - 11264  518,532 - 11264
Global Const $SecondToken = [537,629] ; 546,509 - 11264 537,629 - 11264

;Quit Game Dialog
Global Const $QuitGameDialogYesButton = [411,435] ;411,435 - 2631720
Global Const $QuitGameDialogNoButton = [289,433] ;289,433 - 2631720
Global Const $YesQuitWhite = 2631720 ;13684944 - old quit dialog box

;More Menu
Global Const $MoreMenu = [555,710]
Global Const $RedeemButton = [952,642]
Global Const $AccountButton = [410,230]
Global Const $AccountButton2 = [410,160]
;Global Const $LogoutButton = [1010,550]
Global Const $LogoutButton = [435,510]
Global Const $LogoutYesButton = [300,285]
Global Const $MarchesButton = [314,491]  ; [193,515]; -  ; 4th row Left/bottom ;[875,200] - 3rd row Right/Top
Global Const $MarchesButton2 = [314,421]
Global Const $MarchesButtonColor = 1512207; 4th row(1000,640) ;7362600 - 3rd row(875,200) ; ;6308896
Global Const $MarchesButtonColorAlt = 13159348
;Global Const $MarchesButtonColor = 2102272 193,515 - 13159348
;Helps set
Global Const $AllianceMenu = [400,710]
;Global Const $AllianceHelpMenuDragStart = [1000,450]
;Global Const $AllianceHelpMenuDragEnd = [850,450]
;Global Const $AllianceHelpsMenu = [930,510]
Global Const $AllianceHelpHelpAllButton = [550,610]

;NS-1 BS color (560,585 - 10117447)
Global Const $HelpButton = [560,585] ; 560,585 - 14726291
Global Const $HelpButtonColor = 10117447
Global Const $HelpButtonColorAlt = 14726291 ;14726291 ;6303776 ;4742248 ;3676168 ; 6303776       4221056
Global Const $HelpButtonColorArray[] = [10117447,14726291, 14596506,11957837,14662298,14203814]
Global Const $NOHelpColor = 12663823
;Boucers
Global Const $AthenaGift = [165,495] ; Old = [265,565]
Global Const $NoAthenaGiftColor = 13092798 ; old = 5933875

Global Const $AthenaGiftCollectButton = [411,460] ;411,460 - 11230223
Global Const $SecretGift = [165,570]
Global Const $SecretGiftCollectButton = [411,430] ;411,430 - 11230223
Global Const $SecretGiftCollectButtonColor = 11230223

;Quests
Global Const $QuestsMenu = [240,710]
Global Const $QuestsDaily = [430,340]
Global Const $QuestsAliaance = [430,460]
Global Const $QuestsEmpire = [430,220]
Global Const $QuestsCollect = [555,192]
Global Const $QuestsStart = [540,185]
Global Const $QuestsEmpireCollect = [558,286] ; 558,286 - 11264
Global Const $QuestsHeroLeveledUpOkButton = [262,589] ; 262,589 - 16711
Global Const $NoQuestsColor = 2688000
Global Const $QuestChance = [485,614 ]; 485,614 - 11230223
Global Const $QuestChanceUseButton = [351,340] ;  - 11264

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
Global Const $BoostsIcon = [565,245]
Global Const $ShieldColor = 16514042
Global Const $ShieldColorAlt = 15658214
Global Const $ShieldSearchLeft = 155
Global Const $ShieldSearchTop = 130
Global Const $ShieldSearchRight = 155
Global Const $ShieldSearchBottom = 310
Global Const $ShieldButton = [155,135]
Global Const $ShieldButton8Hr = [520,250]
Global Const $ShieldButton24Hr = [520,400]
Global Const $ShieldButton3Day = [520,535]
Global Const $ShieldReplaceButton = [490,280]
Global Const $ShieldVerifyMaxLength = [485,162]
Global Const $ShieldCountDownBlue = 1337186
Global Const $ShieldCountDownBlueAlt = 6002065
Global Const $ShieldNotEnoughGoldButton = [300,265]

;Banking
Global Const $HelpTopMember = [690,270] ; Blue Color
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

Global Const $HelpRSSMax[][] = [[509,209], _ ;Stone
								   [509,277], _ ;Wood
								   [509,342], _ ;Ore
								   [509,407], _ ;Food
								   [509,474]] ; Silver      Stone - Wood - Ore - Food - Silver  64 px offset

Global Const $DoneAmountEntryButton = [700,790] ; Blue color
Global Const $RSSHelpButton = [645,645] ; Blue
Global Const $RSSOKButton = [500,285] ; Blue
Global Const $MarketLocation = [275,475] ; this is after being zeroed on the screen
Global Enum $eStone,$eWood,$eOre,$eFood,$eSilver
Global Const $MaxMarchesExceeded = [530,300]

Global Const $SessionTimeoutButton = [410,250]

;Rallying
Global Const $HospitalCross = [499,499] ; 499,499 - 10754323 499,499 - 8197136
Global Const $HospitalCrossColor = 10754323
Global Const $HospitalCrossColorAlt = 8197136
Global Const $HospitalBuilding = [522,541]
Global Const $HospitalQueueAllButton = [242,615]; - 16711
Global Const $HospitalHealButton = [451,606]; - 16711
; Rally March screen
Global Const $RallyAttackButton = [261,257] ;261,257 - 4670530   ;815 ;970
Global Const $RallyAttackButtonOffsetY = 124 ;262,380 - 4670530 ;260,504 - 4670530 ; 261,257 - 4670530
Global Const $RallyAttachButtonColor = 4670530
Global Const $RallyCancelButton = [150,259] ;150,259 - 16711 ;815 ;970  148,368 - 16711
Global Const $RallyCancelConfirmButton = [300,291];300,291 - 16711
;Rally - Search Constants
Global Const $SearchKingdomButton = [239,49] ;239,49 - 7110014 ;239,49 - 3753026
Global Const $SearchKingdomButtonColor = 7110014
Global Const $SearchKingdomButtonColorAlt = 3753026
Global Const $SearchKingdomButtonColors = [7110014,3753026,3753027,2827553,3818563,3753027]
Global Const $SearchKingdomX = [346,241] ;346,241 - 16777215
Global Const $SearchKingdomY = [451,238] ;451,238 - 16777215
Global Const $SearchKingdomGoButton = [396,322] ;396,322 - 16711
;Global Const $SearchKingdomButtonColor = 16777215 16317688
;Rally - Actual rally
Global Const $WorldMapCityButton = [347,373] ;347,373 - 5327170
Global Const $RallyButton = [318,396] ;318,396 - 16711 ; Blue
Global Const $RallyRssHelpButton = [349,352]  ;349,352 - 16711
Global Const $Rally8HourCheckBox = [281,439] ;281,439 - 16777215
Global Const $RallySetButton = [391,503] ;391,503 - 16711
Global Const $RallyQueueMaxButton = [286,308] ;286,308 - 16711
Global Const $RallySendButton = [356,295] ;356,295 - 16711
; OLD from VB no longer used
;Global Const $MarchCheck = [969,573]
;Global Const $MarchCheckColor = 3088

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
Global Const $White = 16777215 ;16317688
Global Const $WhiteArray = [16777215,15527148]
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
Global Const $AccountButtonColors = [16777215,16711422,4405554,724238,921618,14935011]
Global Const $GreyedOutButton = 4670530
Global Const $ExitAppErrorColor = 1577765

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
Global Const $GoldSearchBottom = 800
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
Global Const $AndroidHomeButtonBottom  = [175,785]

;Gift retrieval
Global Const $GiftBox[] = [374,715]; 374,715 - 2786836 374,715 - 1332751
Global Const $GiftBoxColor = 2786836
Global Const $GiftBoxColorAlt = 1331471; 1907226 - this is the no gift color
Global Const $GiftBoxColorAlt2 = 1332751;
Global Const $GiftBoxColorArray[] = [2786836,1331471,1332751,2854416]

Global Const $GiftButton[] = [542,237]
Global Const $GiftGetClearButton[] = [550,256] ; [608,208] - 550,265 - 3737603
Global Const $GiftGetClearButtonRed = 3737603

;Treasury Collection
Global Const $TreasuryLocation[] = [191,359] ; 191,359 - 8411962
Global Const $Treasury7[] = [460,256] ; 460,256 - 10719353
Global Const $Treasury14[] = [430,345] ; 430,345 - 10587767
Global Const $Treasury30[] = [463,446] ; 463,446 - 10653304
Global Const $TreasuryBack[] = [146,51] ; 146,51 - 9800838
Global Const $TreasuryCollectButton[] = [449,454] ; 449,454 - 11230223
Global Const $TreasuryCollectColor = 11230223 ; OLD=11033608 ; This is Orange color
Global Const $TreasuryDepositButton[] = [522,497] ; 522,497 - 16711
Global Const $TreasuryRunningCheck[] = [468,471] ; 468,471 - 0
Global Const $TreasuryDragCoords[] = [158,442,402,443] ; 158,442 to 402,443 - 3551013

;Image Positions
Global Const $RssImage[] = [158,88,538,114]
Global Const $CityImage[] = [110,115,590,645]
Global Const $GoldImage[] = [450,30,590,70]
Global Const $HeroImage[] = [111,25,168,95]
Global Const $TreasuryImage[] = [135,270,245,390]

Global Const $ShieldTime[] = [190,148,495,170]
Global Const $ShieldCount[] = [125,495,575,610]
Global Const $RssProduction[] = [1111,1111,1111,1111]
Global Const $SilverProduction[] = [1111,1111,1111,1111]

;Convert to Dark Energy buttons
Global Const $InitialConvert[] = [1000,525]
Global Const $ConvertConfirm[] = [725,525]
Global Const $ConvertAccept[] = [800,525]