@echo off
setlocal
cd /d "%~dp0"
title Luca - Verificacao e instalacao automatica de audio

set "PYTHON=%~dp0.venv\Scripts\python.exe"
if not exist "%PYTHON%" (
  echo [Luca] Ambiente virtual nao encontrado.
  echo Execute iniciar.bat uma vez nesta mesma pasta.
  pause
  exit /b 1
)

echo.
echo =============================================
echo   LUCA - SUPORTE DE TRANSCRICAO LOCAL
echo =============================================
echo Python utilizado:
echo %PYTHON%
echo.
"%PYTHON%" -m app.audio_setup --strict
if errorlevel 1 (
  echo.
  echo [ERRO] Nao foi possivel preparar o suporte de audio.
  echo Consulte logs\luca-service.log e /assistant/audio/status.
  pause
  exit /b 1
)

echo.
echo O suporte de audio esta instalado e compativel.
echo O modelo Whisper sera baixado automaticamente no primeiro audio, se necessario.
echo Reinicie o Luca usando iniciar.bat para aplicar qualquer correcao.
echo.
pause
