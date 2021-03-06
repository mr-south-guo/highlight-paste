﻿#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include <WinClipAPI>
#Include <WinClip>

__author__ := "mr-south-guo at github.com"
__version__ := "20201130.1458"

/**
 * Option defaults
 */

; languages options for syntax-highlighting.
; Use `highlight --list-scripts=lang` to see all supported language.
LANG_OPTIONS := "ahk|bat|bash|cpp|html|java|js|json|latex|python|vhdl"

; Default language
CodeLang := "ahk"

; Show line number prefix: 0=no, 1=yes
LineNumber := 0

; Additional options for `highlight`
; --font : font for source code.
; --tab : convert tabs to given number of spaces.
; --style : color theme (see directory "libexec/highlight/themes/")
HighlightOpts := "--font='Consolas' --tab=4 --style=github"

; Files and directory
HIGHLIGHT_HOME := A_ScriptDir . "\libexec\highlight"
HIGHLIGHT_BIN := HIGHLIGHT_HOME . "\highlight.exe"
HIGHLIGHT_DATA_DIR := HIGHLIGHT_HOME
PLAIN_CODE_PATH := A_Temp . "\highlight-paste.plain-code.txt"
COLOR_CODE_PATH := A_Temp . "\highlight-paste.color-code.html"

/**
 * GUI for settings
 */

; Settings tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Settings, HighlightPasteSettingsShow
Menu, Tray, Add, About/Help, HighlightPasteAboutShow
Menu, Tray, Add, Exit, HighlightPasteExit
Menu, Tray, Default, Settings

; Settings window
Gui, HighlightPasteSettings:Add, ListBox, r10 vCodeLang, %LANG_OPTIONS%
Gui, HighlightPasteSettings:Add, CheckBox, x+m vLineNumber, Line number
Gui, HighlightPasteSettings:Add, Link, gHighlightOptsHelp, <a>highlight options</a>:
Gui, HighlightPasteSettings:Add, Edit, vHighlightOpts w150 r4, %HighlightOpts%
Gui, HighlightPasteSettings:Add, Button, Default w150, &OK
GuiControl, HighlightPasteSettings:ChooseString, CodeLang, %CodeLang%

; About window
Gui, HighlightPasteAbout:Font, s16 bold cBlue, Consolas
Gui, HighlightPasteAbout:Add, Text, w480, highlight-paste
Gui, HighlightPasteAbout:Font, s11 norm cBlack
Gui, HighlightPasteAbout:Add, Text, wp+0 , An AutoHotkey app to one-key-paste plain-text source code with syntax-highlighting.
Gui, HighlightPasteAbout:Add, Text, wp+0 , - Copy source code to clipboard.`n- Press Alt+v to paste into a target program.
Gui, HighlightPasteAbout:Font, s8 norm cBlack
Gui, HighlightPasteAbout:Add, Text, wp+0 , author: %__author__%`nver: %__version__%
return

HighlightPasteExit:
ExitApp
return

HighlightOptsHelp:
Run, %ComSpec% /k "%HIGHLIGHT_BIN% --help", %HIGHLIGHT_HOME%
return

HighlightPasteSettingsShow:
Gui, HighlightPasteSettings:Show, w300 , highlight-paste | settings
return

HighlightPasteSettingsButtonOK:
HighlightPasteSettingsGuiClose:
Gui, HighlightPasteSettings:Submit
return

HighlightPasteAboutShow:
Gui, HighlightPasteAbout:Show, w500 , highlight-paste | about
return

/**
 * Hotkeys
 */

; Alt+v : Paste the source code in clipboard with syntax-highlighting.
!v::
pasteHighlight()
return

; Ctrl+Alt+v : Paste the previous highlighted code again.
^!v::
pasteHTML(COLOR_CODE_PATH)
return

/**
 * Functions
 */

/**
 * Paste the source code in clipboard with syntax-highlighting.
 */
pasteHighlight()
{
	global CodeLang, LineNumber, HighlightOpts
	global HIGHLIGHT_BIN, HIGHLIGHT_DATA_DIR, PLAIN_CODE_PATH, COLOR_CODE_PATH
	
	plain_code := Clipboard
	
	FileDelete, %PLAIN_CODE_PATH%
	FileDelete, %COLOR_CODE_PATH%
	FileAppend, %plain_code%, %PLAIN_CODE_PATH%
	
	if (LineNumber)
		this_opts := HighlightOpts . " --line-number"
	else
		this_opts := HighlightOpts
	
	; --inline-css : inline all formats (otherwise, highlighting won't show up after paste.)
	RunWait, "%HIGHLIGHT_BIN%" --data-dir="%HIGHLIGHT_DATA_DIR%" --input="%PLAIN_CODE_PATH%" --output="%COLOR_CODE_PATH%" --inline-css --src-lang=%CodeLang% %this_opts%
	if (ErrorLevel > 0)
	{
    	MsgBox, ErrorLevel: %ErrorLevel% : "%HIGHLIGHT_BIN%" 
    	return
	}
	
	pasteHTML(COLOR_CODE_PATH)
}

/**
 * Paste an HTML file as HTML formatted data (instead of plain HTML code).
 */
pasteHTML(file)
{
	if not FileExist(file)
		return

	; Patch the HTML for proper rendering.
	; [TECH DETAILS] Line-breaks inside <pre></pre> are handled poorly by many 
	; word processors, such as WPS Office and docs.qq.com. Here changes all
	; line-breaks inside <pre></pre> to <br/>.
	html := ""
	Loop, read, %file%
	{
		; Only patch inside <pre></pre>.
		if InStr(A_LoopReadLine, "<pre")
			is_inside_pre := 1
		else if InStr(A_LoopReadLine, "</pre>")
			is_inside_pre := 0

		html .= A_LoopReadLine

		if (is_inside_pre)
			html .= "<br/>"
		else
			html .= "`r`n"
	}
	
	; Paste without changing current clipboard contents.
	clip_backup := ClipboardAll
	WinClip.Clear()
	WinClip.SetHTML(html)
	Send ^v
	Sleep 1000
	Clipboard := clip_backup
}
