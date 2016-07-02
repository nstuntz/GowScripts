#include-once


Global Const $MSVBHostWindow[] = [100,0]
Global Const $MS500by800IconLocation[] = [200,320]
Global Const $MSWindowSize[] = [500,800]
Global Const $MSRandomSpotForBlankScreenCheck = [340,700]


;Login Set
Global Const $MSUserNameTextBox = [330,300]
Global Const $MSUserNameTextBoxColor = 15592941
Global Const $MSPasswordTextBox = [330,360]
Global Const $MSLoginButton = [445,415]
Global Const $MSLoginButtonInitalColor = 5723995
Global Const $MSLoginButtonReadyColor = 4162975
Global Const $MSLoginFailureButton = [392,259]
Global Const $MSLoginButtonFailueColor = 4162975
Global Const $MSDeviceLockedLogoutButton = [500,325]
Global Const $MSDeviceLockedLogoutButtonColor = 14816813

Global Const $MSFirstPinBox = [230,150]
Global Const $MSSecondPinBox = [315,150]
Global Const $MSPinBoxColor = 15592941
Global Const $MSEmailPinCodeButton = [540,260]

;Gold Screen
Global Const $MSGoldSearchLeft = 260
Global Const $MSGoldSearchTop = 675
Global Const $MSGoldSearchBottom = 760
Global Const $MSGoldSearchRight = 265
Global Const $MSBuyGoldColor = 14319616

;Menus
Global Const $MSCityMenu = [165,725]
Global $MSCityScreenColor = 6729417 ; this goes back into city
Global $MSMapMenuColor = 3702948 ; this leaves city
Global Const $MSGoldExitButton = [570,40];[580,45]
Global Const $MSGetGoldButton = 14916690;16702022

;Logout
Global Const $MSMoreMenu = [555,710]
;Global Const $MSRedeemButton = [952,642]
Global Const $MSAccountButton = [410,230]
Global Const $MSAccountButtonColor = 16777215
Global Const $MSAccountButtonColors = [15000778,14934985]
Global Const $MSLogoutButton = [400,600]
Global Const $MSLogoutButtonColor = 14619434
Global Const $MSLogoutYesButton = [295,275]
Global Const $MSLogoutYesButtonColor = 4162976

Global $MSstoredPIN = ""

;;;;Connection Code Interupted Bluestacks only. Appears on every login it looks like
Global Const $MSConnectionInteruptButton = [394,257]
Global Const $MSConnectionInteruptButtonColor = 4162975
Global Const $MSTermsAndConditionsButton = [250,450]

;Secret Gift
Global Const $MSSecretGift = [165,570]
Global Const $MSSecretGiftCollectButton = [350,500] ;411,430 - 11230223
Global Const $MSNoSecretGiftCollectButton = [350,450] ;411,430 - 11230223
Global Const $MSSecretGiftCollectButtonColor = 14319616

;Image Positions [left, top, right, bottom]
Global Const $MSRssImage[] = [200,70,560,95]
Global Const $MSCityImage[] = [110,95,590,645]
Global Const $MSGoldImage[] = [455,40,560,58]
Global Const $MSHeroImage[] = [111,25,178,95]
Global Const $MSShieldTime[] = [190,150,495,175]
Global Const $MSShieldCount[] = [130,555,210,595]

;Shielding
Global Const $MSBoostsIcon = [565,245]
Global Const $MSShieldColor = 16514042
Global Const $MSShieldColorAlt = 15658214
Global Const $MSShieldSearchLeft = 155
Global Const $MSShieldSearchTop = 120
Global Const $MSShieldSearchRight = 155
Global Const $MSShieldSearchBottom = 310
Global Const $MSShieldButton = [155,135]
Global Const $MSShieldButton8Hr = [520,250]
Global Const $MSShieldButton24Hr = [520,400]
Global Const $MSShieldButton3Day = [520,535]

