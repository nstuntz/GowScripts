#include-once

;7.17.2015.04 - Updated to handle dark energy conversion. Updated login logic around gold button searching
;7.22.2015.04 - Updated to include startup script variables
;8.14.2015.01 - Updated to decrypt the password
;8.30.2015.01 - Updated to have the new shielding logic
Global Const $VersionNumber = "MS - 2.22.2016.01"

;for when we need to kill bluestacks and restart. Happens when clicking the GoW Icon does nothing
;"C:\Program Files (x86)\BlueStacks\HD-StartLauncher.exe"

Global Const $GOWVBHostWindow[] = [100,0]
Global Const $GoW500by800IconLocation[] = [200,320]
Global Const $GOWWindowSize[] = [500,800]
Global Const $GOWRandomSpotForBlankScreenCheck = [340,700]


;Login Set
Global Const $UserNameTextBox = [330,300]
Global Const $UserNameTextBoxColor = 15592941
Global Const $PasswordTextBox = [330,360]
Global Const $LoginButton = [445,415]
Global Const $LoginButtonInitalColor = 5723995
Global Const $LoginButtonReadyColor = 4162975
Global Const $LoginFailureButton = [392,259]
Global Const $LoginButtonFailueColor = 4162975
Global Const $DeviceLockedLogoutButton = [500,325]
Global Const $DeviceLockedLogoutButtonColor = 14816813

Global Const $FirstPinBox = [230,150]
Global Const $SecondPinBox = [315,150]
Global Const $PinBoxColor = 16777215
Global Const $EmailPinCodeButton = [540,260]

;Gold Screen
Global Const $GoldSearchLeft = 260
Global Const $GoldSearchTop = 675
Global Const $GoldSearchBottom = 760
Global Const $GoldSearchRight = 265
Global Const $BuyGoldColor = 14319616

;Menus
Global Const $CityMenu = [165,725]
Global $CityScreenColor = 6729417 ; this goes back into city
Global $MapMenuColor = 3702948 ; this leaves city
Global Const $GoldExitButton = [580,45]
Global Const $GetGoldButton = 16702022
Global $SleepOnLogout = 0

;Logout
Global Const $MoreMenu = [555,710]
;Global Const $RedeemButton = [952,642]
Global Const $AccountButton = [410,230]
Global Const $AccountButtonColor = 16777215
Global Const $AccountButtonColors = [15000778]
Global Const $LogoutButton = [400,605]
Global Const $LogoutButtonColor = 14619434
Global Const $LogoutYesButton = [295,275]
Global Const $LogoutYesButtonColor = 4162976

Global $storedPIN = ""

;;;;Connection Code Interupted Bluestacks only. Appears on every login it looks like
Global Const $ConnectionInteruptButton = [394,257]
Global Const $ConnectionInteruptButtonColor = 4162975
Global Const $TermsAndConditionsButton = [250,450]

;Secret Gift
Global Const $SecretGift = [165,570]
Global Const $SecretGiftCollectButton = [350,500] ;411,430 - 11230223
Global Const $NoSecretGiftCollectButton = [350,450] ;411,430 - 11230223
Global Const $SecretGiftCollectButtonColor = 14319616

;Image Positions [left, top, right, bottom]
Global Const $RssImage[] = [200,70,560,95]
Global Const $CityImage[] = [110,95,590,645]
Global Const $GoldImage[] = [455,40,560,58]
Global Const $HeroImage[] = [111,25,178,95]

;Quests
Global Const $QuestsMenu = [240,710]
Global Const $QuestsDaily = [430,340]
Global Const $QuestsAliaance = [430,460]
Global Const $QuestsEmpire = [430,220]
Global Const $QuestsStart = [555,178]
Global Const $QuestsCollect = [560,180]
Global Const $NoQuestsColor = 1515301

Global Const $QuestsEmpireCollect = [558,286] ; 558,286 - 11264

Global Const $QuestsHeroLeveledUpOkButton = [275,550] ; 262,589 - 16711
Global Const $QuestsHeroLeveledUpOkButtonColor = 41629756

;Global Const $QuestChance = [485,614 ]; 485,614 - 11230223
;Global Const $QuestChanceUseButton = [351,340] ;  - 11264

