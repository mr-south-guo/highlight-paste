#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include <WinClipAPI>
#Include <WinClip>

/**
 * Option defaults
 */

; languages options for syntax-highlighting.
; Use `source-highlight --lang-list` to see all supported language.
LANG_OPTIONS := "bat|bash|cpp|html|java|js|json|latex|python"

; Default language
CodeLang := "cpp"

; Show line number prefix: 0=no, 1=yes
LineNumber := 0

; Additional options for `source-highlight`
; --doc: standalone html
; --tab: number of spaces for tab
HIGHLIGHT_OPTS := "--doc --tab=4"

; Files and directory
HIGHLIGHT_HOME := A_ScriptDir . "\libexec\source-highlight"
HIGHLIGHT_BIN := HIGHLIGHT_HOME . "\bin\source-highlight.exe"
HIGHLIGHT_DATA_DIR := HIGHLIGHT_HOME . "\share\source-highlight"
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
Gui, HighlightPasteSettings:Add, Button, Default w120, &OK
GuiControl, HighlightPasteSettings:ChooseString, CodeLang, %CodeLang%

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
	global CodeLang, LineNumber
	global HIGHLIGHT_BIN, HIGHLIGHT_DATA_DIR, PLAIN_CODE_PATH, COLOR_CODE_PATH, HIGHLIGHT_OPTS
	
	plain_code := Clipboard
	
	FileDelete, %PLAIN_CODE_PATH%
	FileDelete, %COLOR_CODE_PATH%
	FileAppend, %plain_code%, %PLAIN_CODE_PATH%
	
	if (LineNumber)
		this_opts := HIGHLIGHT_OPTS . " --line-number"
	else
		this_opts := HIGHLIGHT_OPTS
	
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
pasteHTML(html_file)
{
	if not FileExist(html_file)
		return

	; Patch the HTML for proper rendering in WPS. (Not tested in MS-Word.)
	; [TECH DETAILS] Inside <pre></pre>, WPS does not render line-break if the 
	; next line does not start with a white-space. Here we wrap each line with 
	; <pre></pre> to fix that.
	html := ""
	Loop, read, %html_file%
	{
		; Only patch inside <pre></pre>.
		if InStr(A_LoopReadLine, "<pre")
			is_inside_pre := 1
		else if InStr(A_LoopReadLine, "</pre>")
			is_inside_pre := 0

		; If blank line, add line-break to make sure it renders.
		if (StrLen(A_LoopReadLine) == 0)
			html .= "`r`n"
		else
			html .= A_LoopReadLine

		if (is_inside_pre)
			html .= "</pre>`r`n<pre>"
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
