#include-once

Global Const $VersionNumber = "7.17.2015.03"

Global Const $GOWVBHostWindow[] = [401,77]
;Global Const $GOWVBHostWindow[] = [431,77]
Global Const $GOWIcon[] = [815,330]
Global Const $GOWColor = 14727280

;These are from the MemDayFix
;Global Const $GOWIcon[] = [831,331]
;Global Const $GOWColor = 16384



;Login Set
;Global Const $UserNameTextBox = [735,540]
Global Const $UserNameTextBox = [705,540]
Global Const $UserNameTextBoxColor = 16317688
;Global Const $PasswordTextBox = [805,550]
Global Const $PasswordTextBox = [775,550]
;Global Const $LoginButton = [885,550]
Global Const $LoginButton = [855,550]
Global Const $LoginFailureButton = [670,495]
Global Const $FirstPinBox = [575,550]
Global Const $SecondPinBox = [575,450]
Global Const $PinBoxColor = 16317688

;Menus
Global Const $CityMenu = [1150,680]
Global $CityScreenColor = 1051656 ;winter2014=1053712 ; Fall2014= 1050624 ; - Old standard one - 1051656     7377064
Global $MapMenuColor = 9471048 ;winter2014=4744320; fall2014 = 7888928 ; - Old Map Color 9471048   5788760

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
Global Const $MoreMenu = [1140,175]
Global Const $RedeemButton = [952,642]
Global Const $AccountButton = [650,360]
;Global Const $LogoutButton = [1010,550]
Global Const $LogoutButton = [960,550]
Global Const $LogoutYesButton = [720,600]
Global Const $MarchesButton = [1000,640]; 4th row Left/bottom ;[875,200] - 3rd row Right/Top
Global Const $MarchesButtonColor = 1050624; 4th row(1000,640) ;7362600 - 3rd row(875,200) ; ;6308896
;Global Const $MarchesButtonColor = 2102272
;Helps set
Global Const $AllianceMenu = [1145,370]
Global Const $AllianceHelpMenuDragStart = [1000,450]
Global Const $AllianceHelpMenuDragEnd = [850,450]
Global Const $AllianceHelpsMenu = [930,510]
Global Const $AllianceHelpHelpAllButton = [1020,345]

Global Const $HelpButton = [989,140]
Global Const $HelpButtonColor = 8931376 ;6303776 ;4742248 ;3676168 ; 6303776       4221056
Global Const $NOHelpColor = 9997432
;Boucers
Global Const $AthenaGift = [977,537]
Global Const $NoAthenaGiftColor = 3170328
Global Const $AthenaGiftCollectButton = [925,485]
Global Const $SecretGift = [990,660]
Global Const $SecretGiftCollectButton = [895,510]

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
Global Const $ShieldButton = [530,460]
Global Const $ShieldButton8Hr = [640,250]
Global Const $ShieldButton24Hr = [780,250]
Global Const $ShieldButton3Day = [960,250]
Global Const $ShieldReplaceButton = [700,360]
Global Const $ShieldVerifyMaxLength = [560,250]

;Banking
Global Const $HelpTopMember = [625,250] ; Blue Color
Global Const $HelpNumberOffsetX = 60
Global Const $HelpSecondMember = [725,250] ; Blue Color
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

Global Const $HelpRSSMax[][] = [[565,345], _ ;Stone
								   [630,345], _ ;Wood
								   [695,345], _ ;Ore
								   [760,345], _ ;Food
								   [825,345]] ; Silver      Stone - Wood - Ore - Food - Silver  64 px offset

Global Const $DoneAmountEntryButton = [1142,223] ; Blue color
Global Const $RSSHelpButton = [1000,350] ; Blue
Global Const $RSSOKButton = [666,325] ; Blue
Global Const $MarketLocation = [869,538] ; this is after being zeroed on the screen
Global Enum $eStone,$eWood,$eOre,$eFood,$eSilver
Global Const $MaxMarchesExceeded = [670,370]

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
Global Const $Orange = 11033608
Global Const $Blue = 16448
Global Const $GreenCollect = 11264
Global Const $Purple = 3672136
Global Const $Black = 0
Global Const $RedNoButton = 3672064
Global Const $BuildingBeige = 10521720
Global Const $StrongholdUpgradeArrowColor = 13663240
Global Const $BlueOKButton = 16448
Global Const $AccountButtonColor = 16317688
Global Const $GreyedOutButton = 4211776
Global Const $ShieldCountDownBlue = 1074272

;Paused?
Global $g_bPaused = false

Global Const $GoldExitButton = [435,160]
Global Const $GoldExitButton1 = [435,160]
Global Const $GoldExitButton2 = [583,183]
Global Const $GoldExitButton3 = [523,168]

;Global Const $GoldBuyButton = [1140,340]
;Global Const $GoldBuyButton2 = [1140,540]

;Global Const $GoldBuyButton = [1145,340]
;Global Const $GoldBuyButton2 = [1145,540]

Global Const $GoldSearchLeft = 1085
Global Const $GoldSearchTop = 520
Global Const $GoldSearchBottom = 530
Global Const $GoldSearchRight = 1130

Global Const $GoldBuyButton = [1135,340]
Global Const $GoldBuyButton2 = [1135,540]
Global Const $BuyGoldColor = 11033608
Global Const $GetGoldButton = 4196352
;Global Const $GetGoldButton = 3672064

;; Than Updated for my machine
Global Const $AndroidHomeButton  = [1186,560]
Global Const $AndroidHomeButtonBottom  = [690,711]

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