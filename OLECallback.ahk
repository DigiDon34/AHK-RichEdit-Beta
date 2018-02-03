;****************************
;RN_SetOLECallback by DigiDon
;Adapted from AutoIt RichEdit class
;
; In the sample we just add
;----->OLECallbackVars()
;----->RN_SetOLECallback(RE2.HWND)
;****************************
	;			MSDN OLECallback Mehods
	;*****************************
	; ContextSensitiveHelp
	; DeleteObject
	; GetClipboardData
	; GetContextMenu
	; GetDragDropEffect
	; GetInPlaceContext
	; GetNewStorage
	; QueryAcceptData
	; QueryInsertObject
	; ShowContainerUI
	;*****************************
	;			IMPLEMENTATION
	;*****************************
	; IUnknown method
	;!!!!!!!!!!!!!!!!!
	; QueryInterface
	; AddRef
	; Release
	;!!!!!!!!!!!!!!!!!
	; GetNewStorage
	; GetInPlaceContext
	; ShowContainerUI
	; QueryInsertObject
	; DeleteObject
	; QueryAcceptData
	; ContextSensitiveHelp
	; GetClipboardData
	; GetDragDropEffect
	; GetContextMenu
;****************************
RN_SetOLECallback(P_HWND) {
global

	If $pObj_RichCom
		return

	VarSetCapacity($pCall_RichCom, A_PtrSize*20, 0)
	
	NumPut($__RichCom_Object_QueryInterface, $pCall_RichCom, 0,"Ptr")
	NumPut($__RichCom_Object_AddRef, $pCall_RichCom, A_PtrSize*1,"Ptr")
	NumPut($__RichCom_Object_Release, $pCall_RichCom, A_PtrSize*2,"Ptr")
	NumPut($__RichCom_Object_GetNewStorage, $pCall_RichCom, A_PtrSize*3,"Ptr")
	NumPut($__RichCom_Object_GetInPlaceContext, $pCall_RichCom, A_PtrSize*4,"Ptr")
	NumPut($__RichCom_Object_ShowContainerUI, $pCall_RichCom, A_PtrSize*5,"Ptr")
	NumPut($__RichCom_Object_QueryInsertObject, $pCall_RichCom, A_PtrSize*6,"Ptr")
	NumPut($__RichCom_Object_DeleteObject, $pCall_RichCom, A_PtrSize*7,"Ptr")
	NumPut($__RichCom_Object_QueryAcceptData, $pCall_RichCom, A_PtrSize*8,"Ptr")
	NumPut($__RichCom_Object_ContextSensitiveHelp, $pCall_RichCom, A_PtrSize*9,"Ptr")
	NumPut($__RichCom_Object_GetClipboardData, $pCall_RichCom, A_PtrSize*10,"Ptr")
	NumPut($__RichCom_Object_GetDragDropEffect, $pCall_RichCom, A_PtrSize*11,"Ptr")
	NumPut($__RichCom_Object_GetContextMenu, $pCall_RichCom, A_PtrSize*12,"Ptr")
	NumPut(&$pCall_RichCom, $pObj_RichComObject, 0,"Ptr")
	NumPut(1, $pObj_RichComObject, A_PtrSize,"int")
	$pObj_RichCom := &$pObj_RichComObject
	;https://wiki.winehq.org/List_Of_Windows_Messages
	$EM_SETOLECALLBACK = 0x446
	SendMessage, % $EM_SETOLECALLBACK , 0, &$pObj_RichComObject,,ahk_id %P_HWND%
	
	if (ErrorLevel ="FAIL" or ErrorLevel=0) {
		; msgbox EM_SETOLECALLBACK FAILED
		return false
		}
	Return true
}

