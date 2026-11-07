# Luca 1.6.3 — guia de atualização

**Pacote:** `luca-assistente-financeiro-v1.6.3.zip`

Esta versão separa o processamento de texto e áudio do Telegram. Um áudio que demore para baixar ou transcrever não bloqueia novas mensagens de texto. Também faz uma verificação automática da tabela `pending_actions` no banco individual de cada pessoa antes de processar mensagens e callbacks.

## Instalação

1. Feche o Luca.
2. Faça backup da pasta `data/` e do arquivo `.env`.
3. Extraia o ZIP em uma pasta nova.
4. Copie o `.env` e a pasta `data/` da instalação anterior.
5. Não copie a pasta `.venv`.
6. Execute `iniciar.bat`.

A aplicação migra o banco central e os bancos individuais. Além disso, quando chega uma mensagem Telegram, confere as colunas necessárias para a confirmação naquele perfil. Nenhum lançamento ou histórico financeiro é removido. Mantenha a instalação anterior e o backup até confirmar que todos os perfis abrem corretamente.

## O que mudou no Telegram

- Texto, comandos e callbacks passam por uma fila/worker próprio.
- Áudios passam por outro worker. Se `getFile` ou a transcrição falhar, os textos seguintes continuam sendo atendidos.
- Falhas transitórias de áudio voltam para a fila com intervalo progressivo. Use `/fila` para consultar o estado e `/reprocessar` depois de corrigir uma falha terminal.
- Um item em espera de retentativa não impede os próximos itens prontos do mesmo tipo. Por isso, em uma situação de falha, uma mensagem de texto pode ser respondida antes de um áudio enviado anteriormente.
- O `getFile` usa timeout menor; o worker de áudio é independente do worker de texto.
- Os logs HTTPX não exibem mais as URLs completas da Bot API.

## Teste recomendado

1. Envie uma mensagem de voz curta.
2. Logo em seguida, envie uma mensagem de texto como `cachorro quente 50 reais no crédito`.
3. Mesmo que o áudio demore, o Luca deve responder à mensagem de texto sem esperar o download/transcrição.
4. Verifique `/fila` e, se necessário, `/reprocessar`.
5. Confirme as prévias somente depois de revisar os campos.

A suíte automatizada passou com 149 testes. O funcionamento real do download e da transcrição ainda depende da conexão do computador com os servidores do Telegram e do Whisper local.

## Segurança do token

O token do bot apareceu em uma captura de tela compartilhada anteriormente. Revogue-o pelo `@BotFather` usando `/revoke`, selecione o bot, atualize `TELEGRAM_BOT_TOKEN` no `.env` com o token novo e reinicie o Luca. Não reutilize o token que apareceu no print.
