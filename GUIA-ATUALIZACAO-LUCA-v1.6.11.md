# Atualização do Luca — versão 1.6.11

Esta versão detalha a composição do crédito pendente na tela **Minhas contas**.

## O que mudou

O valor total de crédito pendente continua representando o saldo das compras no crédito que já se tornaram efetivas, incluindo as parcelas futuras de compras parceladas cujo primeiro vencimento chegou. Agora ele é apresentado em quatro partes:

- **Anteriores em aberto:** parcelas/lançamentos de meses anteriores ainda não quitados.
- **Crédito deste mês:** compras e parcelas cuja data cadastrada está no mês atual.
- **Parcelas futuras:** valor e quantidade de parcelas dos próximos meses.
- **Crédito total restante:** soma dos três grupos anteriores.

Pagamentos de crédito e estornos reduzem primeiro os valores mais antigos. Assim, os subtotais continuam reconciliando com o total.

**Importante:** o Luca usa as datas cadastradas nas compras e parcelas. “Crédito deste mês” não é uma fatura importada do banco nem confirma a data real de vencimento do emissor.

## Atualização

1. Feche o Luca.
2. Faça backup de `data/` e `.env`.
3. Extraia a versão 1.6.11 em uma pasta nova.
4. Copie o `.env` e a pasta `data/` antigos.
5. Não copie a `.venv`.
6. Execute `iniciar.bat`.

Não há migração de banco nesta versão.
