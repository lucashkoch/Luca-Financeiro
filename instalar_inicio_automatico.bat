@echo off
setlocal
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\install_startup.ps1"
if errorlevel 1 (
  echo.
  echo Nao foi possivel instalar a inicializacao automatica.
  pause
  exit /b 1
)
echo.
pause
