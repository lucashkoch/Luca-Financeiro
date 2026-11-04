@echo off
setlocal
where ollama >nul 2>nul
if errorlevel 1 (
  echo Ollama nao foi encontrado. Instale o Ollama para Windows pelo site oficial: https://ollama.com/download
  pause
  exit /b 1
)
echo Baixando o modelo local qwen2.5:3b. O download pode ocupar alguns GB.
ollama pull qwen2.5:3b
if errorlevel 1 (
  echo Falha no download. Confira a conexao e a instalacao do Ollama.
  pause
  exit /b 1
)
echo Modelo pronto. Edite .env e altere OLLAMA_ENABLED=1.
pause
