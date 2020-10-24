# README for Lib

This directory contains external library required by this app.

## WinClip (by Deo @ AutoHotkey Community)

"WinClip is an AutoHotkey_L class allowing you to manipulate with Windows clipboard."
This app mainly uses its SetHTML() method to load syntax-highlighted HTML file into clipboard.

- This library has not been updated since 2012 and there is no official website. 
- A forum post can be found [here](https://autohotkey.com/board/topic/74670-class-winclip-direct-clipboard-manipulations/), but the API description is outdated.
- The source code can be downloaded [here](http://www.apathysoftworks.com/ahk/WinClip.zip).
- The (up-to-date) API document can be view [here](http://www.apathysoftworks.com/ahk/index.html).

### Files

- [[WinClipAPI.ahk]] and [[WinClip.ahk]] are the main source code.
  "include WinClipAPI.ahk before WinClip.ahk!"
- [[WinClip.Help.html]] is the API document downloaded separately for reference.