OLECallbackVars() {
global
	; #VARIABLES# =====================================================================================
	$_GCR_S_OK = 0
	$_GCR_E_NOTIMPL = 0x80004001
	$_GCR_E_INVALIDARG = 0x80070057
	$Debug_RE := False
	; $_GRE_sRTFClassName, $h_GUICtrlRTF_lib, $_GRE_Version, $_GRE_TwipsPeSpaceUnit := 1440 ; inches
	$_GRE_sRTFClassName:=""
	$h_GUICtrlRTF_lib:=""
	$_GRE_Version:=""
	$_GRE_TwipsPeSpaceUnit := 1440 ; inches
	; $_GRE_hUser32dll, $_GRE_CF_RTF, $_GRE_CF_RETEXTOBJ
	$_GRE_hUser32dll:=""
	$_GRE_CF_RTF:=""
	$_GRE_CF_RETEXTOBJ:=""
	;DigiDon: Not implemented yet
	$_GRC_StreamFromFileCallback := RegisterCallback("__GCR_StreamFromFileCallback")
	$_GRC_StreamFromVarCallback := RegisterCallback("__GCR_StreamFromVarCallback")
	$_GRC_StreamToFileCallback := RegisterCallback("__GCR_StreamToFileCallback")
	$_GRC_StreamToVarCallback := RegisterCallback("__GCR_StreamToVarCallback")
	$_GRC_sStreamVar:=""
	$gh_RELastWnd:=""
	VarSetCapacity($pObj_RichComObject, A_PtrSize+4, 0)
	$pCall_RichCom:=""
	$pObj_RichCom:=""
	;We could also preload the DLL, is it the right method?
	; hMod := DllCall( "GetModuleHandle", Str,"kernel32.dll" ) 
	; $hLib_RichCom_OLE32 := DllCall( "GetProcAddress", Ptr, hMod, Str, "OLE32" ) 
	$__RichCom_Object_QueryInterface := RegisterCallback("__RichCom_Object_QueryInterface")
	$__RichCom_Object_AddRef := RegisterCallback("__RichCom_Object_AddRef")
	$__RichCom_Object_Release := RegisterCallback("__RichCom_Object_Release")
	$__RichCom_Object_GetNewStorage := RegisterCallback("__RichCom_Object_GetNewStorage")
	$__RichCom_Object_GetInPlaceContext := RegisterCallback("__RichCom_Object_GetInPlaceContext")
	$__RichCom_Object_ShowContainerUI := RegisterCallback("__RichCom_Object_ShowContainerUI")
	$__RichCom_Object_QueryInsertObject := RegisterCallback("__RichCom_Object_QueryInsertObject")
	$__RichCom_Object_DeleteObject := RegisterCallback("__RichCom_Object_DeleteObject")
	$__RichCom_Object_QueryAcceptData := RegisterCallback("__RichCom_Object_QueryAcceptData")
	$__RichCom_Object_ContextSensitiveHelp := RegisterCallback("__RichCom_Object_ContextSensitiveHelp")
	$__RichCom_Object_GetClipboardData := RegisterCallback("__RichCom_Object_GetClipboardData")
	$__RichCom_Object_GetDragDropEffect := RegisterCallback("__RichCom_Object_GetDragDropEffect")
	$__RichCom_Object_GetContextMenu := RegisterCallback("__RichCom_Object_GetContextMenu")
}

