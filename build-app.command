#!/bin/bash
# Double-click to build the standalone app on macOS or Linux.
cd "$(dirname "$0")" || exit 1

python3 -m pip install --quiet . pyinstaller || { read -r -p "Install failed. Enter to close."; exit 1; }

python3 -m PyInstaller packaging/gui_entry.py \
  --name vidscript --onefile --windowed --noconfirm \
  --icon src/vidscript/assets/icon-512.png \
  --add-data "src/vidscript/assets:assets" || { read -r -p "Build failed. Enter to close."; exit 1; }

echo
echo "Done: $(pwd)/dist/vidscript"
read -r -p "Press enter to close."
