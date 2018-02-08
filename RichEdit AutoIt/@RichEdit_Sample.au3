;~ Opt("MustDeclareVars", 1)

#include <Misc.au3>
#include "GuiRichEdit.au3"
#include <GuiMENU.au3>
#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>


Global $FileStreamCallBack = DllCallbackRegister("_EditStreamCallbackFile", "dword", "long_ptr;ptr;long;ptr")
Global $FileStreamStruct = DllStructCreate($tagEDITSTREAM)
DllStructSetData($FileStreamStruct, 3, DllCallbackGetPtr($FileStreamCallBack))

Global $FileStreamInCallBack = DllCallbackRegister("_EditStreamInCallbackFile", "dword", "long_ptr;ptr;long;ptr")
Global $FileStreamInStruct = DllStructCreate($tagEDITSTREAM)
DllStructSetData($FileStreamInStruct, 3, DllCallbackGetPtr($FileStreamInCallBack))

Global $EDITSTREAM_RTFVariable
Global $VariableStreamCallBack = DllCallbackRegister("_EditStreamCallbackVariable", "dword", "long_ptr;ptr;long;ptr")
Global $VariableStreamStruct = DllStructCreate($tagEDITSTREAM)
DllStructSetData($VariableStreamStruct, 3, DllCallbackGetPtr($VariableStreamCallBack))

Global $h_RichEdit, $RichMENU[10]

Global Const $ES_SUNKEN = 16384

_Main()