;~ '/////////////////////////////////////
;~ '// OLE stuff, don't use yourself..
;~ '/////////////////////////////////////
;~ '// Useless procedure, never called..
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_QueryInterface
; Description ...:
; Syntax.........: __RichCom_Object_QueryInterface($pObject, $REFIID, $ppvObj)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_QueryInterface($pObject, $REFIID, $ppvObj) {
global
	;AHK COULD BE
	; msgbox __RichCom_Object_QueryInterface
	; return ComObjQuery($pObject, $REFIID)
	Return $_GCR_S_OK
}   ;==>__RichCom_Object_QueryInterface

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_AddRef
; Description ...:
; Syntax.........: __RichCom_Object_AddRef($pObject)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_AddRef($pObject) {

	NumPut(NumGet($pObject + 0,A_PtrSize, "Int")+1, $pObject + 0, A_PtrSize, "Int")
	
	Return NumGet($pObject + 0,A_PtrSize, "Int")
}   ;==>__RichCom_Object_AddRef

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_Release
; Description ...:
; Syntax.........: __RichCom_Object_Release($pObject)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_Release($pObject) {

	If ( NumGet($pObject + 0,A_PtrSize, "Int") > 0 ) {
		NumPut(NumGet($pObject + 0,A_PtrSize, "Int")-1, $pObject + 0, A_PtrSize, "Int")
		Return NumGet($pObject + 0,A_PtrSize, "Int")
	}
}   ;==>__RichCom_Object_Release

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_GetInPlaceContext
; Description ...:
; Syntax.........: __RichCom_Object_GetInPlaceContext($pObject, $lplpFrame, $lplpDoc, $lpFrameInfo)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_GetInPlaceContext($pObject, $lplpFrame, $lplpDoc, $lpFrameInfo) {
global
	Return $_GCR_E_NOTIMPL
}   ;==>__RichCom_Object_GetInPlaceContext

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_ShowContainerUI
; Description ...:
; Syntax.........: __RichCom_Object_ShowContainerUI($pObject, $fShow)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_ShowContainerUI($pObject, $fShow) {
global
	Return $_GCR_E_NOTIMPL
}   ;==>__RichCom_Object_ShowContainerUI

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_QueryInsertObject
; Description ...:
; Syntax.........: __RichCom_Object_QueryInsertObject($pObject, $lpclsid, $lpstg, $cp)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_QueryInsertObject($pObject, $lpclsid, $lpstg, $cp) {
global
; msgbox __RichCom_Object_QueryInsertObject
;MSDN SAYS
; The member is called when pasting and when reading Rich Text Format (RTF).
	Return $_GCR_S_OK
}   ;==>__RichCom_Object_QueryInsertObject

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_DeleteObject
; Description ...:
; Syntax.........: __RichCom_Object_DeleteObject($pObject, $lpoleobj)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_DeleteObject($pObject, $lpoleobj) {
global
	Return $_GCR_S_OK
	; Return $_GCR_E_NOTIMPL
}   ;==>__RichCom_Object_DeleteObject

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_QueryAcceptData
; Description ...:
; Syntax.........: __RichCom_Object_QueryAcceptData($pObject, $lpdataobj, $lpcfFormat, $reco, $fReally, $hMetaPict)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_QueryAcceptData($pObject, $lpdataobj, $lpcfFormat, $reco, $fReally, $hMetaPict) {
global
	Return $_GCR_S_OK
}   ;==>__RichCom_Object_QueryAcceptData

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_ContextSensitiveHelp
; Description ...:
; Syntax.........: __RichCom_Object_ContextSensitiveHelp($pObject, $fEnterMode)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_ContextSensitiveHelp($pObject, $fEnterMode) {
global
	Return $_GCR_E_NOTIMPL
}   ;==>__RichCom_Object_ContextSensitiveHelp

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_GetClipboardData
; Description ...:
; Syntax.........: __RichCom_Object_GetClipboardData($pObject, $lpchrg, $reco, $lplpdataobj)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_GetClipboardData($pObject, $lpchrg, $reco, $lplpdataobj) {
global
	Return $_GCR_E_NOTIMPL
}   ;==>__RichCom_Object_GetClipboardData

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_GetDragDropEffect
; Description ...:
; Syntax.........: __RichCom_Object_GetDragDropEffect($pObject, $fDrag, $grfKeyState, $pdwEffect)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_GetDragDropEffect($pObject, $fDrag, $grfKeyState, $pdwEffect) {
global
	Return $_GCR_E_NOTIMPL
}   ;==>__RichCom_Object_GetDragDropEffect

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_GetContextMenu
; Description ...:
; Syntax.........: __RichCom_Object_GetContextMenu($pObject, $seltype, $lpoleobj, $lpchrg, $lphmenu)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_GetContextMenu($pObject, $seltype, $lpoleobj, $lpchrg, $lphmenu) {
global
	Return $_GCR_E_NOTIMPL
}   ;==>__RichCom_Object_GetContextMenu

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_GetNewStorage
; Description ...:
; Syntax.........: __RichCom_Object_GetNewStorage($pObject, $lplpstg)
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
__RichCom_Object_GetNewStorage($pObject, $pPstg) {
global
	Local $lpLockBytes:=0
	Local $aSc := DllCall("OLE32\CreateILockBytesOnHGlobal", "Ptr", 0, "int", 1, "ptr*", $lpLockBytes, "Uint")
	
	If $aSc 
		Return $aSc
		
	local $ppstgOpen:=0
	$aSc := DllCall("OLE32\StgCreateDocfileOnILockBytes", "Ptr", $lpLockBytes, "Uint", 0x10|2|0x1000, "Uint", 0, "ptr*", $ppstgOpen, "Uint")
	NumPut($ppstgOpen, $pPstg+0, 0, "Ptr")
	
	If ($aSc) {
		ObjRelease($lpLockBytes)
	}
	Return $aSc
}   ;==>__RichCom_Object_GetNewStorage