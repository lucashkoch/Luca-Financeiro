@echo off
setlocal
cd /d "%~dp0"
title Luca - Instalacao de audio

set "PYTHON=%~dp0.venv\Scripts\python.exe"
if not exist "%PYTHON%" (
  echo [Luca] Ambiente virtual nao encontrado.
  echo Execute iniciar.bat uma vez nesta mesma pasta e depois rode este instalador.
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
"%PYTHON%" --version
if errorlevel 1 (
  echo [ERRO] Nao foi possivel executar o Python do ambiente virtual.
  pause
  exit /b 1
)

echo.
echo [1/3] Instalando faster-whisper e PyAV compativel neste ambiente...
echo [Luca] PyAV sera mantido abaixo da versao 19 para compatibilidade com faster-whisper.
"%PYTHON%" -m pip install --disable-pip-version-check --upgrade faster-whisper "av>=11,<19"
if errorlevel 1 (
  echo.
  echo [ERRO] A instalacao do faster-whisper falhou.
  echo Confira a conexao com a internet e a versao do Python.
  pause
  exit /b 1
)

echo.
echo [2/3] Validando faster-whisper, CTranslate2 e PyAV...
"%PYTHON%" -c "import sys, faster_whisper, ctranslate2, av; print('faster-whisper:', getattr(faster_whisper, '__version__', 'instalado')); print('ctranslate2:', getattr(ctranslate2, '__version__', 'instalado')); print('PyAV:', av.__version__); print('Bibliotecas FFmpeg:', av.library_versions); major=int(av.__version__.split('.')[0]); print('Compatibilidade faster-whisper:', 'OK' if major < 19 else 'INCOMPATIVEL'); sys.exit(0 if major < 19 else 2)"
if errorlevel 1 (
  echo.
  echo [ERRO] O pacote foi instalado, mas uma dependencia nativa nao carregou.
  echo Copie o erro acima e consulte /assistant/audio/status depois de iniciar o Luca.
  pause
  exit /b 1
)

echo.
echo [3/3] Instalacao e validacao concluidas.
echo O primeiro audio pode baixar o modelo Whisper e levar mais tempo.
echo PyAV abaixo de 19: necessario para a versao atual do faster-whisper.
echo Modelo padrao: medium (mais preciso, porem mais pesado que small).
echo O PyAV normaliza OGG/Opus em WAV mono/16 kHz antes da transcricao.
echo Reinicie o Luca usando iniciar.bat antes de testar no Telegram.
echo.
pause
