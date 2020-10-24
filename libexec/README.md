# README for libexec directory

This directory contains external programs required by this app.

## highlight (by André Simon)

"Highlight converts source code to formatted text with syntax highlighting."

Office website: <https://gitlab.com/saalen/highlight>

### Download pre-built Windows binaries

- The latest version (v3.58+) can be downloaded from [here](http://www.andre-simon.de/): `highlight-*.zip`

### Extraction

- Extract the downloaded zip file here and make sure the following directories exist:
  `libexec\highlight\`
- The following files/directories are not needed by this app. They can be removed to reduce disk usage. All paths are relative to `libexec\highlight\`.
	- `highlight-gui.exe` : GUI for highlight
	- `src\` : source code for highlight
	- `extras\` : some extra stuff to use highlight with other programs
	- `gui_files\` : file used by GUI for highlight