Global Const $MSShieldReplaceButton = [490,280]
Global Const $MSShieldReplaceButtonColor = 4162976
Global Const $MSShieldVerifyMaxLength = [485,165]
Global Const $MSShieldCountDownBlue = 3241360
Global Const $MSShieldCountDownBlueAlt = 6002065
Global Const $MSShieldNotEnoughGoldButton = [300,267]
Global Const $MSShieldNotEnoughGoldButtonColor = 14816813


;Quests
Global Const $MSQuestsMenu = [240,710]
Global Const $MSQuestsDaily = [430,340]
Global Const $MSQuestsAliaance = [430,460]
Global Const $MSQuestsEmpire = [430,220]
Global Const $MSQuestsStart = [555,178]
Global Const $MSQuestsCollect = [560,180]
Global Const $MSQuestsCollectColor = 4162976
Global Const $MSNoQuestsColor = 1515301

Global Const $MSQuestsEmpireCollect = [558,286] ; 558,286 - 11264

Global Const $MSQuestsHeroLeveledUpOkButton = [275,550] ; 262,589 - 16711
Global Const $MSQuestsHeroLeveledUpOkButtonColor = 41629756

;Global Const $MSQuestChance = [485,614 ]; 485,614 - 11230223
;Global Const $MSQuestChanceUseButton = [351,340] ;  - 11264

;Help
Global Const $MSHelpButton = [560,575] ; 560,585 - 14726291
Global Const $MSHelpButtonColorArray[] = [6871960]
Global Const $MSNOHelpColor = 12663823
Global Const $MSAllianceHelpHelpAllButton = [525,615]
Global Const $MSAllianceHelpHelpAllButtonColor = 14319616

;Banking
Global Const $MSHelpTopMember = [550,263]
Global Const $MSHelpTopMemberColor = 4820649
Global Const $MSHelpNumberOffsetX = 59
Global Const $MSHelpRSSMax[][] = [[422,162], _ ;Stone
								   [422,247], _ ;Wood
								   [422,331], _ ;Ore
								   [422,415], _ ;Food
								   [422,415]] ; Silver      This is after it scrolls
Global Const $MSRSSHelpButton = [525,590]
Global Const $MSRSSHelpButtonColor = 4162718

Global Const $MSRSSOKButton = [480,260]
Global Const $MSRSSOKButtonColor = 4162976
Global Const $MSMarketLocation = [385,395];[200,310] - with scroll ; this is after being zeroed on the screen
Global Enum $MSeStone,$MSeWood,$MSeOre,$MSeFood,$MSeSilver
Global Const $MSMaxMarchesExceeded = [400,255]
Global Const $MSMaxMarchesExceededColor = 4162976


;Boucers
Global Const $MSAthenaGift = [150,510] ; Old = [265,565]
Global Const $MSNoAthenaGiftColor = 7757784 ; old = 5933875
Global Const $MSAthenaGiftCollectButton = [350,525] ;411,460 - 11230223

;Gift retrieval
Global Const $MSGiftBox[] = [367,720]; 374,715 - 2786836 374,715 - 1332751
Global Const $MSGiftBoxColorArray[] = [867850,802314]

Global Const $MSGiftButton[] = [542,237]
Global Const $MSGiftGetClearButton[] = [535,290] ; [608,208] - 550,265 - 3737603
Global Const $MSGiftGetClearButtonBlue = 4097181
Global Const $MSGiftGetClearButtonRed = 14553641

;Quit Game Dialog
Global Const $MSQuitGameDialogYesButton = [540,428] ;411,435 - 2631720
Global Const $MSQuitGameDialogNoButton = [500,428] ;289,433 - 2631720
Global Const $MSYesQuitWhite = 4474438 ;13684944 - old quit dialog box


