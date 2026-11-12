# Luca 1.7.4 — frases rápidas para acertos pessoais

Esta versão amplia as formas de registrar valores a receber e a pagar diretamente pelo Telegram.

## Exemplos aceitos

- `Cobrar R$ 80 do João pelo jantar` — registra R$ 80 a receber de João.
- `Cobrar 80 João` — forma curta, sem descrição.
- `João me devendo R$ 80` — registra R$ 80 a receber de João.
- `João me devendo R$ 80 do jantar` — registra o motivo do acerto.
- `Pagar R$ 50 para João pela pizza` — registra R$ 50 a pagar a João.

As formas anteriores continuam funcionando, como `Rafael me deve R$ 80 do jantar`, `Devo R$ 50 para Rafael pela pizza`, `Rafael me pagou R$ 40` e `Paguei R$ 50 para Rafael`.

Todas as novas frases de cadastro geram uma prévia com confirmação. Nenhum acerto é salvo sem confirmação. Os compromissos ficam no módulo **Devendo / A receber**, separados das receitas e despesas e dos saldos das contas. Quando houver pagamento ou recebimento real, registre a movimentação bancária separadamente.

## Atualização

1. Feche o Luca.
2. Faça backup da pasta `data/` e do arquivo `.env`.
3. Extraia o ZIP em uma pasta nova.
4. Copie `data/` e `.env` da instalação anterior.
5. Não copie a pasta `.venv`.
6. Execute `iniciar.bat`.

Não há migração de banco de dados nesta versão.