Func _Main()
	; OpenFileDialog()
    Local $msg, $hgui, $button, $bt2, $btFromFile
    Local $mnuOptions, $mnuBKColor, $mnuResetBKColor
    Local $bkcolor, $bkcolor_save = 16777215, $lResult
    Local $btToVariable
    ; __GCR_Debug("TEST")
    $hgui = GUICreate("Rich Edit Example", 500, 550, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX))
	; __GCR_Debug("$hgui: " & $hgui)
    GUIRegisterMsg($WM_SIZING, "WM_SIZING")
    $h_RichEdit = _GUICtrlRichEdit_Create($hgui, "", 10, 10, 480, 420, BitOR($ES_WANTRETURN, $WS_HSCROLL, $ES_SUNKEN, $ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
;~  GUICtrlSetResizing($h_RichEdit, $GUI_DOCKAUTO)
; MsgBox(0, "", "Value of @error is: " & @error & @CRLF)
; __GCR_Debug("Value of @error is: " & @error)

; __GCR_Debug("$h_RichEdit handle: " & $h_RichEdit & " error " & @error)
    $lResult = _SendMessage($h_RichEdit, $EM_SETEVENTMASK, 0, BitOR($ENM_REQUESTRESIZE, $ENM_LINK, $ENM_DROPFILES, $ENM_KEYEVENTS, $ENM_MOUSEEVENTS))
    ; __GCR_Debug("$h_RichEdit handle: " & $h_RichEdit)
    $lResult = _SendMessage($h_RichEdit, $EM_AUTOURLDETECT, True)
    
    
    $button = GUICtrlCreateButton("Exit", 100, 460, 100, 25)
    ; $btToVariable = GUICtrlCreateButton("MsgBox RTF", 310, 460, 90, 25)
    $btFromFile = GUICtrlCreateButton("ReadFile", 410, 460, 90, 25)
    ; $bt2 = GUICtrlCreateButton("Save to File", 200, 460, 100, 25)
    ; GUICtrlSetTip(-1, "The target-File is: " & @WorkingDir & "\AutoIt_testrtf.rtf")
    GUISetState(@SW_SHOW)
    GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
    HotKeySet("{F8}", "_CharFromPos")
	
	; _GUICtrlRichEdit_InsertText($h_RichEdit, 'Testing' & @CRLF)
    
	; Local $RTFFiletest = OpenFileDialog()
	; MsgBox(0, "", "File handle: " & $RTFFiletest)
    ; _GUICtrlRichEdit_SetText($h_RichEdit, "This is a test" & @CRLF)
    ; _GUICtrlRichEdit_AppendText($h_RichEdit, 'http://www.autoitscript.com/forum' & @CRLF)
    ; _GUICtrlRichEdit_SetSel($h_RichEdit, 0, 15)
    ; _GUICtrlRichEdit_InsertText($h_RichEdit, "Welcome to AutoIt" & @CRLF)
    ; _GUICtrlRichEdit_AppendText($h_RichEdit, 'mailto:yourmail@your.com' & @CRLF)
    ; _GUICtrlRichEdit_AppendText($h_RichEdit, '{\rtf1{\field{\*\fldinst{ HYPERLINK " http://www.msn.com"}}{\fldrslt{ MSN} }}}')
    
    ; _GUICtrlRichEdit_AppendText($h_RichEdit, _RTF_GetBMPRTF(_FindFirstBMP()) & @CRLF)
    
    ; _GUICtrlRichEdit_SetSel($h_RichEdit, 0, 17)
    ; __GCR_Debug( "new Undo-Limit: " & _GUICtrlRichEdit_SetUndoLimit($h_RichEdit, 100))
	
	; Local $send = _GUICtrlRichEdit_StreamFromFile($h_RichEdit, @ScriptDir & "\SampleDocument.rtf")
	Local $TestVar="{\rtf1{\field{\*\fldinst{ HYPERLINK http://www.msn.com }}{\fldrslt{ MSN} }}}"
	_GUICtrlRichEdit_StreamFromVar($h_RichEdit,$TestVar)
	
    $RichMENU[0] = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
    $RichMENU[1] = GUICtrlCreateMenuItem("Undo  Ctrl-Z", $RichMENU[0])
    $RichMENU[2] = GUICtrlCreateMenuItem("Redo  Ctrl-Y", $RichMENU[0])
    GUICtrlCreateMenuItem("", $RichMENU[0])
    $RichMENU[3] = GUICtrlCreateMenuItem("Cut   Ctrl-X", $RichMENU[0])
    $RichMENU[4] = GUICtrlCreateMenuItem("Copy  Ctrl-C", $RichMENU[0])
    $RichMENU[5] = GUICtrlCreateMenuItem("Paste Ctrl-V", $RichMENU[0])
    
    While 1
        $msg = GUIGetMsg()

        Select

            Case $msg = $GUI_EVENT_CLOSE Or $msg = $button ; controls commands don't work here if using wm_command
                Exit
            ; Case $msg = $bt2
                ; Local $RTFFile = FileOpen(@DesktopDir & "\AutoIt_testrtf.rtf", 2)
                ; DllStructSetData($FileStreamStruct, 1, $RTFFile) ; -> Send handle to CallbackFunc
                ; Local $send = _GUICtrlRichEdit_StreamToFile($h_RichEdit, $SF_RTF, $FileStreamStruct)
                ; FileClose($RTFFile)
                ; ConsoleWrite($send & @CRLF)
            ; Case $msg = $btToVariable
                ; Global $EDITSTREAM_RTFVariable = ""
                ; Local $send = _GUICtrlRichEdit_StreamToVar($h_RichEdit, $SF_RTFNOOBJS, $VariableStreamStruct)
                ; MsgBox(0, '', $EDITSTREAM_RTFVariable)
                ; $EDITSTREAM_RTFVariable = ""
            Case $msg = $btFromFile
                ; Local $RTFFile = FileOpen("C:\Users\Jo\Documents\Autohotkey\AutoitRichEdit\SampleDocument.rtf")
                ; Local $RTFFile = FileOpen(@WorkingDir & "\SampleDocument.rtf", 0)
				; __GCR_Debug("chosen file: " & @WorkingDir & "\SampleDocument.rtf")
				; __GCR_Debug("chosen file: " & $RTFFile)
                ; DllStructSetData($FileStreamInStruct, 1, $RTFFile) ; -> Send handle to CallbackFunc
                ; _GUICtrlRichEdit_SetText($h_RichEdit, "")
                ; Local $send = _GUICtrlRichEdit_StreamFromFile($h_RichEdit, $SF_RTF, $FileStreamInStruct)
                ; Local $send = _GUICtrlRichEdit_StreamFromFile($h_RichEdit, $FileStreamInStruct)
                Local $send = _GUICtrlRichEdit_StreamFromFile($h_RichEdit, @ScriptDir & "\SampleDocument.rtf")
				; MsgBox(0, "", "Value of @error is: " & @error & @CRLF & "return " & $send)
                ; FileClose($RTFFile)
                ConsoleWrite($send & @CRLF)
            Case $msg = $RichMENU[1]
                _GUICtrlRichEdit_Undo($h_RichEdit)
            Case $msg = $RichMENU[2]
                _GUICtrlRichEdit_Redo($h_RichEdit)
            Case $msg = $RichMENU[3]
                _GUICtrlRichEdit_Cut($h_RichEdit)
            Case $msg = $RichMENU[4]
                _GUICtrlRichEdit_Copy($h_RichEdit)
            Case $msg = $RichMENU[5]
                _GUICtrlRichEdit_Paste($h_RichEdit)
        EndSelect
    WEnd
EndFunc   ;==>_Main

; Function DebugPrint
; : Outputs debug strings - use DebugView or similar to catch debug messages
Func __GCR_Debug($debugString)
	MsgBox(0, '', $debugString)
   ; DllCall("kernel32.dll", "none", "OutputDebugString", "str", $debugString)
EndFunc

; for PopupMenu
Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $h_RichEdit
            Select
                Case $iCode = $EN_MSGFILTER
                    Local $tMsgFilter = DllStructCreate($tagMSGFILTER, $ilParam)
                    If DllStructGetData($tMsgFilter, 4) = $WM_RBUTTONUP Then ; WM_RBUTTONUP
                        Local $hMenu = GUICtrlGetHandle($RichMENU[0])
                        _SetMenuTexts($hWndFrom, $RichMENU)
                        _GUICtrlMenu_TrackPopupMenu($hMenu, $hWnd)
                    EndIf
            EndSelect
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func WM_SIZING($hWnd, $uMsg, $wParam, $lParam)
    Local $wh = WinGetClientSize($hWnd)
    ControlMove($h_RichEdit, "", "", Default, Default, $wh[0] - 20, $wh[1] - 130)
EndFunc   ;==>WM_SIZING


;Prog@ndy
Func _FindFirstBMP($dir = @WindowsDir)
    Local $find = FileFindFirstFile($dir & "\*.bmp")
    Local $BMPFile = FileFindNextFile($find)
    FileClose($find)
    Return $dir & "\" & $BMPFile
EndFunc   ;==>_FindFirstBMP

;Prog@ndy
Func _CharFromPos()
    Local $pos = MouseGetPos()
    Local $winpos = WinGetPos($h_RichEdit)
    Local $Char = _GUICtrlRichEdit_GetCharPosFromXY($h_RichEdit, $pos[0] - $winpos[0], $pos[1] - $winpos[1])
    MsgBox(0, @error, $Char)
EndFunc   ;==>_CharFromPos

;Prog@ndy
Func _RTF_GetBMPRTF($BMPFile)
    If Not (StringRight($BMPFile,4) = ".bmp") Then Return SetError(1, 0, "")
    Local $Data = FileOpen($BMPFile, 16)
    If FileRead($Data, 2) <> "0x424D" Then Return SetError(1, 0, "")
    FileRead($Data, 12)
    Local $RTF = '{\rtf1{\pict\dibitmap ' & Hex(FileRead($Data)) & '}}'
    FileClose($Data)
    Return $RTF
EndFunc   ;==>_RTF_GetBMPRTF

;Prog@ndy, set thze states of the Context-Menu Items :)
Func _SetMenuTexts($h_RichEdit, $RichMENU)
    Local $hMenu = GUICtrlGetHandle($RichMENU[0])
    ; Undo:
    If _GUICtrlRichEdit_CanUndo($h_RichEdit) Then
        _GUICtrlMenu_SetItemDisabled($hMenu, $RichMENU[1], 0, 0)
        ; _GUICtrlMenu_SetItemText($hMenu, $RichMENU[1], "Undo: " & _GUICtrlRichEdit_UndoID2Text(_GUICtrlRichEdit_GetNextUndo($h_RichEdit)) & "   Ctrl-Z", 0)
        _GUICtrlMenu_SetItemText($hMenu, $RichMENU[1], "Undo: " & _GUICtrlRichEdit_GetNextUndo($h_RichEdit) & "   Ctrl-Z", 0)
    Else
        _GUICtrlMenu_SetItemText($hMenu, $RichMENU[1], "Undo" & "   Ctrl-Z", 0)
        _GUICtrlMenu_SetItemDisabled($hMenu, $RichMENU[1], 1, 0)
    EndIf
    ;Redo
    If _GUICtrlRichEdit_CanRedo($h_RichEdit) Then
        _GUICtrlMenu_SetItemDisabled($hMenu, $RichMENU[2], 0, 0)
        _GUICtrlMenu_SetItemText($hMenu, $RichMENU[2], "Redo: " & _GUICtrlRichEdit_GetNextRedo($h_RichEdit) & "   Ctrl-Y", 0)
        ; _GUICtrlMenu_SetItemText($hMenu, $RichMENU[2], "Redo: " & _GUICtrlRichEdit_UndoID2Text(_GUICtrlRichEdit_GetRedoName($h_RichEdit)) & "   Ctrl-Y", 0)
    Else
        _GUICtrlMenu_SetItemText($hMenu, $RichMENU[2], "Redo" & "   Ctrl-Y", 0)
        _GUICtrlMenu_SetItemDisabled($hMenu, $RichMENU[2], 1, 0)
    EndIf
    ; Cut / Copy:
    Local $sel = _GUICtrlRichEdit_GetSel($h_RichEdit)
    If UBound($sel) = 3 And $sel[1] <> $sel[2] Then
        _GUICtrlMenu_SetItemDisabled($hMenu, $RichMENU[3], 0, 0)
        _GUICtrlMenu_SetItemDisabled($hMenu, $RichMENU[4], 0, 0)
    Else
        _GUICtrlMenu_SetItemDisabled($hMenu, $RichMENU[3], 1, 0)
        _GUICtrlMenu_SetItemDisabled($hMenu, $RichMENU[4], 1, 0)
    EndIf
    ;Paste
    If _GUICtrlRichEdit_CanPaste($h_RichEdit) Then
        _GUICtrlMenu_SetItemDisabled($hMenu, $RichMENU[5], 0, 0)
    Else
        _GUICtrlMenu_SetItemDisabled($hMenu, $RichMENU[5], 1, 0)
    EndIf
EndFunc   ;==>_SetMenuTexts
;~ DWORD EditStreamCallback(
;~     DWORD_PTR dwCookie,
;~     LPBYTE pbBuff,
;~     LONG cb,
;~     LONG *pcb
;~ );

Func _EditStreamCallbackVariable($dwCookie, $pbBuff, $cb, $pcb)
    Local $pcb_Struct = DllStructCreate("long", $pcb)
;~  If @AutoItUnicode Then
;~      Local $buufs = DllStructCreate("wchar[" & $cb & "]", $pbBuff)
;~  Else
    Local $buufs = DllStructCreate("char[" & $cb & "]", $pbBuff)
;~  EndIf
    $EDITSTREAM_RTFVariable &= DllStructGetData($buufs, 1)
    DllStructSetData($pcb_Struct, 1, $cb)
    Return 0
EndFunc   ;==>_EditStreamCallbackVariable
Func _EditStreamCallbackFile($dwCookie, $pbBuff, $cb, $pcb)
    Local $pcb_Struct = DllStructCreate("long", $pcb)
    Local $FileHandle = $dwCookie
;~  If @AutoItUnicode Then
;~      Local $buufs = DllStructCreate("wchar[" & $cb & "]", $pbBuff)
;~  Else
    Local $buufs = DllStructCreate("char[" & $cb & "]", $pbBuff)
;~  EndIf
    ; Write To File :), could also append to a variable ....
    FileWrite($FileHandle, DllStructGetData($buufs, 1))
    DllStructSetData($pcb_Struct, 1, $cb)
    Return 0
EndFunc   ;==>_EditStreamCallbackFile

Func _EditStreamInCallbackFile($dwCookie, $pbBuff, $cb, $pcb)
    Local $pcb_Struct = DllStructCreate("long", $pcb)
    DllStructSetData($pcb_Struct, 1, 0)
    Local $FileHandle = $dwCookie
;~  If @AutoItUnicode Then
;~      Local $buufs = DllStructCreate("wchar[" & $cb & "]", $pbBuff)
;~  Else
    Local $buufs = DllStructCreate("char[" & ($cb + 1) & "]", $pbBuff)
;~  EndIf
    Local $read = FileRead($FileHandle, $cb)
    Local $error = @error
    If $error <> 0 Then Return 1
    DllStructSetData($buufs, 1, $read)
    DllStructSetData($pcb_Struct, 1, StringLen($read))
    Return 0
EndFunc   ;==>_EditStreamInCallbackFile