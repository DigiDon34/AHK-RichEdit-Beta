#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <GuiMenu.au3>
#include <Constants.au3>
#include <WinAPI.au3>

#include "GuiRichEdit.au3"

Global Enum $idOpen = 1000, $idSave, $idInfo

$hGUI = GUICreate("Test", 300, 200)

$Edit1 = _GUICtrlRichEdit_Create($hGUI, "", 10, 10, 280, 150, BitOR($WS_HSCROLL, $WS_VSCROLL, $ES_MULTILINE))

$hMenu = _GUICtrlMenu_CreatePopup()

_GUICtrlMenu_AddMenuItem($hMenu, "Open", $idOpen)
_GUICtrlMenu_AddMenuItem($hMenu, "Save", $idSave)
_GUICtrlMenu_AddMenuItem($hMenu, "Info", $idInfo)

GUISetState()

$wProcHandle = DllCallbackRegister("_WindowProc", "ptr", "hwnd;uint;wparam;lparam")

$wProcOld = _WinAPI_SetWindowLong($Edit1, $GWL_WNDPROC, DllCallbackGetPtr($wProcHandle))

While 1
    $Msg = GUIGetMsg()
    Switch $Msg
        Case $GUI_EVENT_CLOSE
            ExitLoop
    EndSwitch
WEnd


GUIDelete($hGUI)
DllCallbackFree($wProcHandle)


Func _WindowProc($hWnd, $Msg, $wParam, $lParam)
    Switch $hWnd
        Case $Edit1
            Switch $Msg
                Case $WM_RBUTTONUP
                    _GUICtrlMenu_TrackPopupMenu($hMenu, $hWnd)
                    Return 0
                Case $WM_COMMAND
                    Switch $wParam
                        Case $idOpen
                            ConsoleWrite("-> Open" & @LF)
                        Case $idSave
                            ConsoleWrite("-> Save" & @LF)
                        Case $idInfo
                            ConsoleWrite("-> Info" & @LF)
                    EndSwitch
            EndSwitch
    EndSwitch

    Local $aRet = DllCall("user32.dll", "int", "CallWindowProc", "ptr", $wProcOld, _
            "hwnd", $hWnd, "uint", $Msg, "wparam", $wParam, "lparam", $lParam)

    Return $aRet[0]
EndFunc   ;==>_WindowProc

Func __GCR_DebugPrint($debugString)
	MsgBox(0, '', $debugString)
   ; DllCall("kernel32.dll", "none", "OutputDebugString", "str", $debugString)
EndFunc