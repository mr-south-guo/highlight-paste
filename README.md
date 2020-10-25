# highlight-paste

## Description

An AutoHotkey app to one-key-paste plain-text source code with syntax-highlighting.

## Features

- **One hotkey (`Alt+v`) with minimum configuration**
  
  Choose a highlighting language, copy your source code from somewhere, and prese this app's hotkey `Alt+v` to paste into your target program. That's it.

- **Use a standalone syntax-highlighting backend**
  
  It means you can copy source code from anywhere, with or without syntax-highlighting, e.g. from Windows Notepad.

- **Paste as HTML formatted data.**
  
  Any target program support pasting and rendering HTML data, (in theory,) should be able to show your source code with syntax-highlighting, monospace font and other pretty options, such as line-number.

- **Extensive languages and pretty options**
  
  The powerful syntax-highlighting backend [highlight](https://gitlab.com/saalen/highlight) supports a long list of languages, color themes, pretty options, and even plugins. You can tweak it to your heart's content.

- **Standalone, offline, portable and slim**

  This app is very slim but self-contained. No need to install other software, and works completely offline. Oh, it's also portable and leaves nothing behind.

## Installation

This app is portable and no installation required. Just download the zip file from Release section. Extract it to some directory of your choice.

## Usage

- Start the app by running the `highlight-paste.exe`.
  - [For experienced AutoHotkey user] `highlight-paste.exe` is just a renamed `AutoHotkeyU64.exe`. You may run the main script `highlight-paste.ahk` with your copy of AHK. (Tested with AHK v1.1.33.2)
- Right-click on the tray icon of this app (a green "H"), then select "Highlight-Paste -> Settings". On the pop-up dialog, select your highlighting language, and some other pretty options.
- Copy source code from anywhere to clipboard (i.e. by normal `Ctrl+c`), then in your target program, press `Alt+v` to paste with syntax-highlighting.

## In-depth configuration

**[For experienced AHK users only]** Currently, you have to manually modify this app's main script `highlight-paste.ahk`. But don't worry, configurable settings are all placed at the upper part of the script and well commented. Here are some of the possible configurations.

- Change the hotkey.
- Adjust the `highlight` backend's extensive options.
- Even change the backend to another program, such as `GNU source-highlight`.

## Tested target programs

Each program may handle pasting HTML data differently. Here is a list of target programs I have tested, and their quirks.

- **Fully working**
  - WPS Office 2019 PC, Writer（文字）
  - (online) WPS Office, Writer（金山文档）
  - (online) docs.qq.com（腾讯文档-在线文档）
    - For each line of source code, the background color only covers up to the last character, not to the entire line.
  - Apache OpenOffice v4.1.7
  - (online) Google Docs
    - By default, Google Docs does not have Consolas in the font list. You may need to manually add it once.
- **Partially working**
  - (online) Microsoft Office 365, Word
    - Leading spaces (indent) does not show.
- **Not working**
  - Microsoft WordPad
    - WordPad does not support pasting HTML.

## Q&A

### Why do you create this while some code editors, such as VSCode, can already do similar thing?

**Story version**: I frequently work with many editors, and I want a solution not relying on certain feature of a certain editor.

**Long version**:

1. While VSCode and some other editors, such as Notepad++, provide "copy as HTML or RTF" feature, but many other great editors do not (yet). Yes, I can use VSCode or Notepad++ as bridges (which I did for a long time), but I'm tired of it and **it really ought to be as simple as pressing one hotkey**.
2. In VSCode etc., you can not easily control what the code looks. For example, I like to work with black background in VSCode, but I don't want to paste my code into my document in black background. And sometimes I also want some extra pretty options such as line numbers, which is not possible yet.
3. Even with editors that supports "copy as HTML or RTF", they have different ways of syntax-highlighting. Using a standalone syntax-highlighting tool, allows me to get an unified look no matter where I copied the source code from.

### Why don't you test on Microsoft Office (offline)?

Simple, I don't own a copy of it. I would like to know if it works though. Please let me know if you have tested it.
