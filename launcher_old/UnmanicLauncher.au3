#NoTrayIcon
#AutoIt3Wrapper_icon=unmanic.ico
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
Opt("TrayMenuMode", 3)


$iUnmanic_PID=0
$iUnmanic_PID=ShellExecute(@ScriptDir&"\Python\python.exe","-m unmanic",@ScriptDir,"",@SW_HIDE)

Tray_Menu()

Func Tray_Menu()
		Local $iUnmanic = TrayCreateMenu("Start/Stop Unmanic")
		Local $iStart_Unmanic = TrayCreateItem("Start Unmanic", $iUnmanic)
		Local $iStop_Unmanic = TrayCreateItem("Stop Unmanic", $iUnmanic)
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
				Sleep(100)
                Switch TrayGetMsg()
                        Case $idAbout ; Display a message box about the AutoIt version and installation path of the AutoIt executable.
                                MsgBox($MB_SYSTEMMODAL, "", "Unmanic Launcher" & @CRLF & @CRLF & _
                                                "Version: 0.2.1" & @CRLF)

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
						Case $iStart_Unmanic
							If $iUnmanic_PID = 0 Then
								$iUnmanic_PID=ShellExecute(@ScriptDir&"\Python\python.exe","service.py",@ScriptDir,"",@SW_HIDE)
							Else
								MsgBox(0,"Error","Unmanic is already running with a PID of "& $iUnmanic_PID)
							EndIf
						Case $iStop_Unmanic
							If $iUnmanic_PID > 0 Then
								ProcessClose($iUnmanic_PID)
								$iUnmanic_PID = 0
							Else
								MsgBox(0,"Error","Unmanic is not running.")
							EndIf
						Case $idExit ; Exit the loop.
							If $iUnmanic_PID > 0 Then
								ProcessClose($iUnmanic_PID)
                                Exit
							Else
								Exit
							EndIf
                EndSwitch
        WEnd
EndFunc

