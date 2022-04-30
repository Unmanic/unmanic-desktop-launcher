#NoTrayIcon
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <MsgBoxConstants.au3>

Func Update_Channel()
	#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate("Unmanic Updater", 457, 214, 362, 117)
	$Combo1 = GUICtrlCreateCombo("", 129, 96, 199, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
	$Label1 = GUICtrlCreateLabel("Update Channel", 16, 96, 81, 17)
	$Button1 = GUICtrlCreateButton("Update", 344, 152, 81, 33)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	_GUICtrlComboBox_AddString($Combo1, "Default")
	_GUICtrlComboBox_AddString($Combo1, "Staging")
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form1)
			Case $Button1
				$sComboRead = GUICtrlRead($Combo1)
;				MsgBox($MB_SYSTEMMODAL, "", "The combobox is currently displaying: " & $sComboRead, 0, $Form1)


		EndSwitch
	WEnd
EndFunc

Update_Channel()