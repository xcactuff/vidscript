#!/bin/bash
# Double-click this file to open vidscript on macOS or Linux.
cd "$(dirname "$0")" || exit 1

if ! command -v python3 >/dev/null 2>&1; then
  echo "Python 3 is not installed. Get it from https://www.python.org/downloads/"
  read -r -p "Press enter to close."
  exit 1
fi

if ! python3 -c "import vidscript" >/dev/null 2>&1; then
  echo "Installing vidscript, one moment..."
  python3 -m pip install -e . --quiet
fi

python3 -m vidscript.gui
