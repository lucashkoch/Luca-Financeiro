# Atualização do Luca — versão 1.6.10

Esta versão corrige os cálculos dos saldos para não antecipar lançamentos com data futura.

## O que mudou

- Saldo das contas considera somente receitas, despesas, transferências e pagamentos de crédito cuja data já chegou.
- Compras futuras no crédito não entram na dívida pendente antes da data de competência.
- Quando a primeira parcela de uma compra parcelada chega à data, o valor total da compra passa a compor a dívida de crédito; as parcelas continuam distribuídas nos meses correspondentes para faturas e relatórios.
- Pagamentos de crédito agendados para o futuro não reduzem a dívida nem o saldo bancário antes da data informada.
- O resultado do mês no painel, a visão de relatórios usada pelo painel, a tendência e os limites mensais consideram valores realizados até hoje.
- Liquidações de acertos entre pessoas com data futura não reduzem o saldo pendente antes do dia informado. Elas também reservam o valor para evitar compromissos acima do total original.
- A tela completa de lançamentos e relatórios sem `realized_until` continuam permitindo consultar movimentações futuras para planejamento.

## Como atualizar no Windows

1. Feche o Luca.
2. Faça backup da pasta `data/` e do arquivo `.env`.
3. Extraia a versão 1.6.10 em uma pasta nova.
4. Copie o `.env` antigo e a pasta `data/` para a nova pasta.
5. Não copie a `.venv`; o `iniciar.bat` prepara o ambiente automaticamente.
6. Execute `iniciar.bat`.

Não há migração de banco nesta versão. Seus lançamentos e configurações são preservados.

## Como interpretar os indicadores do painel

- **Saldo nas contas:** dinheiro efetivo disponível até hoje, após lançamentos, transferências e pagamentos já ocorridos.
- **Compras no crédito pendentes:** compras já realizadas e ainda não quitadas. Uma compra parcelada é considerada como dívida total a partir da data da primeira parcela.
- **A receber / a pagar de pessoas:** compromissos ainda em aberto, inclusive os que vencem futuramente. Esses valores não são somados ao dinheiro disponível nas contas nem ao patrimônio líquido.
- **Patrimônio líquido:** saldos das contas menos dívida de crédito, sem misturar o controle separado de acertos entre pessoas.
- **Resultado do mês:** receitas menos despesas com data até hoje. Movimentações futuras ficam para o planejamento e não antecipam o resultado realizado.
