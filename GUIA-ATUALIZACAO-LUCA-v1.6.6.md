# Luca v1.6.6 — atualização

# Atualização do Luca para v1.6.6

Esta versão melhora a edição de lançamentos no Telegram. Depois de editar um campo, o Luca envia uma nova prévia completa no fim da conversa, com os botões Confirmar, Editar e Cancelar. A prévia anterior permanece como histórico, mas seus botões são removidos quando o Telegram permite.

## Atualizar sem perder dados

1. Encerre o Luca.
2. Faça backup de `data/` e `.env`.
3. Extraia o ZIP v1.6.6 em uma pasta nova.
4. Copie o `.env` da instalação anterior.
5. Copie a pasta `data/` da instalação anterior.
6. Não copie `.venv/`; o `iniciar.bat` prepara o ambiente e verifica as dependências automaticamente.
7. Execute `iniciar.bat`.

Não envie `.env`, bancos SQLite, logs, backups ou `.venv` ao GitHub.

## Teste da edição no Telegram

1. Envie uma despesa e toque em **Editar**.
2. Escolha **Valor** e envie, por exemplo, `500`.
3. O Luca deve enviar uma nova mensagem abaixo com a prévia inteira e o valor atualizado.
4. Confirme somente depois de conferir todos os campos.

A alteração permanece pendente; nenhuma movimentação é gravada até tocar em **Confirmar**.
