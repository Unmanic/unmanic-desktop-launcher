#NoTrayIcon
#AutoIt3Wrapper_icon=unmanic.ico
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <Process.au3>
#include <WinAPIFiles.au3>

Func Initialize_INI()
		IniWrite("unmanic_updater.ini", "Release_Channel", "Default", "0")
		IniWrite("unmanic_updater.ini", "Release_Channel", "Staging", "0")
EndFunc
Func Update_Channel()
	$iVersion=FileOpen(@TempDir&"\unmanic_version.txt",$FO_OVERWRITE)
	FileWriteLine($iVersion,"__main.py__ 0"&@CR)
	_RunDos(@UserProfileDir&"\AppData\Local\Programs\Unmanic\Python\python.exe -m unmanic1 --version >"&@TempDir&"\unmanic_version.txt" )
	$iVersion=FileOpen(@TempDir&"\unmanic_version.txt",$FO_READ)
	$iUnmanic_Version = StringSplit(FileReadLine($iVersion, 1), " ")
	FileDelete(@TempDir&"\unmanic_version.txt")
	#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate("Unmanic Updater", 457, 214, 362, 117)
	$Combo1 = GUICtrlCreateCombo("", 129, 96, 199, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
	$Label1 = GUICtrlCreateLabel("Update Channel", 16, 96, 81, 17)
	$Label2 = GUICtrlCreateLabel("Current Version:", 16, 180, 81, 17)
	$Version_Label = GUICtrlCreateLabel($iUnmanic_Version[2], 95, 180, 81, 17)

	If string($iUnmanic_Version[2]) <> 0 Then
		$Button1 = GUICtrlCreateButton("Update", 344, 152, 81, 33)
	Else
		$Button1 = GUICtrlCreateButton("Install", 344, 152, 81, 33)
	EndIf
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	_GUICtrlComboBox_AddString($Combo1, "Default")
	_GUICtrlComboBox_AddString($Combo1, "Staging")
	If FileExists("unmanic_updater.ini") Then
		If IniRead("unmanic_updater.ini","Release_Channel","Default","Default Value")=1 Then
			_GUICtrlComboBox_SelectString($Combo1, 'Default')
		EndIf
		If IniRead("unmanic_updater.ini","Release_Channel","Staging","Default Value")=1 Then
			_GUICtrlComboBox_SelectString($Combo1, 'Staging')
		EndIf
	Else
		Initialize_INI()
	EndIf
	While 1
		;sleep(100)
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Button1
				$sComboRead = GUICtrlRead($Combo1)
				Initialize_INI()
				IniWrite("unmanic_updater.ini", "Release_Channel", $sComboRead, "1")
				If String($iUnmanic_Version[2]) = 0 Then
					RunWait("python.exe -m pip install unmanic",@ScriptDir&"Python\",@SW_SHOW)
				Else
					RunWait("python.exe -m pip install unmanic --upgrade",@ScriptDir&"Python\",@SW_SHOW)
		EndSwitch
	WEnd
EndFunc

Update_Channel()