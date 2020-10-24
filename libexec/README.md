# README for libexec directory

This directory contains external programs required by this app.

## source-highlight

This is a Windows port from ""GNU source-highlight", a program convert plain-text source code to syntax-highlighted source code in various file format, including HTML.

### Download pre-built Windows binaries

- The latest version (v3.1.8+) can be downloaded from [ezwinports](https://sourceforge.net/projects/ezwinports/files/): `source-highlight-*-w32-bin.zip` (This version is bigger and supports many languages.)

- As an alternative, a lighter version (v2.1.2) can be downloaded from [Src-Highlite for Windows](http://gnuwin32.sourceforge.net/packages/src-highlite.htm): `src-highlite-*-bin.zip` (This version is smaller but supports fewer languages.)

### Extraction

- Extract the downloaded zip file here and make sure following directories exist:
  `libexec\source-highlight\bin\`
  `libexec\source-highlight\share\source-highlight\`
- Other directories from the zip file are not needed and can be deleted.
