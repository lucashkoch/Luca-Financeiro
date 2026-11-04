@echo off
setlocal
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
  echo Execute iniciar.bat primeiro para criar o ambiente virtual.
  pause
  exit /b 1
)
call ".venv\Scripts\activate.bat"
echo Instalando suporte opcional a transcricao local de audio...
python -m pip install faster-whisper
if errorlevel 1 (
  echo Nao foi possivel instalar faster-whisper.
  pause
  exit /b 1
)
echo Instalacao concluida. A primeira transcricao baixa o modelo escolhido em .env.
pause
