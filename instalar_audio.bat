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
echo [1/3] Instalando faster-whisper neste ambiente...
"%PYTHON%" -m pip install --disable-pip-version-check --upgrade faster-whisper
if errorlevel 1 (
  echo.
  echo [ERRO] A instalacao do faster-whisper falhou.
  echo Confira a conexao com a internet e a versao do Python.
  pause
  exit /b 1
)

echo.
echo [2/3] Validando faster-whisper e CTranslate2...
"%PYTHON%" -c "import faster_whisper, ctranslate2; print('faster-whisper:', getattr(faster_whisper, '__version__', 'instalado')); print('ctranslate2:', getattr(ctranslate2, '__version__', 'instalado'))"
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
echo Modelo padrao: medium (mais preciso, porem mais pesado que small).
echo Reinicie o Luca usando iniciar.bat antes de testar no Telegram.
echo.
pause