;Help
Global Const $HelpButton = [560,575] ; 560,585 - 14726291
Global Const $HelpButtonColorArray[] = [6871960]
Global Const $NOHelpColor = 12663823
Global Const $AllianceHelpHelpAllButton = [525,615]
Global Const $AllianceHelpHelpAllButtonColor = 14319616

;Banking
Global Const $HelpTopMember = [550,263]
Global Const $HelpTopMemberColor = 4886442
Global Const $HelpNumberOffsetX = 59
Global Const $HelpRSSMax[][] = [[422,162], _ ;Stone
								   [422,247], _ ;Wood
								   [422,331], _ ;Ore
								   [422,415], _ ;Food
								   [422,415]] ; Silver      This is after it scrolls
Global Const $RSSHelpButton = [525,590]
Global Const $RSSHelpButtonColor = 4162718

Global Const $RSSOKButton = [480,260]
Global Const $RSSOKButtonColor = 4162976
Global Const $MarketLocation = [325,360] ; this is after being zeroed on the screen
Global Enum $eStone,$eWood,$eOre,$eFood,$eSilver
Global Const $MaxMarchesExceeded = [400,255]
Global Const $MaxMarchesExceededColor = 4162976


;Boucers
Global Const $AthenaGift = [155,515] ; Old = [265,565]
Global Const $NoAthenaGiftColor = 8811851 ; old = 5933875
Global Const $AthenaGiftCollectButton = [350,525] ;411,460 - 11230223

;Gift retrieval
Global Const $GiftBox[] = [367,720]; 374,715 - 2786836 374,715 - 1332751
Global Const $GiftBoxColorArray[] = [867850]

Global Const $GiftButton[] = [542,237]
Global Const $GiftGetClearButton[] = [535,290] ; [608,208] - 550,265 - 3737603
Global Const $GiftGetClearButtonBlue = 4097181
Global Const $GiftGetClearButtonRed = 14553641


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;NOT USED YET
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
;Global Const $LogoutButton = [1010,550]
;Global Const $MarchesButton = [314,491]  ; [193,515]; -  ; 4th row Left/bottom ;[875,200] - 3rd row Right/Top
;Global Const $MarchesButton2 = [314,421]
;Global Const $MarchesButtonColor = 1512207; 4th row(1000,640) ;7362600 - 3rd row(875,200) ; ;6308896
;Global Const $MarchesButtonColorAlt = 13159348
;Global Const $MarchesButtonColor = 2102272 193,515 - 13159348
;Helps set
Global Const $AllianceMenu = [400,710]
;Global Const $AllianceHelpMenuDragStart = [1000,450]
;Global Const $AllianceHelpMenuDragEnd = [850,450]
;Global Const $AllianceHelpsMenu = [930,510]

;NS-1 BS color (560,585 - 10117447)



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
Global Const $GreyedOutButton = 4670530
Global Const $ExitAppErrorColor = 1577765

;Paused?
Global $g_bPaused = false

;Global Const $GoldExitButton1 = [435,160]
;Global Const $GoldExitButton2 = [583,183]
;Global Const $GoldExitButton3 = [523,168]

;Global Const $GoldBuyButton = [1140,340]
;Global Const $GoldBuyButton2 = [1140,540]

;Global Const $GoldBuyButton = [1145,340]
;Global Const $GoldBuyButton2 = [1145,540]



;Global Const $GoldBuyButton = [1135,340]
;Global Const $GoldBuyButton2 = [1135,540]
;Global Const $GetGoldButton = 6962190
;Global Const $GetGoldButton = 3672064

;; Than Updated for my machine
;Global Const $AndroidHomeButton  = [1186,560]
;Global Const $AndroidHomeButtonBottom  = [690,711]
Global Const $AndroidHomeButton  = [1190,420]
Global Const $AndroidHomeButtonBottom  = [175,785]



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


Global Const $TreasuryImage[] = [135,270,245,390]

Global Const $ShieldTime[] = [190,148,495,170]
Global Const $ShieldCount[] = [125,535,215,600]
Global Const $RssProduction[] = [1111,1111,1111,1111]
Global Const $SilverProduction[] = [1111,1111,1111,1111]

;Convert to Dark Energy buttons
Global Const $InitialConvert[] = [1000,525]
Global Const $ConvertConfirm[] = [725,525]
Global Const $ConvertAccept[] = [800,525]