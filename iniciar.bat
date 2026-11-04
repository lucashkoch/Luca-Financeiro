@echo off
setlocal
cd /d "%~dp0"
title Luca - Assistente Financeiro

if not exist ".venv\Scripts\python.exe" (
    echo [Luca] Criando ambiente Python...
    py -3 -m venv .venv
    if errorlevel 1 (
        echo Nao foi possivel criar o ambiente virtual. Instale Python 3.11 ou superior.
        pause
        exit /b 1
    )
)

set "PYTHON=%~dp0.venv\Scripts\python.exe"
echo [Luca] Instalando/verificando dependencias...
"%PYTHON%" -m pip install --disable-pip-version-check -r requirements.txt
if errorlevel 1 (
    echo Falha ao instalar dependencias. Verifique sua conexao e tente novamente.
    pause
    exit /b 1
)

if not exist ".env" copy ".env.example" ".env" >nul

echo.
echo =============================================
echo   LUCA - ASSISTENTE FINANCEIRO v1.4.2
echo =============================================
echo Painel: http://127.0.0.1:8000
echo API:    http://127.0.0.1:8000/docs
echo Dados:  data\
echo Logs:   logs\luca-service.log
echo Para encerrar, pressione Ctrl+C.
echo.

set LUCA_OPEN_BROWSER=1
"%PYTHON%" -m app.service
pause
