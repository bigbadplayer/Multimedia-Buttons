/*	"Multimedia Buttons" AUTOHOTKEY scripts
	Gergely Oláh
	version: v1.13
	last modified: 2016-07-06
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force	; Automatically kill older Instance, and replace it!
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent

;////////////////////////////////////////////////////////////
;/////////////// Run on Admin Rights
;////////////////////////////////////////////////////////////

; if not A_IsAdmin
; {
   ; Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ; ExitApp
; }
;////////////////////////////////////////////////////////////
;/////////////// Media Buttons
;////////////////////////////////////////////////////////////

;/// RemoveTooltip Function
{
RemoveToolTip:
     SetTimer, RemoveToolTip, Delete
     ToolTip
Return

;/// VolumeToolTip Function
VolumeToolTip:
	 Soundget, varVolumeLevel
     varVolumeLevel:= Round(varVolumeLevel)
     ToolTip, Master Volume: %varVolumeLevel% `%
     SetTimer, RemoveToolTip, -1000
Return

;(----- Master Volume up +5% -----)
!#WheelUp::
     Soundset, +5
	 Gosub, VolumeToolTip
Return

;(----- Master Volume down -5% -----)
!#WheelDown::
     Soundset, -5
	 Gosub, VolumeToolTip
Return

;(----- Master Volume mute/unmute -----)
!#Pause::
	Send {Volume_Mute}
Return
}

;////////////////////////////////////////////////////////////
;/////////////// Text Expanders
;////////////////////////////////////////////////////////////
/*	Text Expander Help
;	:*:				Instant replacement (No space or punctuation)
;	:?:				Internal word replacement
;	:B0:			No Backspace
;	:C:				Case sensitive
;	:C1:			Completely Case insensitive
;	:O:				Omit Last Character
;	:*:Example`t::	`t means: only Tab key starts the Expansion
*/
;(----- E-mail -----)
:*:,üdv::Üdvözlettel,
:*:,og::Oláh Gergely
:*:,go::Gergely Oláh
:*?:,áraj::Árajánlatkérésen
:*?:,megr::Megrendelve
:*?:,telj::Teljesítve
:*:,br::Best regards,
::tszn::További szép napot{!}
::ekv::Előre is köszönöm a választ{!}
::eksz::Előre is köszönöm{!}
:*:alk`t::alkatrész
:*:o/::Ø
:*?:,deg::°{Space}
:*?:+-::±
:*?:,u::µ
:*:swx`t::solidworks

;////////////////////////////////////////////////////////////
;/////////////// TextMenu
;////////////////////////////////////////////////////////////

+!s::
  SpecialSymbolsTextMenu("Ø,°,±,µ,©,®,⅓,⅔,¼,½,¾,€")
Return

