# highlight-paste

## Description

An AutoHotkey app to one-key paste plain-text source code with syntax-highlighting.

## Features

- **One hotkey (`Alt+v`) with minimum configuration**
  
  Start the app and choose a highlighting language. Then, just copy your source code from somewhere to your clipboard, and instead of the `Ctrl+v`, use this app's hotkey `Alt+v` to paste into your target program. That's it.

- **Use a standalone syntax-highlighting backend**
  
  It means you can copy source code from anywhere, with or without syntax-highlighting, e.g. from Windows Notepad.

- **Paste as HTML formatted data.**
  
  Any target program support pasting and rendering HTML data, (in theory,) should be able to show your source code with syntax-highlighting, monospace font and other pretty options, such as line-number.

- **Extensive languages and pretty options**
  
  The wonderful syntax-highlighting backend `hightlight` supports a long list of languages, color themes, pretty options, and even plugins. You can tweak it to your heart's content. (But currently requires you to adjust a variable in this app's script manually. Maybe I will add some GUI controls for them in the future.)

- **Standalone, offline, portable and slim**

  This app is very slim but self-contained. No need to install other software, and works completely offline. Oh, it's also portable and leaves nothing behind.

## Some target programs

Each program may handle pasting HTML data differently. Here is a list of target programs I have tested, and their quirks.

- **Fully working**
  - WPS Office 2019 PC, Writer（文字）
  - (online) WPS Office, Writer（金山文档）
  - (online) docs.qq.com（腾讯文档-在线文档）
    - For each line of source code, the background color only covers up to the last characters, not to the entire line.
  - Apache OpenOffice v4.1.7
  - (online) Google Docs
    - By default, Google Docs does not have Consolas in the font list. You may need to manually add it once.
- **Partially working**
  - (online) Microsoft Office 365, Word
    - Leading spaces (indent) does not show.
- **Not working**
  - Microsoft Wordpad
    - Wordpad does not support pasting HTML.

## Q&A

### Why do you create this while some code editors, such as VSCode, can already do similar thing?

**Story version**: I frequently work with many editors, and I want a solution not relying on certain feature of a certain editor.
**Long version**: While VSCode and some other editors, such as Notepad++, provide "copy as HTML or RTF" feature, but many other great editors do not (yet). Yes, I can use VSCode or Notepad++ as bridges (which I did for a long time), but I'm tired of it and it **really ought to be as simple as pressing one hotkey**.
One problem with VSCode and the like is that, you can not easily control what the code looks. For example, I like to work with black background in VSCode, but I don't want to paste my code into my document in black background. And sometimes I also want some extra pretty options such as line numbers, which is not possible yet.
Another problem is that, even all editors support "copy as HTML or RTF", they have different ways of syntax-highlighting. Using a standalone syntax-highlighting tool, allows me to get an unified look no matter where I copied the source code from.

### Why don't you test on Microsoft Office (offline)?

Simple, I don't own a copy of it. I would like to know if it works though. Please let me know if you have tested it.
