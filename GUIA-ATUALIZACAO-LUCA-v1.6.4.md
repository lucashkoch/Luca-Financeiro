# Atualização do Luca para v1.6.4

Esta versão corrige o transporte usado para recuperar áudios do Telegram.

## O que mudou

- O timeout de leitura de `getFile` voltou a 30 segundos, como era antes da v1.6.3.
- `getFile` e o download do arquivo usam um pool HTTPX separado do long polling e das mensagens de texto.
- As três tentativas idempotentes de `getFile` foram mantidas. Se falharem, a mensagem continua na fila persistente para nova tentativa.
- O instalador automático do Faster-Whisper/PyAV continua funcionando; não é necessário executar `instalar_audio.bat` manualmente.
- Não há alteração no esquema do banco de dados nesta versão.

## Atualização no Windows

1. Pare o Luca.
2. Faça backup das pastas `data/` e `logs/` e do arquivo `.env`.
3. Extraia a v1.6.4 em uma pasta nova.
4. Copie o `.env` e a pasta `data/` da instalação anterior para a nova.
5. Não copie a pasta `.venv`; o `iniciar.bat` recria o ambiente e prepara as dependências necessárias.
6. Execute `iniciar.bat`.
7. Confira se o painel abre e se o Telegram conecta.

## Teste recomendado

Envie uma mensagem de voz curta e, em seguida, outra mensagem de texto. Verifique se:

- o Luca obtém os dados do áudio (`getFile`);
- a transcrição aparece;
- a prévia financeira permite editar e confirmar;
- a mensagem de texto continua sendo atendida independentemente do processamento do áudio.

O código passou nos testes automatizados locais, mas a chamada real à Bot API precisa ser validada na sua rede/instalação Windows.

## Segurança do Telegram

O token do bot deve ficar apenas no `.env` e não deve aparecer em prints, logs ou no GitHub. Se o token já apareceu em uma captura compartilhada, revogue-o pelo `@BotFather`, gere outro e atualize `TELEGRAM_BOT_TOKEN` no `.env`.
