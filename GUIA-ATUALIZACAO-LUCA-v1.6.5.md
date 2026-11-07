# Luca v1.6.5 — atualização

Esta versão corrige a falta de uma resposta visível depois que você envia o novo valor ou texto ao editar uma prévia pelo Telegram.

## Arquivos

- Projeto completo: `luca-assistente-financeiro-v1.6.5.zip`
- Guia: `docs/upgrading-to-v1.6.5.md`

## Instalação

1. Feche o Luca.
2. Faça backup de `data/` e `.env`.
3. Extraia o ZIP em uma pasta nova.
4. Copie o `.env` e a pasta `data/` da instalação anterior.
5. Não copie `.venv/`.
6. Execute `iniciar.bat`.

## Correção

Após alterar um campo, o Luca agora confirma a mudança em uma mensagem separada e atualiza a prévia original. O lançamento só é salvo quando você toca em **Confirmar**.

## Validação

Suíte automatizada: 151 testes aprovados. Isso valida o fluxo de código e o teste integrado simulado; ainda é necessário conferir o comportamento em uma conversa real no Telegram.
