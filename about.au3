#include-once

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

; #INDEX# =======================================================================================================================
; Title .........: About Dialog
; UDF Version....: 1.0.0
; AutoIt Version : 3.3.14.2
; Description ...: An easy way to create the About dialog for your application
; Author(s) .....: Juno_okyo
; ===============================================================================================================================

Func _showAboutDialog($softwareName, $version, $author, $copyrightStart = Default, $copyrightEnd = Default, $website = Default, $hwnd = Default, $icon = Default, $width = Default, $height = Default)
	Opt("GUIOnEventMode", 0)

	If $hwnd = Default Then $hwnd = WinGetHandle(AutoItWinGetTitle())

	; Icon
	Local $iconName = -1
	If $icon = Default Then
		$icon = (@Compiled) ? @ScriptFullPath : 'shell32.dll'
		If Not @Compiled Then $iconName = 3 ; icon from shell32.dll
	EndIf

	; Line 01
	If (StringLeft($version, 1) <> 'v') Then $version = 'v' & $version
	$softwareName &= ' ' & $version

	; Line 02
	Local $copyright = 'Copyright ' & Chr(169) & ' '
	If $copyrightStart <> Default Then $copyright &= $copyrightStart & '-'
	If $copyrightEnd = Default Then $copyrightEnd = @YEAR
	$copyright &= $copyrightEnd & ' ' & $author

	; Check website
	Local $GUIheight = ($website = Default) ? 135 : 160
	Local $btnTop = ($website = Default) ? 85 : 115

	; Width, height
	If $width = Default Then $width = 393
	If $height = Default Then $height = $GUIheight

	#Region ### START Koda GUI section ###
	Local $FormAbout = GUICreate('About', $width, $height, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), -1, $hwnd)
	GUISetFont(12, 400, 0, 'Segoe UI')
	GUICtrlCreateIcon($icon, $iconName, 20, 20, 48, 48)
	GUICtrlCreateLabel($softwareName, 80, 20, 238, 25)
	GUICtrlSetFont(-1, 12, 600, 0, 'Segoe UI')
	GUICtrlCreateLabel($copyright, 80, 50, 257, 25)

	If $website = Default Then
		; Prevent GUIGetMsg error
		Local $labelWebsite = GUICtrlCreateDummy()
	Else
		Local $labelWebsite = GUICtrlCreateLabel($website, 80, 80, 222, 25)
		GUICtrlSetFont(-1, 12, 400, 4, 'Segoe UI')
		GUICtrlSetColor(-1, 0x0000FF)
		GUICtrlSetCursor(-1, 0)
	EndIf

	Local $btnOK = GUICtrlCreateButton('OK', 80, $btnTop, 65, 25, $BS_DEFPUSHBUTTON)
	GUICtrlSetCursor(-1, 0)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	Local $iMsg = 0
	While 1
		$iMsg = GUIGetMsg()
		Switch $iMsg
			Case $labelWebsite
				; Make sure it is an valid URL
				Local $url = GUICtrlRead($labelWebsite)
				If $url Then
					Local $test = StringLeft($url, 4)
					If $test = 'http' Or $test = 'www.' Then ShellExecute($url)
				EndIf

			Case $btnOK
				ExitLoop

			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($FormAbout)
EndFunc   ;==>_showAboutDialog
