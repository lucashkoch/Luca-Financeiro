# Luca 1.6.14 — Resumo por fatura

Esta atualização reorganiza a área **Minhas contas** para que o controle de crédito acompanhe o ciclo de fechamento e vencimento do cartão, em vez de separar a dívida apenas pelo mês do lançamento.

## Novo resumo

- **Fatura atual:** saldo da fatura do ciclo que está em aberto, incluindo o saldo inicial consolidado cadastrado para esse ciclo.
- **Próximas faturas:** soma de lançamentos e parcelas futuros, com discriminação por data de fechamento e vencimento.
- **Total comprometido:** soma da fatura atual, próximas faturas e eventuais saldos de ciclos anteriores que ainda não foram quitados.

Se houver saldo anterior não quitado, um aviso informa o valor e explica que ele já está incluído no total comprometido. Se não houver, o aviso não aparece.

O Luca utiliza o dia de fechamento e o dia de vencimento configurados em cada conta. Para contas usadas no crédito sem ciclo configurado, é mantida uma divisão por mês-calendário como alternativa. Lançamentos no crédito com data futura também aparecem nas próximas faturas; eles representam compromissos agendados e não reduzem o saldo disponível da conta antes da data. O Luca inclui ainda a próxima ocorrência de cada recorrência ativa no crédito, respeitando a forma de pagamento explicitamente escolhida e evitando duplicá-la quando o lançamento automático é gerado.

## Conciliação

O detalhe da fatura passa a exibir o saldo inicial consolidado. Na prévia do CSV, esse saldo é incluído no total do Luca, mas não é listado como uma compra sem correspondência, pois representa várias compras antigas consolidadas em um único lançamento.

## Atualizar

1. Feche o Luca.
2. Faça backup da pasta `data/` e do arquivo `.env`.
3. Extraia a versão 1.6.14 em uma pasta nova.
4. Copie `data/` e `.env` da versão anterior para a nova pasta. Não copie `.venv/`.
5. Execute `iniciar.bat`.

Nenhum lançamento é reclassificado, excluído ou recriado por esta atualização. A nova visualização apenas reorganiza os valores já registrados conforme o ciclo da conta.

Mantenha a versão anterior e o backup até conferir os saldos.