SpecialSymbolsTextMenu(TextOptions)
{
  StringSplit, MenuItems, TextOptions , `,
  Loop %MenuItems0%
  {
    Item := MenuItems%A_Index%
    Menu, SpecialSymbolsMenu, add, %Item%, SpecialSymbolsMenuAction
  }
  Menu, SpecialSymbolsMenu, Show
  Menu, SpecialSymbolsMenu, DeleteAll
}

SpecialSymbolsMenuAction:
  SendInput %A_ThisMenuItem%{raw}%A_EndChar%
Return

;////////////////////////////////////////////////////////////
;/////////////// Double Right Click Menu
;////////////////////////////////////////////////////////////

;Double Right Click to menu
~RButton::
If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
{
	Sleep 300 ; wait for right-click menu, fine tune for your PC
	Send {Esc} ; close it
	goto startMyMenu ; your double-right-click action here
}
Return

startMyMenu:
	strPercentageSign:= "%"
	Menu, RButtonMenu, Add, Set Window Transparent 25 `%, SetWindowTransparent25
	Menu, RButtonMenu, Add, Set Window Transparent 50 %strPercentageSign%, SetWindowTransparent50
	Menu, RButtonMenu, Add, Set Window Transparent OFF, SetWindowTransparentOff
	Menu, RButtonMenu, Add,
	Menu, RButtonMenu, Add, Set Window Always On Top ON, SetWindowAlwaysOnTopOn
	Menu, RButtonMenu, Add, Set Window Always On Top OFF, SetWindowAlwaysOnTopOff
	Menu, RButtonMenu, Show
	;MsgBox, %A_ThisMenuItem%	;Ez mindenképp lefut
	Menu, RButtonMenu, DeleteAll
return

SetWindowTransparent25:
	Winset, Transparent, 64, A
return

SetWindowTransparent50:
	Winset, Transparent, 128, A
return

SetWindowTransparentOff:
	Winset, Transparent, OFF, A
return

SetWindowAlwaysOnTopOff:
	WinGetTitle, TempText, A
	   WinSet AlwaysOnTop, Off, A
	   If (SubStr(TempText, 1, 2) = "+ ")
		  TempText := SubStr(TempText, 3)
	WinSetTitle, A, , %TempText%
return

SetWindowAlwaysOnTopOn:
	WinGetTitle, TempText, A
	   WinSet AlwaysOnTop, On, A
	   If (SubStr(TempText, 1, 2) != "+ ")
		  TempText := "+ " . TempText ;chr(134)
	WinSetTitle, A, , %TempText%
return


;////////////////////////////////////////////////////////////
;/////////////// Form-Filling
;////////////////////////////////////////////////////////////

:*:go@::gergely.olah@econengineering.com
:*:big@::bigbadplayer@gmail.com
:*:olg@::olgergely@gmail.com
:*?:@econe::@econengineering.com
:*:ogtel::{+}36 (70) 234 4024
:*:econtel::{+}36-1-279-0320
:*:econfax::{+}36-1-279-0321
:*:ahk`t::AutoHotkey

:*:,ma.::
	FormatTime, CurrentDateTime,, yyyy.MM.dd.
	SendInput %CurrentDateTime%
Return

:*:,ma_::
	FormatTime, CurrentDateTime,, yyyy_MM_dd
	SendInput %CurrentDateTime%
Return

:*:,ma-::
	FormatTime, CurrentDateTime,, yyyy-MM-dd
	SendInput %CurrentDateTime%
Return

:*:,ma ::
	FormatTime, CurrentDateTime,, yyyyMMdd
	SendInput %CurrentDateTime%
Return

;////////////////////////////////////////////////////////////
;/////////////// Programming / Coding
;////////////////////////////////////////////////////////////

::,try::Try{Enter}{Enter}Catch{Enter}{Enter}Finally{Enter}End Try
::,if::If  Then{Enter}{Enter}Else{Enter}{Enter}End If

{	;Notepad++ kivételével:
#IfWinNotActive ahk_class Notepad++
:?*B0:("::"){Left 2}	; (" -> ("|")
:?*B0:()::{Left}		; ( -> (|)
:?*B0:""::{Left}		; "" -> "|"
:?*B0:<>::{Left}		; <> -> <|>
:?*B0:{}::{Left}		; {} -> {|}
:?*B0:[]::{Left}		; [] -> [|]
#IfWinNotActive
}

{	;VBA Editor + Inventor VBA Editor Coding
#If, WinActive("ahk_class wndclass_desked_gsk") || Winactive("ahk_class WindowsForms10.Window.8.app.0.3735c46_r54_ad1")
:?*B0:(::){Left}	; ( -> (|)
:?*B0:"::"{Left}	; "" -> "|"
Return
#If	; Turn off hotkey context
}

+^2::	;Insert selected text between Quotes: "selectedText"
	strLeft = "
	strRight = "
	FuncQuotesAndParentheses(strLeft, strRight)
Return

+^9::	;Insert selected text between Parentheses: (selectedText)
	strLeft = (
	strRight = )
	FuncQuotesAndParentheses(strLeft, strRight)
return

+^8::	;Insert selected text between Quotes ADN Parentheses: ("selectedText")
	strLeft = ("
	strRight = ")
	FuncQuotesAndParentheses(strLeft, strRight)
return

FuncQuotesAndParentheses(ByRef varLeft, varRight)
{
	ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable of your choice.
	; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...
	Clipboard := ; Clear the clipboard
	Send, ^c		; Copy selection
	Clipwait 2, 1
	if (Clipboard = "") {
		;Do nothing
	} else {
		SendInput %varLeft%%Clipboard%%varRight%
	}
	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	Clipwait 2, 1
}
Return


;////////////////////////////////////////////////////////////
;/////////////// Window Management
;////////////////////////////////////////////////////////////

#-::
	send, {AppsKey}
return


;	https://autohotkey.com/board/topic/25393-appskeys-a-suite-of-simple-utility-hotkeys/

;            A - Makes the active window "Always On Top".
;                This will be indicated on it's title bar with a †.
;      SHIFT A - Makes the active window NOT "Always On Top".
{
	AppsKey & a::
;	If NOT IsWindow(WinExist("A"))
;	   Return
	WinGetTitle, TempText, A
	If GetKeyState("shift")
	{
	   WinSet AlwaysOnTop, Off, A
	   If (SubStr(TempText, 1, 2) = "+ ")
		  TempText := SubStr(TempText, 3)
	}
	else
	{
	   WinSet AlwaysOnTop, On, A
	   If (SubStr(TempText, 1, 2) != "+ ")
		  TempText := "+ " . TempText ;chr(134)
	}
	WinSetTitle, A, , %TempText%
	Return
}

;            T - Makes the active window 50% transpartent.
;      SHIFT T - Makes the active window opaque again.
{
	AppsKey & t::
;	If NOT IsWindow(WinExist("A"))
;	   Return
	If GetKeyState("shift")
	   Winset, Transparent, OFF, A
	else
	   Winset, Transparent, 128, A
	Return
}


;(----- Resize window -----)

#!u::ResizeWin(1920,1080)

;/// ResizeWin Function
ResizeWin(Width = 0,Height = 0)
{
	WinGetPos,X,Y,W,H,A
	If %Width% = 0
	Width := W

	If %Height% = 0
	Height := H

	WinMove,A,,%X%,%Y%,%Width%,%Height%
}
Return
;(----- Resize window -----)

;//////////////////////////////////////////////////////////////////////////////////
;//////////////////////////////////////////////////////////////////////////////////
;//////////////////////////////////////////////////////////////////////////////////

; ; ; ;/// Send Command Key to XMPlayer Function
; ; ; pushCommandKey(cmdButton, tooltipText)
	; ; ; {
	; ; ; WinGet, ActualWindowsID, id, A			;Store Active Window's ID
	; ; ; WinActivate, ahk_class XMPLAY-MAIN	;Switch to XMPLAY
	; ; ; WinWaitActive, ahk_class XMPLAY-MAIN, , 1	;Wait for Window activation
	; ; ; Sleep, 75
	; ; ; Send, {%cmdButton% down}					;Push Play/Pause
	; ; ; Tooltip, %tooltipText%						;Turn on Tooltip
	; ; ; SetTimer, RemoveToolTip, 1000				;Kill tooltip after 1 sec.
	; ; ; Sleep, 100									;Make sure, XMPlayer get the command
	; ; ; Send, {%cmdButton% up}
	; ; ; WinActivate, ahk_id %ActualWindowsID%	;Switch back to Original Window
	; ; ; }
; ; ; Return

; ; ; ;(----- XMPlayer Controls -----)
; ; ; !Pause::
	; ; ; IfWinExist, ahk_class XMPLAY-MAIN
	; ; ; pushCommandKey("Pause", "XMPlayer: Play/Pause")
; ; ; Return

; ; ; !PgUp::
	; ; ; IfWinExist, ahk_class XMPLAY-MAIN
	; ; ; pushCommandKey("PgUp", "XMPlayer: Previous Track")
; ; ; Return

; ; ; !PgDn::
	; ; ; IfWinExist, ahk_class XMPLAY-MAIN
	; ; ; pushCommandKey("PgDn", "XMPlayer: Next Track")
; ; ; Return
