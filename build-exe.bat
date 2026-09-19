@echo off
REM ============================================================
REM  Double-click this to build vidscript.exe on this computer.
REM  The finished file appears in the "dist" folder.
REM  Needs Python installed and an internet connection, once.
REM ============================================================

cd /d "%~dp0"

where py >nul 2>nul
if %errorlevel%==0 (set PY=py) else (set PY=python)

%PY% --version >nul 2>nul
if errorlevel 1 (
  echo.
  echo Python is not installed.
  echo Get it from https://www.python.org/downloads/
  echo Tick "Add Python to PATH" on the installer's first screen.
  echo.
  pause
  exit /b 1
)

echo Installing the build tools, one moment...
%PY% -m pip install --quiet --upgrade pip
%PY% -m pip install --quiet . pyinstaller
if errorlevel 1 (
  echo.
  echo Something went wrong installing. Read the message above.
  pause
  exit /b 1
)

echo Building vidscript.exe. This takes a minute or two...
%PY% -m PyInstaller packaging\gui_entry.py ^
  --name vidscript ^
  --onefile ^
  --windowed ^
  --noconfirm ^
  --icon src\vidscript\assets\icon.ico ^
  --add-data "src\vidscript\assets;assets"
if errorlevel 1 (
  echo.
  echo The build failed. Read the message above.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo  Done. Your program is here:
echo    %cd%\dist\vidscript.exe
echo.
echo  Drag it to your desktop and open it whenever you like.
echo ============================================================
echo.
explorer "%cd%\dist"
pause