;Treasury Collection
Global Const $MSTreasuryLocation[] = [260,405] ; 191,359 - 8411962
Global Const $MSTreasury1[] = [530,240] ; 460,256 - 10719353
Global Const $MSTreasury3[] = [530,330] ; 430,345 - 10587767
Global Const $MSTreasury7[] = [530,420] ; 463,446 - 10653304
Global Const $MSTreasuryBack[] = [130,45] ; 146,51 - 9800838
Global Const $MSTreasuryCollectButton[] = [450,455] ; 449,454 - 11230223
Global Const $MSTreasuryCollectColor = 14319616 ; OLD=11033608 ; This is Orange color
Global Const $MSUpgradeTreasury[] = [300,415]
Global Const $MSTreasuryDepositButton[] = [495,500] ;  4162976
Global Const $MSTreasuryRunningCheck[] = [460,440] ; 468,471 - 0
;Global Const $MSTreasuryDragCoords[] = [158,442,402,443] ; 158,442 to 402,443 - 3551013


Global Const $MSTreasuryImage[] = [200,340,300,430]


Global Const $MSBlue = 4162976
Global Const $MSBlack = 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;NOT USED YET
;Items Menu
Global Const $MSItemsMenu = [328,710]
Global Const $MSMyItemsMenu = [408,191]
Global Const $MSTreasuresMenu = [533,253] ; 533,253 - 2888465
Global Const $MSResoucesMenu = [265,250] ; 265,250 - 14934240
Global Const $MSFirstItem = [541,372] ; 541,372 - 11264
Global Const $MSSecondItem = [546,509] ; 546,509 - 11264
Global Const $MSChestOpenBeige = [516,262] ; 516,262 - 11510152 ; 516,262 - 11575689
Global Const $MSChestOpenBeigeColor = 11510152
Global Const $MSChestOpenBeigeColorAlt = 11575689

;Resources Menu
Global Const $MSFirstToken = [518,532] ; 541,372 - 11264  518,532 - 11264
Global Const $MSSecondToken = [537,629] ; 546,509 - 11264 537,629 - 11264


;More Menu
;Global Const $MSLogoutButton = [1010,550]
;Global Const $MSMarchesButton = [314,491]  ; [193,515]; -  ; 4th row Left/bottom ;[875,200] - 3rd row Right/Top
;Global Const $MSMarchesButton2 = [314,421]
;Global Const $MSMarchesButtonColor = 1512207; 4th row(1000,640) ;7362600 - 3rd row(875,200) ; ;6308896
;Global Const $MSMarchesButtonColorAlt = 13159348
;Global Const $MSMarchesButtonColor = 2102272 193,515 - 13159348
;Helps set
Global Const $MSAllianceMenu = [400,710]
;Global Const $MSAllianceHelpMenuDragStart = [1000,450]
;Global Const $MSAllianceHelpMenuDragEnd = [850,450]
;Global Const $MSAllianceHelpsMenu = [930,510]

;NS-1 BS color (560,585 - 10117447)



;Log File Name
Global $MSOpenFailureCount = 0

;SpeedupNoButton
Global Const $MSSpeedupNoButton = [795,590]

;Checking for Builds going on in the top list
Global Const $MSTimerOffsetX = 41
Global Const $MSTimerIcon = [528,696]
Global Const $MSTimerMoreIcon = [599,700]
Global Const $MSTimerIconBuildColor  = 5786696 ; 1575944 -with transparency ; 2099208 - before transparency
Global Const $MSTimerIconBuildColor2 = 5262408 ; 1574920 -with transparency ; 2099208 - before transparency






Global Const $MSSessionTimeoutButton = [410,250]
Global Const $MSSessionTimeoutButtonColor = 4162976

