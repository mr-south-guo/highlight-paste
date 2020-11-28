#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include <WinClipAPI>
#Include <WinClip>

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
; --inline-css : inline all formats (otherwise, highlighting won't show up after paste.)
; --tab : convert tabs to given number of spaces.
; --font : font for source code.
HighlightOpts := "--inline-css --tab=4 --font='Consolas' --style=github"

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
Menu, Tray, Add
Menu, HighlightPasteMenu, Add, Settings, HighlightPasteSettingsShow
Menu, Tray, Add, Highlight-Paste, :HighlightPasteMenu

; Settings window
Gui, HighlightPasteSettings:Add, ListBox, r10 vCodeLang, %LANG_OPTIONS%
Gui, HighlightPasteSettings:Add, CheckBox, vLineNumber, Line number
Gui, HighlightPasteSettings:Add, Link, gHighlightOptsHelp, <a>highlight options</a>:
Gui, HighlightPasteSettings:Add, Edit, vHighlightOpts w120, %HighlightOpts%
Gui, HighlightPasteSettings:Add, Button, Default w120, &OK
GuiControl, HighlightPasteSettings:ChooseString, CodeLang, %CodeLang%

return

HighlightOptsHelp:
Run, %ComSpec% /k "%HIGHLIGHT_BIN% --help", %HIGHLIGHT_HOME%
return

HighlightPasteSettingsShow:
Gui, HighlightPasteSettings:Show, , Settings
return

HighlightPasteSettingsButtonOK:
HighlightPasteSettingsGuiClose:
Gui, HighlightPasteSettings:Submit
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
	
	RunWait, "%HIGHLIGHT_BIN%" --data-dir="%HIGHLIGHT_DATA_DIR%" --input="%PLAIN_CODE_PATH%" --output="%COLOR_CODE_PATH%" --src-lang=%CodeLang% %this_opts%
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
	; line-breaks inside <pre></pre> to <br>.
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
			html .= "<br>"
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
