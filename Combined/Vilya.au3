#include <MsgBoxConstants.au3>
#include "CommonActions.au3"
#include "CommonConstants.au3"
#include "LoginObject.au3"
#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include "MobileStrike/MSMasterBluestacks.au3"
#include "GameOfWar/GoWMasterBluestacks.au3"
#include "Email.au3"



HotKeySet("{F10}","HotKeyPressed")
HotKeySet("{F9}","HotKeyPressed")
HotKeySet("{F8}","HotKeyPressed")
HotKeySet("{F1}","HotKeyPressed")


If FileExists($LogFileName) = 1 Then
   FileDelete($LogFileName)
EndIf
Opt("WinTitleMatchMode", 1) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase


Local $cityType = 'NONE'

While 1

   LogMessage("Starting Vilya Loop")

   ;If there is a session timeout run the other type of city
   if($SleepOnLogout =1) Then

	  ;MsgBox($MB_SYSTEMMODAL, "", "Session Timeout. Switching from " & $cityType)
	  If($cityType = 'GoW') Then
		 $cityType = 'MS'
	  Else
		 $cityType = 'GoW'
	  EndIf
	  $SleepOnLogout = 0
   Else
	  $cityType = GetNextCityType()
	  $SleepOnLogout = 0
   EndIf

   If ($cityType = 'GoW') Then
	  ;Run GoW
	  ;MsgBox($MB_SYSTEMMODAL, "", "Running GoW")
	  RunGoWCity()
   Else
	  ;Run Ms
	  ;MsgBox($MB_SYSTEMMODAL, "", "Running MS")
	  ;MsgBox($MB_SYSTEMMODAL, "", "Have City Type " & $cityType)
	  RunMSCity()
   EndIf

WEnd

