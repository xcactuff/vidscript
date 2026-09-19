@echo off
REM Double-click this file to open vidscript. No terminal needed.
REM It installs what it needs the first time, then opens the window.

cd /d "%~dp0"

where py >nul 2>nul
if %errorlevel%==0 (set PY=py) else (set PY=python)

%PY% --version >nul 2>nul
if errorlevel 1 (
  echo Python is not installed.
  echo Download it from https://www.python.org/downloads/
  echo Remember to tick "Add Python to PATH" in the installer.
  pause
  exit /b 1
)

REM Editable install: changes to the files in this folder take effect
REM straight away, with no need to reinstall.
%PY% -c "import vidscript" >nul 2>nul
if errorlevel 1 (
  echo Installing vidscript, one moment...
  %PY% -m pip install -e . --quiet
)

%PY% -m vidscript.gui
if errorlevel 1 pause
