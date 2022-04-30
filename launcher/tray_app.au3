#NoTrayIcon
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <TrayConstants.au3>
#include <Inet.au3>
#include <Process.au3>
FileInstall("updater.exe",@ScriptDir & "\updater.exe")
Opt("TrayMenuMode", 3)
Tray_Menu()

Func Tray_Menu()
        Local $iWorkers = TrayCreateMenu("Workers") ; Create a tray menu sub menu with two sub items.
        Local $iStart = TrayCreateItem("Start Workers", $iWorkers)
        Local $iPause = TrayCreateItem("Pause Workers", $iWorkers)
		Local $iScan_Library = TrayCreateItem("Scan Library")
        TrayCreateItem("") ; Create a separator line.
		Local $iBrowser_Launch = TrayCreateItem("Launch Browser")
		Local $iUpdate_Settings = TrayCreateItem("Update")
        Local $idAbout = TrayCreateItem("About")
        TrayCreateItem("") ; Create a separator line.

        Local $idExit = TrayCreateItem("Exit")

        TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.

        While 1
                Switch TrayGetMsg()
                        Case $idAbout ; Display a message box about the AutoIt version and installation path of the AutoIt executable.
                                MsgBox($MB_SYSTEMMODAL, "", "Unmanic Launcher" & @CRLF & @CRLF & _
                                                "Version: 0.1" & @CRLF)

                        Case $iStart
                                $iStart_Return = _RunDos('curl -H "accept: Application/json" -X POST http://localhost:8888/unmanic/api/v2/workers/worker/resume/all -d ""')
						Case $iPause
								 $iPause_Return = _RunDos('curl -H "accept: Application/json" -X POST http://localhost:8888/unmanic/api/v2/workers/worker/pause/all -d ""')
						Case $iBrowser_Launch
								ShellExecute("http://localhost:8888")
						Case $iScan_Library
								$iScan_Library_Return = _INetGetSource("http://localhost:8888/unmanic/api/v1/pending/rescan")
						Case $iUpdate_Settings
							Run("updater.exe")
                        Case $idExit ; Exit the loop.
                                Exit
                EndSwitch
        WEnd
EndFunc   ;==>Example

