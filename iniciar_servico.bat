@echo off
setlocal
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
  echo Execute iniciar.bat uma vez para instalar o Luca.
  pause
  exit /b 1
)
call ".venv\Scripts\activate.bat"
python -m app.service