;Rallying
Global Const $MSHospitalCross = [499,499] ; 499,499 - 10754323 499,499 - 8197136
Global Const $MSHospitalCrossColor = 10754323
Global Const $MSHospitalCrossColorAlt = 8197136
Global Const $MSHospitalBuilding = [522,541]
Global Const $MSHospitalQueueAllButton = [242,615]; - 16711
Global Const $MSHospitalHealButton = [451,606]; - 16711
; Rally March screen
Global Const $MSRallyAttackButton = [261,257] ;261,257 - 4670530   ;815 ;970
Global Const $MSRallyAttackButtonOffsetY = 124 ;262,380 - 4670530 ;260,504 - 4670530 ; 261,257 - 4670530
Global Const $MSRallyAttachButtonColor = 4670530
Global Const $MSRallyCancelButton = [150,259] ;150,259 - 16711 ;815 ;970  148,368 - 16711
Global Const $MSRallyCancelConfirmButton = [300,291];300,291 - 16711
;Rally - Search Constants
Global Const $MSSearchKingdomButton = [239,49] ;239,49 - 7110014 ;239,49 - 3753026
Global Const $MSSearchKingdomButtonColor = 7110014
Global Const $MSSearchKingdomButtonColorAlt = 3753026
Global Const $MSSearchKingdomButtonColors = [7110014,3753026,3753027,2827553,3818563,3753027]
Global Const $MSSearchKingdomX = [346,241] ;346,241 - 16777215
Global Const $MSSearchKingdomY = [451,238] ;451,238 - 16777215
Global Const $MSSearchKingdomGoButton = [396,322] ;396,322 - 16711
;Global Const $MSSearchKingdomButtonColor = 16777215 16317688
;Rally - Actual rally
Global Const $MSWorldMapCityButton = [347,373] ;347,373 - 5327170
Global Const $MSRallyButton = [318,396] ;318,396 - 16711 ; Blue
Global Const $MSRallyRssHelpButton = [349,352]  ;349,352 - 16711
Global Const $MSRally8HourCheckBox = [281,439] ;281,439 - 16777215
Global Const $MSRallySetButton = [391,503] ;391,503 - 16711
Global Const $MSRallyQueueMaxButton = [286,308] ;286,308 - 16711
Global Const $MSRallySendButton = [356,295] ;356,295 - 16711
; OLD from VB no longer used
;Global Const $MSMarchCheck = [969,573]
;Global Const $MSMarchCheckColor = 3088

;Colors
Global Const $MSWhite = 16777215 ;16317688
Global Const $MSWhiteArray = [16777215,15527148]
Global Const $MSOrange = 11230223
Global Const $MSGreenCollect = 11264
Global Const $MSPurple = 3672136
Global Const $MSRedNoButton = 3737603
Global Const $MSBuildingBeige = 10521720
Global Const $MSStrongholdUpgradeArrowColor = 13663240
Global Const $MSBlueOKButton = 16711
Global Const $MSGreyedOutButton = 4670530
Global Const $MSExitAppErrorColor = 1385254

;Paused?
Global $MSg_bPaused = false

;Global Const $MSGoldExitButton1 = [435,160]
;Global Const $MSGoldExitButton2 = [583,183]
;Global Const $MSGoldExitButton3 = [523,168]

;Global Const $MSGoldBuyButton = [1140,340]
;Global Const $MSGoldBuyButton2 = [1140,540]

;Global Const $MSGoldBuyButton = [1145,340]
;Global Const $MSGoldBuyButton2 = [1145,540]



;Global Const $MSGoldBuyButton = [1135,340]
;Global Const $MSGoldBuyButton2 = [1135,540]
;Global Const $MSGetGoldButton = 6962190
;Global Const $MSGetGoldButton = 3672064

;; Than Updated for my machine
;Global Const $MSAndroidHomeButton  = [1186,560]
;Global Const $MSAndroidHomeButtonBottom  = [690,711]
Global Const $MSAndroidHomeButton  = [1190,420]
Global Const $MSAndroidHomeButtonBottom  = [190,780]

Global Const $MSRssProduction[] = [1111,1111,1111,1111]
Global Const $MSSilverProduction[] = [1111,1111,1111,1111]

;Convert to Dark Energy buttons
Global Const $MSInitialConvert[] = [1000,525]
Global Const $MSConvertConfirm[] = [725,525]
Global Const $MSConvertAccept[] = [800,525]