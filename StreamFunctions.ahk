; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Global $__g_pGRC_StreamFromVarCallback := RegisterCallback("__GCR_StreamFromVarCallback")
Global $__g_pGRC_sStreamVar := RegisterCallback("__GCR_StreamFromVarCallback")
; For Stream Callbacks :)
Global $SF_TEXT = 0x1
Global $SF_RTF = 0x2
Global $SF_RTFNOOBJS = 0x3
Global $SF_TEXTIZED = 0x4
Global $SF_UNICODE = 0x0010
Global $SF_USECODEPAGE = 0x20
Global $SFF_PLAINRTF = 0x4000
Global $SFF_SELECTION = 0x8000

Func _GUICtrlRichEdit_StreamFromVar($hWnd, $sVar) {
global
; Global Const $tagEDITSTREAM = "align 4;dword_ptr dwCookie;dword dwError;ptr pfnCallback"
	; Local $tEditStream = DllStructCreate($tagEDITSTREAM)
	Local $tEditStream 
	; VarSetCapacity($tEditStream,4*2+A_PtrSize)
	; NumPut(Number, VarOrAddress [, Offset = 0][, Type = "UPtr"])
	VarSetCapacity($tEditStream,A_PtrSize+4+A_PtrSize)
	NumPut($__g_pGRC_StreamFromVarCallback,$tEditStream,A_PtrSize+4,"Ptr")
	; DllStructSetData($tEditStream, "pfnCallback", $__g_pGRC_StreamFromVarCallback)
	; $__g_pGRC_sStreamVar = $sVar
	; Local $s := StringLeft($sVar, 5)
	Local $s := SubStr($sVar, -5 + 1)
	Local $wParam := ($s == "{\rtf" Or $s == "{urtf") ? $SF_RTF : $SF_TEXT
	$wParam := $wParam|$SFF_SELECTION
	; If Not _GUICtrlRichEdit_IsTextSelected($hWnd) Then
		; _GUICtrlRichEdit_SetText($hWnd, "")
	; EndIf
	_SendMessage($hWnd, $EM_STREAMIN, $wParam, $tEditStream, 0, "wparam", "struct*")
	; Local $iError = DllStructGetData($tEditStream, "dwError")
	Local $iError := NumGet($tEditStream, A_PtrSize, "Int")
	If $iError <> 1
		Return False ;Error 700
	Return True
}  ;==>_GUICtrlRichEdit_StreamFromVar

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_StreamFromVarCallback
; Description ...: Callback function for streaming in from a variable
; Syntax.........: __GCR_StreamFromVarCallback ( $iCookie, $pBuf, $iBufLen, $pQbytes )
; Parameters ....: $iCookie - not used
;                  $pBuf - pointer to a buffer in the control
;                  $iBuflen - length of this buffer
;                  $pQbytes - pointer to number of bytes set in buffer
; Return values .: More bytes to "return"  - 0
;                  All bytes have been "returned" - 1
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ EditStreamCallback Function
; Example .......:
; ===============================================================================================================================
__GCR_StreamFromVarCallback($iCookie, $pBuf, $iBuflen, $pQbytes) {
	global
	Local $tQbytes
	; = DllStructCreate("long", $pQbytes)
	; DllStructSetData($tQbytes, 1, 0)
	
	; VarSetCapacity($pQbytes+0,4*2+A_PtrSize)
	NumPut(0,$pQbytes+0,0,"Int")

	; Local $tCtl
	; DllStructCreate("char[" & $iBuflen & "]", $pBuf)
	; VarSetCapacity($pBuf+0,4*2+A_PtrSize)
	Local $sCtl := SubStr($__g_pGRC_sStreamVar, - ($iBuflen - 1) + 1)
	If ($sCtl = "")
		Return 1
	; DllStructSetData($tCtl, 1, $sCtl)
	NumPut($sCtl,$pBuf+0,0,"Str")
	; NumPut($sCtl,$pBuf+0,0,"AStr")

	Local $iLen := StrLen($sCtl)
	; DllStructSetData($tQbytes, 1, $iLen)
	NumPut($iLen,$pQbytes+0,0,"Int")
	$__g_pGRC_sStreamVar := SubStr($__g_pGRC_sStreamVar, $iLen + 1)
	Return 0
}